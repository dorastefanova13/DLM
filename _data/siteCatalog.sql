BEGIN --siteCatalog

    PRINT '    fill siteCatalog'

    DELETE FROM [dlm].[siteCatalog]

    DECLARE @msg NVARCHAR(MAX)
    
    DECLARE
        @id INT ,
        @mainSspId INT,
		@globalSspId INT,
	    @name NVARCHAR(100) ,
        @sspNo INT,
        @releaseDate DATETIME,
        @description NVARCHAR(400),
	    @bCostCenterId INT ,
	    @cCostCenterId INT ,
    	@sponsorCenter NVARCHAR(100) ,
    	@sponsorDepartment NVARCHAR(100) ,
    	@sponsorName NVARCHAR(100) ,
    	@coNo NVARCHAR(100) ,
    	@pspNo NVARCHAR(100) ,
    	@pmNo NVARCHAR(100) ,
        @rowCount INT,
        @mapCount INT,
        @companyId INT,
        @companyCode NVARCHAR(100),
        @isFrozen BIT,
		@isStandard BIT,
		@serviceTypeId INT

	DECLARE @insAt DATE
	DECLARE @updAt DATE
	DECLARE @insBy INT
	DECLARE @updBy INT
  
    DECLARE @sc_CurrencyId INT = (SELECT [id] FROM [std].[currency] WHERE UPPER([code]) = 'EUR')
    DECLARE @sc_ServiceCatalogId INT
    DECLARE @sc_IsSupplementForId INT

    DECLARE @dlm3Id INT

    BEGIN TRY

        BEGIN --LV

            DROP TABLE IF EXISTS [mig].[mapServiceSpecificationSiteCatalog]
            CREATE TABLE [mig].[mapServiceSpecificationSiteCatalog] (dlm2Id INT, dlm3Id INT)

            CREATE CLUSTERED INDEX [x_mapServiceSpecificationSiteCatalog] ON [mig].[mapServiceSpecificationSiteCatalog]
            (
    	        [dlm2Id] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

			SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [code] = N'UHR'

            BEGIN --   fill siteCatalog - Servicespecification with GlobalSspId and without MainSspId and with global.isStandard = 1

	            SET @msg = '   fill siteCatalog - Servicespecification with GlobalSspId and without MainSspId and with global.isStandard = 1'
		        PRINT @msg

                SET @rowCount = 0

				INSERT INTO [dlm].[siteCatalog] ([name],[description],[serviceCatalogId],[currencyId],[releaseDate],[isReleased],[isDeleted],[isLegacy],[updatedBy])
				OUTPUT inserted.[id],inserted.[updatedBy] INTO [mig].[mapServiceSpecificationSiteCatalog]([dlm3Id],[dlm2Id])
				SELECT 
					SUBSTRING('LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - ' + ISNULL(ssp.[Name] COLLATE SQL_Latin1_General_CP1_CI_AI,'*') + ' ' + ISNULL(co.[code],'*'),1,200)
                    ,'LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - '+ ISNULL(ssp.[Name] COLLATE SQL_Latin1_General_CP1_CI_AI,'*') + ' ' + ISNULL(co.[code],'*') + ' - erstellt bei Migration aus DLM2.0'
					,mSSSC.[dlm3Id] AS [serviceCatalogId]
					,ISNULL(mCUCU.[dlm3Id],@sc_CurrencyId)  AS [currencyId]
					,ssp.[ValidFrom] AS [releaseDate]
					,CASE WHEN ssp.[ValidFrom] IS NULL THEN 0 ELSE 1 END AS [isReleased]
					,0
					,1
					,ssp.[id]
				FROM [archiv].[dbo_ServiceSpecification] ssp				
				INNER JOIN [archiv].[dbo_ServiceSpecification] sspGlobal
					ON sspGlobal.[id] = ssp.[GlobalSspId]
                INNER JOIN [mig].[mapServiceSpecificationServiceCatalog]  mSSSC
                    ON mSSSC.[dlm2Id] = ssp.[GlobalSspId]
                INNER JOIN [dlm].[serviceCatalog] svc
                    ON svc.[id] = mSSSC.[dlm3Id]
                INNER JOIN [archiv].[dbo_SspCompany] sspco
                    ON sspco.[SspId] = ssp.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2Id] = sspco.[CompanyId] 
                INNER JOIN [std].[company] co
                    ON co.[id] = mCOCO.[dlm3Id]
				LEFT OUTER JOIN [mig].[mapCurrencyCurrency] mCUCU
					ON mCUCU.[dlm2Id] = ssp.[CurrencyId]
                WHERE ISNULL(ssp.[isGlobal],0) = 0
                AND ISNULL(ssp.[GlobalSspId],0) <> 0
                AND ISNULL(ssp.[MainSspId],0) = 0
				AND ISNULL(sspGlobal.[IsStandard],0) = 1
                AND mCOCO.[dlm3Id] = svc.[companyId]

				SET @rowCount = @@ROWCOUNT

				PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

			END

            BEGIN --'   fill siteCatalog - Servicespecification with GlobalSspId and without MainSspId and with global.isStandard = 0

	            SET @msg = '   fill siteCatalog - Servicespecification with GlobalSspId and without MainSspId and with global.isStandard = 0'
		        PRINT @msg

                SET @rowCount = 0

				INSERT INTO [dlm].[serviceCatalog] ([name],[description],[companyId],[serviceTypeId],[isDeleted],[isLegacy],[updatedBy])
				OUTPUT inserted.[id],inserted.[updatedBy] INTO [mig].[mapServiceSpecificationServiceCatalog]([dlm3Id],[dlm2Id])
				SELECT 
					SUBSTRING('nonStandard ServiceCatalog for LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - ' + ssp.[Name] COLLATE SQL_Latin1_General_CP1_CI_AI  + N' ' + co.[code],1,200)
					,SUBSTRING('nonStandard ServiceCatalog for LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - ' + ssp.[Name] COLLATE SQL_Latin1_General_CP1_CI_AI  + N' ' + co.[code] + N'- erstellt bei Migration aus DLM2.0',1,200)
					,co.[id]
					,@serviceTypeId
					,0 
					,1
					,ssp.[Id]
				FROM [archiv].[dbo_ServiceSpecification] ssp
				INNER JOIN [archiv].[dbo_ServiceSpecification] sspGlobal
				   ON sspGlobal.[id] = ssp.[GlobalSspId]
                INNER JOIN [archiv].[dbo_SspCompany] sspco
                    ON sspco.[SspId] = ssp.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2Id] = sspco.[CompanyId] 
                INNER JOIN [std].[company] co
                    ON co.[id] = mCOCO.[dlm3Id]
				LEFT OUTER JOIN [mig].[mapCurrencyCurrency] mCUCU
					ON mCUCU.[dlm2Id] = ssp.[CurrencyId]
                WHERE ISNULL(ssp.[isGlobal],0) = 0
                AND ISNULL(ssp.[GlobalSspId],0) <> 0
                AND ISNULL(ssp.[MainSspId],0) = 0
				AND ISNULL(sspGlobal.[IsStandard],0) = 0				  

				UPDATE [mig].[mapServiceSpecificationServiceCatalog] SET [typ] = N'LV global nonstandard' WHERE [typ] IS NULL
																								
				INSERT INTO [dlm].[siteCatalog] ([name],[description],[serviceCatalogId],[currencyId],[releaseDate],[isReleased],[isDeleted],[isLegacy],[updatedBy])
				OUTPUT inserted.[id],inserted.[updatedBy] INTO [mig].[mapServiceSpecificationSiteCatalog]([dlm3Id],[dlm2Id])
				SELECT 
					SUBSTRING('LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - ' + ISNULL(ssp.[Name] COLLATE SQL_Latin1_General_CP1_CI_AI,'*') + ' ' + ISNULL(co.[code],'*'),1,200)
                    ,'LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - '+ ISNULL(ssp.[Name] COLLATE SQL_Latin1_General_CP1_CI_AI,'*') + ' ' + ISNULL(co.[code],'*') + ' - erstellt bei Migration aus DLM2.0'
					,mSSSC.[dlm3Id] AS [serviceCatalogId]
					,ISNULL(mCUCU.[dlm3Id],@sc_CurrencyId) AS [currencyId]
					,ssp.[ValidFrom] AS [releaseDate]
					,CASE WHEN ssp.[ValidFrom] IS NULL THEN 0 ELSE 1 END AS [isReleased]
					,0
					,1
					,ssp.[id]
				FROM [archiv].[dbo_ServiceSpecification] ssp				
				INNER JOIN [archiv].[dbo_ServiceSpecification] sspGlobal
					ON sspGlobal.[id] = ssp.[GlobalSspId]
                INNER JOIN [mig].[mapServiceSpecificationServiceCatalog]  mSSSC
                    ON mSSSC.[dlm2Id] = ssp.[Id]
                INNER JOIN [archiv].[dbo_SspCompany] sspco
                    ON sspco.[SspId] = ssp.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2Id] = sspco.[CompanyId] 
                INNER JOIN [std].[company] co
                    ON co.[id] = mCOCO.[dlm3Id]
				LEFT OUTER JOIN [mig].[mapCurrencyCurrency] mCUCU
					ON mCUCU.[dlm2Id] = ssp.[CurrencyId]
                WHERE ISNULL(ssp.[isGlobal],0) = 0
                AND ISNULL(ssp.[GlobalSspId],0) <> 0
                AND ISNULL(ssp.[MainSspId],0) = 0
				AND ISNULL(sspGlobal.[IsStandard],0) = 0

				SET @rowCount = @@ROWCOUNT

				PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'


            END --'   fill siteCatalog - Servicespecification with GlobalSspId and without MainSspId and with global.isStandard = 0'

            SET @msg = '   fill siteCatalog - Servicespecification without GlobalSspId and without MainSspId'
            PRINT @msg

            BEGIN --'   fill siteCatalog - Servicespecification without GlobalSspId and without MainSspId'

				INSERT INTO [dlm].[siteCatalog] ([name],[description],[serviceCatalogId],[currencyId],[releaseDate],[isReleased],[isDeleted],[isLegacy],[updatedBy])
				OUTPUT inserted.[id],inserted.[updatedBy] INTO [mig].[mapServiceSpecificationSiteCatalog]([dlm3Id],[dlm2Id])
				SELECT 
					SUBSTRING('LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - ' + ISNULL(ssp.[Name] COLLATE SQL_Latin1_General_CP1_CI_AI,'*') + ' ' + ISNULL(co.[code],'*'),1,200)
                    ,'LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - '+ ISNULL(ssp.[Name] COLLATE SQL_Latin1_General_CP1_CI_AI,'*') + ' ' + ISNULL(co.[code],'*') + ' - erstellt bei Migration aus DLM2.0'
					, mTSCC.[dlm3Id] AS [serviceCatalogId]
					,ISNULL(mCUCU.[dlm3Id],@sc_CurrencyId) AS [currencyId]
					,ssp.[ValidFrom] AS [releaseDate]
					,CASE WHEN ssp.[ValidFrom] IS NULL THEN 0 ELSE 1 END AS [isReleased]
					,0
					,1
					,ssp.[id]
				FROM [archiv].[dbo_ServiceSpecification] ssp				
                INNER JOIN [archiv].[dbo_SspCompany] sspco
                    ON sspco.[SspId] = ssp.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2Id] = sspco.[CompanyId] 
                INNER JOIN [std].[company] co
                    ON co.[id] = mCOCO.[dlm3Id]
                INNER JOIN [mig].[mapTempServiceCatalogCompany] mTSCC
                    ON mTSCC.[companyId] = mCOCO.[dlm3Id]
				LEFT OUTER JOIN [mig].[mapCurrencyCurrency] mCUCU
					ON mCUCU.[dlm2Id] = ssp.[CurrencyId]
                WHERE ISNULL(ssp.[isGlobal],0) = 0
                AND ISNULL(ssp.[GlobalSspId],0) = 0
                AND ISNULL(ssp.[MainSspId],0) = 0 

				SET @rowCount = @@ROWCOUNT

				PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

            END --'   fill siteCatalog - Servicespecification without GlobalSspId and without MainSspId'

			BEGIN --update audit columns

				PRINT '   set audit columns'

				UPDATE t1
					SET 
						t1.[insertedAt] = ISNULL(t2.[insertedAt],GETDATE())
						,t1.[updatedAt] = t2.[updatedAt]
						,t1.[insertedBy] = ISNULL(t2.[insertedBy],1)
						,t1.[updatedBy] = t2.[insertedBy]
				FROM [dlm].[siteCatalog] t1
				INNER JOIN (
					SELECT 
						mSSSC.[dlm3Id]
						,ssp.[Created] AS [insertedAt]
						,ssp.[Modified] AS [updatedAt]
						,cr.[dlm3Id] AS [insertedBy]
						,mo.[dlm3Id] AS [updatedBy]
					FROM [mig].[mapServiceSpecificationSiteCatalog] mSSSC
					INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
						ON ssp.[id] = mSSSC.[dlm2Id]
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = ssp.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = ssp.[ModifiedBy]
				) t2
				ON t2.[dlm3Id] = t1.[id]

				SET @rowCount = @@ROWCOUNT

				PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

			END --update audit columns

        END --LV
        BEGIN --EPK

            DROP TABLE IF EXISTS [mig].[mapStandardServicesCatalogSiteCatalog]
            CREATE TABLE [mig].[mapStandardServicesCatalogSiteCatalog] (dlm2Id INT, dlm3Id INT)

            CREATE CLUSTERED INDEX [x_mapStandardServicesCatalogSiteCatalog] ON [mig].[mapStandardServicesCatalogSiteCatalog]
            (
    	        [dlm2Id] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

            SET @msg = '   fill siteCatalog for EPK'
            PRINT @msg

            BEGIN --'   fill siteCatalog for EPK'

                SET @rowCount = 0
                SET @mapCount = 0

                DECLARE cMig CURSOR FOR

					--not global EPK with Companies

                    SELECT 
						ssc.[id]
						,N'EPK ' + CAST(ssc.[SscNo] AS NVARCHAR) + ' ' + co.[code]
						,ssc.[Description]
						,ssc.[validFrom]
						,co.[id]
						,ssc.[Created]
						,cr.[dlm3Id]
						,ssc.[Modified]
						,mo.[dlm3Id]
						,ssc.[IsFrozen]
                    FROM [archiv].[dbo_StandardServicesCatalog] ssc
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = ssc.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = ssc.[ModifiedBy]
                    INNER JOIN [archiv].[dbo_SscCompany] sscco
                        ON sscco.[SscId] = ssc.[id]
                    INNER JOIN [mig].[mapCompanyCompany] mCOCO
                        ON mCOCO.[dlm2Id] = sscco.[CompanyId]
                    INNER JOIN [std].[company] co
                        ON co.[id] = mCOCO.[dlm3Id]
                    WHERE ISNULL([isGlobal],0) = 0 			
                    --AND ISNULL([IsActive],0) = 1
                    --AND ISNULL([BaseSscId],0) = 0 
                    UNION ALL

					--not global EPK without Companies (use Company from PO)

                    SELECT ssc.[id],N'EPK ' + CAST(ssc.[SscNo] AS NVARCHAR) + ' ' + co.[code],ssc.[Description],ssc.[validFrom],co.[id],ssc.[Created],cr.[dlm3Id],ssc.[Modified],mo.[dlm3Id],ssc.[isFrozen]
                    FROM [archiv].[dbo_StandardServicesCatalog] ssc
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = ssc.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = ssc.[ModifiedBy]
                    LEFT OUTER JOIN [archiv].[dbo_SscCompany] sscco
                        ON sscco.[SscId] = ssc.[id]
                    INNER JOIN (SELECT DISTINCT [sscId],[CompanyId] FROM [archiv].[dbo_PurchaseOrder] WHERE [CompanyId] IS NOT NULL) po
                        ON po.[SscId] = ssc.[id]
                    INNER JOIN [mig].[mapCompanyCompany] mCOCO
                        ON mCOCO.[dlm2Id] = po.[CompanyId]
                    INNER JOIN [std].[company] co
                        ON co.[id] = mCOCO.[dlm3Id]
                    WHERE ISNULL([isGlobal],0) = 0 
                    AND ISNULL(sscco.[CompanyId],0) = 0
                    --AND ISNULL([IsActive],0) = 1
                    --AND ISNULL([BaseSscId],0) = 0 
					UNION ALL

					--global EPK with existing PO/WO

                    SELECT ssc.[id],N'EPK ' + CAST(ssc.[SscNo] AS NVARCHAR) + ' (global)' + ' ' + co.[code] ,ssc.[Description],ssc.[validFrom],co.[id],ssc.[Created],cr.[dlm3Id],ssc.[Modified],mo.[dlm3Id],ssc.[isFrozen]
                    FROM [archiv].[dbo_StandardServicesCatalog] ssc
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = ssc.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = ssc.[ModifiedBy]
                    INNER JOIN [archiv].[dbo_SscCompany] sscco
                        ON sscco.[SscId] = ssc.[id]
                    INNER JOIN [mig].[mapCompanyCompany] mCOCO
                        ON mCOCO.[dlm2Id] = sscco.[CompanyId]
                    INNER JOIN [std].[company] co
                        ON co.[id] = mCOCO.[dlm3Id]
                    INNER JOIN (SELECT DISTINCT [sscId],[CompanyId] FROM [archiv].[dbo_PurchaseOrder]) po
                        ON po.[SscId] = ssc.[id]
                        AND po.[CompanyId] = sscco.[CompanyId]
                    WHERE ISNULL([isGlobal],0) = 1		
                    --AND ISNULL([IsActive],0) = 1
                    --AND ISNULL([BaseSscId],0) = 0


                OPEN cMig
                FETCH NEXT FROM cMig INTO @id,@name,@description,@releaseDate,@companyId,@insAt,@insBy,@updAt,@updBy,@isFrozen
                WHILE @@FETCH_STATUS = 0
                BEGIN

                    SET @rowCount = @rowCount + 1

					SET @sc_ServiceCatalogId = 0

                    SELECT @sc_ServiceCatalogId = mSSCSC.[dlm3Id] 
                    FROM [mig].[mapStandardServicesCatalogServiceCatalog] mSSCSC
                    INNER JOIN [dlm].[serviceCatalog] sc
                        ON sc.[id] = mSSCSC.[dlm3Id]
                    WHERE mSSCSC.[dlm2Id] = @id
                    AND sc.[companyId] = @companyId

					--if no servicecatalog exists, use BaseSSC as servicecatalog

					IF @sc_ServiceCatalogId = 0
					BEGIN

						SELECT @sc_ServiceCatalogId = mSSCSC.[dlm3Id]
						FROM [mig].[mapStandardServicesCatalogServiceCatalog] mSSCSC
						INNER JOIN [dlm].[serviceCatalog] sc
							ON sc.[id] = mSSCSC.[dlm3Id]
						WHERE mSSCSC.[dlm2Id] = (
							SELECT [BaseSscId]
							FROM [archiv].[dbo_StandardServicesCatalog] ssc
							WHERE [id] = @id
						)

					END

					IF @sc_ServiceCatalogId = 0
					BEGIN

						PRINT 'serviceCatalog for DLM2.0-SiteCatalogId = ' + CAST(@id AS NVARCHAR) + 'nicht gefunden'

					END
					ELSE
					BEGIN

						INSERT INTO [dlm].[siteCatalog] ([name],[description],[serviceCatalogId],[currencyId],[releaseDate],[isReleased],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
						SELECT
							@name
							,@name + ' ' + @description + ' - erstellt bei Migration aus DLM2.0'
							,@sc_ServiceCatalogId
							,@sc_CurrencyId
							,@updAt
							,CASE WHEN @updAt IS NOT NULL AND @isFrozen = 1 THEN 1 ELSE 0 END
							,0
							,1
							,@insAt
							,@insBy
							,@updAt
							,@updBy

						SET @dlm3Id = @@IDENTITY

						SET @mapCount = @mapCount + 1
 
						INSERT INTO [mig].[mapStandardServicesCatalogSiteCatalog]([dlm2Id],[dlm3Id])
						SELECT @id,@dlm3Id

					END

                    FETCH NEXT FROM cMig INTO @id,@name,@description,@releaseDate,@companyId,@insAt,@insBy,@updAt,@updBy,@isFrozen 

                END

                CLOSE cMig
                DEALLOCATE cMig

                PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

            END --'   fill siteCatalog for EPK'

        END --EPK

    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' siteCatalog.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
