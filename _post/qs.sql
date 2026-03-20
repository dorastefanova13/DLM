SET NOCOUNT ON
DECLARE @result NVARCHAR(MAX)
DECLARE @object NVARCHAR(100)
DROP TABLE IF EXISTS #tmpOutput
CREATE TABLE #tmpOutput ([out] NVARCHAR(MAX))
PRINT N'Objekte bei Migration nicht 1 zu 1 übernommen: (IDs aus DLM2.0) '
PRINT ''
---------------------------------------------------------------------------
--LV
-----------------------------------------------------------------------------
SET @object = N'LV komplett: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_ServiceSpecification]
WHERE [id] NOT IN (
	SELECT [dlm2Id] FROM [mig].[mapServiceSpecificationServiceCatalog] UNION ALL
	SELECT [dlm2Id] FROM [mig].[mapServiceSpecificationSiteCatalog] UNION ALL
	SELECT [dlm2Id] FROM [mig].[mapServiceSpecificationServiceOrder]
)
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'LV global          ->       Servicecatalog: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_ServiceSpecification]
WHERE [isGlobal] = 1
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapServiceSpecificationServiceCatalog]
)
--optionale Filter zur Fehlererkennung
--AND [IsStandard] = 1
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'LV Pos global      ->      Serviceposition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_sspItem]
WHERE [SspId] IN (SELECT [id] FROM [archiv].[dbo_ServiceSpecification] WHERE [isGlobal] = 1)
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapSspItemServicePosition]
)
--optionale Filter zur Fehlererkennung
--AND [SspId] IN (SELECT [dlm2Id] FROM [mig].[mapServiceSpecificationServiceCatalog])		--wenn ServiceCatalog fehlt, dann fehlen auch die Positionen
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'LV not global      ->          SiteCatalog: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_ServiceSpecification]
WHERE [isGlobal] = 0 AND ISNULL([MainSspid],0) = 0
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapServiceSpecificationSiteCatalog]
)
AND [id] NOT IN (5999,6016,6017,6018,6019) --sollen lauf Alex nicht übernommen werden
--AND [id] IN (SELECT [sspId] FROM [archiv].[dbo_SspCompany])
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'LV Pos not global  ->  SiteCatalogPosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_SspItem]
WHERE [SspId] IN (SELECT [id] FROM [archiv].[dbo_ServiceSpecification] WHERE [isGlobal] = 0 AND ISNULL([MainSspid],0) = 0)
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapSspItemSiteCatalogPosition]
)
--optionale Filter zur Fehlererkennung
--AND [SspId] IN (SELECT [dlm2Id] FROM [mig].[mapServiceSpecificationSiteCatalog]) --wenn Sitecatalog fehlt, dann fehlen auch Positionen
AND [SspId] NOT IN (5999,6016,6017,6018,6019)  --sollen laut Alex nicht übernommen werden
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'subLV              ->         ServiceOrder: ' 
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_ServiceSpecification]
WHERE [isGlobal] = 0 AND ISNULL([MainSspid],0) <>  0
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapServiceSpecificationServiceOrder]
)
--optionale Filter zur Fehlererkennung
AND [MainSspId]	 NOT IN (5999,6016,6017,6018,6019)	-- sollen laut Alex nicht übernommen werden
--AND [PoId] IS NOT NULL --ServiceOrder ohne Bestellung
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'subLV Pos          -> ServiceOrderPosition: ' 
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_SspItem]
WHERE [SspId] IN (SELECT [id] FROM [archiv].[dbo_ServiceSpecification] WHERE [isGlobal] = 0 AND ISNULL([MainSspid],0) >  0)
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapSspItemServiceOrderPosition]
)
--optionale Filter zur Fehlererkennung
--AND [SspId] IN (SELECT [dlm2Id] FROM [mig].[mapServiceSpecificationServiceOrder]) --wenn ServiceOrder fehlt, dann fehlen auch Positionen
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
PRINT ''
---------------------------------------------------------------------------
--EPK
---------------------------------------------------------------------------
SET @object = N'EPK komplett: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_StandardServicesCatalog]
WHERE [id] NOT IN (
	SELECT [dlm2Id] FROM [mig].[mapStandardServicesCatalogServiceCatalog] UNION ALL
	SELECT [dlm2Id] FROM [mig].[mapStandardServicesCatalogSiteCatalog] 
)
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'EPK global         ->       ServiceCatalog: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_StandardServicesCatalog]
WHERE [isGlobal] = 1
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapStandardServicesCatalogServiceCatalog]
)
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'EPK Pos global     ->      ServicePosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_SscItem]
WHERE [SscId] IN (SELECT [id] FROM [archiv].[dbo_StandardServicesCatalog] WHERE [isGlobal] = 1)
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapSscItemServicePosition]	 
)
--optionale Filter zur Fehlererkennung
--AND [SscId] IN (SELECT [dlm2Id] FROM [mig].[mapStandardServicesCatalogServiceCatalog])	---wenn ServiceCatalog fehlt, dann fehlen auch Positionen
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'EPK not global     ->          SiteCatalog: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_StandardServicesCatalog]
WHERE [isGlobal] = 0
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapStandardServicesCatalogSiteCatalog]
)
--optionale Filter zur Fehlererkennung
--AND [Id] IN (SELECT [sscId] FROM [archiv].[dbo_SscCompany])	  -- keine Gesellschaft zugeordnet
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'EPK Pos not global ->  SiteCatalogPosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_SscItem]
WHERE [SscId] IN (SELECT [id] FROM [archiv].[dbo_StandardServicesCatalog] WHERE [isGlobal] = 0)
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapSscItemSiteCatalogPosition]
)
--optionale Filter zur Fehlererkennung
--AND [SscId] IN (SELECT [dlm2Id] FROM [mig].[mapStandardServicesCatalogSiteCatalog]) --wenn SiteCatalog fehlt, dann fehlen auch Positionen
--AND [SscId] IN (SELECT [sscId] FROM [archiv].[dbo_SscCompany])						-- keine Gesellschaft zugeordnet
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'Workorder          ->         ServiceOrder: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_WorkOrder]  wo
WHERE wo.[id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapWorkOrderServiceOrder]
)
--optionale Filter zur Fehlererkennung
--AND wo.[PoId] IN (SELECT [Id] FROM [archiv].[dbo_PurchaseOrder] WHERE [SscId] IN (SELECT [SscId] FROM [archiv].[dbo_SscCompany]))	  --keine Gesellschaft zugeordnet
--AND wo.[PoId] IN (																													  --Supplier in Bestellung und Preis stimmen nicht überein (unterschiedliche Gesellschaft)
--	SELECT po.[id]
--	FROM [archiv].[dbo_PurchaseOrder] po 
--	INNER JOIN [archiv].[dbo_SscQuoteRequest] qr
--		ON qr.[SupplierId] = po.[SupplierId]
--	INNER JOIN [archiv].[dbo_SscQuoteRequestGroup] qrg
--		ON qrg.[Id] = qr.[GroupId]
--		AND qrg.[SscId] = po.[SscId]
--)
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'Workorder Pos      -> ServiceOrderPosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_WoItem]
WHERE [WoId] IN (SELECT [id] FROM [archiv].[dbo_WorkOrder])
AND [id] NOT IN
(
    SELECT [dlm2id] FROM [mig].[mapWorkOrderItemServiceOrderPosition]
)
--optionale Filter zur Fehlererkennung
--AND [WoId] IN (SELECT [dlm2Id] FROM [mig].[mapWorkOrderServiceOrder])	      -- wenn ServiceOrder fehlt, dann fehlen auch Positionen
--AND [SscItemId] IN (														  -- EPK keine Gesellschaft zugeordnet
--	SELECT [Id] FROM [archiv].[dbo_SscItem] WHERE [SscId] IN (SELECT [SscId] FROM [archiv].[dbo_SscCompany])
--)
--AND [WoId] IN (																  --Supplier in Bestellung für Auftrag und Preis stimmen nicht überein (unterschiedliche Gesellschaft)
--	SELECT [id]
--	FROM [archiv].[dbo_WorkOrder] wo
--	WHERE wo.[PoId] IN (																													  
--		SELECT po.[id]
--		FROM [archiv].[dbo_PurchaseOrder] po 
--		INNER JOIN [archiv].[dbo_SscQuoteRequest] qr
--			ON qr.[SupplierId] = po.[SupplierId]
--		INNER JOIN [archiv].[dbo_SscQuoteRequestGroup] qrg
--			ON qrg.[Id] = qr.[GroupId]
--			AND qrg.[SscId] = po.[SscId]
--	)
--)
--AND [Id] IN (																  --SscId in PO ist ungleich des SscId in WoItem->SsciItem
--	SELECT woi.[id]
--	FROM [archiv].[dbo_WoItem] woi
--	INNER JOIN [archiv].[dbo_Workorder] wo
--		ON wo.[Id] = woi.[WoId]
--	INNER JOIN [archiv].[dbo_PurchaseOrder] po
--		ON po.[Id] = wo.[PoId]
--	INNER JOIN [archiv].[dbo_SscItem] ssci
--		ON ssci.[id] = woi.[SscItemId]
--	WHERE ssci.[SscId] = po.[SscId]
--)

PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
PRINT '' 
--------------------------------------------------------------------------
--BESTELLUNG
---------------------------------------------------------------------------
SET @object = N'PurchaseOrder      ->             SAPOrder: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_PurchaseOrder]
WHERE [id] NOT IN
(
     SELECT [dlm2Id] FROM [mig].[mapPurchaseOrderSapOrder]
)
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
PRINT '' 
---------------------------------------------------------------------------
--AUFMASSE 
---------------------------------------------------------------------------
SET @object = N'Aufmasse LV        ->  SiteCatalogPosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(q.[ids],N','),' ')
FROM 
(
	SELECT	CONCAT(CAST(dlm2.[id] AS NVARCHAR(MAX)),' (',CAST(dlm2.[units] AS NVARCHAR),')->',CAST(ISNULL(dlm3.[id],0) AS NVARCHAR(MAX)),' (',CAST(ISNULL(dlm3.[units],0) AS NVARCHAR),')') AS [ids]
	FROM 
		(SELECT [sspItemId] AS [id],SUM([units]) AS [units] FROM [archiv].[dbo_Measurement] WHERE ([FileName] IS NOT NULL AND [ShapeId] IS NOT NULL) OR [Manual] = 1 GROUP BY [sspItemId]) dlm2
		INNER JOIN [archiv].[dbo_SspItem] sspi
			ON sspi.[id] = dlm2.[id]
		INNER JOIN [archiv].[dbo_SspCompany] sspco
			ON sspco.[SspId] = sspi.[SspId]
		INNER JOIN [mig].[mapCompanyCompany] mCOCO
			ON mCOCO.[dlm2Id] = sspco.[CompanyId]
		INNER JOIN [mig].[mapSspItemSiteCatalogPosition] mSISCP
			ON mSISCP.[dlm2Id] = dlm2.[id]
		INNER JOIN (
			SELECT 
				[id] 
				,[servicePositionId]
				,ISNULL([unitsActive],0) + ISNULL([unitsNotActive],0) AS [units]
			FROM [dlm].[siteCatalogPosition]
		) dlm3
			ON dlm3.[id] = mSISCP.[dlm3Id]
		INNER JOIN [dlm].[servicePosition] svp
			ON svp.[id] = dlm3.[servicePositionId]
			AND svp.[companyId] = mCOCO.[dlm3Id]
		WHERE dlm2.[units] <> ISNULL(dlm3.[units],0)
		
)q
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'Aufmasse LV active ->  SiteCatalogPosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(q.[ids],N','),' ')
FROM 
(
	SELECT	CONCAT(CAST(dlm2.[id] AS NVARCHAR(MAX)),' (',CAST(dlm2.[units] AS NVARCHAR),')->',CAST(ISNULL(dlm3.[id],0) AS NVARCHAR(MAX)),' (',CAST(ISNULL(dlm3.[units],0) AS NVARCHAR),')') AS [ids]
	FROM 
		(SELECT [sspItemId] AS [id],SUM([units]) AS [units] FROM [archiv].[dbo_Measurement] WHERE (([FileName] IS NOT NULL AND [ShapeId] IS NOT NULL) OR [Manual] = 1) AND [isActive] = 1 GROUP BY [sspItemId]) dlm2
		INNER JOIN [archiv].[dbo_SspItem] sspi
			ON sspi.[id] = dlm2.[id]
		INNER JOIN [archiv].[dbo_SspCompany] sspco
			ON sspco.[SspId] = sspi.[SspId]
		INNER JOIN [mig].[mapCompanyCompany] mCOCO
			ON mCOCO.[dlm2Id] = sspco.[CompanyId]
		INNER JOIN [mig].[mapSspItemSiteCatalogPosition] mSISCP
			ON mSISCP.[dlm2Id] = dlm2.[id]
		INNER JOIN (
			SELECT 
				[id] 
				,[servicePositionId]
				,ISNULL([unitsActive],0) AS [units]
			FROM [dlm].[siteCatalogPosition]
		) dlm3
			ON dlm3.[id] = mSISCP.[dlm3Id]
		INNER JOIN [dlm].[servicePosition] svp
			ON svp.[id] = dlm3.[servicePositionId]
			AND svp.[companyId] = mCOCO.[dlm3Id]
		WHERE dlm2.[units] <> ISNULL(dlm3.[units],0)
		
)q
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
PRINT '' 
---------------------------------------------------------------------------
SET @object = N'Aufmasse LV        -> ServiceOrderPosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(q.[ids],N','),' ')
FROM 
(
	SELECT	CONCAT(CAST(dlm2.[id] AS NVARCHAR(MAX)),' (',CAST(dlm2.[units] AS NVARCHAR),')->',CAST(ISNULL(dlm3.[id],0) AS NVARCHAR(MAX)),' (',CAST(ISNULL(dlm3.[units],0) AS NVARCHAR),')') AS [ids]
	FROM 
		(SELECT [sspItemId] AS [id],SUM([units]) AS [units] FROM [archiv].[dbo_Measurement] WHERE ([FileName] IS NOT NULL AND [ShapeId] IS NOT NULL) OR [Manual] = 1 GROUP BY [sspItemId]) dlm2
		INNER JOIN [archiv].[dbo_SspItem] sspi
			ON sspi.[id] = dlm2.[id]
		INNER JOIN [archiv].[dbo_SspCompany] sspco
			ON sspco.[SspId] = sspi.[SspId]
		INNER JOIN [mig].[mapCompanyCompany] mCOCO
			ON mCOCO.[dlm2Id] = sspco.[CompanyId]
		INNER JOIN [mig].[mapSspItemServiceOrderPosition] mSISCP
			ON mSISCP.[dlm2Id] = dlm2.[id]
		INNER JOIN (
			SELECT 
				[id] 
				,ISNULL([unitsActive],0) + ISNULL([unitsNotActive],0) AS [units]
			FROM [dlm].[serviceOrderPosition]
		) dlm3
			ON dlm3.[id] = mSISCP.[dlm3Id]
		WHERE dlm2.[units] <> ISNULL(dlm3.[units],0)
		
)q
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
---------------------------------------------------------------------------
SET @object = N'Aufmasse LV activ  -> ServiceOrderPosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(q.[ids],N','),' ')
FROM 
(
	SELECT	CONCAT(CAST(dlm2.[id] AS NVARCHAR(MAX)),' (',CAST(dlm2.[units] AS NVARCHAR),')->',CAST(ISNULL(dlm3.[id],0) AS NVARCHAR(MAX)),' (',CAST(ISNULL(dlm3.[units],0) AS NVARCHAR),')') AS [ids]
	FROM 
		(SELECT [sspItemId] AS [id],SUM([units]) AS [units] FROM [archiv].[dbo_Measurement] WHERE (([FileName] IS NOT NULL AND [ShapeId] IS NOT NULL) OR [Manual] = 1) AND [IsActive] = 1 GROUP BY [sspItemId]) dlm2
		INNER JOIN [archiv].[dbo_SspItem] sspi
			ON sspi.[id] = dlm2.[id]
		INNER JOIN [archiv].[dbo_SspCompany] sspco
			ON sspco.[SspId] = sspi.[SspId]
		INNER JOIN [mig].[mapCompanyCompany] mCOCO
			ON mCOCO.[dlm2Id] = sspco.[CompanyId]
		INNER JOIN [mig].[mapSspItemServiceOrderPosition] mSISCP
			ON mSISCP.[dlm2Id] = dlm2.[id]
		INNER JOIN (
			SELECT 
				[id] 
				,ISNULL([unitsActive],0) AS [units]
			FROM [dlm].[serviceOrderPosition]
		) dlm3
			ON dlm3.[id] = mSISCP.[dlm3Id]
		WHERE dlm2.[units] <> ISNULL(dlm3.[units],0)
		
)q
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
PRINT '' 
---------------------------------------------------------------------------
SET @object = N'Aufmasse EPK       -> ServiceOrderPosition: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(q.[ids],N','),' ')
FROM 
(
	SELECT	CONCAT(CAST(dlm2.[id] AS NVARCHAR(MAX)),' (',CAST(dlm2.[units] AS NVARCHAR),')->',CAST(ISNULL(dlm3.[id],0) AS NVARCHAR(MAX)),' (',CAST(ISNULL(dlm3.[units],0) AS NVARCHAR),')') AS [ids]
	FROM 
		(SELECT [Id] AS [id],[units] FROM [archiv].[dbo_WoItem] WHERE ([FileName] IS NOT NULL AND [ShapeId] IS NOT NULL) OR [IsManual] = 1 ) dlm2
		INNER JOIN [mig].[mapWorkOrderItemServiceOrderPosition] mWOISOP
			ON mWOISOP.[dlm2Id] = dlm2.[id]
		INNER JOIN (
			SELECT 
				[id] 
				,ISNULL([unitsActive],0) AS [units]
			FROM [dlm].[serviceOrderPosition]
		) dlm3
			ON dlm3.[id] = mWOISOP.[dlm3Id]
		WHERE dlm2.[units] <> ISNULL(dlm3.[units],0)
		
)q
PRINT @result
INSERT INTO #tmpOutput ([out]) SELECT @result
PRINT '' 
---------------------------------------------------------------------------
--ABRECHNUNG 
---------------------------------------------------------------------------
SET @object = N'Abrechnung          ->                Bill: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_Bill]
WHERE [StateId] <> 50
AND [id] NOT IN
(
     SELECT [dlm2Id] FROM [mig].[mapBillBill]
)
--optionale Filter zur Fehlererkennung
AND [TypeId] <> 3												   -- manuelle Abrechnungen sollten nicht übernommen werden
---------------------------------------------------------------------------
INSERT INTO #tmpOutput ([out]) SELECT @result
PRINT @result
SET @object = N'Abrechnung LV       ->                Bill: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_Bill]
WHERE [StateId] <> 50
AND [TypeId] = 1
AND [id] NOT IN
(
     SELECT [dlm2Id] FROM [mig].[mapBillBill]
)
--optionale Filter zur Fehlererkennung
AND [Id] IN (SELECT [BillId] FROM [archiv].[dbo_SspBill])			--BillId Nicht in SsspBill
AND [Id] IN (														--BillId in SspBill aber Ssp hat keine PurchaseOrder
	SELECT [billId] 
	FROM [archiv].[dbo_SspBill]
	WHERE [SspId] IN (
		SELECT [id]
		FROM [archiv].[dbo_ServiceSpecification]
		WHERE [PoId] IS NOT NULL
	)
)
---------------------------------------------------------------------------
INSERT INTO #tmpOutput ([out]) SELECT @result
PRINT @result
SET @object = N'Abrechnung WorkOrder->                 Bill: '
SELECT @result = @object + '(' + CAST(COUNT(1) AS NVARCHAR) + ') ' + ISNULL(STRING_AGG(CAST([id] AS NVARCHAR(MAX)),N','),' ')
FROM [archiv].[dbo_Bill]
WHERE [StateId] <> 50
AND [TypeId] = 2
AND [id] NOT IN
(
     SELECT [dlm2Id] FROM [mig].[mapBillBill]
)
--optionale Filter zur Fehlererkennung
AND [id] IN (SELECT [BillId] FROM [archiv].[dbo_WorkOrder])		--BillId Nicht in WorkOrder
AND [id] IN (													--BillId in     Workorder aber WorkOrder nicht übernommen
	SELECT [BillId] 
	FROM [archiv].[dbo_WorkOrder] 
	WHERE [id] IN (
		SELECT [dlm2Id] 
		FROM [mig].[mapWorkOrderServiceOrder]
	)
)
PRINT '' 
---------------------------------------------------------------------------
SELECT * FROM #tmpOutput


