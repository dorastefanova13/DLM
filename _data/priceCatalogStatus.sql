BEGIN --priceCatalogStatus

    PRINT '    fill priceCatalogStatus'

    DELETE FROM  [std].[priceCatalogStatus]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[priceCatalogStatus] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[priceCatalogStatus]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,N'n/a',N'keine Zuordnung',N'keine Zuordnung',0,GETDATE(),1

	INSERT INTO [std].[priceCatalogStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 1,N'CREATED',N'erstellt',N'PriceCatalog erstellt',0,GETDATE(),1
    INSERT INTO [std].[priceCatalogStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 2,N'READY',N'Bereit zur Ausschreibung',N'PriceCatalog fertig zur Ausschreibung',0,GETDATE(),1
	INSERT INTO [std].[priceCatalogStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 3,N'TENDER',N'Ausschreibung',N'PriceCatalog ausgeschrieben',0,GETDATE(),1
    INSERT INTO [std].[priceCatalogStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 4,N'CONTRACT',N'Vertrag',N'Ausschreibung angenommen',0,GETDATE(),1

	SET IDENTITY_INSERT [std].[priceCatalogStatus] OFF    

END --priceCatalogStatus
GO
