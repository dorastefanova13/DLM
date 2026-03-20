BEGIN --servicePosition

    SET NOCOUNT ON

    PRINT '    fill servicePosition'

    DECLARE @msg NVARCHAR(MAX)
	DECLARE @rowcount INT 
	BEGIN --   mapMainPositionSubPosition

		SET @msg =  '   fill parentId for subPosition'
		PRINT @msg

		SET @rowcount = 0

		DROP TABLE IF EXISTS [mig].[serviceMainPositions]
		DROP TABLE IF EXISTS [mig].[serviceSubPositions]

		PRINT '     fill temp serviceMainPosition'

		CREATE TABLE [mig].[serviceMainPositions] ([servicePositionId] INT, [mainCodeId] INT, [turnusId] INT, [serviceCatalogId] INT,[dlm2Id] INT,[dlm2SspId] INT)

		INSERT INTO [mig].[serviceMainPositions]([servicePositionId],[mainCodeId],[turnusId],[serviceCatalogId],[dlm2Id],[dlm2SspId])
		SELECT sp.[id],sp.[mainCodeId],sp.[turnusId],m.[serviceCatalogId],mSSPISP.[dlm2Id],sspi.[SspId]
		FROM [dlm].[servicePosition] sp
		INNER JOIN [dlm].[mapServiceCatalogServicePosition] m
			ON m.[servicePositionId] = sp.[id]
		INNER JOIN [mig].[mapSspItemServicePosition] mSSPISP
			ON mSSPISP.[dlm3Id] = sp.[id]
		INNER JOIN [FAPLISDlm].[dbo].[SspItem] sspi
			ON sspi.[id] = mSSPISP.[dlm2Id]
		INNER JOIN [dlm].[serviceCatalog] svc
			ON svc.[id] = m.[serviceCatalogId]
			AND svc.[companyId] = sp.[companyId]
		WHERE sp.[isMainService] = 1

		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		PRINT '     fill temp serviceSubPosition'

		CREATE TABLE [mig].[serviceSubPositions] ([servicePositionId] INT, [mainCodeId] INT, [turnusId] INT, [serviceCatalogId] INT, [parentId] INT, [dlm2Id] INT, [dlm2SspId] INT)

		INSERT INTO [mig].[serviceSubPositions]([servicePositionId],[mainCodeId],[turnusId],[serviceCatalogId],[dlm2Id],[dlm2SspId])
		SELECT sp.[id],sp.[mainCodeId],sp.[turnusId],m.[serviceCatalogId],mSSPISP.[dlm2Id],sspi.[SspId]
		FROM [dlm].[servicePosition] sp
		INNER JOIN [dlm].[mapServiceCatalogServicePosition] m
			ON m.[servicePositionId] = sp.[id]
		INNER JOIN [mig].[mapSspItemServicePosition] mSSPISP
			ON mSSPISP.[dlm3Id] = sp.[id]
		INNER JOIN [FAPLISDlm].[dbo].[SspItem] sspi
			ON sspi.[id] = mSSPISP.[dlm2Id]
		INNER JOIN [dlm].[serviceCatalog] svc
			ON svc.[id] = m.[serviceCatalogId]
			AND svc.[companyId] = sp.[companyId]
		WHERE sp.[isMainService] = 0

		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		PRINT '     build indexe'

		CREATE CLUSTERED INDEX [x_serviceMainPositionId] ON [mig].[serviceMainPositions]([servicePositionId] ASC )
		CREATE NONCLUSTERED INDEX [x_serviceMainPositionCodes] ON [mig].[serviceMainPositions]([mainCodeId] ASC ,[turnusId] ASC,[dlm2SspId] ASC )

		CREATE CLUSTERED INDEX [x_serviceSubPositionId] ON [mig].[serviceSubPositions]([servicePositionId] ASC )
		CREATE NONCLUSTERED INDEX [x_serviceSubPositionParentId] ON [mig].[serviceSubPositions]([parentId] ASC )
		CREATE NONCLUSTERED INDEX [x_serviceSubPositionCodes] ON [mig].[serviceSubPositions]([mainCodeId] ASC ,[turnusId] ASC,[dlm2SspId] ASC )

		PRINT '     update parentId'
				
		UPDATE T1
		SET T1.[parentId] = T2.[servicePositionId]
		FROM [mig].[serviceSubPositions] T1
		INNER JOIN [mig].[serviceMainPositions] T2
			ON T1.[mainCodeId] = T2.[mainCodeId]
			AND T1.[turnusId] = t2.[turnusId]
			AND T1.[dlm2SspId] = T2.[dlm2SspId]

		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		PRINT '     update servicePositionId'

		UPDATE T1
		SET T1.[servicePositionId] = T2.[parentId]
		FROM [dlm].[servicePosition] T1
		INNER JOIN [mig].[serviceSubPositions] T2
			ON T1.[id] = T2.[servicePositionId]    
                
		SET @rowCount = @@ROWCOUNT

		PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

	END -- fill parent Id for subPosition

END
GO