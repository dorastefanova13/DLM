BEGIN --permission

    PRINT '    fill clientPermission'

    DROP TABLE IF EXISTS [mig].[mapPermissions]
    CREATE TABLE [mig].[mapPermissions] (dlm3Id INT,dlm2RoleId INT,dlm2PlantId INT, IsStandardPlant BIT)

    DELETE FROM [sec].[mapClientPermissionDefaultPlant]
    DELETE FROM [sec].[mapClientClientPermission]
    DELETE FROM [sec].[clientPermission]

    DECLARE @roleId INT
    DECLARE @userId INT
    DECLARE @role NVARCHAR(100)
    DECLARE @login NVARCHAR(100)

    --set all Permissions for roles without Administrator (and other global roles) with mapping of all default plants for user

    DECLARE cMig CURSOR FOR
        SELECT DISTINCT r.[id] AS [roleId],r.[Key] AS [roleName],u.[login],u.[id]
        FROM
        (
            SELECT * FROM [archiv].[dbo_User] WHERE [IsActive] = 1
        ) u
        INNER JOIN [archiv].[dbo_Role] r ON r.[id] = u.[RoleId]
        WHERE r.[Key] <> 'DlmAdministrator'

    DECLARE @permissionId INT

    OPEN cMig
    FETCH NEXT FROM cMig INTO @roleId,@role,@login,@userId
    WHILE @@FETCH_STATUS = 0
    BEGIN

        --create permission

        INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted])
        SELECT @login + '/' +  q.[name],q.[dlm3Id],0
        FROM 
		(
			SELECT mRCR.[dlm3Id] ,cr.[name]
			FROM [mig].[mapRoleClientRole] mRCR
			INNER JOIN [sec].[clientRole] cr
				ON cr.[id] = mRCR.[dlm3Id]
			WHERE [dlm2Id] = @roleId
		) q

        SET @permissionId = @@IDENTITY

        --map all default plants for user to permission

        INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId])
        SELECT @permissionId,pl.[dlm3Id]
        FROM (
            SELECT [dlm3Id] 
            FROM [mig].[mapPlantPlant] 
            WHERE [dlm2Id] IN (
                SELECT [PlantId] 
                FROM [archiv].[dbo_UserPlant] 
                WHERE [UserId] = @userId
                AND [isStandardPlant] = 1
        )) pl

        --map permision to user

        INSERT INTO [sec].[mapClientClientPermission]([clientPermissionId],[clientId])
        SELECT @permissionId,[dlm3Id]
        FROM [mig].[mapUserClient]
        WHERE [dlm2Id] = @userId

        FETCH NEXT FROM cMig INTO @roleId,@role,@login,@userId

    END
    CLOSE cMig
    DEALLOCATE cMig

    --set all Permissions for role Administrator without plants

    DECLARE cMig CURSOR FOR
        SELECT DISTINCT r.[id] AS [roleId],r.[Key] AS [roleName],u.[login],u.[id]
        FROM
        (
            SELECT * FROM [archiv].[dbo_User] WHERE [IsActive] = 1
        ) u
        INNER JOIN [archiv].[dbo_Role] r ON r.[id] = u.[RoleId]
        WHERE r.[Key] = 'DlmAdministrator'

    OPEN cMig
    FETCH NEXT FROM cMig INTO @roleId,@role,@login,@userId
    WHILE @@FETCH_STATUS = 0
    BEGIN

        --create permission

        INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted])
        SELECT @login + '/' +  q.[name],q.[dlm3Id],0
        FROM 
		(
			SELECT mRCR.[dlm3Id] ,cr.[name]
			FROM [mig].[mapRoleClientRole] mRCR
			INNER JOIN [sec].[clientRole] cr
				ON cr.[id] = mRCR.[dlm3Id]
			WHERE [dlm2Id] = @roleId
		) q

        SET @permissionId = @@IDENTITY

        --map permission to user
		

        INSERT INTO [sec].[mapClientClientPermission]([clientPermissionId],[clientId])
        SELECT DISTINCT @permissionId,[dlm3Id]
        FROM [mig].[mapUserClient]
        WHERE [dlm2Id] = @userId

        FETCH NEXT FROM cMig INTO @roleId,@role,@login,@userId

    END
    CLOSE cMig
    DEALLOCATE cMig

	PRINT '    fill clientPlant'

	DELETE FROM [sec].[mapClientPlant]

	INSERT INTO [sec].[mapClientPlant]([clientId],[plantId])
	SELECT DISTINCT mUC.[dlm3Id],mPP.[dlm3Id]
	FROM [archiv].[dbo_UserPlant]	up
	INNER JOIN [mig].[mapUserClient] mUC 
		ON mUC.[dlm2Id] = up.[UserId]
	INNER JOIN [mig].[mapPlantPlant] mPP
		ON mPP.[dlm2Id] = up.[PlantId]

END --permission
GO
