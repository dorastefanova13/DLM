BEGIN --serviceOrderStatus

    PRINT '    fill serviceOrderStatus'

    DELETE FROM  [std].[serviceOrderStatus]

    DROP TABLE IF EXISTS [mig].[mapServiceOrderStatusWoState]
    CREATE TABLE [mig].[mapServiceOrderStatusWoState] (dlm2Id INT, dlm3Id INT)


    BEGIN TRY

        SET IDENTITY_INSERT [std].[serviceOrderStatus] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[serviceOrderStatus]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,N'CREATED',N'erstellt',N'erstellt',0,GETDATE(),1
    INSERT INTO [mig].[mapServiceOrderStatusWoState]([dlm2Id],[dlm3Id]) SELECT 0,0


    INSERT INTO [std].[serviceOrderStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy])
    SELECT 
		[id]/10 AS [id]
		,CASE [id]	
			WHEN 10 THEN N'PROGRESS'
			WHEN 20 THEN N'ORDERED'
			WHEN 30 THEN N'PREBILLED'
			WHEN 40 THEN N'BILLED'
			WHEN 50 THEN N'CANCELLED'
			ELSE N'n/a'
		END AS [code]
        ,[Name] AS [name]
        ,[Name] AS [description]
        ,0 AS [isDeleted]
		,GETDATE()
		,1
    FROM [archiv].[dbo_WoStateDetail]
    WHERE [lcid] = 1031

    SET IDENTITY_INSERT [std].[serviceOrderStatus] OFF    


    INSERT INTO [mig].[mapServiceOrderStatusWoState]([dlm2Id],[dlm3Id])
    SELECT dlm2.[id],dlm3.[id]
    FROM
    (
        SELECT 
            [id]
            ,[name]
        FROM [archiv].[dbo_WoStateDetail]
        WHERE [lcid] = 1031
    ) dlm2
    INNER JOIN [std].[serviceOrderStatus] dlm3
        ON dlm2.[name] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[name]


END --serviceOrderStatus
GO
