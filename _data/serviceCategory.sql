BEGIN --serviceCategory

    PRINT '    fill serviceCategory'

    DROP TABLE IF EXISTS [mig].[mapSspCategoryServiceCategory]
    CREATE TABLE [mig].[mapSspCategoryServiceCategory] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [std].[serviceCategory]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[serviceCategory] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[serviceCategory]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,'n/a','keine Zuordnung','keine Zuordnung',0,GETDATE(),1
    INSERT [mig].[mapSspCategoryServiceCategory] (dlm2Id,dlm3Id) SELECT 0,0

    SET IDENTITY_INSERT [std].[serviceCategory] OFF    

    INSERT INTO [std].[serviceCategory]([code],[description],[name],[isDeleted],[insertedAt],[insertedBy])
    SELECT SUBSTRING(t.[DefaultText],1,3),t.[DefaultText],t.[DefaultText],0 ,GETDATE(),1
	FROM [archiv].[dbo_SspCategory] t1 INNER JOIN [archiv].[dbo_Text] t ON t.[id] = t1.[NameTextId]

    INSERT [mig].[mapSspCategoryServiceCategory] (dlm2Id,dlm3Id)
    SELECT dlm2.[Id],dlm3.[id]
    FROM [std].[serviceCategory] dlm3
    INNER JOIN (SELECT t1.[id],t.[DefaultText] AS [name] FROM [archiv].[dbo_SspCategory] t1 INNER JOIN [archiv].[dbo_Text] t ON t.[id] = t1.[NameTextId]) dlm2
        ON dlm2.[name] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[name]


    --select * from [FAPLISDlm]..sspcategory t1 INNER JOIN [archiv].[dbo_Text] t ON t.[id] = t1.[NameTextId]
    --select * from std.serviceCategory
    --select * from ##mapSspCategoryServiceCategory

END --serviceCategory
GO
