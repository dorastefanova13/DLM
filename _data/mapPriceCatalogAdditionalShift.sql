BEGIN --mapPriceCatalogAddidtionalShift

    PRINT '    fill mapPriceCatalogAddidtionalShift'

    DECLARE @additionalShiftIdSA INT = (SELECT [id] FROM [std].[additionalShift] WHERE [code] = 'SA')
    DECLARE @rowCount INT

    INSERT INTO [dlm].[mapPriceCatalogAdditionalShift] ([priceCatalogId],[additionalShiftId],[factor],[insertedAt],[insertedBy])
    SELECT 
        mSSPC.[dlm3Id],
        @additionalShiftIdSA,
        4.25 AS [factor],
		GETDATE(),
		1
    FROM [mig].[mapServiceSpecificationPriceCatalog] mSSPC
    WHERE mSSPC.[dlm2Id] IN (
        SELECT [sspId]
        FROM [archiv].[dbo_SspItem]
        WHERE [CycleCodeId] IN (
            SELECT [id]
            FROM [archiv].[dbo_Cycle]
            WHERE [isSaturday] = 1
        )
    )

    SET @rowCount = @@ROWCOUNT
    
    PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

END --mapPriceCatalogAddidtionalShift
GO