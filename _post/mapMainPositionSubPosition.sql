BEGIN --mapMainPositionSubPosition

	DECLARE @msg NVARCHAR(MAX)
	DECLARE @rowcount INT

	BEGIN --   mapMainPositionSubPosition

        SET @msg =  '   fill parentId for subPosition'
        PRINT @msg

        SET @rowcount = 0

        DROP TABLE IF EXISTS [mig].[serviceMainPosition]
        DROP TABLE IF EXISTS [mig].[serviceSubPosition]

        CREATE TABLE [mig].[serviceMainPosition] ([servicePositionId] INT, [mainCodeId] INT, [turnusId] INT, [serviceCatalogId] INT)
        INSERT INTO [mig].[serviceMainPosition]([servicePositionId],[mainCodeId],[turnusId],[serviceCatalogId])
        SELECT sp.[id],sp.[mainCodeId],sp.[turnusId],m.[serviceCatalogId]
        FROM [dlm].[servicePosition] sp
        INNER JOIN [dlm].[mapServiceCatalogServicePosition] m
            ON m.[servicePositionId] = sp.[id]
		INNER JOIN [dlm].[serviceCatalog] svc
			ON svc.[id] = m.[serviceCatalogId]
			AND svc.[companyId] = sp.[companyId]
        WHERE sp.[isMainService] = 1


		PRINT '     serviceMainPosition filled'

        CREATE TABLE [mig].[serviceSubPosition] ([servicePositionId] INT, [mainCodeId] INT, [turnusId] INT, [serviceCatalogId] INT,[parentId] INT)
        INSERT INTO [mig].[serviceSubPosition]([servicePositionId],[mainCodeId],[turnusId],[serviceCatalogId])
        SELECT sp.[id],sp.[mainCodeId],sp.[turnusId],m.[serviceCatalogId]
        FROM [dlm].[servicePosition] sp
        INNER JOIN [dlm].[mapServiceCatalogServicePosition] m
            ON m.[servicePositionId] = sp.[id]
		INNER JOIN [dlm].[serviceCatalog] svc
			ON svc.[id] = m.[serviceCatalogId]
			AND svc.[companyId] = sp.[companyId]
        WHERE sp.[isMainService] = 0

		PRINT '     serviceSubPosition filled'

		CREATE CLUSTERED INDEX [x_serviceMainPositionId] ON [mig].[serviceMainPosition]([servicePositionId] ASC )
		CREATE NONCLUSTERED INDEX [x_serviceMainPositionCodes] ON [mig].[serviceMainPosition]([mainCodeId] ASC ,[turnusId] ASC,[serviceCatalogId] ASC )

		CREATE CLUSTERED INDEX [x_serviceSubPositionId] ON [mig].[serviceSubPosition]([servicePositionId] ASC )
		CREATE NONCLUSTERED INDEX [x_serviceSubPositionParentId] ON [mig].[serviceSubPosition]([parentId] ASC )
		CREATE NONCLUSTERED INDEX [x_serviceSubPositionCodes] ON [mig].[serviceSubPosition]([mainCodeId] ASC ,[turnusId] ASC,[serviceCatalogId] ASC )

		PRINT '     indexe filled'

        UPDATE T1
        SET T1.[parentId] = T2.[servicePositionId]
        FROM [mig].[serviceSubPosition] T1
        INNER JOIN [mig].[serviceMainPosition] T2
            ON T1.[mainCodeId] = T2.[mainCodeId]
            AND T1.[turnusId] = t2.[turnusId]
            AND T1.[serviceCatalogId] = T2.[serviceCatalogId]

		PRINT '     parentId updated'

        UPDATE T1
        SET T1.[servicePositionId] = T2.[parentId]
        FROM [dlm].[servicePosition] T1
        INNER JOIN [mig].[serviceSubPosition] T2
            ON T1.[id] = T2.[servicePositionId]    
		WHERE T1.[servicePositionId] IS NULL			
                
        SET @rowCount = @@ROWCOUNT

        PRINT '      servicePositionId updated' + CAST(@rowcount AS NVARCHAR) + ' records'


    END -- fill parent Id for subPosition

END
GO