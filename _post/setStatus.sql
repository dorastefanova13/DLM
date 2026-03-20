
BEGIN --set Status

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '    set Status'
    PRINT @msg

    DECLARE @rowCount INT
    DECLARE @statusId INT

    BEGIN --priceCatalogStatus READY

        SET @msg = '      priceCatalogStatus READY'
        PRINT @msg

        SELECT @statusId = [id] FROM [std].[priceCatalogStatus] WHERE [code] = N'READY'

        UPDATE [dlm].[priceCatalog] SET [priceCatalogStatusId] = @statusId

        SET @rowCount = @@ROWCOUNT
        SET @msg = '        ' + CAST(@rowCount AS NVARCHAR) + ' records'
        PRINT @msg

    END
    BEGIN --priceCatalogStatus TENDER

        SET @msg = '      priceCatalogStatus TENDER'
        PRINT @msg

        SELECT @statusId = [id] FROM [std].[priceCatalogStatus] WHERE [code] = N'TENDER'

        UPDATE [dlm].[priceCatalog] SET [priceCatalogStatusId] = @statusId WHERE [tenderName] IS NOT NULL

        SET @rowCount = @@ROWCOUNT
        SET @msg = '        ' + CAST(@rowCount AS NVARCHAR) + ' records'
        PRINT @msg

    END
    BEGIN --tenderStatus OPEN

        SET @msg = '      tenderStatus OPEN'
        PRINT @msg

        SELECT @statusId = [id] FROM [std].[tenderStatus] WHERE [code] = N'OPEN'

        UPDATE [dlm].[priceCatalog] SET [tenderStatusId] = @statusId 
        WHERE [tenderName] IS NOT NULL

        SET @rowCount = @@ROWCOUNT
        SET @msg = '        ' + CAST(@rowCount AS NVARCHAR) + ' records'
        PRINT @msg

    END
    BEGIN --tenderStatus INPROGRESS

        SET @msg = '      tenderStatus INPROGRESS'
        PRINT @msg

        SELECT @statusId = [id] FROM [std].[tenderStatus] WHERE [code] = N'INPROGRESS'

        UPDATE [dlm].[priceCatalog] SET [tenderStatusId] = @statusId 
        WHERE [tenderName] IS NOT NULL
        AND [id] IN (
            SELECT [priceCatalogId] FROM [dlm].[priceCatalogCalculation]
        )

        SET @rowCount = @@ROWCOUNT
        SET @msg = '        ' + CAST(@rowCount AS NVARCHAR) + ' records'
        PRINT @msg

    END
    BEGIN --tenderStatus AWARDED

        SET @msg = '      tenderStatus AWARDED'
        PRINT @msg

        SELECT @statusId = [id] FROM [std].[tenderStatus] WHERE [code] = N'AWARDED'

        UPDATE [dlm].[priceCatalog] SET [tenderStatusId] = @statusId 
        WHERE [tenderName] IS NOT NULL
        AND [id] IN (
            SELECT [priceCatalogId] 
            FROM [dlm].[priceCatalogCalculation]
            WHERE [priceCatalogCalculationStatusId] IN (
                SELECT [id] FROM [std].[priceCatalogCalculationStatus] WHERE [code] = N'AWARDED'
            )

        )

        SET @rowCount = @@ROWCOUNT
        SET @msg = '        ' + CAST(@rowCount AS NVARCHAR) + ' records'
        PRINT @msg

    END

END
GO

