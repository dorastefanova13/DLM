BEGIN --mapServiceOrderClient

    PRINT '    fill mapServiceOrderClient'

	DECLARE @rowcount INT

    INSERT INTO [dlm].[mapServiceOrderClient] ([clientId],[serviceOrderId])
    SELECT DISTINCT [clientId],[serviceOrderId]
    FROM
    (
        SELECT mUC.[dlm3Id] AS [clientId],sop.[serviceOrderId] AS [serviceOrderId]
        FROM [archiv].[dbo_UserGroup] ug 
        INNER JOIN [mig].[mapUserClient] mUC ON mUC.[dlm2Id] = ug.[UserId]
        INNER JOIN [archiv].[dbo_ServiceSpecification] ssp ON  ssp.[GroupId] = ug.[GroupId]
        INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssp.[Id]
		INNER JOIN [dlm].[priceCatalog] pc ON pc.[siteCatalogId] = mSSSC.[dlm3Id]
		INNER JOIN [dlm].[priceCatalogPosition] pcp ON pcp.[priceCatalogId] = pc.[id]
		INNER JOIN [dlm].[priceCatalogCalculationPosition] pccp ON pccp.[priceCatalogPositionId] = pcp.[id]
		INNER JOIN [dlm].[serviceOrderPosition] sop ON sop.[priceCatalogCalculationPositionId] = pccp.[id]
        WHERE mUC.[dlm3Id] IS NOT NULL
        UNION ALL
        SELECT mUC.[dlm3Id],sop.[serviceOrderId]
        FROM [archiv].[dbo_ServiceSpecification] ssp
        INNER JOIN [mig].[mapUserClient] mUC  ON  ssp.[OwnerId] = mUC.[dlm2Id]
        INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssp.[Id]
		INNER JOIN [dlm].[priceCatalog] pc ON pc.[siteCatalogId] = mSSSC.[dlm3Id]
		INNER JOIN [dlm].[priceCatalogPosition] pcp ON pcp.[priceCatalogId] = pc.[id]
		INNER JOIN [dlm].[priceCatalogCalculationPosition] pccp ON pccp.[priceCatalogPositionId] = pcp.[id]
		INNER JOIN [dlm].[serviceOrderPosition] sop ON sop.[priceCatalogCalculationPositionId] = pccp.[id]
        UNION ALL
        SELECT mUC.[dlm3Id],sop.[serviceOrderId]
        FROM [archiv].[dbo_StandardServicesCatalog] ssc
        INNER JOIN [mig].[mapUserClient] mUC  ON  ssc.[OwnerId] = mUC.[dlm2Id]
        INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSSC ON mSSSC.[dlm2Id] = ssc.[Id]
		INNER JOIN [dlm].[priceCatalog] pc ON pc.[siteCatalogId] = mSSSC.[dlm3Id]
		INNER JOIN [dlm].[priceCatalogPosition] pcp ON pcp.[priceCatalogId] = pc.[id]
		INNER JOIN [dlm].[priceCatalogCalculationPosition] pccp ON pccp.[priceCatalogPositionId] = pcp.[id]
		INNER JOIN [dlm].[serviceOrderPosition] sop ON sop.[priceCatalogCalculationPositionId] = pccp.[id]
    )q

	SET @rowcount = @@ROWCOUNT

	PRINT '       ' + CAST(@rowcount AS NVARCHAR) + ' records'

END --fill mapServiceOrderClient
GO

