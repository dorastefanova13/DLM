BEGIN --mapPriceCatalogClient

    PRINT '    fill mapPriceCatalogClient'

	DECLARE @rowcount INT

    INSERT INTO [dlm].[mapPriceCatalogClient] ([clientId],[priceCatalogId],[insertedAt],[insertedBy])
    SELECT DISTINCT [clientId],[priceCatalogId],GETDATE(),1
    FROM
    (
        SELECT mUC.[dlm3Id] AS [clientId],pc.[id] AS [priceCatalogId]
        FROM [archiv].[dbo_UserGroup] ug 
        INNER JOIN [archiv].[dbo_ServiceSpecification] ssp ON  ssp.[GroupId] = ug.[GroupId]
        INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssp.[Id]
		INNER JOIN [dlm].[priceCatalog] pc ON pc.[siteCatalogId] = mSSSC.[dlm3Id]
        INNER JOIN [mig].[mapUserClient] mUC ON mUC.[dlm2Id] = ug.[UserId]
        WHERE mUC.[dlm3Id] IS NOT NULL
        UNION ALL
        SELECT mUC.[dlm3Id],pc.[id]
        FROM [archiv].[dbo_ServiceSpecification] ssp
        INNER JOIN [mig].[mapUserClient] mUC  ON  ssp.[OwnerId] = mUC.[dlm2Id]
        INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssp.[Id]
		INNER JOIN [dlm].[priceCatalog] pc ON pc.[siteCatalogId] = mSSSC.[dlm3Id]
        WHERE mUC.[dlm3Id] IS NOT NULL
        UNION ALL
        SELECT mUC.[dlm3Id],pc.[id]
        FROM [archiv].[dbo_StandardServicesCatalog] ssc
        INNER JOIN [mig].[mapUserClient] mUC  ON  ssc.[OwnerId] = mUC.[dlm2Id]
        INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssc.[Id]
		INNER JOIN [dlm].[priceCatalog] pc ON pc.[siteCatalogId] = mSSSC.[dlm3Id]
        WHERE mUC.[dlm3Id] IS NOT NULL
    )q

	SET @rowcount = @@ROWCOUNT

	PRINT '     ' + CAST(@rowcount AS NVARCHAR) + ' records'

END --mapPriceCatalogClient
GO
