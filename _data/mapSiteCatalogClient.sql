BEGIN --mapSitecatalogClient

    PRINT '    fill mapSitecatalogClient'

    DELETE FROM [dlm].[mapSiteCatalogClient] 
    
    INSERT INTO [dlm].[mapSiteCatalogClient] ([clientId],[siteCatalogId],[insertedAt],[insertedBy])
    SELECT DISTINCT [clientId],[siteCatalogId],GETDATE(),1
    FROM
    (
        SELECT mUC.[dlm3Id] AS [clientId],mSSSC.[dlm3Id] AS [siteCatalogId]
        FROM [archiv].[dbo_UserGroup] ug 
        INNER JOIN [archiv].[dbo_ServiceSpecification] ssp ON  ssp.[GroupId] = ug.[GroupId]
        INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssp.[Id]
        INNER JOIN [mig].[mapUserClient] mUC ON mUC.[dlm2Id] = ug.[UserId]
        INNER JOIN [archiv].[dbo_SspCompany] sspco
            ON sspco.[SspId] = ssp.[id]
        INNER JOIN [mig].[mapCompanyCompany] mCC
            ON mCC.[dlm2Id] = sspco.[CompanyId]
        WHERE mUC.[dlm3Id] IS NOT NULL
        UNION ALL
        SELECT mUC.[dlm3Id],mSSSC.[dlm3Id]
        FROM [archiv].[dbo_ServiceSpecification] ssp
        INNER JOIN [mig].[mapUserClient] mUC  ON  ssp.[OwnerId] = mUC.[dlm2Id]
        INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssp.[Id]
        INNER JOIN [archiv].[dbo_SspCompany] sspco
            ON sspco.[SspId] = ssp.[id]
        INNER JOIN [mig].[mapCompanyCompany] mCC
            ON mCC.[dlm2Id] = sspco.[CompanyId]
        WHERE mUC.[dlm3Id] IS NOT NULL
        UNION ALL
        SELECT mUC.[dlm3Id],mSSSC.[dlm3Id]
        FROM [archiv].[dbo_StandardServicesCatalog] ssc
        INNER JOIN [mig].[mapUserClient] mUC  ON  ssc.[OwnerId] = mUC.[dlm2Id]
        INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssc.[Id]
        INNER JOIN [archiv].[dbo_SscCompany] sscco
            ON sscco.[SscId] = ssc.[id]
        INNER JOIN [mig].[mapCompanyCompany] mCC
            ON mCC.[dlm2Id] = sscco.[CompanyId]
        WHERE mUC.[dlm3Id] IS NOT NULL
    )q

END --mapSitecatalogClient
GO
