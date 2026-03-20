BEGIN --mapClientCompany

    PRINT '    fill mapClientCompany'

    DELETE FROM [sec].[mapClientCompany]

    INSERT INTO [sec].[mapClientCompany]([clientId],[companyId])
    SELECT mcl.[dlm3Id],dlm3co.[id]
    FROM [archiv].[dbo_UserCompany] uc
    INNER JOIN [mig].[mapUserClient] mcl ON mcl.[dlm2Id] = uc.[UserId]
    INNER JOIN [archiv].[dbo_Company] dlm2co ON dlm2co.[Id] = uc.[CompanyId]
    INNER JOIN [std].[company] dlm3co ON dlm3co.[code] = dlm2co.[Code]

END --mapClientCompany
GO
