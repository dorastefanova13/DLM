BEGIN --mapSiteCatalogPlant

    PRINT '    fill mapSiteCatalogPlant'

    DELETE FROM [dlm].[mapSiteCatalogPlant]

    --get LV-plant-relations for default plant

    PRINT '   fill LV default plants'

    INSERT INTO [dlm].[mapSiteCatalogPlant]([siteCatalogId],[plantId],[isDefaultPlant])
    SELECT DISTINCT mSSPSC.[dlm3Id],mPP.[dlm3Id],1
    FROM [archiv].[dbo_ServiceSpecification] ssp
    INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSPSC ON mSSPSC.[dlm2Id] = ssp.[Id]
    INNER JOIN [mig].[mapPlantPlant] mPP ON mPP.[dlm2Id] = ssp.[DefaultPlantId]
    INNER JOIN [archiv].[dbo_SspCompany] sspco ON sspco.[SspId] = ssp.[id]
    INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sspco.[CompanyId]


    --get LV-plant-relations for plants not default

    PRINT '   fill LV plants no default'

    INSERT INTO [dlm].[mapSiteCatalogPlant]([siteCatalogId],[plantId],[isDefaultPlant])
    SELECT DISTINCT mSSPSC.[dlm3Id],mPP.[dlm3Id],0
    FROM  
    (
        SELECT DISTINCT ssp.[Id] AS [SspId],sspp.[plantId]
        FROM [archiv].[dbo_ServiceSpecification] ssp
        INNER JOIN [archiv].[dbo_SspPlant] sspp
            ON sspp.[SspId] = ssp.[Id]
        WHERE sspp.[PlantId] <> ssp.[DefaultPlantId]
    ) sspp
    INNER JOIN [mig].[mapPlantPlant] mPP ON mPP.[dlm2Id] = sspp.[PlantId]
    INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSPSC ON mSSPSC.[dlm2Id] = sspp.[SspId]
    INNER JOIN [archiv].[dbo_SspCompany] sspco ON sspco.[SspId] = sspp.[SspId]
    INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sspco.[CompanyId]
    WHERE NOT EXISTS 
    (
        SELECT 1
        FROM [dlm].[mapSiteCatalogPlant] WITH(nolock)
        WHERE [plantId] = mPP.[dlm3Id]
        AND [siteCatalogId] = mSSPSC.[dlm3Id]
    )
    --get EPK-plant-relations from SscPlant (not global EPK)

    PRINT '   fill EPK plants from SscPlant (not global EPK)'

    INSERT INTO [dlm].[mapSiteCatalogPlant]([siteCatalogId],[plantId],[isDefaultPlant])
    SELECT DISTINCT mSSCSC.[dlm3Id],mPP.[dlm3Id],1
    FROM (SELECT [SscId],[PlantId] FROM [archiv].[dbo_SscPlant]) sscp
    INNER JOIN [mig].[mapPlantPlant] mPP ON mPP.[dlm2Id] = sscp.[PlantId]
    INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSCSC ON mSSCSC.[dlm2Id] = sscp.[SscId]
    INNER JOIN [archiv].[dbo_SscCompany] sscco ON sscco.[SscId] = sscp.[SscId]
    INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sscco.[CompanyId]
    WHERE mSSCSC.[dlm3Id] IS NOT NULL


    --get EPK-plant-relations from WorkOrder (global EPK)

    PRINT '   fill EPK plants from WorkOrder (global EPK)'

    INSERT INTO [dlm].[mapSiteCatalogPlant]([siteCatalogId],[plantId],[isDefaultPlant])
    SELECT DISTINCT mSSCSC.[dlm3Id],mPP.[dlm3Id],1
	FROM (
		SELECT DISTINCT ssc.[id] AS sscId,wo.[PlantId]
		FROM [archiv].[dbo_WorkOrder] wo
		INNER JOIN [archiv].[dbo_PurchaseOrder] po
			ON po.[id] = wo.[PoId]
		INNER JOIN [archiv].[dbo_StandardServicesCatalog] ssc
			ON ssc.[id] = po.[SscId]
		WHERE ssc.[IsGlobal] = 1
		--AND wo.[SubPlantId] IS NULL
	) q
	INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSCSC
		ON mSSCSC.[dlm2Id] = q.[sscId]
	INNER JOIN [mig].[mapPlantPlant] mPP
		ON mPP.[dlm2Id] = q.[PlantId]
    INNER JOIN [archiv].[dbo_SscCompany] sscco ON sscco.[SscId] = q.[SscId]
    INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sscco.[CompanyId]
    WHERE mSSCSC.[dlm3Id] IS NOT NULL

    --set audit fields

    PRINT '   set audit fields'

	UPDATE [dlm].[mapSiteCatalogPlant] SET [insertedAt] = GETDATE(),[insertedBy] = 1


END --mapSiteCatalogPlant
GO



