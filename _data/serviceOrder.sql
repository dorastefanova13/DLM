BEGIN --serviceOrder

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    fill serviceOrder'

    PRINT @msg

    DELETE FROM [dlm].[serviceOrder]
    
    DECLARE
        @id INT
        ,@priceCatalogId INT
        ,@priceCatalogCalculationId INT
        ,@name NVARCHAR(200)
        ,@description NVARCHAR(4000)
        ,@serviceCategoryId INT
        ,@serviceTypeId INT
        ,@periodFrom DATE
        ,@sapOrderId INT
        ,@systemOrderNo NVARCHAR(100)
        ,@serviceOrderStatusId INT
        ,@additionalInfo NVARCHAR(200)
        ,@SupplierReferenceNo NVARCHAR(30)
        ,@supplierId INT
        ,@rowCount INT
        ,@mapCount INT
        ,@companyId INT
        ,@sponsorInformation NVARCHAR(200)
        ,@costCenterBId INT
        ,@costCenterCId INT
        ,@coOrder NVARCHAR(100)
        ,@pmNo NVARCHAR(100)
        ,@pspElement NVARCHAR(100)
  
  	DECLARE @insAt DATE
	DECLARE @updAt DATE
	DECLARE @insBy INT
	DECLARE @updBy INT

    DECLARE @dlm3Id INT


    BEGIN TRY

	
        BEGIN --fill serviceOrder from SubLV

            SET @msg = '   fill serviceOrder from SubLV ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg

            DROP TABLE IF EXISTS [mig].[mapServiceSpecificationServiceOrder]
            CREATE TABLE [mig].[mapServiceSpecificationServiceOrder] (dlm2Id INT, dlm3Id INT)


            SELECT @serviceTypeId = (SELECT [id] FROM [std].[serviceType] WHERE [code] = N'UHR')

            SET @rowCount = 0

			INSERT INTO [dlm].[serviceOrder]
                            ([priceCatalogCalculationId]
                            ,[name]
                            ,[description]
                            ,[serviceCategoryId]
                            ,[serviceTypeId]
                            ,[periodFrom]
                            ,[periodUntil]
                            ,[systemOrderNo]
                            ,[sponsorInformation]
                            ,[costCenterBId]
                            ,[costCenterCId]
                            ,[coOrder]
                            ,[pmNo]
                            ,[pspElement]
                            ,[serviceOrderStatusId]
                            ,[isLegacy]
                            ,[isDeleted]
                            ,[isGranular]
							,[updatedBy] )
			OUTPUT inserted.[id],inserted.[updatedBy]
			INTO [mig].[mapServiceSpecificationServiceOrder]([dlm3Id],[dlm2Id])
			SELECT 	
				pcc.[id] AS [priceCatalogCalculationId]
                ,N'UnterLV '+ CAST(ssp.[MainSspId] AS NVARCHAR) + N'-' + CAST(ssp.[SspNo] AS NVARCHAR) + N' erstellt bei Migration aus DLM2.0' AS [name]
                ,[name]  + N' (' + CAST(ssp.[MainSspId] AS NVARCHAR) +  N')  erstellt bei Migration aus DLM2.0' AS [description]
                ,mSCSC.[dlm3Id] AS [serviceCategoryId]
				,@serviceTypeId
                ,CASE
                    WHEN ssp.[ValidFrom] IS NOT NULL THEN ssp.[ValidFrom]
                    WHEN ssp.[ChangeFrom] IS NOT NULL THEN ssp.[ChangeFrom]
                    WHEN ssp.[Created] IS NOT NULL THEN ssp.[Created]
                    ELSE ssp.[Modified]
                END AS [periodFrom]
				,CONVERT(DATE,'21001231',12) AS [periodUntil]
				,CAST(10000000 + ssp.[id] AS NVARCHAR) AS [systemOrderNo]
                ,LTRIM(ISNULL(po.[SponsorCenter],'') + ' ' + ISNULL(po.[SponsorDepartment],'') + ' ' + ISNULL(po.[SponsorName],'')) AS [sponsorInformation]
                ,mCCCCB.[dlm3Id] AS [costCenterBId]
                ,mCCCCC.[dlm3Id] AS [costCenterCId]
                ,po.[CoNo] AS [coOrder]
                ,po.[PmNo] AS [pmNo]
                ,po.[PspNo] AS [pspElement]
                ,0 AS [serviceOrderStatusId]
                ,1 AS [isLegacy]
                ,0 AS [isDeleted]
                ,0 AS [isGranular]
				,ssp.[id] AS [updateBy]
			FROM [archiv].[dbo_ServiceSpecification] ssp
			LEFT OUTER JOIN [mig].[mapUserClient] cr
				ON cr.[dlm2Id] = ssp.[CreatedBy]
			LEFT OUTER JOIN [mig].[mapUserClient] mo
				ON mo.[dlm2Id] = ssp.[ModifiedBy]
            INNER JOIN [archiv].[dbo_PurchaseOrder] po
                ON po.[id] = ssp.[PoId]
            INNER JOIN (SELECT fCC.[id] AS [dlm2Id],sCC.[id] AS [dlm3Id] FROM [archiv].[faplis_CostCenter] fCC INNER JOIN [std].[costCenter] sCC ON fCC.[functionalId] = sCC.[faplisId] COLLATE SQL_Latin1_General_CP1_CI_AI ) mCCCCB
                ON mCCCCB.[dlm2Id] = po.[BCostCenterId]
            LEFT OUTER JOIN (SELECT fCC.[id] AS [dlm2Id],sCC.[id] AS [dlm3Id] FROM [archiv].[faplis_CostCenter] fCC INNER JOIN [std].[costCenter] sCC ON fCC.[functionalId] = sCC.[faplisId] COLLATE SQL_Latin1_General_CP1_CI_AI ) mCCCCC
                ON mCCCCC.[dlm2Id] = po.[CCostCenterId]
            INNER JOIN [mig].[mapSspCategoryServiceCategory] mSCSC
                ON mSCSC.[dlm2Id] = ssp.[SspCategoryId]
            INNER JOIN [mig].[mapSupplierSupplier] mSS
                ON mss.[dlm2Id] = ssp.[SupplierId]
            INNER JOIN [mig].[mapServiceSpecificationPriceCatalog] mSSPC
                ON mSSPC.[dlm2Id] = ssp.[MainSspId]
			INNER JOIN [dlm].[priceCatalogCalculation] pcc
				ON pcc.[priceCatalogId] = mSSPC.[dlm3Id]
				AND pcc.[supplierId] = mss.[dlm3Id]
            WHERE ISNULL(ssp.[MainSspId],0) <> 0
			AND pcc.[isReleased] = 1
            --AND ISNULL(ssp.[IsActive],0) <> 0
            --AND ISNULL(ssp.[IsFrozen],0) = 1
                
			SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END--fill serviceOrder from SubLV

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
					mSSSO.[dlm3Id]
					,ssp.[Created] AS [insertedAt]
					,ssp.[Modified] AS [updatedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,mo.[dlm3Id] AS [updatedBy]
				FROM [mig].[mapServiceSpecificationServiceOrder] mSSSO
				INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
					ON ssp.[id] = mSSSO.[dlm2Id]
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = ssp.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = ssp.[ModifiedBy]
			) t2
			ON t2.[dlm3Id] = t1.[id]

			SET @rowCount = @@ROWCOUNT

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		END --update audit columns

        BEGIN--fill serviceOrder from WorkOrder (EPKs)

            SET @msg = '   fill serviceOrder from WorkOrder (EPKs) ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg

            DROP TABLE IF EXISTS [mig].[mapWorkOrderServiceOrder]
            CREATE TABLE [mig].[mapWorkOrderServiceOrder] (dlm2Id INT, dlm3Id INT)
        
            SET @rowCount = 0

            SELECT @serviceTypeId = (SELECT [id] FROM [std].[serviceType] WHERE [code] = N'ADHOC')

            INSERT INTO [dlm].[serviceOrder]
                        ([priceCatalogCalculationId]
						,[name]
                        ,[description]
                        ,[serviceCategoryId]
                        ,[serviceTypeId]
                        ,[periodFrom]
                        ,[periodUntil]
                        ,[systemOrderNo]
                        ,[sponsorInformation]
                        ,[costCenterBId]
                        ,[costCenterCId]
                        ,[coOrder]
                        ,[pmNo]
                        ,[pspElement]
                        ,[serviceOrderStatusId]
                        ,[isLegacy]
                        ,[isDeleted]
                        ,[isGranular]
						,[updatedBy])
			OUTPUT inserted.[id],inserted.[updatedBy]							
			INTO [mig].[mapWorkOrderServiceOrder]([dlm3Id],[dlm2Id])
			SELECT
				pcc.[id] AS [priceCatalogCalculationId]
                ,N'Auftrag '
                    + CAST(wo.[OrderNo] AS NVARCHAR) 
                    + ' EPK ' 
                    + ISNULL(wo.[SupplierReferenceNo],' ')
                AS [name]
                ,N'Auftrag ' 
                    + ISNULL(wo.[AdditionalInfo],CAST(wo.[OrderNo] AS NVARCHAR)) 
                    + ' EPK erstellt bei Migration aus DLM2.0 ' 
					+ CASE WHEN ISNULL(wo.[PmNo],'') = '' THEN '' ELSE ' PM-No: ' + wo.[PmNo]  + ' ' END
                    + ISNULL(wo.[SupplierReferenceNo],' ')
                    + ISNULL(wo.[AdditionalInfo],' ')
                AS [description]
                ,mSCSC.[dlm3Id] AS [serviceCategoryId]
				,@serviceTypeId
				,ISNULL(b.[ServiceDate],wo.[ContractingDate]) AS [periodFrom]
				,ISNULL(b.[ServiceDate],wo.[ContractingDate]) AS [periodUntil]
				,CAST(20000000 + wo.[id] AS NVARCHAR) AS [systemOrderNo]
                ,LTRIM(ISNULL(po.[SponsorCenter],'') + ' ' + ISNULL(po.[SponsorDepartment],'') + ' ' + ISNULL(po.[SponsorName],'')) AS [sponsorInformation]
                ,mCCCCB.[dlm3Id] AS [costCenterBId]
                ,mCCCCC.[dlm3Id] AS [costCenterCId]
                ,po.[CoNo] AS [coOrder]
                ,po.[PmNo] AS [pmNo]
                ,po.[PspNo] AS [pspElement]
				,mSOSWS.[dlm3id] AS [serviceOrderStatusId]
				,1 AS [isLegacy]
                ,0 AS [isDeleted]
                ,1 AS [isGranular]
				,wo.[id] AS [updatedBy]
            FROM [archiv].[dbo_WorkOrder] wo
            INNER JOIN [mig].[mapPurchaseOrderSapOrder] mPOSO
                ON mPOSO.[dlm2Id] = wo.[PoId]
			INNER JOIN [archiv].[dbo_PurchaseOrder] po
				ON po.[id] = wo.[PoId]
			INNER JOIN [mig].[mapStandardServicesCatalogPriceCatalog] mSSCSC
				ON mSSCSC.[dlm2Id] = po.[SscId]
            INNER JOIN [dlm].[sapOrder] so
                ON so.[id] = mPOSO.[dlm3Id]
            INNER JOIN (SELECT fCC.[id] AS [dlm2Id],sCC.[id] AS [dlm3Id] FROM [archiv].[faplis_CostCenter] fCC INNER JOIN [std].[costCenter] sCC ON fCC.[functionalId] = sCC.[faplisId] COLLATE SQL_Latin1_General_CP1_CI_AI ) mCCCCB
                ON mCCCCB.[dlm2Id] = po.[BCostCenterId]
            LEFT OUTER JOIN (SELECT fCC.[id] AS [dlm2Id],sCC.[id] AS [dlm3Id] FROM [archiv].[faplis_CostCenter] fCC INNER JOIN [std].[costCenter] sCC ON fCC.[functionalId] = sCC.[faplisId] COLLATE SQL_Latin1_General_CP1_CI_AI ) mCCCCC
                ON mCCCCC.[dlm2Id] = po.[CCostCenterId]
			INNER JOIN [dlm].[priceCatalogCalculation] pcc
				ON pcc.[priceCatalogId] = mSSCSC.[dlm3Id]
				AND pcc.[supplierId] = so.[supplierId]
            INNER JOIN [dlm].[priceCatalog] prc
                ON prc.[id] = pcc.[priceCatalogId]
            INNER JOIN [dlm].[siteCatalog] sic
                ON sic.[id] = prc.[siteCatalogId]
            INNER JOIN [dlm].[serviceCatalog] svc
                ON svc.[id] = sic.[serviceCatalogId]
            INNER JOIN [mig].[mapCompanyCompany] mCOCO
                ON mCOCO.[dlm3Id] = svc.[companyId]
                AND mCOCO.[dlm2Id] = po.[CompanyId]
            INNER JOIN [mig].[mapServiceOrderStatusWoState] mSOSWS
                ON mSOSWS.[dlm2id] = wo.[StateId]
            INNER JOIN [mig].[mapSspCategoryServiceCategory] mSCSC
                ON mSCSC.[dlm2Id] = wo.[WoCategoryId]
			LEFT OUTER JOIN [archiv].[dbo_bill] b
				ON b.[id] = wo.[BillId]
			WHERE pcc.[isReleased] = 1

			SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --fill serviceOrder from WorkOrder (EPKs)

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
					mWOSO.[dlm3Id]
					,wo.[Created] AS [insertedAt]
					,wo.[Modified] AS [updatedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,mo.[dlm3Id] AS [updatedBy]
				FROM [mig].[mapWorkOrderServiceOrder] mWOSO
				INNER JOIN [archiv].[dbo_WorkOrder] wo
					ON wo.[id] = mWOSO.[dlm2Id]
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = wo.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = wo.[ModifiedBy]
			) t2
			ON t2.[dlm3Id] = t1.[id]

			SET @rowCount = @@ROWCOUNT

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		END --update audit columns


    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' serviceOrder.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
