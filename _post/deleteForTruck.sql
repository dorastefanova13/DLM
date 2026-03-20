DECLARE @truckId INT
SELECT @truckId = [id] FROM [std].[company] WHERE [code] = N'DTAG'

--BILL
PRINT 'billPosition'
DELETE FROM [dlm].[billPosition] 
WHERE [BillId] IN (
	SELECT [id] FROM [dlm].[bill]
	WHERE [ServiceOrderId] IN (
		SELECT [id]
		FROM [dlm].[serviceOrder]
		WHERE [priceCatalogCalculationId] IN (
			SELECT [id] FROM [dlm].[priceCatalogCalculation] 
			WHERE [priceCatalogId] IN (
				SELECT [id] FROM [dlm].[priceCatalog]
				WHERE [siteCatalogId] IN (
					SELECT [id] FROM [dlm].[siteCatalog]
					WHERE [serviceCatalogId] NOT IN (
						SELECT [id] FROM [dlm].[serviceCatalog] 
						WHERE [companyId] = 2 --@truckId
					)
				)
			)
		)
	)
)
PRINT 'mapBillBillStatus'
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
                    WHERE [serviceCatalogId] NOT IN (
                        SELECT [id] FROM [dlm].[serviceCatalog] 
                        WHERE [companyId] = 2 --@truckId
                    )
                )
            )
        )
    )
)
PRINT 'mapBillAttachedDocument'
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
                    WHERE [serviceCatalogId] NOT IN (
                        SELECT [id] FROM [dlm].[serviceCatalog] 
                        WHERE [companyId] = 2 --@truckId
                    )
                )
            )
        )
    )
)
PRINT 'bill'
DELETE FROM [dlm].[bill] 
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] NOT IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = 2 --@truckId
                )
            )
        )
    )
)
--SERVICERORDER
PRINT 'serviceExecution'
DELETE FROM [dlm].[serviceExecution] 
WHERE [mapServiceOrderPositionServiceObjectId] IN (
    SELECT [id] FROM [dlm].[mapServiceOrderPositionServiceObject]
    WHERE [serviceOrderPositionId] IN (
		SELECT [id] FROM [dlm].[serviceOrderPosition]
		WHERE [ServiceOrderId] IN (
			SELECT [id]
			FROM [dlm].[serviceOrder]
			WHERE [priceCatalogCalculationId] IN (
				SELECT [id] FROM [dlm].[priceCatalogCalculation] 
				WHERE [priceCatalogId] IN (
					SELECT [id] FROM [dlm].[priceCatalog]
					WHERE [siteCatalogId] IN (
						SELECT [id] FROM [dlm].[siteCatalog]
						WHERE [serviceCatalogId] NOT IN (
							SELECT [id] FROM [dlm].[serviceCatalog] 
							WHERE [companyId] = 2 --@truckId
						)
					)
				)
			)
		)
	)
)
PRINT 'mapServiceOrderPositionServiceObject'
DELETE FROM [dlm].[mapServiceOrderPositionServiceObject]
WHERE [serviceOrderPositionId] IN (
    SELECT [id] FROM [dlm].[serviceOrderPosition]
	WHERE [ServiceOrderId] IN (
		SELECT [id]
		FROM [dlm].[serviceOrder]
		WHERE [priceCatalogCalculationId] IN (
			SELECT [id] FROM [dlm].[priceCatalogCalculation] 
			WHERE [priceCatalogId] IN (
				SELECT [id] FROM [dlm].[priceCatalog]
				WHERE [siteCatalogId] IN (
					SELECT [id] FROM [dlm].[siteCatalog]
					WHERE [serviceCatalogId] NOT IN (
						SELECT [id] FROM [dlm].[serviceCatalog] 
						WHERE [companyId] = 2 --@truckId
					)
				)
			)
		)
	)
)
PRINT 'serviceOrderPosition'
DELETE FROM [dlm].[serviceOrderPosition]
WHERE [ServiceOrderId] IN (
	SELECT [id]
	FROM [dlm].[serviceOrder]
	WHERE [priceCatalogCalculationId] IN (
		SELECT [id] FROM [dlm].[priceCatalogCalculation] 
		WHERE [priceCatalogId] IN (
			SELECT [id] FROM [dlm].[priceCatalog]
			WHERE [siteCatalogId] IN (
				SELECT [id] FROM [dlm].[siteCatalog]
				WHERE [serviceCatalogId] NOT IN (
					SELECT [id] FROM [dlm].[serviceCatalog] 
					WHERE [companyId] = 2 --@truckId
				)
			)
		)
	)
)
PRINT 'map ServiceOrderClient'
DELETE FROM [dlm].[mapServiceOrderClient]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] NOT IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = 2 --@truckId
                )
            )
        )
    )
)
PRINT 'mapServiceOrderLocation'
DELETE FROM [dlm].[mapServiceOrderLocation]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] NOT IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = 2 --@truckId
                )
            )
        )
    )
)
PRINT 'mapServiceOrderAttachedDocument'
DELETE FROM [dlm].[mapServiceOrderAttachedDocument]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] NOT IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = 2 --@truckId
                )
            )
        )
    )
)
PRINT 'mapServiceOrderSapOrder'
DELETE FROM [dlm].[mapServiceOrderSapOrder]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] NOT IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = 2 --@truckId
                )
            )
        )
    )
)
PRINT 'serviceOrderCalendar'
DELETE FROM [dlm].[serviceOrderCalendar]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] NOT IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = 2 --@truckId
                )
            )
        )
    )
)
PRINT 'serviceOrder'
DELETE FROM [dlm].[serviceOrder]
WHERE [priceCatalogCalculationId] IN (
    SELECT [id] FROM [dlm].[priceCatalogCalculation] 
    WHERE [priceCatalogId] IN (
        SELECT [id] FROM [dlm].[priceCatalog]
        WHERE [siteCatalogId] IN (
            SELECT [id] FROM [dlm].[siteCatalog]
            WHERE [serviceCatalogId] NOT IN (
                SELECT [id] FROM [dlm].[serviceCatalog] 
                WHERE [companyId] = 2 --@truckId
            )
        )
    )
)
--PRICECATALOGCALCULAION
PRINT 'priceCatalogCalculationPosition'
--select * from dlm.serviceorderposition where priceCatalogCalculationPositionId in 
DELETE FROM [dlm].[priceCatalogCalculationPosition] 
--(select id from dlm.priceCatalogCalculationPosition
WHERE [priceCatalogCalculationId] IN (
	SELECT [id] FROM [dlm].[priceCatalogCalculation] 
	WHERE [priceCatalogId] IN (
		SELECT [id] FROM [dlm].[priceCatalog]
		WHERE [siteCatalogId] IN (
			SELECT [id] FROM [dlm].[siteCatalog]
			WHERE [serviceCatalogId] NOT IN (
				SELECT [id] FROM [dlm].[serviceCatalog] 
				WHERE [companyId] = 2--@truckId
			)
		)
	)
) and id = 27088735
) and priceCatalogCalculationPositionId = 27088935
select * from dlm.serviceOrderPosition where priceCatalogCalculationPositionId = 27088935

select * from dlm.priceCatalogCalculationPosition pccp
inner join dlm.priceCatalogCalculation pcc
	on pcc.id = pccp.priceCatalogCalculationId
inner join 
select * from dlm.serviceorder where id = 25039
select * from dlm.priceCatalogCalculation where id = 4249
select * from dlm.priceCatalog where id = 2078
select * from dlm.sitecatalog where id = 	 3333
select * from dlm.serviceCatalog where id = 150
PRINT 'priceCatalogPosition'
DELETE FROM [dlm].[priceCatalogPosition]
WHERE [priceCatalogId] IN (
	SELECT [id] FROM [dlm].[priceCatalog]
	WHERE [siteCatalogId] IN (
		SELECT [id] FROM [dlm].[siteCatalog]
		WHERE [serviceCatalogId] NOT IN (
			SELECT [id] FROM [dlm].[serviceCatalog] 
			WHERE [companyId] = 2 --@truckId
		)
	)
)

PRINT 'mapSiteCatalogPositionServiceObject'
DELETE FROM [dlm].[mapSiteCatalogPositionServiceObject]
WHERE [siteCatalogPositionId] IN (
    SELECT [id] FROM [dlm].[siteCatalogPosition]
    WHERE [servicePositionId] NOT IN (
        SELECT [id] FROM [dlm].[servicePosition] 
        WHERE [companyId] = 2 --@truckId
    )
)
PRINT 'mapSiteCatalogPositionExecutionDay'
DELETE FROM [dlm].[mapSiteCatalogPositionExecutionDay]
WHERE [siteCatalogPositionId] IN (
    SELECT [id] FROM [dlm].[siteCatalogPosition]
    WHERE [servicePositionId] NOT IN (
        SELECT [id] FROM [dlm].[servicePosition] 
        WHERE [companyId] = 2 --@truckId
    )
)
PRINT 'siteCatalogPosition'
DELETE FROM [dlm].[siteCatalogPosition]
WHERE [siteCatalogId] IN (
	SELECT [id]
	FROM [dlm].[siteCatalog]
	WHERE [serviceCatalogId] NOT IN (
		SELECT [id] FROM [dlm].[serviceCatalog] 
		WHERE [companyId] = 2 --@truckId
	)
)
PRINT 'mapServiceCatalogServicePosition'
DELETE FROM [dlm].[mapServiceCatalogServicePosition]
WHERE [servicePositionId] NOT IN (
    SELECT [id] FROM [dlm].[servicePosition]
    WHERE [companyId] = 2 --@truckId
)
OR [serviceCatalogId] IN (
	SELECT [id]
	FROM [dlm].[serviceCatalog]
	WHERE [companyId] <> @truckId
)
PRINT 'mapServicePositionUsageType'
DELETE FROM [dlm].[mapServicePositionUsageType]
WHERE [servicePositionId] NOT IN (
    SELECT [id] FROM [dlm].[servicePosition]
    WHERE [companyId] = 2 --@truckId
)
PRINT 'servicePosition'
DELETE FROM [dlm].[servicePosition] 
WHERE [companyId] <> @truckId
PRINT 'mapServiceOrderAttachedDocument'
DELETE FROM [dlm].[mapServiceOrderAttachedDocument]
WHERE [serviceOrderId] IN (
    SELECT [id] FROM [dlm].[serviceOrder]
    WHERE [priceCatalogCalculationId] IN (
        SELECT [id] FROM [dlm].[priceCatalogCalculation] 
        WHERE [priceCatalogId] IN (
            SELECT [id] FROM [dlm].[priceCatalog]
            WHERE [siteCatalogId] IN (
                SELECT [id] FROM [dlm].[siteCatalog]
                WHERE [serviceCatalogId] NOT IN (
                    SELECT [id] FROM [dlm].[serviceCatalog] 
                    WHERE [companyId] = 2 --@truckId
                )
            )
        )
    )
)
PRINT 'priceCatalogCalculation'
DELETE FROM [dlm].[priceCatalogCalculation] 
WHERE [priceCatalogId] IN (
    SELECT [id] FROM [dlm].[priceCatalog]
    WHERE [siteCatalogId] IN (
        SELECT [id] FROM [dlm].[siteCatalog]
        WHERE [serviceCatalogId] NOT IN (
            SELECT [id] FROM [dlm].[serviceCatalog] 
            WHERE [companyId] = 2 --@truckId
        )
    )
)
PRINT 'mapPriceCatalogAdditionalShift'
DELETE FROM [dlm].[mapPriceCatalogAdditionalShift]
WHERE [priceCatalogId] IN (
    SELECT [id] FROM [dlm].[priceCatalog]
    WHERE [siteCatalogId] IN (
        SELECT [id] FROM [dlm].[siteCatalog]
        WHERE [serviceCatalogId] NOT IN (
            SELECT [id] FROM [dlm].[serviceCatalog] 
            WHERE [companyId] = 2 --@truckId
        )
    )
)
PRINT 'mapPRiceCatalogAttachedDocument'
DELETE FROM [dlm].[mapPriceCatalogAttachedDocument]
WHERE [priceCatalogId] IN (
    SELECT [id] FROM [dlm].[priceCatalog]
    WHERE [siteCatalogId] IN (
        SELECT [id] FROM [dlm].[siteCatalog]
        WHERE [serviceCatalogId] NOT IN (
            SELECT [id] FROM [dlm].[serviceCatalog] 
            WHERE [companyId] = 2 --@truckId
        )
    )
)
PRINT 'mapPriceCatalogClient'
DELETE FROM [dlm].[mapPriceCatalogClient]
WHERE [priceCatalogId] IN (
    SELECT [id] FROM [dlm].[priceCatalog]
    WHERE [siteCatalogId] IN (
        SELECT [id] FROM [dlm].[siteCatalog]
        WHERE [serviceCatalogId] NOT IN (
            SELECT [id] FROM [dlm].[serviceCatalog] 
            WHERE [companyId] = 2 --@truckId
        )
    )
)
PRINT 'priceCatalog'
DELETE FROM [dlm].[priceCatalog]
WHERE [siteCatalogId] IN (
    SELECT [id] FROM [dlm].[siteCatalog]
    WHERE [serviceCatalogId] NOT IN (
        SELECT [id] FROM [dlm].[serviceCatalog] 
        WHERE [companyId] = 2 --@truckId
    )
)
PRINT 'mapSiteCatalogClient'
DELETE FROM [dlm].[mapSiteCatalogClient]
WHERE [siteCatalogId] IN (
    SELECT [id] FROM [dlm].[siteCatalog]
    WHERE [serviceCatalogId] NOT IN (
        SELECT [id] FROM [dlm].[serviceCatalog] 
        WHERE [companyId] = 2 --@truckId
    )
)
PRINT 'mapSiteCatalogPlant'
DELETE FROM [dlm].[mapSiteCatalogPlant]
WHERE [siteCatalogId] IN (
    SELECT [id] FROM [dlm].[siteCatalog]
    WHERE [serviceCatalogId] NOT IN (
        SELECT [id] FROM [dlm].[serviceCatalog] 
        WHERE [companyId] = 2 --@truckId
    )
)
PRINT 'mapSiteCatalogSite'
DELETE FROM [dlm].[mapSiteCatalogSite]
WHERE [siteCatalogId] IN (
    SELECT [id] FROM [dlm].[siteCatalog]
    WHERE [serviceCatalogId] NOT IN (
        SELECT [id] FROM [dlm].[serviceCatalog] 
        WHERE [companyId] = 2 --@truckId
    )
)
PRINT 'SiteCatalog'
DELETE FROM [dlm].[siteCatalog]
WHERE [serviceCatalogId] NOT IN (
    SELECT [id] FROM [dlm].[serviceCatalog] 
    WHERE [companyId] = 2 --@truckId
)
PRINT 'mapServiceCatalogServicePosition'
DELETE FROM [dlm].[mapServiceCatalogServicePosition]
WHERE [serviceCatalogId] NOT IN (
    SELECT [id] FROM [dlm].[serviceCatalog]
    WHERE [companyId] = 2 --@truckId
)
PRINT 'serviceCatalog'
DELETE FROM [dlm].[serviceCatalog] 
WHERE [companyId] <> @truckId
PRINT 'mapSupplierPlant'
DELETE FROM [dlm].[mapSupplierPlant]
WHERE [supplierId] NOT IN (
    SELECT [id] FROM [dlm].[supplier]
    WHERE [companyId] = 2 --@truckId
)
PRINT 'mapSapOrderServiceType'
DELETE FROM [dlm].[mapSapOrderServiceType]
WHERE [sapOrderId] IN ( 
    SELECT [id] FROM [dlm].[sapOrder]
    WHERE [supplierId] NOT IN (
        SELECT [id] FROM [dlm].[supplier]
        WHERE [companyId] = 2 --@truckId
    )
)
PRINT 'sapOrder'
DELETE FROM [dlm].[sapOrder]
WHERE [supplierId] NOT IN (
    SELECT [id] FROM [dlm].[supplier]
    WHERE [companyId] = 2 --@truckId
)
PRINT 'supplier'
DELETE FROM [dlm].[supplier]
WHERE [companyId] <> @truckId
PRINT 'mapClientCompany'
DELETE FROM [sec].[mapClientCompany]
WHERE [companyId] NOT IN (
    SELECT [id] FROM [std].[company]
    WHERE [id] = 2 --@truckId
)
PRINT 'company'
DELETE FROM [std].[company]
WHERE [id] <> @truckId

SELECT @truckId = [id] FROM [archiv].[dbo_company] WHERE [Code] = N'DTAG'

PRINT 'SscPrice'
DELETE FROM [archiv].[dbo_SscPrice] WHERE [SscItemId] IN (SELECT [id] FROM  [archiv].[dbo_SscItem] WHERE [SscId] NOT IN (SELECT [SscId] FROM  [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @truckId))
PRINT 'SscItem'
DELETE FROM [archiv].[dbo_SscItem] WHERE [SscId] NOT IN (SELECT [id] FROM [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) = @truckId)
PRINT 'Ssc'
DELETE FROM [archiv].[dbo_StandardServicesCatalog] WHERE [id] NOT IN (SELECT [SscId] FROM [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) = @truckId)
PRINT 'SscCompany'
DELETE FROM [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) <> @truckId
PRINT 'InspectionItem'
DELETE FROM [archiv].[dbo_InspectionItem] WHERE [SspItemId] IN (SELECT [Id] FROM [archiv].[dbo_SspItem] WHERE [SspId] NOT IN (SELECT [id] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @truckId))
PRINT 'SspItem'
DELETE FROM [archiv].[dbo_SspItem] WHERE [SspId] NOT IN (SELECT [id] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @truckId)
PRINT 'Ssp'
DELETE FROM [archiv].[dbo_ServiceSpecification] WHERE [Id] NOT IN (SELECT [SspId] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @truckId)
PRINT 'SspCompany'
DELETE FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) <> @truckId
PRINT 'SspRelease'
DELETE FROM [archiv].[dbo_SspRelease] WHERE ISNULL([CompanyId],0) <> @truckId
PRINT 'Supplier'
DELETE FROM [archiv].[dbo_Supplier] WHERE ISNULL([CompanyId],0) <> @truckId
PRINT 'UserCOmpany'
DELETE FROM [archiv].[dbo_UserCompany] WHERE ISNULL([CompanyId],0) <> @truckId
PRINT 'KPIAreaHistory'
DELETE FROM [archiv].[dbo_KPIAreaHistory] WHERE ISNULL([CompanyId],0) <> @truckId
PRINT 'KPIBILLHistory'
DELETE FROM [archiv].[dbo_KPIBillHistory] WHERE ISNULL([CompanyId],0) <> @truckId
PRINT 'KPIBillHistory'
DELETE FROM [archiv].[dbo_KPIReportHistory] WHERE ISNULL([CompanyId],0) <> @truckId
PRINT 'PurchaseOrder'
DELETE FROM [archiv].[dbo_PurchaseOrder] WHERE ISNULL([CompanyId],0) <> @truckId

