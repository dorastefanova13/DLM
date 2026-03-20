BEGIN --sapOrder

    SET NOCOUNT ON

    PRINT '    fill sapOrder'

    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '   fill sapOrder'

    PRINT @msg

    DECLARE @rowCount INT

    DROP TABLE IF EXISTS [mig].[mapPurchaseOrderSapOrder]
        
    CREATE TABLE [mig].[mapPurchaseOrderSapOrder] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [dlm].[sapOrder]

    MERGE INTO [dlm].[sapOrder] t
    USING
    (
        SELECT 
            po.[id] AS [dlm2Id]
            ,REPLACE(SUBSTRING(po.[OrderNo],1,CHARINDEX('/',po.[OrderNo])),'/','') AS [sapOrderNo]
            ,SUBSTRING(po.[OrderNo],CHARINDEX('/',po.[OrderNo])+1,LEN(po.[OrderNo])) AS [sapOrderPosition]
            ,po.[PurchaseRequisitionNo] AS [sapBANFNo]
            ,po.[OrderDate] AS [periodFrom]
            ,CONVERT(DATETIME,'21001231', 112) AS [periodUntil]
            ,ISNULL(po.[OrderText],'kein Text') AS [orderText]
            ,po.[Value] AS [budget]
            ,mSS.[dlm3Id] AS [supplierId]
            ,mPP.[dlm3Id] AS [plantId]
            ,CASE 
                WHEN mCUCU.[dlm3Id] IS NULL THEN (SELECT [id] FROM [std].[currency] WHERE UPPER([code]) = 'EUR')
                ELSE mCUCU.[dlm3Id] 
             END AS [currencyId]
            ,mSTST.[dlm3Id] AS [settlementTypeId]
            ,LTRIM(ISNULL(po.[SponsorCenter],'') + ' ' + ISNULL(po.[SponsorDepartment],'') + ' ' + ISNULL(po.[SponsorName],'')) AS [sponsorInformation]
            ,mCCCCB.[dlm3Id] AS [costCenterBId]
            ,mCCCCC.[dlm3Id] AS [costCenterCId]
            ,po.[CoNo] AS [coOrder]
            ,po.[PmNo] AS [pmNo]
            ,po.[PspNo] AS [pspElement]
            ,po.[isactive] AS [isActive]
            ,1 AS [isLegacy]
            ,0 AS [isDeleted]
			,po.[Created] AS [insertedAt]
			,cr.[dlm3Id] AS [insertedBy]
			,po.[Modified] AS [updatedAt]
			,mo.[dlm3Id] AS [updatedBy]
        FROM [archiv].[dbo_PurchaseOrder] po
		LEFT OUTER JOIN [mig].[mapUserClient] cr
			ON cr.[dlm2Id] = po.[CreatedBy]
		LEFT OUTER JOIN [mig].[mapUserClient] mo
			ON mo.[dlm2Id] = po.[ModifiedBy]
		INNER JOIN [archiv].[dbo_supplier] s
			ON s.[id] = po.[supplierId]
		INNER JOIN [mig].[mapCompanyCompany] mCOCO
			ON mCOCO.[dlm2id] = s.[companyId]
        LEFT OUTER JOIN [mig].[mapSupplierSupplier] mSS
            ON mSS.[dlm2Id] = po.[SupplierId]
        LEFT OUTER JOIN [mig].[mapPlantPlant] mPP
            ON mPP.[dlm2Id] = po.[PlantId]
        LEFT OUTER JOIN [mig].[mapCurrencyCurrency] mCUCU
            ON mCUCU.[dlm2Id] = po.[CurrencyId]
        LEFT OUTER JOIN [mig].[mapSettlementTypeSettlementType] mSTST
            ON mSTST.[dlm2Id] = po.[SettlementTypeId]
        INNER JOIN (SELECT fCC.[id] AS [dlm2Id],sCC.[id] AS [dlm3Id] FROM [archiv].[faplis_CostCenter] fCC INNER JOIN [std].[costCenter] sCC ON fCC.[functionalId] = sCC.[faplisId] COLLATE SQL_Latin1_General_CP1_CI_AI ) mCCCCB
            ON mCCCCB.[dlm2Id] = po.[BCostCenterId]
        LEFT OUTER JOIN (SELECT fCC.[id] AS [dlm2Id],sCC.[id] AS [dlm3Id] FROM [archiv].[faplis_CostCenter] fCC INNER JOIN [std].[costCenter] sCC ON fCC.[functionalId] = sCC.[faplisId] COLLATE SQL_Latin1_General_CP1_CI_AI ) mCCCCC
            ON mCCCCC.[dlm2Id] = po.[CCostCenterId]
        WHERE (
			ISNULL(po.[IsActive],0) >= 0
		) OR (
			po.[SscId] IN (SELECT [id] FROM [archiv].[dbo_StandardServicesCatalog] WHERE [isGlobal] = 1)
		) 
    ) s
    ON s.[dlm2Id] = t.[id]
    WHEN NOT MATCHED THEN
    INSERT ([sapOrderNo],[sapOrderPosition],[sapBANFNo],[periodFrom],[periodUntil],[orderText],[budget],[supplierId],[plantId],[currencyId],[settlementTypeId],[sponsorInformation],[costCenterBId],[costCenterCId],[coOrder],[pmNo],[pspElement],[isActive],[isLegacy],[isDeleted],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
    VALUES (s.[sapOrderNo],s.[sapOrderPosition],s.[sapBANFNo],s.[periodFrom],s.[periodUntil],s.[orderText],s.[budget],s.[supplierId],s.[plantId],s.[currencyId],s.[settlementTypeId],s.[sponsorInformation],s.[costCenterBId],s.[costCenterCId],s.[coOrder],s.[pmNo],s.[pspElement],s.[isActive],s.[isLegacy],s.[isDeleted],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
    OUTPUT s.[dlm2Id],inserted.[id]
    INTO [mig].[mapPurchaseOrderSapOrder]([dlm2Id],[dlm3Id]);

    SET @rowCount = @@ROWCOUNT
        
    PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

    SET @msg = '   fill mapSapOrderServiceType'

    PRINT @msg

    INSERT INTO [dlm].[mapSapOrderServiceType]([sapOrderId],[serviceTypeId])
    SELECT 
        so.[id]
        ,CASE
            WHEN po.[SscId] IS NULL THEN (SELECT [id] FROM [std].[serviceType] WHERE UPPER([name]) = UPPER('Unterhaltsreinigung'))
            ELSE (SELECT [id] FROM [std].[serviceType] WHERE UPPER([name]) = UPPER('adHoc'))
        END
    FROM [dlm].[sapOrder] so
    INNER JOIN [mig].[mapPurchaseOrderSapOrder] mPOSO 
        ON mPOSO.[dlm3Id] = so.[id]
    INNER JOIN [archiv].[dbo_PurchaseOrder] po
        ON po.[Id] = mPOSO.[dlm2Id]

    SET @rowCount = @@ROWCOUNT
        
    PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

    --select * from faplisdlm..purchaseorder

END --sapOrder
GO

