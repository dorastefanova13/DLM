BEGIN --priceCatalogCalculationStatus

    PRINT '    fill priceCatalogCalculationStatus'

    --DELETE FROM [std].[priceCatalogCalculationStatus]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[priceCatalogCalculationStatus] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

	MERGE INTO [std].[priceCatalogCalculationStatus] AS t
	USING
	(
	    SELECT 0 AS [id],N'n/a' AS [code] ,N'keine Zuordnung' AS [name] ,N'keine Zuordnung' AS [description],0 AS [isDeleted]
		UNION ALL SELECT 1,N'OPEN',N'erstellt',N'Preisafrage ist erstellt',0
		UNION ALL SELECT 2,N'INPROGRESS',N'in Bearbeitung',N'Preisanfrage wird bearbeitet',0
		UNION ALL SELECT 3,N'AWARDED', N'angenommen',N'mit dem Dienstleister wurde ein Vertrag geschlossen',0
		UNION ALL SELECT 4,N'DECLINED', N'kein Vertrag',N'Angebot des Dienstleisters aurde abgelehnt',0
		UNION ALL SELECT 6,N'DELETED',N'gelöscht',N'Preisanfrage wurde gelöscht',0
	) AS s
	ON t.[code] = s.[code]
	WHEN NOT MATCHED THEN
		INSERT ([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) 
		VALUES (s.[id],s.[code],s.[description],s.[name],s.[isDeleted],GETDATE(),1) 
	;

    SET IDENTITY_INSERT [std].[priceCatalogCalculationStatus] OFF 

END --priceCatalogCalculationStatus
GO
