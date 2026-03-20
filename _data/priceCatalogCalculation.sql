BEGIN --priceCatalogCalculation

    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '    fill priceCatalogCalculation'
    PRINT @msg

    DECLARE @rowCount INT
    
    BEGIN TRY

        DELETE FROM [dlm].[priceCatalogCalculation]

        DECLARE @priceCatalogStatusCalculationCREATEDId INT = (SELECT [id] FROM [std].[priceCatalogCalculationStatus] WHERE [code] = N'OPEN')
        DECLARE @priceCatalogStatusCalculationCONTRACTId INT = (SELECT [id] FROM [std].[priceCatalogCalculationStatus] WHERE [code] = N'AWARDED')
        DECLARE @priceCatalogStatusCalculationDECLINEDId INT = (SELECT [id] FROM [std].[priceCatalogCalculationStatus] WHERE [code] = N'DECLINED')
        DECLARE @serviceTypeId INT

		DROP TABLE IF EXISTS [mig].[mapQuotePriceCatalogCalculation]
		CREATE TABLE [mig].[mapQuotePriceCatalogCalculation] (dlm2Id INT, dlm3Id INT, typ NVARCHAR(100))

        BEGIN --priceCatalogCalculation LV	 with global LV

            SET @msg = '   fill priceCatalogCalculation LV  with global LV'
            
            PRINT @msg

            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE UPPER([name]) = UPPER('Unterhaltsreinigung')

			MERGE INTO [dlm].[priceCatalogCalculation] AS t
			USING (
				SELECT DISTINCT
					pc.[id] as [priceCatalogId]
					,price.[quoteId] AS [quoteId]
					,ISNULL(mSS.[dlm3id],2) AS [supplierId]
					,CASE 
						WHEN ISNULL(price.[IsAccepted],0) = 1 THEN @priceCatalogStatusCalculationCONTRACTId
						WHEN price.[SspId] IS NULL THEN @priceCatalogStatusCalculationCREATEDId
						ELSE @priceCatalogStatusCalculationDECLINEDId 
					END	AS [priceCatalogCalculationStatusId]
					,ISNULL(price.[discount],0) AS [supplierPriceChange]
					,ISNULL(price.[IsAccepted],0) AS [isReleased]
					,ISNULL(sd.[discount],0) AS [discount]
					,0 AS [isDeleted]
					,1 AS [isLegacy]
					,ISNULL(price.[Created],GETDATE()) AS [insertedAt]
					,ISNULL(price.[CreatedBy],1) AS [insertedBy]
					,price.[Modified] AS [updatedAt]
					,price.[ModifiedBy] AS [updatedBy]
				FROM [dlm].[priceCatalog] pc                                            --1 priceCatalogCalculation per priceCataLog
				INNER JOIN [dlm].[siteCatalog] sc                                       --get parent siteCatalog
					ON sc.[id] = pc.[siteCatalogId]
				INNER JOIN [dlm].[serviceCatalog] svc
					ON svc.[id] = sc.[serviceCatalogId]
				INNER JOIN [mig].[mapServiceSpecificationServiceCatalog] mSSSC          --get dlm2-LV-id
					ON mSSSC.[dlm3Id] = sc.[serviceCatalogId]
				INNER JOIN [archiv].[dbo_ServiceSpecification] globalSsp           --get LV for dlm2-supplier-id
					ON globalSsp.[id] = mSSSC.[dlm2id]
				INNER JOIN [archiv].[dbo_SspCompany] sspco
					ON sspco.[SspId] = globalSsp.[id]
				INNER JOIN [archiv].[dbo_Company] c
					ON c.[id] = sspco.[CompanyId]
				INNER JOIN [mig].[mapCompanyCompany] mcc
					ON c.[id] = mcc.[dlm2Id]
				INNER JOIN  [mig].[mapServiceSpecificationSiteCatalog] mSSSTC
					ON mSSSTC.[dlm3Id] = sc.[id]
				INNER JOIN [archiv].[dbo_ServiceSpecification] mainSsp
					ON mainSsp.[id] = mSSSTC.[dlm2Id]
				INNER JOIN [std].[company] co
					ON co.[id] = svc.[companyId]
				LEFT OUTER JOIN 
				(
					SELECT sq.[id] AS [quoteId], sqrg.[SspId] AS [sspId] ,sqr.[SupplierId],(sq.[Discount] / 100) AS [discount], sq.[IsAccepted],sq.[Created],ISNULL(cr.[dlm3Id],1) AS [CreatedBy],sq.[Modified],ISNULL(mo.[dlm3Id],1) AS [ModifiedBy]
					FROM [archiv].[dbo_SspQuote] sq
					INNER JOIN [archiv].[dbo_SspQuoteRequest] sqr
						ON sqr.[id] = sq.[RequestId]
					INNER JOIN [archiv].[dbo_SspQuoteRequestGroup] sqrg
						ON sqrg.[id] = sqr.[GroupId]
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = sq.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = sq.[ModifiedBy]
				) price                                                         --get discount from acceptedPrice
				ON price.[SspId] = mainSsp.[id]
				INNER JOIN [mig].[mapSupplierSupplier] mSS                      --get dlm3-supplier-id
					ON mSS.[dlm2Id] = price.[SupplierId]
				LEFT OUTER JOIN [archiv].[dbo_SspDiscount] sd
					ON sd.[SspId] = mainSsp.[id]
				WHERE svc.[companyId] = mCC.[dlm3Id]
				AND svc.[id] IN (
					SELECT [serviceCatalogId] 
					FROM [dlm].[mapServiceCatalogServicePosition] 
					WHERE [servicePositionId] IN                                        --all ServicePosistion for 'Unterhaltsreinigung'
					(
						SELECT [id] 
						FROM [dlm].[servicePosition] 
						WHERE [serviceTypeId] = @serviceTypeId
					)
				)
				AND svc.[id] NOT IN (
					SELECT [dlm3Id]
					FROM mig.[mapTempServiceCatalogCompany]
				)
			) AS s
			ON s.[priceCatalogId] = t.[priceCatalogId]
			AND s.[supplierId] = t.[supplierId]
			AND s.[insertedAt] = t.[insertedAt]
			WHEN NOT MATCHED THEN
				INSERT ([priceCatalogId],[supplierId],[priceCatalogCalculationStatusId],[supplierPriceChange],[isReleased],[discount],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
				VALUES (s.[priceCatalogId],s.[supplierId],s.[priceCatalogCalculationStatusId],s.[supplierPriceChange],s.[isReleased],s.[discount],s.[isDeleted],s.[isLegacy],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
			OUTPUT s.[quoteId],inserted.[id],N'SSP with global'
            INTO [mig].[mapQuotePriceCatalogCalculation]([dlm2Id],[dlm3Id],[typ])
			;

            SELECT @rowCount = COUNT(1) FROM [mig].[mapQuotePriceCatalogCalculation] WHERE [typ] = N'SSP with global'

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --priceCatalogCalculation LV  with global LV

        BEGIN --priceCatalogCalculation LV	 without global LV

            SET @msg = '   fill priceCatalogCalculation LV  without global LV'

            PRINT @msg

            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE UPPER([name]) = UPPER('Unterhaltsreinigung')
			
			MERGE INTO [dlm].[priceCatalogCalculation] AS t
			USING (
				SELECT DISTINCT
					pc.[id] AS [priceCatalogId]
					,price.[quoteId]
					,ISNULL(mSS.[dlm3id],2) AS [supplierId]
					,CASE 
						WHEN ISNULL(price.[IsAccepted],0) = 1 THEN @priceCatalogStatusCalculationCONTRACTId
						WHEN price.[SspId] IS NULL THEN @priceCatalogStatusCalculationCREATEDId
						ELSE @priceCatalogStatusCalculationDECLINEDId 
					END	[priceCatalogCalculationStatusId]
					,ISNULL(price.[discount],0) AS [supplierPriceChange]
					,ISNULL(price.[IsAccepted],0) AS [isReleased]
					,ISNULL(sd.[discount],0) AS [discount]
					,0 AS [isDeleted]
					,1 AS [isLegacy]
					,ISNULL(price.[Created],GETDATE()) AS [insertedAt]
					,ISNULL(price.[CreatedBy],1) AS [insertedBy]
					,price.[Modified] AS [updatedAt]
					,price.[ModifiedBy] AS [updatedBy]
				FROM [dlm].[priceCatalog] pc                                            --1 priceCatalogCalculation per priceCataLog
				INNER JOIN [dlm].[siteCatalog] sc                                       --get parent siteCatalog
					ON sc.[id] = pc.[siteCatalogId]
				INNER JOIN [dlm].[serviceCatalog] svc
					ON svc.[id] = sc.[serviceCatalogId]
				INNER JOIN [mig].[mapTempServiceCatalogCompany] mSCC					--get temp catalog company
					ON mSCC.[dlm3Id] = sc.[serviceCatalogId]
				INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSPSC
					ON mSSPSC.[dlm3Id] = sc.[id]																			 
				INNER JOIN [archiv].[dbo_ServiceSpecification] globalSsp           --get LV for dlm2-supplier-id
					ON globalSsp.[id] = mSSPSC.[dlm2id]
				INNER JOIN [archiv].[dbo_SspCompany] sspco
					ON sspco.[SspId] = globalSsp.[id]
				INNER JOIN [archiv].[dbo_Company] c
					ON c.[id] = sspco.[CompanyId]
				INNER JOIN [mig].[mapCompanyCompany] mcc
					ON c.[id] = mcc.[dlm2Id]
				INNER JOIN  [mig].[mapServiceSpecificationSiteCatalog] mSSSTC
					ON mSSSTC.[dlm3Id] = sc.[id]
				INNER JOIN [std].[company] co
					ON co.[id] = svc.[companyId]
				LEFT OUTER JOIN 
				(
					SELECT sq.[id] AS [quoteId], sqrg.[SspId] AS [sspId] ,sqr.[SupplierId],(sq.[Discount] / 100) AS [discount], sq.[IsAccepted],sq.[Created],ISNULL(cr.[dlm3Id],1) AS [CreatedBy],sq.[Modified],ISNULL(mo.[dlm3Id],1) AS [ModifiedBy]
					FROM [archiv].[dbo_SspQuote] sq
					INNER JOIN [archiv].[dbo_SspQuoteRequest] sqr
						ON sqr.[id] = sq.[RequestId]
					INNER JOIN [archiv].[dbo_SspQuoteRequestGroup] sqrg
						ON sqrg.[id] = sqr.[GroupId]
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = sq.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = sq.[ModifiedBy]
				) price                                                         --get discount from acceptedPrice
				ON price.[SspId] = globalSsp.[id]
				INNER JOIN [mig].[mapSupplierSupplier] mSS                      --get dlm3-supplier-id
					ON mSS.[dlm2Id] = price.[SupplierId]
				LEFT OUTER JOIN [archiv].[dbo_SspDiscount] sd
					ON sd.[SspId] = globalSsp.[id]
				WHERE svc.[companyId] = mCC.[dlm3Id]
				AND svc.[id] IN (
					SELECT [serviceCatalogId] 
					FROM [dlm].[mapServiceCatalogServicePosition] 
					WHERE [servicePositionId] IN                                        --all ServicePosistion for 'Unterhaltsreinigung'
					(
						SELECT [id] 
						FROM [dlm].[servicePosition] 
						WHERE [serviceTypeId] = @serviceTypeId
					)
				)
				AND svc.[id] IN (
					SELECT [dlm3Id]
					FROM [mig].[mapTempServiceCatalogCompany]
				)
			) AS s
			ON s.[priceCatalogId] = t.[priceCatalogId]
			AND s.[supplierId] = t.[supplierId]
			AND s.[insertedAt] = t.[insertedAt]
			WHEN NOT MATCHED THEN
				INSERT ([priceCatalogId],[supplierId],[priceCatalogCalculationStatusId],[supplierPriceChange],[isReleased],[discount],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
				VALUES (s.[priceCatalogId],s.[supplierId],s.[priceCatalogCalculationStatusId],s.[supplierPriceChange],s.[isReleased],s.[discount],s.[isDeleted],s.[isLegacy],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
			OUTPUT s.[quoteId],inserted.[id],N'SSP without global'
            INTO [mig].[mapQuotePriceCatalogCalculation]([dlm2Id],[dlm3Id],[typ])
			;

            SELECT @rowCount = COUNT(1) FROM [mig].[mapQuotePriceCatalogCalculation] WHERE [typ] = N'SSP without global'

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --priceCatalogCalculation LV  without global LV

        BEGIN --priceCatalogCalculation EPK not global

            SET @msg = '   fill priceCatalogCalculation EPK not global'

            PRINT @msg

            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [Code] = N'ADHOC'

			MERGE INTO [dlm].[priceCatalogCalculation] AS t
			USING (
				SELECT DISTINCT
					pc.[id] AS [priceCatalogId]
					,mSS.[dlm3id] AS [supplierId]
					,price.[quoteId]
					,CASE 
						WHEN ISNULL(price.[IsAccepted],0) = 1 THEN @priceCatalogStatusCalculationCONTRACTId
						WHEN price.[SscId] IS NULL THEN @priceCatalogStatusCalculationCREATEDId
						ELSE @priceCatalogStatusCalculationDECLINEDId 
					END	AS [priceCatalogCalculationStatusId]
					,0 AS [supplierPriceChange]
					,ISNULL(price.[IsAccepted],0) AS [isReleased]
					,0 AS [discount]
					,0 AS [isDeleted]
					,1 AS [isLegacy]
					,ISNULL(price.[Created],GETDATE()) AS [insertedAt]
					,ISNULL(price.[CreatedBy],1) AS [insertedBy]
					,price.[Modified] AS [updatedAt]
					,price.[ModifiedBy] AS [updatedBy]
				FROM [dlm].[priceCatalog] pc                                            --one priceCatalogCalculation per priceCataLog
				INNER JOIN [dlm].[siteCatalog] sc                                       --get parent siteCatalog
					ON sc.[id] = pc.[siteCatalogId]
				INNER JOIN [mig].[mapStandardServicesCatalogServiceCatalog] mSSCSC      --get dlm2-EPK-id
					ON mSSCSC.[dlm3Id] = sc.[serviceCatalogId]
				INNER JOIN [archiv].[dbo_StandardServicesCatalog] ssc               --get EPK for dlm2-supplier-id
					ON ssc.[id] = mSSCSC.[dlm2id]
				LEFT OUTER JOIN 
				(
					SELECT sq.[id] AS [quoteId],sqrg.[SscId],sqr.[SupplierId],sq.[IsAccepted],sq.[Created],ISNULL(cr.[dlm3Id],1) AS [CreatedBy],sq.[Modified],ISNULL(mo.[dlm3Id],1) AS [ModifiedBy]
					FROM [archiv].[dbo_SscQuote] sq
					INNER JOIN [archiv].[dbo_SscQuoteRequest] sqr
						ON sqr.[id] = sq.[RequestId]
					INNER JOIN [archiv].[dbo_SscQuoteRequestGroup] sqrg
						ON sqrg.[id] = sqr.[GroupId]
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = sq.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = sq.[ModifiedBy]
					WHERE sqrg.[SupplementSscId] IS NULL
				) price                                                         --get discount from acceptedPrice
				ON price.[SscId] = ssc.[id]
				INNER JOIN [mig].[mapSupplierSupplier] mSS                      --get dlm3-supplier-id
					ON mSS.[dlm2Id] = price.[SupplierId]
				WHERE sc.[id] IN														--all SiteCatalogs with 'adHoc'-Positions
				(
					SELECT [siteCatalogId]
					FROM [dlm].[siteCatalogPosition] scp
					INNER JOIN [dlm].[servicePosition] svp
						ON svp.[id] = scp.[servicePositionId]
					INNER JOIN [std].[company] co
						ON co.[id] = svp.[companyId]
					WHERE svp.[serviceTypeId] = @serviceTypeId
				)
				AND ssc.[isGlobal] <> 1
			) AS s
			ON s.[priceCatalogId] = t.[priceCatalogId]
			AND s.[supplierId] = t.[supplierId]
			AND s.[insertedAt] = t.[insertedAt]
			WHEN NOT MATCHED THEN
				INSERT ([priceCatalogId],[supplierId],[priceCatalogCalculationStatusId],[supplierPriceChange],[isReleased],[discount],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
				VALUES (s.[priceCatalogId],s.[supplierId],s.[priceCatalogCalculationStatusId],s.[supplierPriceChange],s.[isReleased],s.[discount],s.[isDeleted],s.[isLegacy],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
			OUTPUT s.[quoteId],inserted.[id],N'SSC not global'
            INTO [mig].[mapQuotePriceCatalogCalculation]([dlm2Id],[dlm3Id],[typ])
			;

            SELECT @rowCount = COUNT(1) FROM [mig].[mapQuotePriceCatalogCalculation] WHERE [typ] = N'SSC not global'

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --priceCatalogCalculation EPK not global

        BEGIN --priceCatalogCalculation EPK global

            SET @msg = '   fill priceCatalogCalculation EPK global'

            PRINT @msg

            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [Code] = N'ADHOC'

			MERGE INTO [dlm].[priceCatalogCalculation] AS t
			USING (
				SELECT DISTINCT
					pc.[id] AS [priceCatalogId]
					,mSS.[dlm3id] AS [supplierId]
					,price.[quoteId]
					,CASE 
						WHEN ISNULL(price.[IsAccepted],0) = 1 THEN @priceCatalogStatusCalculationCONTRACTId
						WHEN price.[SscId] IS NULL THEN @priceCatalogStatusCalculationCREATEDId
						ELSE @priceCatalogStatusCalculationDECLINEDId 
					END	AS [priceCatalogCalculationStatusId]
					,0 AS [supplierPriceChange]
					,ISNULL(price.[IsAccepted],0) AS [isReleased]
					,0 AS [discount]
					,0 AS [isDeleted]
					,1 AS [isLegacy]
					,ISNULL(price.[Created],GETDATE()) AS [insertedAt]
					,ISNULL(price.[CreatedBy],1) AS [insertedBy]
					,price.[Modified] AS [updatedAt]
					,price.[ModifiedBy] AS [updatedBy]
				FROM [dlm].[priceCatalog] pc
				INNER JOIN [mig].[mapStandardServicesCatalogPriceCatalog] mSSCPC
					ON mSSCPC.[dlm3Id] = pc.[id]
				INNER JOIN [archiv].[dbo_StandardServicesCatalog] ssc
					ON ssc.[id] = mSSCPC.[dlm2Id]
				INNER JOIN [archiv].[dbo_SscCompany] sscC
					ON sscC.[SscId] = ssc.[id]
				INNER JOIN [mig].[mapCompanyCompany] mCC
					ON mCC.[dlm2Id] = sscC.[CompanyId]
				INNER JOIN [std].[company] co
					ON co.[id] = mCC.[dlm3Id]
				LEFT OUTER JOIN 
				(
					SELECT sq.[id] AS [quoteId],sqrg.[SscId],sqr.[SupplierId],sq.[IsAccepted],sq.[Created],ISNULL(cr.[dlm3Id],1) AS [CreatedBy],sq.[Modified],ISNULL(mo.[dlm3Id],1) AS [ModifiedBy]
					FROM [archiv].[dbo_SscQuote] sq
					INNER JOIN [archiv].[dbo_SscQuoteRequest] sqr
						ON sqr.[id] = sq.[RequestId]
					INNER JOIN [archiv].[dbo_SscQuoteRequestGroup] sqrg
						ON sqrg.[id] = sqr.[GroupId]
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = sq.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = sq.[ModifiedBy]
					WHERE sqrg.[SupplementSscId] IS NULL
				) price                                                         --get discount from acceptedPrice
				ON price.[SscId] = ssc.[id]
				INNER JOIN [mig].[mapSupplierSupplier] mSS                      --get dlm3-supplier-id
					ON mSS.[dlm2Id] = price.[SupplierId]
				INNER JOIN [dlm].[siteCatalog] sic
					ON sic.[id] = pc.[siteCatalogId]
				INNER JOIN [dlm].[serviceCatalog] svc
					ON svc.[id] = sic.[serviceCatalogId]
				WHERE ssc.[IsGlobal] = 1
				AND svc.[companyId] = mCC.[dlm3Id]
			) AS s
			ON s.[priceCatalogId] = t.[priceCatalogId]
			AND s.[supplierId] = t.[supplierId]
			AND s.[insertedAt] = t.[insertedAt]
			WHEN NOT MATCHED THEN
				INSERT ([priceCatalogId],[supplierId],[priceCatalogCalculationStatusId],[supplierPriceChange],[isReleased],[discount],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
				VALUES (s.[priceCatalogId],s.[supplierId],s.[priceCatalogCalculationStatusId],s.[supplierPriceChange],s.[isReleased],s.[discount],s.[isDeleted],s.[isLegacy],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
			OUTPUT s.[quoteId],inserted.[id],N'SSC global'
            INTO [mig].[mapQuotePriceCatalogCalculation]([dlm2Id],[dlm3Id],[typ])
			;

            SELECT @rowCount = COUNT(1) FROM [mig].[mapQuotePriceCatalogCalculation] WHERE [typ] = N'SSC global'

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --priceCatalogCalculation EPK global

        BEGIN --set priceCatalogTenderName

            SET @msg = '   set priceCatalogTenderName'
            PRINT @msg

            DECLARE cMig CURSOR FOR
                SELECT [priceCatalogId],[name],[description],[supplierName],[supplierCode]
                FROM
                (
                    SELECT 
                        pcc.[priceCatalogId]
                        ,sc.[name]
                        ,sc.[description]
                        ,su.[name] AS [supplierName]
                        ,su.[code] AS [supplierCode]
                        ,ROW_NUMBER() OVER(PARTITION BY pc.[id] ORDER BY pcc.[priceCatalogCalculationStatusId] DESC,pcc.[insertedAt] DESC) AS [isLast]
                    FROM [dlm].[priceCatalogCalculation] pcc
                    INNER JOIN [dlm].[priceCatalog] pc
                        ON pc.[id] = pcc.[priceCatalogId]
                    INNER JOIN [dlm].[siteCatalog] sc
                        ON sc.[id] = pc.[siteCatalogId]
                    INNER JOIN [dlm].[supplier] su
                        ON su.[id] = pcc.[supplierId]
                ) q
                WHERE q.[isLast] = 1

            DECLARE @priceCatalogId INT
            DECLARE @siteCatalogname NVARCHAR(200)
            DECLARE @siteCatalogDescription NVARCHAR(4000)
            DECLARE @supplierName NVARCHAR(200)
            DECLARE @supplierCode NVARCHAR(200)

            SET @rowCount = 0
            
            OPEN cMig
            FETCH NEXT FROM cMIG INTO @priceCatalogId,@siteCatalogName,@siteCatalogDescription,@supplierName,@supplierCode
            WHILE @@FETCH_STATUS = 0
            BEGIN

                SET @rowCount = @rowCount + 1

                UPDATE [dlm].[priceCatalog] 
                SET 
                    [tenderName] = SUBSTRING(N'Ausschreibung für ' + @siteCatalogname + ' für ' + @supplierName + ' (' + @supplierCode + ')',1,200)
                    ,[tenderDescription] = SUBSTRING(N'Ausschreibung für ' + @siteCatalogDescription + ' für ' + @supplierName + ' (' + @supplierCode + ')',1,4000)
                WHERE [id] = @priceCatalogId

                FETCH NEXT FROM cMIG INTO @priceCatalogId,@siteCatalogName,@siteCatalogDescription,@supplierName,@supplierCode

            END
            CLOSE cMig
            DEALLOCATE cMig

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --fill priceCatalogTenderName

		BEGIN --set priceCatalogStatus for released calculations

            SET @msg = '   set priceCatalogStatus for released calculations'
            PRINT @msg

			UPDATE [dlm].[priceCatalog] 
			SET [priceCatalogStatusId] = (
				SELECT [id]
				FROM [std].[priceCatalogStatus]
				WHERE [code] = N'CONTRACT'
			)
			WHERE [id] IN (
				SELECT [priceCatalogId]
				FROM [dlm].[priceCatalogCalculation]
				WHERE [isReleased] = 1
			)

		END--set priceCatalogStatus for released calculations

        BEGIN --set Audit columns

            SET @msg = '   set Audit columns'
            PRINT @msg

			UPDATE [dlm].[priceCatalogCalculation] SET [insertedAt] = GETDATE(),[insertedBy] = 1 wHERE [insertedAt] IS NULL

			SET @rowCount = @@ROWCOUNT

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		END --set Audit columns

    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' priceCatalogCalculation.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
