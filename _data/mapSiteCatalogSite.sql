BEGIN --mapSiteCatalogSite

    PRINT '    fill mapSiteCatalogSite'

    DELETE FROM [dlm].[mapSiteCatalogSite]

    --get LV-location-relations with not empty SubPlantId - assign siteId direct from subplant from table location

    PRINT '   fill LV-location-relations with not empty SubPlantId'

    INSERT INTO [dlm].[mapSiteCatalogSite]([siteCatalogId],[siteId])
    SELECT DISTINCT mSSSC.[dlm3Id],sp.[siteId]
    FROM (SELECT * FROM [archiv].[dbo_SspLocation] WHERE [SubPlantId] IS NOT NULL)    sl
    INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC 
		ON mSSSC.[dlm2Id] = sl.[SspId]
    INNER JOIN [mig].[mapSubPlantSubPlant] mSS 
		ON mSS.[dlm2Id] = sl.[SubPlantId]
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'subplant' AND [siteId] IS NOT NULL) sp 
		ON sp.[id] = mSS.[dlm3Id]
    INNER JOIN [archiv].[dbo_SspCompany] sspco ON sspco.[SspId] = sl.[SspId]
    INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sspco.[CompanyId]

    

    --get LV-location-relations with empty SubPlantId - assign siteId from all subplants for plant

    PRINT '   fill LV-location-relations with empty SubPlantId'

    MERGE INTO [dlm].[mapSiteCatalogSite] AS t
    USING
    (
        SELECT DISTINCT mSSSC.[dlm3Id] AS [siteCatalogId],sp.[siteId] AS [siteId]
        FROM (SELECT * FROM [archiv].[dbo_SspLocation] WHERE [SubPlantId] IS NULL)    sl
        INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC 
			ON mSSSC.[dlm2Id] = sl.[SspId]
        INNER JOIN [archiv].[dbo_SspCompany] sspco ON sspco.[SspId] = sl.[SspId]
        INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sspco.[CompanyId]
        INNER JOIN [mig].[mapPlantPlant] mPP 
			ON mPP.[dlm2Id] = sl.[PlantId]
        INNER JOIN (
			SELECT ll.[siteId],lmlp.[plantId] 
			FROM [loc].[location] ll
			INNER JOIN [loc].[mapLocationPlant] lmlp
				ON ll.[id] = lmlp.[locationId]
			WHERE ll.[type] = 'subplant' 
			AND ll.[siteId] IS NOT NULL
		) sp 
			ON sp.[plantId] = mPP.[dlm3Id]
    ) AS s
    ON t.[siteCatalogId] = s.[siteCatalogId]
    AND t.[siteId] = s.[siteId]
    WHEN NOT MATCHED THEN
        INSERT ([siteCatalogId],[siteId])
        VALUES (s.[siteCatalogId],s.[siteId]);

    --get EPK-sites - assign siteId from all subplants for plant from SscPlant (not global EPK)

    PRINT '   fill EPK-sites for not global EPK'

    MERGE INTO [dlm].[mapSiteCatalogSite] AS t
    USING
    (
        SELECT DISTINCT mSSCSC.[dlm3Id] AS [siteCatalogId],sp.[siteId]
        FROM (SELECT [SscId],[PlantId] FROM [archiv].[dbo_SscPlant]) p
        INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSCSC ON mSSCSC.[dlm2Id] = p.[SscId]
        INNER JOIN [archiv].[dbo_SscCompany] sscco ON sscco.[SscId] = p.[SscId]
        INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sscco.[CompanyId]
        INNER JOIN [mig].[mapPlantPlant] mPP ON mPP.[dlm2Id] = p.[PlantId]
        INNER JOIN (
		    SELECT ll.[siteId],lmlp.[plantId] 
		    FROM [loc].[location] ll
		    INNER JOIN [loc].[mapLocationPlant] lmlp
			    ON ll.[id] = lmlp.[locationId]
		    WHERE ll.[type] = 'subplant' 
		    AND ll.[siteId] IS NOT NULL
	    ) sp 
		    ON sp.[plantId] = mPP.[dlm3Id] 
        WHERE mSSCSC.[dlm3Id] IS NOT NULL
    ) AS s
    ON t.[siteCatalogId] = s.[siteCatalogId]
    AND t.[siteId] = s.[siteId]
    WHEN NOT MATCHED THEN
        INSERT ([siteCatalogId],[siteId])
        VALUES (s.[siteCatalogId],s.[siteId]);

	-- get EPK-sites for global EPK and assigned ServiceOrder with assigned SubPlant

    PRINT '   fill EPK-sites for global EPK and assigned ServiceOrder with assigned SubPlant'

    MERGE INTO [dlm].[mapSiteCatalogSite] AS t
    USING
    (
        SELECT DISTINCT mSSCSC.[dlm3Id] AS [siteCatalogId],sp.[siteId]
	    FROM
	    (
		    SELECT DISTINCT ssc.[id] AS sscId,wo.[SubPlantId]
		    FROM [archiv].[dbo_WorkOrder] wo
		    INNER JOIN [archiv].[dbo_PurchaseOrder] po
			    ON po.[id] = wo.[PoId]
		    INNER JOIN [archiv].[dbo_StandardServicesCatalog] ssc
			    ON ssc.[id] = po.[SscId]
		    WHERE ssc.[IsGlobal] = 1
		    AND wo.[SubPlantId] IS NOT NULL
	    ) q
	    INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSCSC
		    ON mSSCSC.[dlm2Id] = q.[sscId]
        INNER JOIN [archiv].[dbo_SscCompany] sscco ON sscco.[SscId] = q.[SscId]
        INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sscco.[CompanyId]
	    INNER JOIN [mig].[mapSubPlantSubPlant] mSS 
		    ON mSS.[dlm2Id] = q.[SubPlantId]
        INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'subplant' AND [siteId] IS NOT NULL) sp 
		    ON sp.[id] = mSS.[dlm3Id]
        WHERE mSSCSC.[dlm3Id] IS NOT NULL
    ) AS s
    ON t.[siteCatalogId] = s.[siteCatalogId]
    AND t.[siteId] = s.[siteId]
    WHEN NOT MATCHED THEN
        INSERT ([siteCatalogId],[siteId])
        VALUES (s.[siteCatalogId],s.[siteId]);


	-- get EPK-sites for global EPK and assigned ServiceOrder with only assigned Plant

    PRINT '   fill EPK-sites for global EPK and assigned ServiceOrder with only assigned Plant'


    MERGE INTO [dlm].[mapSiteCatalogSite] AS t
	USING (
		SELECT DISTINCT mSSCSC.[dlm3Id] AS [siteCatalogId],sp.[siteId]
		FROM
		(
			SELECT DISTINCT ssc.[id] AS sscId,wo.[PlantId]
			FROM [archiv].[dbo_WorkOrder] wo
			INNER JOIN [archiv].[dbo_PurchaseOrder] po
				ON po.[id] = wo.[PoId]
			INNER JOIN [archiv].[dbo_StandardServicesCatalog] ssc
				ON ssc.[id] = po.[SscId]
			WHERE ssc.[IsGlobal] = 1
			AND wo.[SubPlantId] IS NULL
		) q
		INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSCSC
			ON mSSCSC.[dlm2Id] = q.[sscId]
        INNER JOIN [archiv].[dbo_SscCompany] sscco ON sscco.[SscId] = q.[SscId]
        INNER JOIN [mig].[mapCompanyCompany] mCC ON mCC.[dlm2Id] = sscco.[CompanyId]
		INNER JOIN [mig].[mapPlantPlant] mPP
			ON mPP.[dlm2Id] = q.[PlantId]
		INNER JOIN (
			SELECT ll.[siteId],lmlp.[plantId] 
			FROM [loc].[location] ll
			INNER JOIN [loc].[mapLocationPlant] lmlp
				ON ll.[id] = lmlp.[locationId]
			WHERE ll.[type] = 'subplant' 
			AND ll.[siteId] IS NOT NULL
		) sp 
			ON sp.[plantId] = mPP.[dlm3Id]
        WHERE mSSCSC.[dlm3Id] IS NOT NULL
	) AS s
	ON s.[siteCatalogId] = t.[siteCatalogId]
	AND s.[siteId] = t.[siteId]
	WHEN NOT MATCHED THEN 
		INSERT ([siteCatalogId],[siteId])
		VALUES (s.[siteCatalogId],s.[siteId]);

END --mapSiteCatalogSite
GO


