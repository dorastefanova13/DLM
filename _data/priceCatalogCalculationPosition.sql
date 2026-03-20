BEGIN --priceCatalogCalculationPosition

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '    fill priceCatalogCalculationPosition'
    PRINT @msg

    DECLARE @rowCount INT

    BEGIN TRY

        DELETE FROM [dlm].[priceCatalogCalculationPosition]

        DECLARE @priceCatalogStatusCalculationId INT = (SELECT [id] FROM [std].[priceCatalogCalculationStatus] WHERE [name] = N'Freigabe')
        DECLARE @serviceTypeId INT

        DECLARE 
            @sspId INT
            ,@sscId INT
            ,@priceCatalogId INT
            ,@priceCatalogCalculationId INT
            ,@priceCatalogPositionId INT
			,@servicePositionId INT
            ,@mainCodeId INT
            ,@turnusId INT
			,@supplierId INT
			,@price DECIMAL(20,5)
            ,@unitsPerHour FLOAT
			,@discount FLOAT
			,@dlm2QuoteId INT
			,@dlm2ItemId INT
			,@dlm2MainCodeId INT
			,@dlm2CycleCodeId INT

        DECLARE @errCount INT 
        DECLARE @curCount INT 

		DECLARE @archive TABLE
		(
		   ActionType VARCHAR(50),
		   [functionalId] NVARCHAR(100)
		);

		DECLARE @logText NVARCHAR(MAX)

        BEGIN --priceCatalogCalulationPosition LV  with data from serviceposition and wagecluster

            SET @msg = '   fill priceCatalogCalculationPosition LV with data from serviceposition and wagecluster'
            PRINT @msg

            INSERT INTO [dlm].[priceCatalogCalculationPosition]
                       ([priceCatalogCalculationId]
                       ,[priceCatalogPositionId]
					   ,[servicePositionId]
                       ,[hourlyRate]
                       ,[calculatedRegularOutput]
                       ,[referencePrice]
                       ,[isDeleted]
                       ,[isLegacy])
			 SELECT pcc.[id] AS [priceCatalogCalculationId]
                 , pcp.[id]
				 , svp.[id] AS [servicePositionId]
				 , CASE WHEN svp.[isMainService] = 1 THEN ISNULL(wc.[hourlyRate],0) ELSE 0 END AS [hourlyRate]
				 , CASE WHEN svp.[isMainService] = 1 THEN ISNULL(svp.[calculatedRegularOutput],0) ELSE 0 END AS [calculatedRegularOutput]
				 , CASE WHEN svp.[isMainService] = 1 THEN 
                        CASE 
					        WHEN ISNULL(svp.[calculatedRegularOutput],0) = 0
						        THEN 0
					            ELSE ISNULL(wc.[hourlyRate],0) / svp.[calculatedRegularOutput]
					        END 
                            ELSE 0
                 END AS [referencePrice]
				 , 0 AS [isDeleted] 
				 , 1 AS [isLegacy]
            FROM [dlm].[priceCatalogPosition] pcp
            INNER JOIN [dlm].[siteCatalogPosition] scp
                ON scp.[id] = pcp.[siteCatalogPositionId]
            INNER JOIN [dlm].[servicePosition] svp
                ON svp.[id] = scp.[servicePositionId]
            INNER JOIN [dlm].[priceCatalog] pc
                ON pc.[id] = pcp.[priceCatalogId]
            INNER JOIN [dlm].[priceCatalogCalculation] pcc
                ON pc.[id] = pcc.[priceCatalogId]
            INNER JOIN [dlm].[mainCode] mc
                ON mc.[id] = svp.[mainCodeId]
				AND mc.[isLegacy] = 1
			INNER JOIN [std].[company] co
				ON co.[id] = svp.[companyId]
			LEFT OUTER JOIN [std].[wageGroup] wg
				 ON wg.[id] = mc.[wageGroupId]
			LEFT OUTER JOIN [std].[wageCluster] wc
				 ON wc.[wageGroupId] = wg.[id]
            --WHERE svp.[isSiteSpecific] = 0
			--AND svp.[isMainService] = 1
			--AND wc.[currencyId] = sc.[currencyId] 
			
            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

			SELECT @rowCount = COUNT(1) 
			FROM [dlm].[priceCatalogCalculationPosition] pccp
			INNER JOIN [dlm].[servicePosition] svp
				ON svp.[id] = pccp.[servicePositionId]
			INNER JOIN [std].[serviceType] st
				ON st.[id] = svp.[serviceTypeId]
			WHERE st.[code] = N'UHR'

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records UHR'

			SELECT @rowCount = COUNT(1) 
			FROM [dlm].[priceCatalogCalculationPosition] pccp
			INNER JOIN [dlm].[servicePosition] svp
				ON svp.[id] = pccp.[servicePositionId]
			INNER JOIN [std].[serviceType] st
				ON st.[id] = svp.[serviceTypeId]
			WHERE st.[code] = N'ADHOC'

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records ADHOC'

        END --priceCatalogCalulationPosition LV  with data from serviceposition and wagecluster

        BEGIN --priceCatalogCalulationPosition LV  with prices from SspPrice

            SET @msg = '   fill priceCatalogCalculationPosition LV with prices from SspPrice'
            PRINT @msg

            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [code] = N'UHR' 
			SET @rowCount = 0

            DROP TABLE IF EXISTS [mig].[mapSspPricePriceCatalogCalculationPosition]
            CREATE TABLE [mig].[mapSspPricePriceCatalogCalculationPosition] (dlm2SspQuoteId INT, dlm2MainCodeId INT, dlm2CycleCodeId INT,dlm3Id INT)

			DECLARE cMig CURSOR FOR 
				SELECT 
					mMCMC.[dlm3Id] AS [mainCodeId]
					,mCT.[dlm3Id] AS [turnusId]
					,ISNULL(CAST(p.[Value] AS DECIMAL(20,5)),0) AS [price]
					,ISNULL(p.[unitsPerHour],0)
					,ISNULL(q.[discount],0)
					,mSS.dlm3Id AS [supplierId]
					,mSSPC.[dlm3Id] AS [priceCatalogId]	   
					,p.[sspQuoteId]
					,p.[MainCodeId]
					,p.[CycleCodeId]
				FROM [archiv].[dbo_SspPrice]  p
				INNER JOIN [archiv].[dbo_SspQuote] q
					ON q.[id] = p.[SspQuoteId]
				INNER JOIN [archiv].[dbo_SspQuoteRequest] qr
					ON qr.[id] = q.[RequestId]
				INNER JOIN [archiv].[dbo_SspQuoteRequestGroup] qrg
					ON qrg.[id] = qr.[GroupId]
				INNER JOIN [mig].[mapMainCodeMainCode] mMCMC
					ON mMCMC.[dlm2Id] = p.[MainCodeId]
				INNER JOIN [mig].[mapCycleTurnus] mCT
					ON mCT.[dlm2Id] = p.[CycleCodeId]
				INNER JOIN [mig].[mapServiceSpecificationPriceCatalog] mSSPC
					ON mSSPC.[dlm2Id] = qrg.[SspId]
				INNER JOIN [mig].[mapSupplierSupplier] mSS
					ON mSS.[dlm2Id] = qr.[SupplierId]
				INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
					ON ssp.[id] = mSSPC.[dlm2Id]
				INNER JOIN [archiv].[dbo_SspCompany] sspco
					ON sspco.[SspId] = ssp.[id]
				INNER JOIN [mig].[mapCompanyCompany] mCOCO
					ON mCOCO.[dlm2Id] = sspco.[CompanyId]
				INNER JOIN [std].[company] co
					ON co.[id] = mCOCO.[dlm3Id]
				WHERE q.[IsAccepted] = 1


			OPEN cMig
			FETCH NEXT FROM cMig INTO @mainCodeId,@turnusId,@price,@unitsPerHour,@discount,@supplierId,@priceCatalogId,@dlm2QuoteId,@dlm2MainCodeId,@dlm2CycleCodeId
			WHILE @@FETCH_STATUS = 0
			BEGIN

				SELECT @priceCatalogPositionId = pcp.[id]
				FROM [dlm].[priceCatalogPosition] pcp
				INNER JOIN [dlm].[siteCatalogPosition] scp
					ON scp.[id] = pcp.[siteCatalogPositionId]
				INNER JOIN [dlm].[servicePosition] svp
					ON svp.[id] = scp.[servicePositionId]
				WHERE svp.[mainCodeId] = @mainCodeId
				AND svp.[turnusId] = @turnusId
				AND svp.[isMainService] = 1
				AND pcp.[priceCatalogId] = @priceCatalogId


				UPDATE [dlm].[priceCatalogCalculationPosition]
				SET 
					[priceCatalogPositionId] = @priceCatalogPositionId
					,[referencePrice] = ISNULL(@price,0)
					,[calculatedPrice] = ISNULL(@price,0)
					,[hourlyRate] = ISNULL(@unitsPerHour,0)
					,[calculatedRegularOutput] = 
					CASE
						WHEN ISNULL(@price,0) = 0 THEN 0
						ELSE ISNULL(@unitsPerHour,0) / @price
					END
				OUTPUT INSERTED.[id],@dlm2QuoteId,@dlm2MainCodeId,@dlm2CycleCodeId 
				INTO [mig].[mapSspPricePriceCatalogCalculationPosition] ([dlm3Id],[dlm2SspQuoteId], [dlm2MainCodeId], [dlm2CycleCodeId])
				WHERE [priceCatalogCalculationId] IN 
				(
					SELECT [id] 
					FROM [dlm].[priceCatalogCalculation] 
					WHERE [priceCatalogId] = @priceCatalogId
					AND [supplierId] = @supplierId
				)
				AND [servicePositionId] IN
				(
					SELECT svp.[id]
					FROM [dlm].[servicePosition] svp
					WHERE svp.[mainCodeId] = @mainCodeId
					AND svp.[turnusId] = @turnusId
					AND svp.[isMainService] = 1
				)

				SET @rowCount = @rowCount + @@ROWCOUNT

				FETCH NEXT FROM cMig INTO @mainCodeId,@turnusId,@price,@unitsPerHour,@discount,@supplierId,@priceCatalogId,@dlm2QuoteId,@dlm2MainCodeId,@dlm2CycleCodeId

			END
			CLOSE cMig
			DEALLOCATE cMig

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --priceCatalogCalulationPosition LV   with prices from SspPrice

        BEGIN --priceCatalogCalulationPosition EPK   with prices from SscPrice

            SET @msg = '   fill priceCatalogCalulationPosition EPK   with prices from SscPrice'
            PRINT @msg

            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [code] = N'ADHOC'
			SET @rowCount = 0

            DROP TABLE IF EXISTS [mig].[mapSscPricePriceCatalogCalculationPosition]
            CREATE TABLE [mig].[mapSscPricePriceCatalogCalculationPosition] (dlm2SscQuoteId INT, dlm2SscItemId INT, dlm3Id INT)

			DECLARE cMig CURSOR FOR 
                SELECT 
					scp.[servicePositionId] AS [servicePositionId]
					,ISNULL(CAST(p.[Value] AS DECIMAL(20,5)),0) AS [price]
					,0 AS [UnitsPerHour]
					,0 AS [Discount]
					,pcc.[id] AS [priceCatalogCalculationId]
					,pcp.[id] [priceCatalogPositionId]
					,p.[QuoteId]
					,p.[SscItemId]
                FROM [dlm].[priceCatalogPosition] pcp
                INNER JOIN [dlm].[siteCatalogPosition] scp
                    ON scp.[id] = pcp.[siteCatalogPositionId]
                INNER JOIN [mig].[mapSscitemPriceCatalogPosition] mSPCP
                    ON mSPCP.[dlm3Id] = pcp.[id]
                INNER JOIN [archiv].[dbo_SscPrice] p
                    ON p.[sscItemId] = mSPCP.[dlm2id]
				INNER JOIN [archiv].[dbo_SscQuote] q
					ON q.[id] = p.[QuoteId]
				INNER JOIN [archiv].[dbo_SscQuoteRequest] qr
					ON qr.[id] = q.[RequestId]
				INNER JOIN [archiv].[dbo_SscQuoteRequestGroup] qrg
					ON qrg.[id] = qr.[GroupId]
				INNER JOIN [mig].[mapSupplierSupplier] mSS
					ON mSS.[dlm2Id] = qr.[SupplierId]
				INNER JOIN [dlm].[priceCatalogCalculation] pcc
					ON pcc.[priceCatalogId] = pcp.[priceCatalogId]
					AND pcc.[supplierId] = mss.[dlm3Id]
				INNER JOIN [dlm].[servicePosition] svp
					ON svp.[id] = scp.[servicePositionId]
				INNER JOIN [std].[company] co
					ON co.[id] = svp.[companyId]
                WHERE q.[isAccepted] = 1
				AND ISNULL(p.[value],0) <> 0

			OPEN cMig
			FETCH NEXT FROM cMig INTO @servicePositionId,@price,@unitsPerHour,@discount,@priceCatalogCalculationId,@priceCatalogPositionId, @dlm2QuoteId, @dlm2ItemId
			WHILE @@FETCH_STATUS = 0
			BEGIN
			
				UPDATE [dlm].[priceCatalogCalculationPosition]
				SET 
					[priceCatalogPositionId] = @priceCatalogPositionId
					,[referencePrice] = ISNULL(@price,0)
					,[calculatedPrice] = ISNULL(@price,0)
					,[hourlyRate] = ISNULL(@unitsPerHour,0)
					,[calculatedRegularOutput] = 
					CASE
						WHEN ISNULL(@price,0) = 0 THEN 0
						ELSE ISNULL(@unitsPerHour,0) / @price
					END
				OUTPUT INSERTED.[id],@dlm2QuoteId,@dlm2ItemId 
				INTO [mig].[mapSscPricePriceCatalogCalculationPosition] ([dlm3Id],[dlm2SscQuoteId], [dlm2SscItemId])
				WHERE [priceCatalogCalculationId] = @priceCatalogCalculationId
				AND [servicePositionId] = @servicePositionId

				SET @rowCount = @rowCount + @@ROWCOUNT

				FETCH NEXT FROM cMig INTO @servicePositionId,@price,@unitsPerHour,@discount,@priceCatalogCalculationId,@priceCatalogPositionId, @dlm2QuoteId, @dlm2ItemId

			END
			CLOSE cMig
			DEALLOCATE cMig

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --priceCatalogCalulationPosition EPK   with prices from SscPrice

        BEGIN --set Audit columns

            SET @msg = '   set Audit columns'
            PRINT @msg

			UPDATE [dlm].[priceCatalogCalculationPosition] SET [insertedAt] = GETDATE(),[insertedBy] = 1

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
