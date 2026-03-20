BEGIN --mapServiceCatalogServicePosition

    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '    map ServiceCatalog ServicePosition and UsageType'
    PRINT @msg

    DECLARE @rowCount INT
    
    BEGIN TRY

		PRINT '   fill mapping Catalog <-> Position for global LV'

        INSERT INTO [dlm].[mapServiceCatalogServicePosition]([serviceCatalogId],[servicePositionId])
        SELECT mSSSC.[dlm3Id],mSISP.[dlm3Id]
        FROM [mig].[mapSspItemServicePosition] mSISP
        INNER JOIN [mig].[mapServiceSpecificationServiceCatalog] mSSSC
            ON mSSSC.[dlm2Id] = mSISP.[dlm2SspId]
		INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
			ON ssp.[id] = mSSSC.[dlm2Id]
		WHERE ISNULL(ssp.[isGLobal],0) <> 0 -- nur SspItems aus globalen LVs

        SET @rowCount = @@ROWCOUNT

        PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		PRINT '   fill mapping Catalog <-> Position LV with global LV with not standard'

        INSERT INTO [dlm].[mapServiceCatalogServicePosition]([serviceCatalogId],[servicePositionId])
        SELECT mSSSC.[dlm3Id],mSISP.[dlm3Id]
        FROM [mig].[mapSspItemServicePosition] mSISP
        INNER JOIN [mig].[mapServiceSpecificationServiceCatalog] mSSSC
            ON mSSSC.[dlm2Id] = mSISP.[dlm2SspId]
		INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
			ON ssp.[id] = mSSSC.[dlm2Id]
		WHERE ISNULL(ssp.[GlobalSspId],0) <> 0 -- nur SspItems aus globalen LVs

        SET @rowCount = @@ROWCOUNT

        PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'


		PRINT '   fill mapping Catalog <-> Position for LV without global LV'

        INSERT INTO [dlm].[mapServiceCatalogServicePosition]([serviceCatalogId],[servicePositionId])
		SELECT mTSCC.[dlm3Id],mSISP.[dlm3Id]
		FROM [archiv].[dbo_SspItem] sspi
		INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
			ON ssp.[Id] = sspi.[SspId]
		INNER JOIN  [mig].[mapSspItemServicePosition] mSISP
			ON mSISP.[dlm2Id] = sspi.[id]
		INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC
			ON mSSSC.[dlm2Id] = ssp.[id]
		INNER JOIN [dlm].[siteCatalog] sic
			ON sic.[id] = mSSSC.[dlm3Id]
		INNER JOIN [dlm].[serviceCatalog] svc
			ON svc.[id] = sic.[serviceCatalogId]
		INNER JOIN [mig].[mapTempServiceCatalogCompany] mTSCC
			ON mTSCC.[companyId] = svc.[companyId]
		WHERE ISNULL(ssp.[IsGlobal],0) = 0		--nur SspItems aus nicht globalen LVs
		AND ISNULL(ssp.[GlobalSspId],0) = 0		--nur SspItems aus LVs ohne globalen LV
		AND ISNULL(ssp.[MainSspId],0) = 0		--nur SspItems aus Nicht-SubLVs

        SET @rowCount = @@ROWCOUNT

        PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'


	    PRINT '   fill mapping Position <-> UsageType'

        INSERT INTO [dlm].[mapServicePositionUsageType]([usageTypeId],[servicePositionId])
        SELECT mUTUT.[dlm3Id],mSISP.[dlm3Id]
        FROM  [archiv].[dbo_SspItemUsageType] sspiUt
        INNER JOIN [mig].[mapSspItemServicePosition] mSISP
            ON mSISP.[dlm2Id] = sspiUt.[SspItemId]
        INNER JOIN [mig].[mapUsageTypeUsageType] mUTUT
            ON mUTUT.[dlm2Id] = sspiUt.[UsageTypeId]

        SET @rowCount = @@ROWCOUNT

        PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' mapServiceCatalogServicePosition.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
