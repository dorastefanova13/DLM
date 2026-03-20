BEGIN --priceCatalogPosition

    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '    fill priceCatalogPosition'
    PRINT @msg

    DECLARE @rowCount INT

    DELETE FROM [dlm].[priceCatalogPosition]

    BEGIN TRY

        BEGIN --priceCatalogPosition LV

            SET @msg = '    fill priceCatalogPosition LV'
            PRINT @msg

            DROP TABLE IF EXISTS [mig].[mapSspItemPriceCatalogPosition]
            CREATE TABLE [mig].[mapSspItemPriceCatalogPosition] (dlm2Id INT, dlm3Id INT)

            MERGE INTO [dlm].[priceCatalogPosition] AS t
            USING (
                SELECT 
                    scp.[id] AS [siteCatalogPositionId]
                    ,pc.[id] AS [priceCatalogId]
                    ,pc.[periodFrom]
                    ,pc.[periodUntil]
                    ,0 AS [IsDeleted]
                    ,1 AS [isLegacy]
                    ,mSSCP.[dlm2Id]
                FROM [dlm].[siteCatalogPosition] scp
                INNER JOIN [dlm].[siteCatalog] sc
                    ON sc.[id] = scp.[siteCatalogId]
                INNER JOIN [dlm].[priceCatalog] pc
                    ON pc.[siteCatalogId] = sc.[id]
                INNER JOIN [mig].[mapSspitemSiteCatalogPosition] mSSCP
                    ON mSSCP.[dlm3Id] = scp.[id]
            ) AS s
            ON s.[siteCatalogPositionId] = t.[siteCatalogPositionId]
            AND s.[priceCatalogId] = t.[priceCatalogId]
            WHEN NOT MATCHED THEN
                INSERT ([siteCatalogPositionId],[priceCatalogId],[periodFrom],[periodUntil],[isDeleted],[isLegacy])
                VALUES (s.[siteCatalogPositionId],s.[priceCatalogId],s.[periodFrom],s.[periodUntil],s.[isDeleted],s.[isLegacy])
            OUTPUT s.[dlm2id],inserted.[id]
            INTO [mig].[mapSspItemPriceCatalogPosition]([dlm2Id],[dlm3Id]);

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'
            
        END --priceCatalogPosition LV

        BEGIN --priceCatalogPosition EPK

            SET @msg = '    fill priceCatalogPosition EPK'
            PRINT @msg

            DROP TABLE IF EXISTS [mig].[mapSscItemPriceCatalogPosition]
            CREATE TABLE [mig].[mapSscItemPriceCatalogPosition] (dlm2Id INT, dlm3Id INT)

            MERGE INTO [dlm].[priceCatalogPosition] AS t
            USING (
                SELECT 
                    scp.[id] AS [siteCatalogPositionId]
                    ,pc.[id] AS [priceCatalogId]
                    ,pc.[periodFrom]
                    ,pc.[periodUntil]
                    ,0 AS [IsDeleted]
                    ,1 AS [isLegacy]
                    ,mSSCP.[dlm2Id]
                FROM [dlm].[siteCatalogPosition] scp
                INNER JOIN [dlm].[siteCatalog] sc
                    ON sc.[id] = scp.[siteCatalogId]
                INNER JOIN [dlm].[priceCatalog] pc
                    ON pc.[siteCatalogId] = sc.[id]
                INNER JOIN [mig].[mapSscitemSiteCatalogPosition] mSSCP
                    ON mSSCP.[dlm3Id] = scp.[id]
            ) AS s
            ON s.[siteCatalogPositionId] = t.[siteCatalogPositionId]
            AND s.[priceCatalogId] = t.[priceCatalogId]
            WHEN NOT MATCHED THEN
                INSERT ([siteCatalogPositionId],[priceCatalogId],[periodFrom],[periodUntil],[isDeleted],[isLegacy])
                VALUES (s.[siteCatalogPositionId],s.[priceCatalogId],s.[periodFrom],s.[periodUntil],s.[isDeleted],s.[isLegacy])
            OUTPUT s.[dlm2id],inserted.[id]
            INTO [mig].[mapSscItemPriceCatalogPosition]([dlm2Id],[dlm3Id]);

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'
            
        END --priceCatalogPosition EPK

        BEGIN --set Audit columns

            SET @msg = '   set Audit columns'
            PRINT @msg

			UPDATE [dlm].[priceCatalogPosition] SET [insertedAt] = GETDATE(),[insertedBy] = 1

			SET @rowCount = @@ROWCOUNT

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		END --set Audit columns

    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' priceCatalogPosition.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
