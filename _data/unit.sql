BEGIN --unit

    PRINT '    fill unit'

    DROP TABLE IF EXISTS [mig].[mapUnitUnit]
    CREATE TABLE [mig].[mapUnitUnit] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [std].[unit]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[unit] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[unit]([id],[code],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,N'n/a',N'keine Zuordnung',0,GETDATE(),1
    INSERT INTO [mig].[mapUnitUnit]([dlm2Id],[dlm3Id]) SELECT 0,0

    INSERT INTO [std].[unit]([id],[code],[name],[isDeleted],[insertedAt],[insertedBy])
    SELECT 
		t1.[id]
		,CASE t1.[id]
			WHEN 1 THEN N'NONE'
			WHEN 2 THEN N'HOUR'
			WHEN 3 THEN N'KG'
			WHEN 4 THEN N'LFM'
			WHEN 5 THEN N'LITER'
			WHEN 6 THEN N'M'
			WHEN 7 THEN N'QM'
			WHEN 8 THEN N'CM'
			WHEN 9 THEN N'PAUSCH'
			WHEN 10 THEN N'HOUR'
			WHEN 11 THEN N'ITEM'
			WHEN 12 THEN N'TON'
			ELSE N'n/a'
		END
		,t.[DefaultText]
		,0 
		,t1.[Created]
		,1
	FROM [archiv].[dbo_Unit] t1 
	INNER JOIN [archiv].[dbo_Text] t 
	ON t.[id] = t1.[NameTextId]

    INSERT [mig].[mapUnitUnit] (dlm2Id,dlm3Id)
    SELECT dlm2.[Id],dlm3.[id]
    FROM  [std].[Unit] dlm3
    INNER JOIN (SELECT t1.[id],t.[DefaultText] AS [name] FROM [archiv].[dbo_Unit] t1 INNER JOIN [archiv].[dbo_Text] t ON t.[id] = t1.[NameTextId]) dlm2
        ON dlm2.[name] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[name]

    SET IDENTITY_INSERT [std].[unit] OFF 

END -- unit
GO
