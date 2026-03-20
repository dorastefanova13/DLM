BEGIN --BillPosition

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    fill billPosition'

    PRINT @msg

    DECLARE @rowCount INT

    DELETE FROM [dlm].[billPosition]
    
    BEGIN TRY

        BEGIN --billPosition for LV

            SET @msg = '   fill billPosition for LV into tmpTable ' + CONVERT(NVARCHAR,getdate(),120)

            PRINT @msg

            DROP TABLE IF EXISTS [mig].[tmpBillPrice]

            SELECT
                b.[id] AS [SspBillId]
                ,mBIBI.[dlm3Id] AS [dlm3BillId]
                ,mMCMC.[dlm3Id] AS [dlm3MainCodeId]
                ,mCYTU.[dlm3Id] AS [dlm3TurnusId]
                ,svp.[id] AS [servicePositionId]
                ,bi.[Units]
                ,p.[Value]
                ,p.[UnitsPerHour]
                ,bi.[Units] * c.[Factor] AS [UnitsPerDay]
                ,CAST(bi.[Units] * c.[Factor] * p.[Value] AS DECIMAL(10,2)) AS [pricePerDay]
                ,CAST(c.[Factor] * p.[Value] AS DECIMAL(10,2)) AS [pricePerUnitAndDay]
                ,CASE 
                    WHEN c.[IsSaturday] = 1 THEN CAST(bi.[Units] * c.[Factor] * p.[Value] * 4.25 AS DECIMAL(10,2))
                    ELSE CAST(bi.[Units] * c.[Factor] * p.[Value] * 20.83 AS DECIMAL(10,2))
                END AS [pricePerMonth]
            INTO [mig].[tmpBillPrice]
            FROM [archiv].[dbo_SspBill] sspb
            INNER JOIN [archiv].[dbo_SspBillItem] bi
                ON bi.[SspBillId] = sspb.[id]
            INNER JOIN [archiv].[dbo_SspPriceAll] p
                ON p.[SspId] = sspb.[SspId]
                AND p.[MainCodeId] = bi.[MainCodeId]
                AND p.[CycleCodeId] = bi.[CycleCodeId]
                AND p.[IsAccepted] = 1
            INNER JOIN [archiv].[dbo_Cycle] c
                ON c.[id] = p.[CycleCodeId]
            INNER JOIN [mig].[mapMainCodeMainCode] mMCMC
                ON mMCMC.[dlm2Id] = p.[MainCodeId]
            INNER JOIN [mig].[mapCycleTurnus] mCYTU
                ON mCYTU.[dlm2Id] = p.[CycleCodeId]
            INNER JOIN [mig].[mapBillBill] mBIBI
                ON mBIBI.[dlm2Id] = sspb.[billId]
            INNER JOIN [dlm].[bill] b
                ON b.[id] = mBIBI.[dlm3Id]
            INNER JOIN [dlm].[serviceOrder] sor
                ON sor.[id] = b.[serviceOrderId]
            INNER JOIN [dlm].[priceCatalogCalculation] pcc
                ON pcc.[id] = sor.[priceCatalogCalculationId]
            INNER JOIN [dlm].[priceCatalog] prc
                ON prc.[id] = pcc.[priceCatalogId]
            INNER JOIN [dlm].[siteCatalog] sic
                ON sic.[id] = prc.[siteCatalogId]
            INNER JOIN [dlm].[serviceCatalog] svc
                ON svc.[id] = sic.[serviceCatalogId]
            INNER JOIN (SELECT [id],[mainCodeId],[turnusId],[companyId] FROM [dlm].[servicePosition] WHERE [isMainService] = 1) svp
                ON svp.[mainCodeId] = mMCMC.[dlm3Id]
                AND svp.[turnusId] = mCYTU.[dlm3Id]
            WHERE svc.[companyId] = svp.[companyId]
			AND pcc.[isReleased] = 1

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

			SET @rowCount = @@ROWCOUNT

			SET @msg = '   create index '  + CONVERT(NVARCHAR,getdate(),120)

            PRINT @msg

            CREATE CLUSTERED INDEX [x_tmpBillPrice] ON [mig].[tmpBillPrice]([dlm3BillId] ASC, [servicePositionId] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)            

			SET @msg = '   fill billPosition for LV into billPosition-Table '  + CONVERT(NVARCHAR,getdate(),120)

            PRINT @msg

            SET @rowCount = 0
            
            INSERT INTO [dlm].[billPosition]([billId],[serviceOrderPositionId],[unitsPerDay],[unitPrice],[amount],[isDeleted])
            SELECT 
                sbp.[dlm3BillId] AS [billId]
                ,sop.[id] AS [serviceOrderPositionId]
                ,ISNULL(sbp.[Units],0) AS [units]
                ,ISNULL(sbp.[Value],0) AS [unitPrice]
                ,ISNULL(sbp.[PricePerMonth],0) AS [amount]
                ,0 AS [isDeleted]
            FROM [mig].[tmpBillPrice] sbp
            INNER JOIN [dlm].[bill] b
                ON b.[id] = sbp.[dlm3BillId]
            INNER JOIN [dlm].[serviceOrder] so
                ON so.[id] = b.[serviceOrderId]
            INNER JOIN [dlm].[serviceOrderPosition] sop
                ON sop.[serviceOrderId] = so.[id]
            INNER JOIN [dlm].[priceCatalogCalculationPosition] pccp
                ON pccp.[id] = sop.[priceCatalogCalculationPositionId]
                AND pccp.[servicePositionId] = sbp.[servicePositionId]
			WHERE sop.[isActive] = 1

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --billPosition for LV

        BEGIN --billPosition for WorkOrder

            SET @msg = '   fill billPosition for WorkOrder '  + CONVERT(NVARCHAR,getdate(),120)

            PRINT @msg

            SET @rowCount = 0

            INSERT INTO [dlm].[billPosition]([billId],[serviceOrderPositionId],[amount],[unitsPerDay],[unitPrice],[isDeleted])
            SELECT 
                mBB.[dlm3Id] AS [billId]
                ,mWOISOP.[dlm3Id] AS [serviceOrderPositionId]
                ,ISNULL(sscp.[Value],0) * ISNULL(woi.[Units],0) AS [amount]
                ,ISNULL(woi.[Units],0) AS [units]
                ,ISNULL(sscp.[Value],0) AS [unitPrice]
                ,0 AS [isDeleted]
            FROM [archiv].[dbo_WoItem] woi
            INNER JOIN [archiv].[dbo_WorkOrder] wo
                ON wo.[Id] = woi.[WoId]
            INNER JOIN [archiv].[dbo_PurchaseOrder] po
                    ON po.[id] = wo.[PoId] 
            INNER JOIN [archiv].[dbo_SscPrice] sscp
                ON sscp.[SscItemId] = woi.[SscItemId]
            INNER JOIN [archiv].[dbo_SscQuote] sscq
                ON sscq.[id] = sscp.[QuoteId]
            INNER JOIN [archiv].[dbo_SscQuoteRequest] sscqr
                ON sscqr.[Id] = sscq.[RequestId]
                AND sscqr.[SupplierId] = po.[SupplierId]
            INNER JOIN [archiv].[dbo_Bill] b
                ON b.[id] = wo.[BillId]
            INNER JOIN [mig].[mapBillBill] mBB
                ON mBB.[dlm2Id] = b.[id]
            INNER JOIN [mig].[mapWorkOrderItemServiceOrderPosition] mWOISOP
                ON mWOISOP.[dlm2Id] = woi.[Id]
            WHERE ISNULL(po.[IsActive],0) = 1   
            --AND ISNULL(woip.[isManual],1) <> 1

            SET @rowCount = @@ROWCOUNT
        
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --bill for WorkOrder

		DROP TABLE IF EXISTS [mig].[tmpBillPrice]
        
    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' billPosition.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
