BEGIN --serviceOrderPositionStatus

    PRINT '    fill serviceOrderPositionStatus'

    DELETE FROM  [std].[serviceOrderPositionStatus]

    DROP TABLE IF EXISTS [mig].[mapServiceOrderPositionStatusWoItemState]
    CREATE TABLE [mig].[mapServiceOrderPositionStatusWoItemState] (dlm2Id INT, dlm3Id INT)


    BEGIN TRY

        SET IDENTITY_INSERT [std].[serviceOrderPositionStatus] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[serviceOrderPositionStatus]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,N'n/a',N'keine Zuordnung',N'keine Zuordnung',0,GETDATE(),1
    INSERT INTO [mig].[mapServiceOrderPositionStatusWoItemState]([dlm2Id],[dlm3Id]) SELECT 0,0

    INSERT INTO [std].[serviceOrderPositionStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy])
    SELECT 
		[id] /10
		,CASE [id]
			WHEN 10 THEN N'OPEN'
			WHEN 20 THEN N'OK'
			WHEN 30 THEN N'NOTOK'
			ELSE N'n/a'
		END
        ,[name]
        ,[Name]
        ,0
		,GETDATE()
		,1
    FROM [archiv].[dbo_WoItemStateDetail]
    WHERE [lcid] = 1031

    SET IDENTITY_INSERT [std].[serviceOrderPositionStatus] OFF    

    INSERT INTO [mig].[mapServiceOrderPositionStatusWoItemState]([dlm2Id],[dlm3Id])
    SELECT dlm2.[id],dlm3.[id]
    FROM
    (
        SELECT 
            [id]
            ,[name]
        FROM [archiv].[dbo_WoItemStateDetail]
        WHERE [lcid] = 1031
    ) dlm2
    INNER JOIN [std].[serviceOrderStatus] dlm3
        ON dlm2.[name] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[name]


END --serviceOrderStatus
GO
