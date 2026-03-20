BEGIN --company

    PRINT '    fill company'

    DROP TABLE IF EXISTS [mig].[mapCompanyCompany]
    CREATE TABLE [mig].[mapCompanyCompany] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [std].[company]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[company] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[company]([id],[name],[description],[code],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,'keine Zuordnung','keine Zuordnung','n/a',1,0,GETDATE(),1
    INSERT [mig].[mapCompanyCompany] (dlm2Id,dlm3Id) SELECT 0,0

    INSERT INTO [std].[company] ([id],[name],[code],[description],[isActive],[isDeleted],[insertedAt],[insertedBy])
    SELECT [id],[Name],[Code],[Description],[IsActive],0 ,GETDATE(),1
	FROM [archiv].[dbo_Company]
	--WHERE [code] = 'MBAG'
    WHERE [code] = 'DTAG'
       

    SET IDENTITY_INSERT [std].[company] OFF 

    INSERT [mig].[mapCompanyCompany] (dlm2Id,dlm3Id)
    SELECT dlm2.[Id],dlm3.[id]
    FROM  [archiv].[dbo_Company] dlm2
    INNER JOIN [std].[company] dlm3
        ON dlm2.[Code] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[code]

END --company
GO
