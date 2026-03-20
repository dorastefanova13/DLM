BEGIN --Bill

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    fill bill'

    PRINT @msg

    DECLARE @rowCount INT

    DELETE FROM [dlm].[mapBillBillStatus]
    DELETE FROM [dlm].[bill]

    DECLARE @billStatusOpenId INT = (SELECT [id] FROM [std].[billStatus] WHERE [code] = N'OPEN')
    DECLARE @billStatusReleasedId INT = (SELECT [id] FROM [std].[billStatus] WHERE [code] = N'RELEASED')
    DECLARE @billStatusCanceledId INT = (SELECT [id] FROM [std].[billStatus] WHERE [code] = N'CANCELLED')
    DECLARE @billStatusClosedId INT = (SELECT [id] FROM [std].[billStatus] WHERE [code] = N'CLOSED')
    DECLARE @clientSystemId INT = (SELECT [id] FROM [sec].[client] WHERE [login] = N'SYSTEM')

   
    DROP TABLE IF EXISTS [mig].[mapBillBill]
    CREATE TABLE [mig].[mapBillBill] (dlm2Id INT, dlm3Id INT, typ NVARCHAR(100))

    BEGIN TRY

        BEGIN -- bill for LV

            SET @msg = '   fill bill for LV'

            PRINT @msg

            SET @rowCount = 0

            MERGE INTO [dlm].[bill] AS t
            USING
            (
                SELECT 
                    b.[id] AS [dlm2BillId]
                    ,b.[Description] + N' übernommen aus DLM2' AS [description]
                    ,mSSPSO.[dlm3id] AS [serviceOrderId]
                    ,b.[Amount] AS [totalAmount]
                    ,b.[NetAmount] AS [calculatedAmount]
                    ,ISNULL(b.[DiscountAmount],0) AS [discount]
                    ,sb.[Penalty]/100 AS [contractPenalty]
                    ,CONVERT(DATE,CAST(b.[YEAR] AS NVARCHAR) + RIGHT('0' + CAST(b.[Month] AS NVARCHAR),2) + '01',112) AS [periodFrom]
                    ,DATEADD(DAY, -1,DATEADD(MONTH,1,CONVERT(DATE,CAST(b.[YEAR] AS NVARCHAR) + RIGHT('0' + CAST(b.[Month] AS NVARCHAR),2) + '01',112))) AS [periodUntil]
                    ,CAST(b.[id] AS NVARCHAR) AS [systemBillNo]
                    ,sb.[Increase] AS [priceIncrease]
                    ,sb.[Deduction] AS [priceReduction]
                    ,sb.[DeductionIncreaseReason] AS [priceIncreaseReductionComment]
                    ,sb.[DayDeduction] AS [dayReductionWorkDay]
                    ,sb.[DayDeductionSaturday] AS [dayReductionSaturday]
                    ,sb.[DayDeductionReason] AS [dayReductionComment]
                    ,mPOSO.[dlm3Id] AS [sapOrderId]
                    ,1 AS [isLegacy]
                    ,0 AS [isDeleted]
					,b.[Created] AS [insertedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,b.[Modified] AS [updatedAt]
					,mo.[dlm3Id] AS [updatedBy]
                FROM [archiv].[dbo_Bill] b
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = b.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = b.[ModifiedBy]
                INNER JOIN [archiv].[dbo_SspBill] sb
                    ON sb.[billid] = b.[id] 
                INNER JOIN [mig].[mapServiceSpecificationServiceOrder] mSSPSO
                    ON mSSPSO.[dlm2Id] = sb.[SspId]
                INNER JOIN [archiv].[dbo_ServiceSpecification] sp
                    ON sp.[id] = sb.[SspId]
                INNER JOIN [mig].[mapPurchaseOrderSapOrder] mPOSO
                    ON mPOSO.[dlm2Id] = b.[PoId]
                WHERE ISNULL(sp.[IsFrozen],0) = 1
                AND b.[TypeId] = 1 --LV
            ) AS s
            ON s.[serviceOrderId] = t.[serviceOrderId]
            AND s.[description]  COLLATE SQL_Latin1_General_CP1_CI_AI = t.[description]
            WHEN NOT MATCHED THEN
                INSERT ([description],[serviceOrderId],[totalAmount],[calculatedAmount],[discount],[contractPenalty],[periodFrom],[periodUntil],[systemBillNo],[priceIncrease],[priceReduction], [priceIncreaseReductionComment],[dayReductionWorkDay],[dayReductionSaturday],[dayReductionComment],[sapOrderId],[isLegacy],[isDeleted],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
                VALUES (s.[description],s.[serviceOrderId],s.[totalAmount],s.[calculatedAmount],s.[discount],s.[contractPenalty],s.[periodFrom],s.[periodUntil],s.[systemBillNo],s.[priceIncrease],s.[priceReduction],s.[priceIncreaseReductionComment],s.[dayReductionWorkDay],s.[dayReductionSaturday],s.[dayReductionComment],s.[sapOrderId],s.[isLegacy],s.[isDeleted],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
            OUTPUT s.[dlm2BillId],inserted.[id],N'SSP'
            INTO [mig].[mapBillBill]([dlm2Id],[dlm3Id],[typ]);

            SET @rowCount = @@ROWCOUNT
        
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --bill for LV

        BEGIN --bill for WorkOrder

            SET @msg = '   fill bill for WorkOrder'

            PRINT @msg

            SET @rowCount = 0

            MERGE INTO [dlm].[bill] AS t
            USING
            (
                SELECT 
                    b.[id] AS [dlm2BillId]
                    ,b.[Description] + N' übernommen aus DLM2' AS [description]
                    ,mWOSO.[dlm3id] AS [serviceOrderId]
                    ,b.[amount] AS [totalAmount]
                    ,b.[NetAmount] AS [calculatedAmount]
                    ,ISNULL(b.[DiscountAmount],0) AS [discount]
                    ,CASE WHEN b.[netAmount] = 0 THEN 0 ELSE b.[PenaltyAmount] / b.[NetAmount] END AS [contractPenalty]
                    ,b.[serviceDate] AS [periodFrom]
                    ,NULL AS [periodUntil]
                    ,CAST(b.[id] AS NVARCHAR) AS [systemBillNo]
                    ,0 AS [priceIncrease]
                    ,0 AS [priceReduction]
                    ,NULL AS [priceIncreaseReductionComment]
                    ,0 AS [dayReductionWorkDay]
                    ,0 AS [dayReductionSaturday]
                    ,NULL AS [dayReductionComment]
                    ,mPOSO.[dlm3Id] AS [sapOrderId]
                    ,1 AS [isLegacy]
                    ,0 AS [isDeleted]
					,b.[Created] AS [insertedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,b.[Modified] AS [updatedAt]
					,mo.[dlm3Id] AS [updatedBy]
                FROM [archiv].[dbo_Bill] b
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = b.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = b.[ModifiedBy]
                INNER JOIN [archiv].[dbo_PurchaseOrder] po
                    ON po.[id] = b.[PoId] 
                INNER JOIN [archiv].[dbo_WorkOrder] wo
                    ON wo.[BillId] = b.[id]
                INNER JOIN [mig].[mapWorkOrderServiceOrder] mWOSO
                    ON mWOSO.[dlm2Id] = wo.[Id]
                INNER JOIN [mig].[mapBillStateBillStatus] mBSBS
                    ON mBSBS.[dlm2Id] = b.[StateId]
                INNER JOIN [mig].[mapPurchaseOrderSapOrder] mPOSO
                    ON mPOSO.[dlm2Id] = po.[Id]
                WHERE b.[TypeId] = 2 --EPK
            ) AS s
            ON s.[serviceOrderId] = t.[serviceOrderId]
            AND s.[description]  COLLATE SQL_Latin1_General_CP1_CI_AI = t.[description]
            WHEN NOT MATCHED THEN
                INSERT ([description],[serviceOrderId],[totalAmount],[calculatedAmount],[discount],[contractPenalty],[periodFrom],[periodUntil],[systemBillNo],[priceIncrease],[priceReduction], [priceIncreaseReductionComment],[dayReductionWorkDay],[dayReductionSaturday],[dayReductionComment],[sapOrderId],[isLegacy],[isDeleted],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
                VALUES (s.[description],s.[serviceOrderId],s.[totalAmount],s.[calculatedAmount],s.[discount],s.[contractPenalty],s.[periodFrom],s.[periodUntil],s.[systemBillNo],s.[priceIncrease],s.[priceReduction],s.[priceIncreaseReductionComment],s.[dayReductionWorkDay],s.[dayReductionSaturday],s.[dayReductionComment],s.[sapOrderId],s.[isLegacy],s.[isDeleted],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
            OUTPUT s.[dlm2BillId],inserted.[id],'WO'
            INTO [mig].[mapBillBill]([dlm2Id],[dlm3Id],[typ]);
        
            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --bill for WorkOrder             
        
        BEGIN --bill for manual Bill

            SET @msg = '   fill bill for manual Bill'

            PRINT @msg

            SET @rowCount = 0

            MERGE INTO [dlm].[bill] AS t
            USING
            (
                SELECT 
                    b.[id] AS [dlm2BillId]
                    ,b.[Description] + N' übernommen aus DLM2' AS [description]
                    ,mWOSO.[dlm3id] AS [serviceOrderId]
                    ,b.[amount] AS [totalAmount]
                    ,b.[NetAmount] AS [calculatedAmount]
                    ,ISNULL(b.[DiscountAmount],0) AS [discount]
                    ,CASE WHEN b.[netAmount] = 0 THEN 0 ELSE b.[PenaltyAmount] / b.[NetAmount] END AS [contractPenalty]
                    ,CASE
                        WHEN b.[day] IS NULL THEN CONVERT(DATE,CAST(b.[YEAR] AS NVARCHAR) + RIGHT('0' + CAST(b.[Month] AS NVARCHAR),2) + '01',112)
                        ELSE b.[serviceDate] 
                    END AS [periodFrom]
                    ,CASE
                        WHEN b.[day] IS NULL THEN DATEADD(DAY, -1,DATEADD(MONTH,1,CONVERT(DATE,CAST(b.[YEAR] AS NVARCHAR) + RIGHT('0' + CAST(b.[Month] AS NVARCHAR),2) + '01',112))) 
                        ELSE NULL 
                    END AS [periodUntil]
                    ,CAST(b.[id] AS NVARCHAR) AS [systemBillNo]
                    ,0 AS [priceIncrease]
                    ,0 AS [priceReduction]
                    ,NULL AS [priceIncreaseReductionComment]
                    ,0 AS [dayReductionWorkDay]
                    ,0 AS [dayReductionSaturday]
                    ,NULL AS [dayReductionComment]
                    ,mPOSO.[dlm3Id] AS [sapOrderId]
                    ,1 AS [isLegacy]
                    ,0 AS [isDeleted]
					,b.[Created] AS [insertedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,b.[Modified] AS [updatedAt]
					,mo.[dlm3Id] AS [updatedBy]
                FROM [archiv].[dbo_Bill] b
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = b.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = b.[ModifiedBy]
                INNER JOIN [archiv].[dbo_PurchaseOrder] po
                    ON po.[id] = b.[PoId] 
                INNER JOIN [archiv].[dbo_WorkOrder] wo
                    ON wo.[BillId] = b.[id]
                INNER JOIN [mig].[mapWorkOrderServiceOrder] mWOSO
                    ON mWOSO.[dlm2Id] = wo.[Id]
                INNER JOIN [mig].[mapBillStateBillStatus] mBSBS
                    ON mBSBS.[dlm2Id] = b.[StateId]
                INNER JOIN [mig].[mapPurchaseOrderSapOrder] mPOSO
                    ON mPOSO.[dlm2Id] = po.[Id]
                WHERE ISNULL(po.[IsActive],0) = 1 
                AND b.[TypeId] = 3
            ) AS s
            ON s.[serviceOrderId] = t.[serviceOrderId]
            AND s.[description]  COLLATE SQL_Latin1_General_CP1_CI_AI = t.[description]
            WHEN NOT MATCHED THEN
                INSERT ([description],[serviceOrderId],[totalAmount],[calculatedAmount],[discount],[contractPenalty],[periodFrom],[periodUntil],[systemBillNo],[priceIncrease],[priceReduction], [priceIncreaseReductionComment],[dayReductionWorkDay],[dayReductionSaturday],[dayReductionComment],[sapOrderId],[isLegacy],[isDeleted],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
                VALUES (s.[description],s.[serviceOrderId],s.[totalAmount],s.[calculatedAmount],s.[discount],s.[contractPenalty],s.[periodFrom],s.[periodUntil],s.[systemBillNo],s.[priceIncrease],s.[priceReduction],s.[priceIncreaseReductionComment],s.[dayReductionWorkDay],s.[dayReductionSaturday],s.[dayReductionComment],s.[sapOrderId],s.[isLegacy],s.[isDeleted],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
            OUTPUT s.[dlm2BillId],inserted.[id],'MAN'
            INTO [mig].[mapBillBill]([dlm2Id],[dlm3Id],[typ]);
        
            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --bill for manual Bill            

        BEGIN --billStatus

            SET @msg = '   fill billStatus'

            PRINT @msg

            SET @rowCount = 0

            INSERT INTO [dlm].[mapBillBillStatus]([billId],[billStatusId],[createdAt],[createdBy],[description],[insertedAt],[insertedBy])
            SELECT mBIBI.[dlm3Id],@billStatusOpenId,b.[ServiceDate],c.[login],N'erstellt bei Migration aus DLM 2.0',bl.[insertedAt],bl.[insertedBy]
            FROM [mig].[mapBillBill] mBIBI
            INNER JOIN [archiv].[dbo_bill] b
                ON b.[id] = mBIBI.[dlm2Id]
            LEFT OUTER JOIN  [mig].[mapUserClient] mUSCL
                ON mUSCL.[dlm2Id] = b.[CreatedBy]
            INNER JOIN [sec].[client] c
                ON c.[id] = ISNULL(mUSCL.[dlm3id], @clientSystemId)
            INNER JOIN [dlm].[bill] bl
                ON bl.[id] = mBIBI.[dlm3Id]

            SET @rowCount = @@ROWCOUNT
        
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records for open'

            SET @rowCount = 0

            INSERT INTO [dlm].[mapBillBillStatus]([billId],[billStatusId],[createdAt],[createdBy],[description],[insertedAt],[insertedBy])
            SELECT mBIBI.[dlm3Id],@billStatusReleasedId,b.[Released],c.[login],N'erstellt bei Migration aus DLM 2.0',b.[Released],mUSCL.[dlm3Id]
            FROM [mig].[mapBillBill] mBIBI
            INNER JOIN [archiv].[dbo_bill] b
                ON b.[id] = mBIBI.[dlm2Id]
            LEFT OUTER JOIN  [mig].[mapUserClient] mUSCL
                ON mUSCL.[dlm2Id] = b.[ReleasedBy]
            INNER JOIN [sec].[client] c
                ON c.[id] = ISNULL(mUSCL.[dlm3id], @clientSystemId)
            WHERE b.[Released] IS NOT NULL

            SET @rowCount = @@ROWCOUNT
        
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records for released'

            SET @rowCount = 0

            INSERT INTO [dlm].[mapBillBillStatus]([billId],[billStatusId],[createdAt],[createdBy],[description],[insertedAt],[insertedBy])
            SELECT mBIBI.[dlm3Id],@billStatusClosedId,b.[Modified],c.[login],N'erstellt bei Migration aus DLM 2.0',b.[Modified],mUSCL.[dlm3Id]
            FROM [mig].[mapBillBill] mBIBI
            INNER JOIN [archiv].[dbo_bill] b
                ON b.[id] = mBIBI.[dlm2Id]
            LEFT OUTER JOIN  [mig].[mapUserClient] mUSCL
                ON mUSCL.[dlm2Id] = b.[ModifiedBy]
            INNER JOIN [sec].[client] c
                ON c.[id] = ISNULL(mUSCL.[dlm3id], @clientSystemId)
            WHERE b.[StateId] = 40

            SET @rowCount = @@ROWCOUNT
        
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records for closed'

            SET @rowCount = 0

            INSERT INTO [dlm].[mapBillBillStatus]([billId],[billStatusId],[createdAt],[createdBy],[description],[insertedAt],[insertedBy])
            SELECT mBIBI.[dlm3Id],@billStatusCanceledId,b.[Modified],c.[login],N'erstellt bei Migration aus DLM 2.0',b.[Modified],mUSCL.[dlm3Id]
            FROM [mig].[mapBillBill] mBIBI
            INNER JOIN [archiv].[dbo_bill] b
                ON b.[id] = mBIBI.[dlm2Id]
            LEFT OUTER JOIN  [mig].[mapUserClient] mUSCL
                ON mUSCL.[dlm2Id] = b.[ModifiedBy]
            INNER JOIN [sec].[client] c
                ON c.[id] = ISNULL(mUSCL.[dlm3id], @clientSystemId)
            WHERE b.[StateId] = 50

            SET @rowCount = @@ROWCOUNT
        
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records for canceled'

            UPDATE T1
            SET T1.[isCurrent] = 1
            FROM [dlm].[mapBillBillStatus] T1
            INNER JOIN (
	            SELECT [billId],MAX([billStatusId]) AS [billStatusId]
	            FROM [dlm].[mapBillBillStatus]
	            GROUP BY [billId]
            ) T2
            ON T2.[billId] = T1.[billId]
            AND T2.[billStatusId] = T1.[billStatusId]

            SET @rowCount = @@ROWCOUNT
        
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records set current status'

        END --billStatus
        
    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' bill.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
