BEGIN --attachedDocument

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    fill Documents'

    PRINT @msg

    DECLARE @rowCount INT

	DELETE FROM [dlm].[attachedDocument] WHERE [type] NOT IN ( N'FY235',N'KB21')

	BEGIN --'      fill ServiceConfirmation,WoConfirmationOfWork'

		SET @msg = '      fill ServiceConfirmation,WoConfirmationOfWork'
		PRINT @msg

		DROP TABLE IF EXISTS [mig].[mapReportGenerationAttachedDocument]
		CREATE TABLE [mig].[mapReportGenerationAttachedDocument] (dlm2Id INT, dlm3Id INT)


		INSERT INTO [dlm].[attachedDocument]([name],[originalFilename],[ref],[description],[timestamp],[type],[status],[isDeleted],[updatedBy])
		OUTPUT inserted.[id],inserted.[updatedBy] INTO [mig].[mapReportGenerationAttachedDocument]([dlm3Id],[dlm2Id])
		SELECT 
			r.[File] AS [name]
			,r.[File] AS [originalFileName]
			,r.[File] AS [ref]
			,N'DLM 2.0 ' + ISNULL(r.[OperationStateMessage],'') AS [description]
			,r.[Created] AS [timestamp]
			,N'BillCreatedReport' AS [type]
			,N'STORED' AS [status]
			,0 AS [isDeleted]
			,r.[Id]
		FROM [archiv].[dbo_ReportGeneration] r
		INNER JOIN [archiv].[dbo_ReportType] rt
			ON rt.[Id] = r.[ReportTypeId]
		INNER JOIN [archiv].[dbo_Bill] b
			ON b.[ReportGenerationId] = r.[id]
		INNER JOIN [mig].[mapBillBill] mBIBI
			ON mBIBI.[dlm2Id] = b.[Id]
		WHERE rt.[Key] IN (N'ServiceConfirmation',N'WoConfirmationOfWork')
		AND r.[File] IS NOT NULL




		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

	END --'      fill ServiceConfirmation,WoConfirmationOfWork'

	BEGIN --update audit columns


		SET @msg = '      set audit columns'
		PRINT @msg

		UPDATE t1
			SET 
				t1.[insertedAt] = ISNULL(t2.[insertedAt],GETDATE())
				,t1.[updatedAt] = t2.[updatedAt]
				,t1.[insertedBy] = ISNULL(t2.[insertedBy],1)
				,t1.[updatedBy] = t2.[insertedBy]
		FROM [dlm].[attachedDocument] t1
		INNER JOIN (
			SELECT 
				mRGAD.[dlm3Id]
				,rg.[Created] AS [insertedAt]
				,rg.[Modified] AS [updatedAt]
				,cr.[dlm3Id] AS [insertedBy]
				,mo.[dlm3Id] AS [updatedBy]
			FROM [mig].[mapReportGenerationAttachedDocument] mRGAD
			INNER JOIN [archiv].[dbo_ReportGeneration] rg
				ON rg.[id] = mRGAD.[dlm2Id]
			LEFT OUTER JOIN [mig].[mapUserClient] cr
				ON cr.[dlm2Id] = rg.[CreatedBy]
			LEFT OUTER JOIN [mig].[mapUserClient] mo
				ON mo.[dlm2Id] = rg.[ModifiedBy]
		) t2
		ON t2.[dlm3Id] = t1.[id]

		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

	END --update audit columns

	
	BEGIN --map Documents to Bill SSP

		SET @msg = '      delete old mappings Bill SSP'
		PRINT @msg

		DELETE FROM [dlm].[mapBillAttachedDocument]
		WHERE [billId] IN (
			SELECT [dlm3Id] FROM [mig].[mapBillBill] WHERE [typ] = N'SSP'
		)
		AND [attachedDocumentId] IN (
			SELECT [id] FROM [dlm].[attachedDocument] WHERE [type] = N'BillCreatedReport'
		)

		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		SET @msg = '      map Documents to Bill SSP'
		PRINT @msg

		INSERT INTO [dlm].[mapBillAttachedDocument]([attachedDocumentId],[billId])
		SELECT mRGAD.[dlm3Id],mBIBI.[dlm3Id]
		FROM [mig].[mapBillBill] mBIBI
		INNER JOIN [archiv].[dbo_SspBill] sspb
			ON sspb.[BillId] = mBIBI.[dlm2Id]
		INNER JOIN [mig].[mapReportGenerationAttachedDocument] mRGAD
			ON mRGAD.[dlm2Id] = sspb.[ReportGenerationId]
		WHERE mBIBI.[typ] = N'SSP'

		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

	END --map Documents to Bill SSP

	BEGIN --map Documents to Bill WO

		SET @msg = '      delete old mappings Bill SSP'
		PRINT @msg

		DELETE FROM [dlm].[mapBillAttachedDocument]
		WHERE [billId] IN (
			SELECT [dlm3Id] FROM [mig].[mapBillBill] WHERE [typ] = N'WO'
		)
		AND [attachedDocumentId] IN (
			SELECT [id] FROM [dlm].[attachedDocument] WHERE [type] = N'BillCreatedReport'
		)

		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'


		SET @msg = '      map Documents to Bill WO'
		PRINT @msg


		INSERT INTO [dlm].[mapBillAttachedDocument]([attachedDocumentId],[billId])
		SELECT mRGAD.[dlm3Id],mBIBI.[dlm3Id]
		FROM [mig].[mapBillBill] mBIBI
		INNER JOIN [archiv].[dbo_Workorder] wo
			ON wo.[BillId] = mBIBI.[dlm2Id]
		INNER JOIN [mig].[mapReportGenerationAttachedDocument] mRGAD
			ON mRGAD.[dlm2Id] = wo.[ReportGenerationId]
		WHERE mBIBI.[typ] = N'WO'

		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

	END --map Documents to Bill WO


END
GO