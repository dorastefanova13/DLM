-- This file contains SQL statements that will be executed for Migration - not for build.

:setvar pathname "H:\repos\DLM\Database\Migration\database\full\"
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - ScriptPath:    $(pathname)'

:setvar dropmigschema "1"
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - DropMigSchema: $(dropmigschema)'

PRINT CONVERT(NVARCHAR,getdate(),120) + ' pre'
:r $(pathname)\_pre\clearSecurityPolicy.sql
:r $(pathname)\_pre\clearDB.sql
:r $(pathname)\_pre\createMigrationSchema.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' ------------------------------ Create Archiv Start'
:r $(pathname)\_pre\createArchivSchema.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' ------------------------------ Create Archiv Done'
:r $(pathname)\_pre\createAuditColumns.sql



--------------------------------------------------
--stammdaten/location/security
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run parameter.sql'
:r $(pathname)\_data\parameter.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run additionalShift.sql'
:r $(pathname)_data/additionalShift.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run billStatus.sql'
:r $(pathname)_data/billStatus.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run company.sql'
:r $(pathname)_data/company.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run currency.sql'
:r $(pathname)_data/currency.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run language.sql'
:r $(pathname)_data/language.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run reportText.sql'
:r $(pathname)_data/reportText.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run reportConfig.sql'
:r $(pathname)_data/reportConfig.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run dayType.sql'
:r $(pathname)_data/dayType.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run site.sql'
:r $(pathname)_data/site.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run plant.sql'
:r $(pathname)_data/plant.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run geoRegion.sql'
:r $(pathname)_data/geoRegion.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run orgUnit.sql'
:r $(pathname)_data/orgUnit.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run flooring.sql'
:r $(pathname)_data/flooring.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run lvAlloc.sql'
:r $(pathname)_data/lvAlloc.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run ffg.sql'
:r $(pathname)_data/ffg.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run cycle.sql'
:r $(pathname)_data/cycle.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run costCenter.sql'
:r $(pathname)_data/costCenter.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run location.sql'
:r $(pathname)_data/location.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run standard.sql'
:r $(pathname)_data/standard.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run priceCatalogStatus.sql'
:r $(pathname)_data/priceCatalogStatus.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run tenderStatus.sql'
:r $(pathname)_data/tenderStatus.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run priceCatalogCalculationStatus.sql'
:r $(pathname)_data/priceCatalogCalculationStatus.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceOrderStatus.sql'
:r $(pathname)_data/serviceOrderStatus.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceOrderPositionStatus.sql'
:r $(pathname)_data/serviceOrderPositionStatus.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceOrderExecutionStatus.sql'
--:r $(pathname)_data/serviceOrderExecutionStatus.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceType.sql'
:r $(pathname)_data/serviceType.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run settlementType.sql'
:r $(pathname)_data/settlementType.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run technicalCleaningObjectType.sql'
:r $(pathname)_data/technicalCleaningObjectType.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceObjectType.sql'
:r $(pathname)_data/serviceObjectType.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceCategory.sql'
:r $(pathname)_data/serviceCategory.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run turnus.sql'
:r $(pathname)_data/turnus.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run usageType.sql'
:r $(pathname)_data/usageType.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mainCode.sql'
:r $(pathname)_data/mainCode.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapMainCodeUsageType.sql'
:r $(pathname)_data/mapMainCodeUsageType.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run wage.sql'
:r $(pathname)_data/wage.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run unit.sql'
:r $(pathname)_data/unit.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run supplier.sql'
:r $(pathname)_data/supplier.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapSupplierPlant.sql'
:r $(pathname)_data/mapSupplierPlant.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run calendar.sql'
:r $(pathname)_data/calendar.sql

--------------------------------------------------
--clients
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run client.sql'
:r $(pathname)_data/client.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run clientRole.sql'
:r $(pathname)_data/clientRole.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run clientPermission.sql'
:r $(pathname)_data/clientPermission.sql 

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run standardDiscount.sql'
:r $(pathname)_data/standardDiscount.sql


--servicecatalog
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceCatalog.sql'
:r $(pathname)_data/serviceCatalog.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run servicePosition.sql'
:r $(pathname)_data/servicePosition.sql

--measurement/location
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run measurement.sql'
:r $(pathname)_data/measurement.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapLocation.sql'
:r $(pathname)_data/mapLocation.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceObject.sql'
:r $(pathname)_data/serviceObject.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run customCleaningObject.sql'
:r $(pathname)_data/customCleaningObject.sql

--sitecatalog
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run siteCatalog.sql'
:r $(pathname)_data/siteCatalog.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapServiceCatalogServicePosition.sql'
:r $(pathname)_data/mapServiceCatalogServicePosition.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run siteCatalogPosition.sql'
:r $(pathname)_data/siteCatalogPosition.sql


PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapSiteCatalogClient.sql'
:r $(pathname)_data/mapSiteCatalogClient.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapSiteCatalogPlant.sql'
:r $(pathname)_data/mapSiteCatalogPlant.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapSiteCatalogSite.sql'
:r $(pathname)_data/mapSiteCatalogSite.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapServiceMainPositionSubPosition.sql'
:r $(pathname)_data/mapServiceMainPositionSubPosition.sql

 --pricecatalog
 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run priceCatalog.sql'
:r $(pathname)_data/priceCatalog.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run priceCatalogPosition.sql'
:r $(pathname)_data/priceCatalogPosition.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapPriceCatalogClient.sql'
:r $(pathname)_data/mapPriceCatalogClient.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapPriceCatalogAdditionalShift.sql'
:r $(pathname)_data/mapPriceCatalogAdditionalShift.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run priceCatalogCalculation.sql'
:r $(pathname)_data/priceCatalogCalculation.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run priceCatalogCalculationPosition.sql'
:r $(pathname)_data/priceCatalogCalculationPosition.sql

 --sapOrder
  PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run sapOrder.sql'
:r $(pathname)_data/sapOrder.sql

 --serviceorder
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceOrder.sql'
:r $(pathname)_data/serviceOrder.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run serviceOrderPosition.sql'
:r $(pathname)_data/serviceOrderPosition.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapServiceOrderClient.sql'
:r $(pathname)_data/mapServiceOrderClient.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapServiceOrderSapOrder.sql'
:r $(pathname)_data/mapServiceOrderSapOrder.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run mapServiceOrderLocation.sql'
:r $(pathname)_data/mapServiceOrderLocation.sql

 --bill
 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run bill.sql'
:r $(pathname)_data/bill.sql
 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run billPosition.sql'
:r $(pathname)_data/billPosition.sql
 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run settlement.sql'
:r $(pathname)_data/settlement.sql
 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run attachedDocument.sql'
:r $(pathname)_data/attachedDocument.sql


--------------------------------------------------

--security
 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run testuser.sql'
:r $(pathname)_security/testuser.sql
 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run rowSecurity.sql'
:r $(pathname)_security/rowSecurity.sql

--------------------------------------------------

--post
 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run restoreSecurityPolicy.sql'
:r $(pathname)_post/restoreSecurityPolicy.sql

 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run restoreCheckConstraints.sql'
:r $(pathname)_post/restoreCheckConstraints.sql

 PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run CreateDetailViews.sql'
:r $(pathname)_post/CreateDetailViews.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run CreateAuditTrigger.sql'
:r $(pathname)_post/CreateAuditTrigger.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run specialTrigger.sql'
:r $(pathname)_post/specialTrigger.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run setStatus.sql'
:r $(pathname)_post/setStatus.sql

PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run additionExpressions.sql'
:r $(pathname)_post/additionalExpressions.sql

--------------------------------------------------

--technicalData
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run technicalData.sql'
:r $(pathname)_technicalData/technicalData.sql
PRINT CONVERT(NVARCHAR,getdate(),120) + ' - run importRawdata.sql'
:r $(pathname)_technicalData/importRawdata.sql



--:r $(pathname)\_post\dropMigrationSchema.sql
