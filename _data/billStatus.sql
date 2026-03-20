BEGIN -- billStatus

    PRINT '    fill billState'

    DROP TABLE IF EXISTS [mig].[mapBillStateBillStatus]
    CREATE TABLE [mig].[mapBillStateBillStatus] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [std].[billStatus]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[billStatus] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[billStatus]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,N'n/a',N'keine Zuordnung',N'keine Zuordnung',0,GETDATE(),1
    INSERT [mig].[mapBillStateBillStatus] (dlm2Id,dlm3Id) SELECT 0,0

    INSERT INTO [std].[billStatus]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 6,N'FY235',N'Export FY235',N'Export FY235',0,GETDATE(),1
    INSERT [mig].[mapBillStateBillStatus] (dlm2Id,dlm3Id) SELECT 6,6

    INSERT INTO [std].[billStatus]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 7,N'KB21',N'Export KB21',N'Export KB21',0,GETDATE(),1
    INSERT [mig].[mapBillStateBillStatus] (dlm2Id,dlm3Id) SELECT 7,7

    INSERT INTO [std].[billStatus]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy])
    SELECT 
		CASE t1.[Id]
			WHEN 10 THEN 1
			WHEN 20 THEN 2
			WHEN 30 THEN 3
			WHEN 40 THEN 4
			WHEN 50 THEN 5
			ELSE 99
		END,
		CASE t1.[Id]
			WHEN 10 THEN N'OPEN'
			WHEN 20 THEN N'RELEASED'
			WHEN 30 THEN N'PARTLY'
			WHEN 40 THEN N'CLOSED'
			WHEN 50 THEN N'CANCELLED'
			ELSE N'n/a'
		END,
	t.[DefaultText],t.[DefaultText],0 ,GETDATE(),1
	FROM [archiv].[dbo_BillState] t1 
	INNER JOIN [archiv].[dbo_Text] t 
		ON t.[id] = t1.[NameTextId]

    SET IDENTITY_INSERT [std].[billStatus] OFF    

    INSERT [mig].[mapBillStateBillStatus] (dlm2Id,dlm3Id)
    SELECT dlm2.[Id],dlm3.[id]
    FROM [std].[billStatus] dlm3
    INNER JOIN (
        SELECT t1.[id],t.[DefaultText] COLLATE SQL_Latin1_General_CP1_CI_AI AS [name] 
        FROM [archiv].[dbo_BillState] t1 
        INNER JOIN [archiv].[dbo_Text] t 
            ON t.[id] = t1.[NameTextId]
        ) dlm2
        ON dlm2.[name] = dlm3.[name]
    WHERE dlm3.[id] NOT IN (0,6,7)

END -- billStatus
GO
