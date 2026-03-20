DECLARE @truckId INT
SELECT @truckId = [id] FROM [std].[company] WHERE [code] = N'DTAG'

DELETE FROM [dlm].[billPosition] 
WHERE [serviceOrderPositionId] IN (
    SELECT [id] FROM [dlm].[serviceOrderPosition]
    WHERE [priceCatalogCalculationPositionId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculationPosition] 
        WHERE [priceCatalogPositionId] IN (
            SELECT [id] FROM [dlm].[priceCatalogPosition]
            WHERE [siteCatalogPositionId] IN (
                SELECT [id] FROM [dlm].[siteCatalogPosition]
                WHERE [servicePositionId] IN (
                    SELECT [id] FROM [dlm].[servicePosition] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)
DELETE FROM [dlm].[serviceExecution] 
WHERE [mapServiceOrderPositionServiceObjectId] IN (
    SELECT [id] FROM [dlm].[mapServiceOrderPositionServiceObject]
    WHERE [serviceOrderPositionId] IN (
        SELECT [id] FROM [dlm].[serviceOrderPosition]
        WHERE [priceCatalogCalculationPositionId] IN (
            SELECT [id] FROM [dlm].[priceCatalogCalculationPosition] 
            WHERE [priceCatalogPositionId] IN (
                SELECT [id] FROM [dlm].[priceCatalogPosition]
                WHERE [siteCatalogPositionId] IN (
                    SELECT [id] FROM [dlm].[siteCatalogPosition]
                    WHERE [servicePositionId] IN (
                        SELECT [id] FROM [dlm].[servicePosition] 
                        WHERE [companyId] = @truckId
                    )
                )
            )
        )
    )
)
DELETE FROM [dlm].[mapServiceOrderPositionServiceObject]
WHERE [serviceOrderPositionId] IN (
    SELECT [id] FROM [dlm].[serviceOrderPosition]
    WHERE [priceCatalogCalculationPositionId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculationPosition] 
        WHERE [priceCatalogPositionId] IN (
            SELECT [id] FROM [dlm].[priceCatalogPosition]
            WHERE [siteCatalogPositionId] IN (
                SELECT [id] FROM [dlm].[siteCatalogPosition]
                WHERE [servicePositionId] IN (
                    SELECT [id] FROM [dlm].[servicePosition] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)

DELETE FROM [dlm].[serviceOrderPosition]
WHERE [priceCatalogCalculationPositionId] IN (
    SELECT [id] FROM [dlm].[priceCatalogCalculationPosition] 
    WHERE [priceCatalogPositionId] IN (
        SELECT [id] FROM [dlm].[priceCatalogPosition]
        WHERE [siteCatalogPositionId] IN (
            SELECT [id] FROM [dlm].[siteCatalogPosition]
            WHERE [servicePositionId] IN (
                SELECT [id] FROM [dlm].[servicePosition] 
                WHERE [companyId] = @truckId
            )
        )
    )
)
DELETE FROM [dlm].[priceCatalogCalculationPosition] 
WHERE [priceCatalogPositionId] IN (
    SELECT [id] FROM [dlm].[priceCatalogPosition]
    WHERE [siteCatalogPositionId] IN (
        SELECT [id] FROM [dlm].[siteCatalogPosition]
        WHERE [servicePositionId] IN (
            SELECT [id] FROM [dlm].[servicePosition] 
            WHERE [companyId] = @truckId
        )
    )
)
DELETE FROM [dlm].[priceCatalogPosition]
WHERE [siteCatalogPositionId] IN (
    SELECT [id] FROM [dlm].[siteCatalogPosition]
    WHERE [servicePositionId] IN (
        SELECT [id] FROM [dlm].[servicePosition] 
        WHERE [companyId] = @truckId
    )
)
DELETE FROM [dlm].[mapSiteCatalogPositionServiceObject]
WHERE [siteCatalogPositionId] IN (
    SELECT [id] FROM [dlm].[siteCatalogPosition]
    WHERE [servicePositionId] IN (
        SELECT [id] FROM [dlm].[servicePosition] 
        WHERE [companyId] = @truckId
    )
)
DELETE FROM [dlm].[mapSiteCatalogPositionExecutionDay]
WHERE [siteCatalogPositionId] IN (
    SELECT [id] FROM [dlm].[siteCatalogPosition]
    WHERE [servicePositionId] IN (
        SELECT [id] FROM [dlm].[servicePosition] 
        WHERE [companyId] = @truckId
    )
)
DELETE FROM [dlm].[siteCatalogPosition]
WHERE [servicePositionId] IN (
    SELECT [id] FROM [dlm].[servicePosition] 
    WHERE [companyId] = @truckId
)
DELETE FROM [dlm].[mapServiceCatalogServicePosition]
WHERE [servicePositionId] IN (
    SELECT [id] FROM [dlm].[servicePosition]
    WHERE [companyId] = @truckId
)
DELETE FROM [dlm].[mapServicePositionUsageType]
WHERE [servicePositionId] IN (
    SELECT [id] FROM [dlm].[servicePosition]
    WHERE [companyId] = @truckId
)
DELETE FROM [dlm].[servicePosition] 
WHERE [companyId] = @truckId

DELETE FROM [dlm].[mapBillBillStatus]
WHERE [billId] IN (
    SELECT [id] FROM [dlm].[bill] 
    WHERE [serviceOrderId] IN (
        SELECT [id] FROM [dlm].[serviceOrder]
        WHERE [priceCatalogCalculationId] IN (
            SELECT [id] FROM [dlm].[priceCatalogCalculation] 
            WHERE [priceCatalogId] IN (
                SELECT [id] FROM [dlm].[priceCatalog]
                WHERE [siteCatalogId] IN (
                    SELECT [id] FROM [dlm].[siteCatalog]
                    WHERE [serviceCatalogId] IN (
                        SELECT [id] FROM [dlm].[serviceCatalog] 
                        WHERE [companyId] = @truckId
                    )
                )
            )
        )
    )
)
DELETE FROM [dlm].[mapBillAttachedDocument]
WHERE [billId] IN (
    SELECT [id] FROM [dlm].[bill] 
    WHERE [serviceOrderId] IN (
        SELECT [id] FROM [dlm].[serviceOrder]
        WHERE [priceCatalogCalculationId] IN (
            SELECT [id] FROM [dlm].[priceCatalogCalculation] 
            WHERE [priceCatalogId] IN (
                SELECT [id] FROM [dlm].[priceCatalog]
                WHERE [siteCatalogId] IN (
                    SELECT [id] FROM [dlm].[siteCatalog]
                    WHERE [serviceCatalogId] IN (
                        SELECT [id] FROM [dlm].[serviceCatalog] 
                        WHERE [companyId] = @truckId
                    )
                )
            )
        )
    )
)
DELETE FROM [dlm].[bill] 
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)
DELETE FROM [dlm].[mapServiceOrderAttachedDocument]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)
DELETE FROM [dlm].[mapServiceOrderClient]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)
DELETE FROM [dlm].[mapServiceOrderLocation]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)
DELETE FROM [dlm].[mapServiceOrderAttachedDocument]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)
DELETE FROM [dlm].[mapServiceOrderSapOrder]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)
DELETE FROM [dlm].[serviceOrderCalendar]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = @truckId
                )
            )
        )
    )
)
DELETE FROM [dlm].[serviceOrder]
WHERE [priceCatalogCalculationId] IN (
    SELECT [id] FROM [dlm].[priceCatalogCalculation] 
    WHERE [priceCatalogId] IN (
        SELECT [id] FROM [dlm].[priceCatalog]
        WHERE [siteCatalogId] IN (
            SELECT [id] FROM [dlm].[siteCatalog]
            WHERE [serviceCatalogId] IN (
                SELECT [id] FROM [dlm].[serviceCatalog] 
                WHERE [companyId] = @truckId
            )
        )
    )
)
DELETE FROM [dlm].[priceCatalogCalculation] 
WHERE [priceCatalogId] IN (
    SELECT [id] FROM [dlm].[priceCatalog]
    WHERE [siteCatalogId] IN (
        SELECT [id] FROM [dlm].[siteCatalog]
        WHERE [serviceCatalogId] IN (
            SELECT [id] FROM [dlm].[serviceCatalog] 
            WHERE [companyId] = @truckId
        )
    )
)
DELETE FROM [dlm].[mapPriceCatalogAdditionalShift]
WHERE [priceCatalogId] IN (
    SELECT [id] FROM [dlm].[priceCatalog]
    WHERE [siteCatalogId] IN (
        SELECT [id] FROM [dlm].[siteCatalog]
        WHERE [serviceCatalogId] IN (
            SELECT [id] FROM [dlm].[serviceCatalog] 
            WHERE [companyId] = @truckId
        )
    )
)
DELETE FROM [dlm].[mapPriceCatalogAttachedDocument]
WHERE [priceCatalogId] IN (
    SELECT [id] FROM [dlm].[priceCatalog]
    WHERE [siteCatalogId] IN (
        SELECT [id] FROM [dlm].[siteCatalog]
        WHERE [serviceCatalogId] IN (
            SELECT [id] FROM [dlm].[serviceCatalog] 
            WHERE [companyId] = @truckId
        )
    )
)
DELETE FROM [dlm].[mapPriceCatalogClient]
WHERE [priceCatalogId] IN (
    SELECT [id] FROM [dlm].[priceCatalog]
    WHERE [siteCatalogId] IN (
        SELECT [id] FROM [dlm].[siteCatalog]
        WHERE [serviceCatalogId] IN (
            SELECT [id] FROM [dlm].[serviceCatalog] 
            WHERE [companyId] = @truckId
        )
    )
)

DELETE FROM [dlm].[priceCatalog]
WHERE [siteCatalogId] IN (
    SELECT [id] FROM [dlm].[siteCatalog]
    WHERE [serviceCatalogId] IN (
        SELECT [id] FROM [dlm].[serviceCatalog] 
        WHERE [companyId] = @truckId
    )
)
DELETE FROM [dlm].[mapSiteCatalogClient]
WHERE [siteCatalogId] IN (
    SELECT [id] FROM [dlm].[siteCatalog]
    WHERE [serviceCatalogId] IN (
        SELECT [id] FROM [dlm].[serviceCatalog] 
        WHERE [companyId] = @truckId
    )
)
DELETE FROM [dlm].[mapSiteCatalogPlant]
WHERE [siteCatalogId] IN (
    SELECT [id] FROM [dlm].[siteCatalog]
    WHERE [serviceCatalogId] IN (
        SELECT [id] FROM [dlm].[serviceCatalog] 
        WHERE [companyId] = @truckId
    )
)
DELETE FROM [dlm].[mapSiteCatalogSite]
WHERE [siteCatalogId] IN (
    SELECT [id] FROM [dlm].[siteCatalog]
    WHERE [serviceCatalogId] IN (
        SELECT [id] FROM [dlm].[serviceCatalog] 
        WHERE [companyId] = @truckId
    )
)
DELETE FROM [dlm].[siteCatalog]
WHERE [serviceCatalogId] IN (
    SELECT [id] FROM [dlm].[serviceCatalog] 
    WHERE [companyId] = @truckId
)
DELETE FROM [dlm].[mapServiceCatalogServicePosition]
WHERE [serviceCatalogId] IN (
    SELECT [id] FROM [dlm].[serviceCatalog]
    WHERE [companyId] = @truckId
)
DELETE FROM [dlm].[serviceCatalog] 
WHERE [companyId] = @truckId

DELETE FROM [dlm].[supplier]
WHERE [companyId] = @truckId

DELETE FROM [std].[company]
WHERE [id] = @truckId

SELECT @truckId = [id] FROM [archiv].[dbo_company] WHERE [Code] = N'DTAG'

DELETE FROM [dlm].[sapOrder]
WHERE [id] IN (
    SELECT [dlm3Id] FROM [mig].[mapPurchaseOrderSapOrder]
    WHERE [dlm2Id] IN (
        SELECT [id] FROM [archiv].[dbo_PurchaseOrder]
        WHERE [CompanyId] = @truckId
    )
)

DELETE FROM [archiv].[dbo_SspCompany] WHERE [CompanyId] = @truckId
DELETE FROM [archiv].[dbo_SspRelease] WHERE [CompanyId] = @truckId
DELETE FROM [archiv].[dbo_Supplier] WHERE [CompanyId] = @truckId
DELETE FROM [archiv].[dbo_UserCompany] WHERE [CompanyId] = @truckId
DELETE FROM [archiv].[dbo_KPIAreaHistory] WHERE [CompanyId] = @truckId
DELETE FROM [archiv].[dbo_KPIBillHistory] WHERE [CompanyId] = @truckId
DELETE FROM [archiv].[dbo_KPIReportHistory] WHERE [CompanyId] = @truckId
DELETE FROM [archiv].[dbo_PurchaseOrder] WHERE [CompanyId] = @truckId
DELETE FROM [archiv].[dbo_SscCompany] WHERE [CompanyId] = @truckId
