BEGIN --client

	SET NOCOUNT ON

    PRINT '    fill client'

    DROP TABLE IF EXISTS [mig].[mapUserClient]
    CREATE TABLE [mig].[mapUserClient] (dlm2Id INT, dlm3Id INT)

    
    CREATE CLUSTERED INDEX [x_mapUserCliend_dlm2Id] ON [mig].[mapUserClient]
    (
	    [dlm2id] ASC
    )
    
    DROP TABLE IF EXISTS [mig].[benutzer]
    SELECT * INTO [mig].[benutzer] FROM [archiv].[stage_benutzer]

    DELETE FROM [sec].[mapClientPermissionDefaultPlant]
    DELETE FROM [sec].[mapClientClientPermission]
    DELETE FROM [sec].[mapClientCompany]
    DELETE FROM [sec].[mapClientPlant]
    DELETE FROM [sec].[clientPermission]
    --DELETE FROM [sec].[client]

	DBCC CHECKIDENT ('[sec].[client]', RESEED, 1);

    DECLARE @userId INT
    DECLARE @login NVARCHAR(100)
    DECLARE @rowCount INT = 0

    BEGIN TRY

        SET IDENTITY_INSERT [sec].[client] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH
	

    INSERT INTO [sec].[client]([id],[login],[name],[firstname],[email],[language],[isDeleted],[insertedAt],[insertedBy])
    SELECT
		1
        ,'SYSTEM'
        ,'SYSTEM'
        ,'SYSTEM'
        ,'SYSTEM'
        ,'DE'
        ,0
		,GETDATE()
		,1
    WHERE NOT EXISTS (SELECT 1 FROM [sec].[client] WHERE [login] = N'SYSTEM')

	SET IDENTITY_INSERT [sec].[client] OFF
    
    DECLARE cMig CURSOR FOR SELECT DISTINCT REPLACE(LTRIM(RTRIM([UserId])),CHAR(160),'') FROM [mig].[benutzer] 
    OPEN cMig
    FETCH NEXT FROM cMig INTO @login
    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @rowCount = @rowCount + 1

		--PRINT '>'+ @login + '<'

        MERGE INTO [sec].[client] AS t
        USING
        (
            SELECT TOP 1 
                @login AS [login]
                ,[Nachname] AS [name]
                ,[Vorname] AS [firstname]
                ,[eMail] AS [email]
                ,N'DE' AS [language]
                ,0 AS [isDeleted]
            FROM [mig].[benutzer]
            WHERE [UserId] = @login
        ) AS s
        ON s.[login] = t.[login]
        WHEN NOT MATCHED THEN
            INSERT([login],[name],[firstname],[email],[language],[isDeleted],[insertedAt],[insertedBy])
            VALUES(s.[login],s.[name],s.[firstname],s.[email],s.[language],s.[isDeleted],GETDATE(),1)
        WHEN MATCHED THEN 
            UPDATE SET
                t.[name] = s.[name]
                ,t.[firstname] = s.[firstname]
                ,t.[email] = s.[email]
                ,t.[language] = s.[language]
                ,t.[isDeleted] = s.[isDeleted]
				,t.[updatedAt] = GETDATE()
				,t.[updatedBy] = 1
           ;

        SET @userId = 0
        SELECT @userId = [id] FROM [sec].[client] WHERE [login] = @login

        DELETE FROM [sec].[mapClientCompany] WHERE [clientId] = @userId

		DELETE FROM [mig].[mapUserClient] WHERE [dlm3Id] = @userId

        INSERT INTO [sec].[mapClientCompany]([clientId],[companyId])
        SELECT DISTINCT cl.[id],co.[id]
        FROM [sec].[client] cl
        INNER JOIN [mig].[benutzer] mig
            ON mig.[UserID] = cl.[login] COLLATE SQL_Latin1_General_CP1_CI_AS
        INNER JOIN [std].[company] co
            ON co.[name] = mig.[Gesellschaft] COLLATE SQL_Latin1_General_CP1_CI_AS
        WHERE cl.[login] = @login

        SET @rowCount = @@ROWCOUNT

        --PRINT 'INSERT UserId ' + CAST(@userId AS NVARCHAR) + ' ' + @login + ' -> ' + CAST(@rowCount AS NVARCHAR)

		INSERT INTO [mig].[mapUserClient]([dlm2Id],[dlm3Id])
		SELECT [id],@userId 
		FROM [archiv].[dbo_User]
		WHERE [Login] = @login
		AND @userId <> 0

        FETCH NEXT FROM cMig INTO @login

    END
    CLOSE cMig
    DEALLOCATE cMig

END --client
GO
