BEGIN --priceCatalog

    --TODO periodFrom and periodUntil
    
    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '    fill priceCatalog'
    PRINT @msg

    DECLARE @rowCount INT
    DECLARE @mapCount INT

	DECLARE 
		@id INT
		,@dlm2Id INT
		,@name NVARCHAR(200)
		,@description NVARCHAR(4000)
		,@periodFrom DATE
		,@periodUntil DATE
		,@siteCatalogId INT

    BEGIN TRY

        DELETE FROM [dlm].[priceCatalog]

        DECLARE @priceCatalogStatusReadyId INT = (SELECT [id] FROM [std].[priceCatalogStatus] WHERE [name] = N'READY')

        BEGIN --fill priceCatalog for LVs (SubLVs)

            SET @msg = '   fill priceCatalog for LVs (SubLVs)'
            PRINT @msg

            DROP TABLE IF EXISTS [mig].[mapServiceSpecificationPriceCatalog]
            CREATE TABLE [mig].[mapServiceSpecificationPriceCatalog] (dlm2Id INT, dlm3Id INT)

			DECLARE cMig CURSOR FOR
				SELECT      
					SUBSTRING(N'Price Catalog for SiteCatalog ' + [name],1,200) AS [name]
					,N'Price Catalog for SiteCatalog ' + [description] AS [description]
					,CONVERT(DATE,'20100101',112) AS [periodFrom]
					,CONVERT(DATE,'20301231',112) AS [periodUntil]
					,[id] AS [siteCatalogId]
					,mSSSC.[dlm2Id] AS [dlm2Id]
				FROM [dlm].[siteCatalog] sc
				INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC
					ON mSSSC.[dlm3Id] = sc.[id]
				WHERE mSSSC.[dlm2Id] IN
				(
					SELECT [id]
					FROM [archiv].[dbo_ServiceSpecification]
					WHERE [isGlobal] = 0
					AND ISNULL([MainSspId],0) = 0
					AND ISNULL([IsFrozen],0) = 1
					--AND [isActive] = 1
					--TODO keine LVs aus Globalen LVs erstellt?
					--AND ISNULL([GlobalSspId],0) = 0
				)

			SET @rowCount = 0
			SET @mapCount = 0

			OPEN cMig
			FETCH NEXT FROM cMig INTO @name,@description,@periodFrom,@periodUntil,@siteCatalogId,@dlm2Id
			WHILE @@FETCH_STATUS = 0
			BEGIN

				INSERT INTO [dlm].[priceCatalog]
                   ([name]
                   ,[description]
                   ,[periodFrom]
                   ,[periodUntil]
                   ,[priceCatalogStatusId]
                   ,[siteCatalogId]
                   ,[isSupplementForId]
                   ,[isDeleted]
                   ,[isLegacy])
				SELECT @name,@description,@periodFrom,@periodUntil,@priceCatalogStatusReadyId,@siteCatalogId,NULL,0,1

				SET @rowCount = @rowCount + 1

				SET @id = @@IDENTITY

				INSERT INTO [mig].[mapServiceSpecificationPriceCatalog] (dlm3Id,dlm2Id)
				SELECT @id,@dlm2Id

				SET @mapCount = @mapCount + 1

				FETCH NEXT FROM cMig INTO @name,@description,@periodFrom,@periodUntil,@siteCatalogId,@dlm2Id

			END
			CLOSE cMig
			DEALLOCATE cMig

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

        END --fill priceCatalog for LVs (SubLVs)

        BEGIN --fill priceCatalog for EPKs

            --TODO 0 records f EPK

            SET @msg = '   fill priceCatalog for EPKs'
            PRINT @msg

            DROP TABLE IF EXISTS [mig].[mapStandardServicesCatalogPriceCatalog]
            CREATE TABLE [mig].[mapStandardServicesCatalogPriceCatalog] (dlm2Id INT, dlm3Id INT)

            DECLARE cMig CURSOR FOR
				SELECT      
					SUBSTRING(N'Price Catalog for ' + [name],1,200) AS [name]
					,N'Price Catalog for ' + [description] AS [description]
					,CONVERT(DATE,'20100101',112) AS [periodFrom]
					,CONVERT(DATE,'20301231',112) AS [periodUntil]
					,[id] AS [siteCatalogId]
					,mSSCSC.[dlm2Id] AS [dlm2Id]
				FROM [dlm].[siteCatalog] sc
				INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSCSC
					ON mSSCSC.[dlm3Id] = sc.[id]
				WHERE mSSCSC.[dlm2Id] IN
				(
					SELECT [id]
					FROM [archiv].[dbo_StandardServicesCatalog]
					WHERE ISNULL([IsFrozen],0) = 1
                    --AND ISNULL([isActive],0) = 1
					--TODO keine EPKs aus Globalen EPKs erstellt?
					--AND ISNULL([isGlobal],0) = 0
                
				)
			SET @rowCount = 0
			SET @mapCount = 0

			OPEN cMig
			FETCH NEXT FROM cMig INTO @name,@description,@periodFrom,@periodUntil,@siteCatalogId,@dlm2Id
			WHILE @@FETCH_STATUS = 0
			BEGIN

				INSERT INTO [dlm].[priceCatalog]
                   ([name]
                   ,[description]
                   ,[periodFrom]
                   ,[periodUntil]
                   ,[priceCatalogStatusId]
                   ,[siteCatalogId]
                   ,[isSupplementForId]
                   ,[isDeleted]
                   ,[isLegacy])
				SELECT @name,@description,@periodFrom,@periodUntil,@priceCatalogStatusReadyId,@siteCatalogId,NULL,0,1

				SET @rowCount = @rowCount + 1

				SET @id = @@IDENTITY

				INSERT INTO [mig].[mapStandardServicesCatalogPriceCatalog] (dlm3Id,dlm2Id)
				SELECT @id,@dlm2Id

				SET @mapCount = @mapCount + 1

				FETCH NEXT FROM cMig INTO @name,@description,@periodFrom,@periodUntil,@siteCatalogId,@dlm2Id

			END
			CLOSE cMig
			DEALLOCATE cMig

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

        END --fill priceCatalog for EPKs

        BEGIN --set Audit columns

            SET @msg = '   set Audit columns'
            PRINT @msg

			UPDATE [dlm].[priceCatalog] SET [insertedAt] = GETDATE(),[insertedBy] = 1

			SET @rowCount = @@ROWCOUNT

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		END --set Audit columns

    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' priceCatalog.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
