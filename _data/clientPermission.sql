BEGIN --clientPermission
	SET NOCOUNT ON

    DROP TABLE IF EXISTS [mig].[mapPermissions]
    CREATE TABLE [mig].[mapPermissions] (dlm3Id INT,dlm2RoleId INT,dlm2PlantId INT, IsStandardPlant BIT)

    DECLARE @roleId INT
    DECLARE @userId INT
    DECLARE @clientPermissionId INT
    DECLARE @plantCodes NVARCHAR(1000)
    DECLARE @plantRoleCodes NVARCHAR(1000)
    DECLARE @role NVARCHAR(100)
    DECLARE @login NVARCHAR(100)
    DECLARE @rowCount INT = 0

    UPDATE [mig].[benutzer] SET [UserId] =  REPLACE(LTRIM(RTRIM([UserId]  COLLATE SQL_Latin1_General_CP1_CI_AS)),CHAR(160),'') 
    UPDATE [mig].[benutzer] SET [rolle] = REPLACE([rolle],'Planer','Planner')
    UPDATE [mig].[benutzer] SET [rolle] = REPLACE([rolle],'Einkauf','Purchaser')
    UPDATE [mig].[benutzer] SET [rolle] = REPLACE([rolle],'Cleaningboard','CleaningBoard')
    UPDATE [mig].[benutzer] SET [rolle] = REPLACE([rolle],'Werksadmin','PlantAdmin')
	UPDATE [mig].[benutzer] SET [rolle] = REPLACE([rolle],'DLM-Admin','DLMAdmin')

    DECLARE cMig CURSOR FOR SELECT DISTINCT REPLACE(LTRIM(RTRIM([UserId])),CHAR(160),'') FROM [mig].[benutzer] 
    OPEN cMig
    FETCH NEXT FROM cMig INTO @login
    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @userId = 0
		
		SELECT @userId = [id] FROM [sec].[client] WHERE [login] = @login

		IF @userId = 0
		BEGIN

			PRINT '>'+ @login + '<  not found'

		END
		ELSE
		BEGIN

			--PRINT '>'+ @login + '<  UserId: ' + CAST(@userId AS NVARCHAR)

			SELECT TOP 1 @plantCodes = [Werke]
			FROM [mig].[benutzer]
			WHERE [UserID] = @login

			--SET @rowCount = @@ROWCOUNT

			--PRINT '-> Plant: ' + CAST(@rowCount AS NVARCHAR)

			DELETE FROM [sec].[mapClientPlant] WHERE [clientId] = @userId

			INSERT INTO [sec].[mapClientPlant]([clientId],[plantId])
			SELECT @userId,pl.[id]
			FROM [loc].[plant] pl
			WHERE pl.[code] IN (
				SELECT RIGHT(N'00' + [value],3) FROM string_split(@plantCodes,',')
			)

			SET @rowCount = @@ROWCOUNT

			--PRINT '-> Plant: ' + CAST(@rowCount AS NVARCHAR)  + ' (' + @plantCodes + ')'

			DELETE FROM [sec].[mapClientClientPermission] WHERE [clientId] = @userId

			SET @rowCount = @@ROWCOUNT

			--PRINT '   Delete mapClientClientPermission for clientId ' + CAST(@userId AS NVARCHAR) + ' - Records: ' + CAST(@rowCount AS NVARCHAR)

			DECLARE cR CURSOR FOR
				SELECT DISTINCT 
					cr.[id]
					,b.[Werke der Rolle] 
					,b.[Rolle]
				FROM [mig].[benutzer] b
				INNER JOIN [std].[company] co
					ON co.[name] = b.[Gesellschaft] COLLATE SQL_Latin1_General_CP1_CI_AS
				INNER JOIN [sec].[clientRole] cr
					ON UPPER(REPLACE(cr.[name],'-','')) = UPPER(b.[Rolle]) COLLATE SQL_Latin1_General_CP1_CI_AS
				WHERE b.[UserID] = @login



			OPEN cR
			FETCH NEXT FROM cR INTO @roleId,@plantRoleCodes,@role
			WHILE @@FETCH_STATUS = 0
			BEGIN

				--PRINT '   Rolle >' + @role + '<'

				MERGE INTO [sec].[clientPermission] AS t
				USING (
					SELECT 
						@login + '/' + cr.[name] AS [name]
						,cr.[id] AS [clientRoleId]
						,0 AS [isDeleted]
					FROM [sec].[clientRole] cr
					WHERE cr.[id] = @roleId
				) AS s
				ON  s.[name] = t.[name]
				AND s.[clientRoleId] = t.[clientRoleId]
				WHEN NOT MATCHED THEN
					INSERT([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy])
					VALUES(s.[name],s.[clientRoleId],s.[isDeleted],GETDATE(),1)
				WHEN MATCHED THEN
					UPDATE SET
						t.[isDeleted] = s.[isDeleted]
						,t.[updatedAt] = GETDATE()
						,t.[updatedBy] = 1;

				SELECT @clientPermissionId = [id] 
				FROM [sec].[clientPermission]
				WHERE [name] = (
					SELECT  @login + '/' + cr.[name] AS [name]
					FROM [sec].[clientRole] cr
					WHERE cr.[id] = @roleId
				) 
				AND [clientRoleId] = @roleId

				--PRINT 'id: '+CAST(@clientPermissionId AS NVARCHAR)

				MERGE INTO [sec].[mapClientClientPermission] AS t
				USING (
					SELECT DISTINCT @userId AS [clientId],@clientPermissionId AS [clientPermissionId]
				) AS s
				ON s.[clientId] = t.[clientId]
				AND s.[clientPermissionId] = t.[clientPermissionId]
				WHEN NOT MATCHED THEN
					INSERT([clientId],[clientPermissionId])
					VALUES(s.[clientId],s.[clientPermissionId]);
				

				--PRINT '   -> ClientPermission: ' + CAST(@rowCount AS NVARCHAR)

				SELECT @rowCount = COUNT(1)
				FROM [sec].[mapClientPermissionDefaultPlant]
				WHERE [permissionId] = @clientPermissionId
				AND [plantId] IN (
					SELECT [id]
					FROM [loc].[plant] pl
					WHERE pl.[code] IN (
						SELECT RIGHT('00' + [value],3)  FROM string_split(@plantRoleCodes,',')
					)   
				)

				MERGE INTO [sec].[mapClientPermissionDefaultPlant] AS t
				USING(
					SELECT 
						@clientPermissionId AS [permissionId]
						,pl.[id] AS [plantId]
					FROM [loc].[plant] pl
					WHERE pl.[code] IN (
						SELECT RIGHT('00' + [value],3)  FROM string_split(@plantRoleCodes,',')
					)
				) AS s
				ON s.[permissionId] = t.[permissionId]
				AND s.[plantId] = t.[plantId]
				WHEN NOT MATCHED THEN
					INSERT ([permissionId],[plantId])
					VALUES (s.[permissionId],s.[plantId])
				WHEN MATCHED THEN
					UPDATE SET
						t.[plantId] = s.[plantId];


				SET @rowCount = @@ROWCOUNT
				--PRINT '   -> ClientPermissionDefaultPlant: ' + CAST(@rowCount AS NVARCHAR) + ' (' + @plantRoleCodes + ')'

				FETCH NEXT FROM cR INTO @roleId,@plantRoleCodes,@role

			END
			CLOSE cR
			DEALLOCATE cR

		END

        FETCH NEXT FROM cMig INTO @login

    END
    CLOSE cMig
    DEALLOCATE cMig

END --clientPermission
GO
