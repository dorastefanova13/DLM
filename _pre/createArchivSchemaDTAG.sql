BEGIN

    PRINT 'clean temp schema [archiv] if exists'

    DECLARE @dropsql VARCHAR(MAX)='';

    DECLARE cMig CURSOR FOR 
            SELECT N'DROP TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)  AS [~]
            FROM sys.tables AS t
            INNER JOIN sys.schemas AS s 
                ON t.[schema_id] = s.[schema_id]
            WHERE s.[name] IN ('archiv')
            ORDER BY s.[name],t.[name]

    OPEN cMig
    FETCH NEXT FROM cMig INTO @dropsql
    WHILE @@FETCH_STATUS = 0
    BEGIN

        --PRINT @sql
        EXECUTE (@dropsql)
        FETCH NEXT FROM cMig INTO @dropsql
    END
    CLOSE cMig
    DEALLOCATE cMig

	DROP VIEW IF EXISTS [archiv].[dbo_AcceptedSscSuppliers]
	DROP VIEW IF EXISTS [archiv].[dbo_CycleDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_MainCodeDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_OperationStateDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SscPriceAcceptedDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SscPriceDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SscPriceQuotedDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SscQuoteComparisonDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SscQuoteComparisonQuoteFlat]
	DROP VIEW IF EXISTS [archiv].[dbo_SscQuoteDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SscQuoteRequestDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SscQuoteRequestGroupDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspDiscount]
	DROP VIEW IF EXISTS [archiv].[dbo_SspEffectiveMainCodeDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPlant]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPriceAcceptedDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPriceAcceptedTotals]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPriceAccepted]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPriceAll]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPriceItemDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPriceItem]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPriceQuotedDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspPriceQuoted]
	DROP VIEW IF EXISTS [archiv].[dbo_SspQuoteComparisonDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspQuoteComparisonQuoteFlat]
	DROP VIEW IF EXISTS [archiv].[dbo_SspQuoteDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspQuoteRequestDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspQuoteRequestGroupDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SspQuoteRequestGroupSupplierFlat]
	DROP VIEW IF EXISTS [archiv].[dbo_SupplierDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_SupplierPlantFlat]
	DROP VIEW IF EXISTS [archiv].[dbo_UnitDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_UserName]
	DROP VIEW IF EXISTS [archiv].[dbo_WoItemStateDetail]
	DROP VIEW IF EXISTS [archiv].[dbo_WoStateDetail]
	DROP VIEW IF EXISTS [archiv].[faplis_Building_V]
	DROP VIEW IF EXISTS [archiv].[faplis_Costcenter_V]
	DROP VIEW IF EXISTS [archiv].[faplis_Elevation_V]
	DROP VIEW IF EXISTS [archiv].[faplis_Ffg_V]
	DROP VIEW IF EXISTS [archiv].[faplis_Floor_V]
	DROP VIEW IF EXISTS [archiv].[faplis_Flooring_V]
	DROP VIEW IF EXISTS [archiv].[faplis_LvAlloc_V]
	DROP VIEW IF EXISTS [archiv].[faplis_Plant_V]
	DROP VIEW IF EXISTS [archiv].[faplis_SubBuilding_V]
	DROP VIEW IF EXISTS [archiv].[faplis_SubPlant_V]
	DROP VIEW IF EXISTS [archiv].[faplis_UsageType_V]

    DROP SCHEMA IF EXISTS archiv;


END
PRINT 'create temp schema [archiv]'
GO
CREATE SCHEMA archiv AUTHORIZATION dbo;
GO
BEGIN

    PRINT 'fill tables in schema [archiv]'

    DECLARE @selsql VARCHAR(MAX)='';

    DECLARE cMig CURSOR FOR 
            SELECT N'SELECT * INTO [archiv].' + QUOTENAME(s.name + '_' + t.name)  + ' FROM [FAPLISDlm].' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
            FROM FAPLISDlm.sys.tables AS t
            INNER JOIN FAPLISDlm.sys.schemas AS s 
                ON t.[schema_id] = s.[schema_id]
            WHERE s.[name] IN ('dbo','faplis')
			AND t.[name] NOT IN ('AreaCleaning20240126','AreaCleaning20240130','measurement_20231108','measurement20240126')
            ORDER BY s.[name],t.[name]

    OPEN cMig
    FETCH NEXT FROM cMig INTO @selsql
    WHILE @@FETCH_STATUS = 0
    BEGIN

        --PRINT @selsql
        EXECUTE (@selsql)
        FETCH NEXT FROM cMig INTO @selsql
    END
    CLOSE cMig
    DEALLOCATE cMig

    DECLARE @indsql VARCHAR(MAX)='';

    DECLARE cMig CURSOR FOR 
            SELECT 
            'CREATE ' + 
            CASE WHEN i.is_unique = 1 THEN 'UNIQUE ' ELSE '' END + 
            i.type_desc + ' INDEX [' + i.name  COLLATE SQL_Latin1_General_CP1_CI_AS  + '] ON [archiv].[' + s.name  COLLATE SQL_Latin1_General_CP1_CI_AS  + '_' + t.name  COLLATE SQL_Latin1_General_CP1_CI_AS  + '] (' + 
            STUFF((
                SELECT TOP 30 ', [' + c.name  COLLATE SQL_Latin1_General_CP1_CI_AS + '] ' + 
                       CASE WHEN ic.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END
                FROM [FAPLISDlm].sys.index_columns ic
                JOIN [FAPLISDlm].sys.columns c 
                    ON ic.object_id = c.object_id 
                    AND ic.column_id = c.column_id
                WHERE ic.object_id = i.object_id 
                AND ic.index_id = i.index_id
                ORDER BY ic.key_ordinal
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')' +
            CASE WHEN i.has_filter = 1 THEN ' WHERE ' + i.filter_definition   COLLATE SQL_Latin1_General_CP1_CI_AS ELSE '' END + ';' AS CreateIndexStatement
        FROM [FAPLISDlm].sys.indexes i
        JOIN [FAPLISDlm].sys.tables t ON i.object_id = t.object_id
        JOIN [FAPLISDlm].sys.schemas s ON t.schema_id = s.schema_id
        WHERE i.type > 0  -- Ignoriere Heaps (type = 0)
          AND i.is_primary_key = 0  -- Keine Primärschlüssel
          AND i.is_unique_constraint = 0  -- Keine Unique Constraints
          AND s.[name]  COLLATE SQL_Latin1_General_CP1_CI_AS  IN ('dbo','faplis')
        ORDER BY s.name, t.name, i.name;
    OPEN cMig
    FETCH NEXT FROM cMig INTO @indsql
    WHILE @@FETCH_STATUS = 0
    BEGIN

        PRINT @indsql
        EXECUTE (@indsql)
        FETCH NEXT FROM cMig INTO @indsql
    END
    CLOSE cMig
    DEALLOCATE cMig

    
END
GO
BEGIN

    DECLARE @selsql VARCHAR(MAX)='';

    DECLARE cMig CURSOR FOR 
            SELECT N'SELECT * INTO [archiv].' + QUOTENAME('stage_' + t.name)  + ' FROM [DLM30Faplis].' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
            FROM DLM30Faplis.sys.tables AS t
            INNER JOIN DLM30Faplis.sys.schemas AS s 
                ON t.[schema_id] = s.[schema_id]
            WHERE s.[name] IN ('mig','etl')
			AND t.[name] NOT IN (N'AreaCleaning20240126',N'AreaCleaning20240130',N'measurement_20231108',N'measurement20240126')
            ORDER BY s.[name],t.[name]

    OPEN cMig
    FETCH NEXT FROM cMig INTO @selsql
    WHILE @@FETCH_STATUS = 0
    BEGIN

        --PRINT @selsql
        EXECUTE (@selsql)
        FETCH NEXT FROM cMig INTO @selsql
    END
    CLOSE cMig
    DEALLOCATE cMig

END

GO
CREATE VIEW [archiv].[faplis_Building_V]
	AS 
	select 
    PlantID = p.ID
, PlantCode = p.Code
, PlantName = pt.DefaultText
, PlantFunctionalId = p.functionalId
, SubPlantID = sp.ID
, SubPlantCode = sp.Code
, SubPlantName = spt.DefaultText
, SubPLantFunctionalId = sp.functionalId
, BuildingID = b.ID
, BuildingCode = b.Code
, BuildingName = bt.DefaultText 
, BuildingFunctionalId = b.functionalId
, b.isActive
FROM   [archiv].[faplis_Building] b									INNER JOIN [archiv].[dbo_text]  bt with (nolock) on  b.NameTextID =  bt.ID
INNER JOIN [archiv].[faplis_SubPlant] sp ON b.SubPlantID=sp.ID			INNER JOIN [archiv].[dbo_text]  spt with (nolock) on  sp.NameTextID =  spt.ID
INNER JOIN [archiv].[faplis_Plant] p ON sp.PlantID = p.ID				INNER JOIN [archiv].[dbo_text]  pt with (nolock) on  p.NameTextID =  pt.ID
GO

CREATE VIEW [archiv].[faplis_Costcenter_V]
	AS 
select 
c.Id
,c.Code
,Name=t.DefaultText
,c.PlantID
,C.Created
,c.Modified 
,c.functionalId
,c.isActive
from [archiv].[faplis_costcenter] c
INNER JOIN [archiv].[dbo_text] t ON c.NameTextId = t.ID
GO

CREATE VIEW [archiv].[faplis_Elevation_V]
	AS 
select 
    PlantID = p.ID
, PlantCode = p.Code
, PlantName = pt.DefaultText
, PlantFunctionalId = p.functionalId
, SubPlantID = sp.ID
, SubPlantCode = sp.Code
, SubPlantName = spt.DefaultText
, SubPlantFunctionalId = sp.functionalId
, BuildingID = b.ID
, BuildingCode = b.Code
, BuildingName = bt.DefaultText 
, BuildingFunctionalId = b.functionalId
, SubBuildingID = sb.ID
, SubBuildingCode = sb.Code
, SubBuildingName = sbt.DefaultText
, SubBuildingFunctionalId = sb.functionalId
, FloorID = f.ID
, FloorCode =  f.Code
, FloorName = ft.DefaultText
, FloorFunctionalId = f.functionalId
, ElevationID = e.ID
, Elevation= e.[ValueInMm]
, ElevationName= et.DefaultText
, ElevationFunctionalId = e.functionalId
, e.isActive
FROM [archiv].[faplis_Elevation] e			 
INNER JOIN [archiv].[dbo_text] et with (nolock) on e.NameTextID = et.ID
INNER JOIN [archiv].[faplis_Floor] f	ON e.FloorID = f.ID				INNER JOIN [archiv].[dbo_text] ft with (nolock) ON f.NameTextID = ft.ID
INNER JOIN [archiv].[faplis_SubBuilding] sb ON f.SubBuildingID = sb.ID	INNER JOIN [archiv].[dbo_text] sbt with (nolock) on sb.NameTextID = sbt.ID
INNER JOIN [archiv].[faplis_Building] b ON sb.BuildingID = b.ID		INNER JOIN [archiv].[dbo_text]  bt with (nolock) on  b.NameTextID =  bt.ID
INNER JOIN [archiv].[faplis_SubPlant] sp ON b.SubPlantID=sp.ID			INNER JOIN [archiv].[dbo_text]  spt with (nolock) on  sp.NameTextID =  spt.ID
INNER JOIN [archiv].[faplis_Plant] p ON sp.PlantID = p.ID				INNER JOIN [archiv].[dbo_text]  pt with (nolock) on  p.NameTextID =  pt.ID
GO

CREATE VIEW [archiv].[faplis_Ffg_V]
	AS 
	select 
    ff.Id
--,ut.NameTextId
,Name = t.DefaultText
,ff.Created
,ff.Modified
from [archiv].[faplis_Ffg] ff
INNER JOIN [archiv].[dbo_text] t on ff.NameTextId = t.id
GO

CREATE VIEW [archiv].[faplis_Floor_V]
	AS 
select 
    PlantID = p.ID
, PlantCode = p.Code
, PlantName = pt.DefaultText
, PlantFunctionalId = p.functionalId
, SubPlantID = sp.ID
, SubPlantCode = sp.Code
, SubPlantName = spt.DefaultText
, SubPLantFunctionalId = sp.functionalId
, BuildingID = b.ID
, BuildingCode = b.Code
, BuildingName = bt.DefaultText 
, BuildingFunctionalId = b.functionalId
, SubBuildingID = sb.ID
, SubBuildingCode = sb.Code
, SubBuildingName = sbt.DefaultText
, SubBuildingFunctionalId = sb.functionalId
, FloorID = f.ID
, FloorCode =  f.Code
, FloorName = ft.DefaultText
, FloorFunctionalId = f.functionalId
, f.isActive
FROM  [archiv].[faplis_Floor] f			INNER JOIN [archiv].[dbo_text] ft with (nolock) ON f.NameTextID = ft.ID
INNER JOIN [archiv].[faplis_SubBuilding] sb ON f.SubBuildingID = sb.ID	INNER JOIN [archiv].[dbo_text] sbt with (nolock) on sb.NameTextID = sbt.ID
INNER JOIN [archiv].[faplis_Building] b ON sb.BuildingID = b.ID		INNER JOIN [archiv].[dbo_text]  bt with (nolock) on  b.NameTextID =  bt.ID
INNER JOIN [archiv].[faplis_SubPlant] sp ON b.SubPlantID=sp.ID			INNER JOIN [archiv].[dbo_text]  spt with (nolock) on  sp.NameTextID =  spt.ID
INNER JOIN [archiv].[faplis_Plant] p ON sp.PlantID = p.ID				INNER JOIN [archiv].[dbo_text]  pt with (nolock) on  p.NameTextID =  pt.ID
GO

CREATE VIEW [archiv].[faplis_Flooring_V]
	AS 
	select 
    fl.Id
--,ut.NameTextId
,Name = t.DefaultText
,fl.[Type]
,fl.Created
,fl.Modified
from [archiv].[faplis_Flooring] fl
INNER JOIN [archiv].[dbo_text] t on fl.NameTextId = t.id
GO

CREATE VIEW [archiv].[faplis_LvAlloc_V]
	AS 
	select 
    la.Id
--,ut.NameTextId
,Name = t.DefaultText
,la.Created
,la.Modified
from [archiv].[faplis_LvAlloc] la
INNER JOIN [archiv].[dbo_text] t on la.NameTextId = t.id
GO

CREATE VIEW [archiv].[faplis_Plant_V]
	AS 
	select 
    PlantID = p.ID
, PlantCode = p.Code
, PlantName = pt.DefaultText
, PlantFunctionalId = p.functionalId
, PlantFaplisId = p.faplisId
, p.isActive

FROM  [archiv].[faplis_Plant] p 	INNER JOIN [archiv].[dbo_text]  pt with (nolock) on  p.NameTextID =  pt.ID
GO

CREATE VIEW [archiv].[faplis_SubBuilding_V]
	AS
	select 
    PlantID = p.ID
, PlantCode = p.Code
, PlantName = pt.DefaultText
, PlantFunctionalId = p.functionalId
, SubPlantID = sp.ID
, SubPlantCode = sp.Code
, SubPlantName = spt.DefaultText
, SubPLantFunctionalId = sp.functionalId
, BuildingID = b.ID
, BuildingCode = b.Code
, BuildingName = bt.DefaultText 
, BuildingFunctionalId = b.functionalId
, SubBuildingID = sb.ID
, SubBuildingCode = sb.Code
, SubBuildingName = sbt.DefaultText
, SubBuildingFunctionalId = sb.functionalId
, sb.isActive
FROM   [archiv].[faplis_SubBuilding] sb								INNER JOIN [archiv].[dbo_text] sbt with (nolock) on sb.NameTextID = sbt.ID
INNER JOIN [archiv].[faplis_Building] b ON sb.BuildingID = b.ID		INNER JOIN [archiv].[dbo_text]  bt with (nolock) on  b.NameTextID =  bt.ID
INNER JOIN [archiv].[faplis_SubPlant] sp ON b.SubPlantID=sp.ID			INNER JOIN [archiv].[dbo_text]  spt with (nolock) on  sp.NameTextID =  spt.ID
INNER JOIN [archiv].[faplis_Plant] p ON sp.PlantID = p.ID				INNER JOIN [archiv].[dbo_text]  pt with (nolock) on  p.NameTextID =  pt.ID
GO

CREATE VIEW [archiv].[faplis_SubPlant_V]
	AS 

	SELECT 
    PlantID = p.ID
, PlantCode = p.Code
, PlantName = pt.DefaultText
, PlantFunctionalId = p.functionalId
, SubPlantID = sp.ID
, SubPlantCode = sp.Code
, SubPlantName = spt.DefaultText
, SubPlantFunctionalId = sp.functionalId
, sp.isActive
FROM    [archiv].[faplis_SubPlant] sp 		INNER JOIN [archiv].[dbo_text]  spt with (nolock) on  sp.NameTextID =  spt.ID
INNER JOIN [archiv].[faplis_Plant] p ON sp.PlantID = p.ID				INNER JOIN [archiv].[dbo_text]  pt with (nolock) on  p.NameTextID =  pt.ID
GO

CREATE VIEW [archiv].[faplis_UsageType_V]
	AS 
	select 
    ut.Id
--,ut.NameTextId
,Name = t.DefaultText
,ut.FFG_6_ID
,ut.Created
,ut.Modified
from [archiv].[faplis_UsageType] ut
INNER JOIN [archiv].[dbo_text] t on ut.NameTextId = t.Id
GO

CREATE VIEW [archiv].[dbo_WoStateDetail]
	AS 
	SELECT  wos.Id,
			t.[Text] as Name, 
			t.Lcid			
	
	FROM [archiv].[dbo_WoState] wos
	INNER JOIN	[archiv].[dbo_TextDetail] AS t ON wos.NameTextId = t.Id
GO

CREATE VIEW [archiv].[dbo_WoItemStateDetail]
	AS 
	SELECT  wois.Id,			  
			t.[Text] as Name, 
			t.Lcid			
	
	FROM [archiv].[dbo_WoItemState] wois
	INNER JOIN	[archiv].[dbo_TextDetail] AS t ON wois.NameTextId = t.Id
GO

CREATE VIEW [archiv].[dbo_SspPlant]
    AS
select distinct ssp.Id as SspId, loc.PlantId
from [archiv].[dbo_ServiceSpecification] ssp
inner join [archiv].[dbo_SspLocation] loc on loc.SspId = ssp.Id
GO

CREATE VIEW [archiv].[dbo_SspDiscount] 
AS 
select 
	 g.SspId
	,q.Discount
from [archiv].[dbo_SspQuoteRequestGroup] g
inner join [archiv].[dbo_SspQuoteRequest] r on r.GroupId = g.Id
inner join [archiv].[dbo_SspQuote] q on q.RequestId = r.Id and q.IsAccepted = 1

union all

select 
	 SspId = ssp.Id
	,q.Discount
from [archiv].[dbo_SspQuoteRequestGroup] g
inner join [archiv].[dbo_SspQuoteRequest] r on r.GroupId = g.Id
inner join [archiv].[dbo_SspQuote] q on q.RequestId = r.Id and q.IsAccepted = 1
inner join [archiv].[dbo_ServiceSpecification] ssp on ssp.MainSspId = g.SspId
GO

CREATE VIEW [archiv].[dbo_SspPriceAll] as

select
	 g.SspId
	,q.IsAccepted
	,p.MainCodeId
	,p.CycleCodeId
	,p.Value
	,p.UnitsPerHour
from
	[archiv].[dbo_SspQuoteRequestGroup] g
	inner join [archiv].[dbo_SspQuoteRequest] r on r.GroupId = g.Id
	inner join [archiv].[dbo_SspQuote] q on q.RequestId = r.Id
	inner join [archiv].[dbo_SspPrice] p on p.SspQuoteId = q.Id
	
union all

select
	 SspId = ssp.id
	,q.IsAccepted
	,p.MainCodeId
	,p.CycleCodeId
	,p.Value
	,p.UnitsPerHour
from
	[archiv].[dbo_SspQuoteRequestGroup] g
	inner join [archiv].[dbo_SspQuoteRequest] r on r.GroupId = g.Id
	inner join [archiv].[dbo_SspQuote] q on q.RequestId = r.Id
	inner join [archiv].[dbo_SspPrice] p on p.SspQuoteId = q.Id
	inner join [archiv].[dbo_ServiceSpecification] ssp on ssp.MainSspId = g.SspId
GO
CREATE VIEW [archiv].[dbo_SspPriceItem]
AS
SELECT i.SspId, 
 i.MainCodeId, 
 i.CycleCodeId, 
 i.UnitId, 
 ISNULL(SUM(m.Units), 0) AS Units
FROM [archiv].[dbo_SspItem] AS i LEFT OUTER JOIN [archiv].[dbo_Measurement] AS m ON m.SspItemId = i.Id
 AND m.IsActive = 1 
WHERE i.IsMajorItem = 1
 and i.IsActive = 1
GROUP BY i.SspId, 
 i.MainCodeId, 
 i.CycleCodeId, 
 i.UnitId
GO
CREATE VIEW [archiv].[dbo_SspPriceQuoted] as
with SspGroup as (
	select Id as MainSspId, Id
	from [archiv].[dbo_ServiceSpecification]
	where MainSspId is null
	union all
	select MainSspId, Id
	from [archiv].[dbo_ServiceSpecification]
	where MainSspId is not null
), Price as(
	select
		g.SspId,
		q.Id as QuoteId,
		p.MainCodeId,
		p.CycleCodeId,
		p.Value,
		p.UnitsPerHour
	from [archiv].[dbo_SspQuoteRequestGroup] g
	inner join [archiv].[dbo_SspQuoteRequest] r on r.GroupId = g.Id
	inner join [archiv].[dbo_SspQuote] q on q.RequestId = r.Id
	inner join [archiv].[dbo_SspPrice] p on p.SspQuoteId = q.Id
	where q.IsAccepted = 0
)
select it.*, p.QuoteId, p.Value, p.UnitsPerHour
from [archiv].[dbo_SspPriceItem] it
inner join SspGroup sg on sg.Id = it.SspId
inner join Price p on
	p.SspId = sg.MainSspId and
	p.MainCodeId = it.MainCodeId and
	p.CycleCodeId = it.CycleCodeId
union all
select
	it.SspId,
	it.MainCodeId,
	it.CycleCodeId,
	it.UnitId,
	it.Units,
	null as QuoteId,
	null as Value,
	null as UnitsPerHour
from [archiv].[dbo_SspPriceItem] it
GO
CREATE VIEW [archiv].[dbo_UserName]
AS 
SELECT			u.Id, 
				case
					when u.LastName is null and u.FirstName is null then null
					when u.FirstName is null then u.LastName
					when u.LastName is null then u.FirstName
					else u.LastName + ', ' + u.FirstName
				end as Name
FROM			[archiv].[dbo_User] AS u
GO
CREATE VIEW [archiv].[dbo_OperationStateDetail]
AS 
SELECT		op.Id, 
			t.[Text] as Name, 
			t.Lcid			
FROM		[archiv].[dbo_OperationState] AS op
INNER JOIN	[archiv].[dbo_TextDetail] AS t 
ON			t.Id = op.NameTextId
GO
CREATE VIEW [archiv].[dbo_SscQuoteDetail] as
select
	q.*,
	u.Name AS CreatedByName,
	s.Code as SupplierCode,
	s.Name as SupplierName,
	o.Name as OperationStateName,
	l.Lcid,
	g.SscId,
	r.SupplierId,
	g.SupplementSscId,
	convert(bit, case
		when g.SupplementSscId is null then 0
		else 1 
	end) as IsAcceptedSupplement
from [archiv].[dbo_SscQuote] q
inner join [archiv].[dbo_Language] l on 1 = 1
inner join [archiv].[dbo_SscQuoteRequest] r on r.Id = q.RequestId
inner join [archiv].[dbo_SscQuoteRequestGroup] g on g.Id = r.GroupId
inner join [archiv].[dbo_Supplier] s on s.Id = r.SupplierId
inner join [archiv].[dbo_UserName] u on u.Id = q.CreatedBy
inner join [archiv].[dbo_OperationStateDetail] o on o.Id = q.OperationStateId and o.Lcid = l.Lcid
GO

CREATE VIEW [archiv].[dbo_SupplierPlantFlat] as
select *
from
(
	select SupplierId = s.Id from [archiv].[dbo_Supplier] s
) sup
cross apply
(
	select
		case row_number() over (order by p.Code) when 1 then '' else ';' end + cast(ps.PlantId as varchar(max))	
	from [archiv].[dbo_PlantSupplier] ps
	inner join [archiv].[faplis_Plant] p on ps.PlantId = p.Id
	where ps.SupplierId= sup.SupplierId
	order by p.Code
	for xml path('')
) spId(PlantIds)

cross apply
(
	select
		case row_number() over (order by p.Code) when 1 then '' else ';' end + cast(p.Code as varchar(max))	
	from [archiv].[dbo_PlantSupplier] ps
	inner join [archiv].[faplis_plant] p on ps.PlantId = p.Id
	where ps.SupplierId= sup.SupplierId
	order by p.Code
	for xml path('')
) spCode(PlantCodes)
GO
CREATE VIEW [archiv].[dbo_SupplierDetail]
	AS 
	
SELECT			
				supp.[Id],
				supp.[Name],
				supp.[Code],
				supp.[Note],
				--LTRIM(ISNULL(supp.[Note],'') + ' ') + CASE WHEN supp.[CompanyId] = 1 THEN 'MB' WHEN supp.[CompanyId] = 2 THEN 'DTR' WHEN supp.[CompanyId] = 3 THEN 'DAG' ELSE '' END AS [Note],
				supp.[IsActive],
				supp.[CompanyId],
				supp.[Created],
				supp.[Modified],
				supp.[CreatedBy],
				supp.[ModifiedBy],
				supp.[Version],
				ps.PlantCodes,
				ps.PlantIds,
				c.[Name] AS [Company]
FROM			[archiv].[dbo_Supplier] supp
INNER JOIN		[archiv].[dbo_Company] c
	ON c.[Id] = supp.[CompanyId]
LEFT OUTER JOIN	[archiv].[dbo_SupplierPlantFlat] ps
ON				supp.Id = ps.SupplierId
GO


CREATE VIEW [archiv].[dbo_AcceptedSscSuppliers]
	AS 
	SELECT 
		supp.[Id]
		, supp.[Name]
		, supp.[Code]
		, supp.[Note]
		, supp.[IsActive]
		, supp.[CompanyId]
		, supp.[Created]
		, supp.[Modified]
		, supp.[CreatedBy]
		, supp.[ModifiedBy]
		, supp.[Version]
		, supp.[PlantCodes]
		, supp.[PlantIds]
		, supp.[Company]
		, gr.Id as GroupId
		, gr.SscId as SscId
	from [archiv].[dbo_SupplierDetail] supp
	join [archiv].[dbo_SscQuoteRequest] sqr on supp.Id = sqr.SupplierId
	join [archiv].[dbo_SscQuote] q on sqr.Id = q.RequestId
	join [archiv].[dbo_SscQuoteRequestGroup] gr on sqr.GroupId = gr.Id
	where q.IsAccepted = 1 and gr.SupplementSscId is null
GO
CREATE VIEW [archiv].[dbo_UnitDetail]
	AS 
SELECT		u.Id, 
			t.[Text], 
			t.Lcid
FROM        [archiv].[dbo_Unit] AS u 
INNER JOIN	[archiv].[dbo_TextDetail] AS t 
ON			u.NameTextId = t.Id
GO
CREATE VIEW [archiv].[dbo_SscPriceAcceptedDetail] as
with supplierPrices (SscItemId, Value, IsAccepted, QuoteId, SupplierId)
as (
	select pr.SscItemId, pr.Value, q.IsAccepted, q.Id, r.SupplierId
	from [archiv].[dbo_SscPrice] pr
	left join [archiv].[dbo_SscQuote] q on pr.QuoteId = q.Id
	left join [archiv].[dbo_SscQuoteRequest] r on r.Id = q.RequestId
	where q.IsAccepted = 1
)
select 
	prices.SscId,
	prices.SscItemId,
	prices.QuoteId,
	prices.Value,
	convert(bit, prices.IsAccepted) as IsAccepted,
	prices.SupplierId,
	l.Lcid,
	u.[Text] as UnitName,
	ssc.BaseSscId as BaseSscId,
	sscItem.Code,
	sscItem.[Definition],
	sscItem.[Description],
	sscItem.SupplementSscItemId,
	convert(bit, case
		when sscItem.SupplementSscItemId is null then 0
		else 1 
	end) as IsAcceptedSupplement,
	suppSsc.Id as SupplementSscId
from (select 
			supplier.SscId,
			it.Id as SscItemId,
			price.Value,
			case
				when price.QuoteId is null then 0
				else price.QuoteId 
			end as QuoteId,
			price.IsAccepted,
			supplier.Id as SupplierId
		from [archiv].[dbo_AcceptedSscSuppliers] supplier
		inner join [archiv].[dbo_SscItem] it on it.SscId = supplier.SscId
		left join supplierPrices price on price.SscItemId = it.Id and price.SupplierId = supplier.Id

		union all

		select
			it.SscId,
			it.Id as SscItemId,
			null as Value,
			0 as QuoteId,
			1 as IsAccepted,
			0 as SupplierId
		from [archiv].[dbo_SscItem] it)
	as prices

	inner join [archiv].[dbo_Language] l on 1 = 1
	inner join [archiv].[dbo_StandardServicesCatalog] ssc on prices.SscId = ssc.Id
	left join [archiv].[dbo_SscItem] sscItem on prices.SscItemId = sscItem.Id
	left join [archiv].[dbo_UnitDetail] u on u.Id = sscItem.UnitId and u.Lcid = l.Lcid
	left join [archiv].[dbo_SscQuoteDetail] q on q.Id = prices.QuoteId and q.Lcid = l.Lcid
	left join [archiv].[dbo_SscItem] suppSscItem on sscItem.SupplementSscItemId = suppSscItem.Id
	left join [archiv].[dbo_StandardServicesCatalog] suppSsc on suppSscItem.SscId = suppSsc.Id
GO
CREATE VIEW [archiv].[dbo_SspPriceAccepted] as
with SspGroup as (
	select Id as MainSspId, Id
	from [archiv].[dbo_ServiceSpecification]
	where MainSspId is null
	
	union all
	
	select MainSspId, Id
	from [archiv].[dbo_ServiceSpecification]
	where MainSspId is not null
), Price as(
	select
		g.SspId,
		p.MainCodeId,
		p.CycleCodeId,
		p.Value,
		p.UnitsPerHour
	from [archiv].[dbo_SspQuoteRequestGroup] g
	inner join [archiv].[dbo_SspQuoteRequest] r on r.GroupId = g.Id
	inner join [archiv].[dbo_SspQuote] q on q.RequestId = r.Id
	inner join [archiv].[dbo_SspPrice] p on p.SspQuoteId = q.Id
	where q.IsAccepted = 1
)

select
	it.*,
	p.Value,
	p.UnitsPerHour,
	it.Units * cy.Factor as UnitsPerDay,
	it.Units * cy.Factor * p.Value as PricePerDay,
	case
		when cy.IsSaturday = 1 then
			it.Units * cy.Factor * p.Value * 4.25
		else
			it.Units * cy.Factor * p.Value * 20.83
	end as PricePerMonth
from [archiv].[dbo_SspPriceItem] it
inner join SspGroup sg on sg.Id = it.SspId
inner join [archiv].[dbo_Cycle] cy on cy.Id = it.CycleCodeId
left join Price p on
	p.SspId = sg.MainSspId and
	p.MainCodeId = it.MainCodeId and
	p.CycleCodeId = it.CycleCodeId
GO
CREATE VIEW [archiv].[dbo_MainCodeDetail] as

select 
	mc.Id, 
	mc.Code,
	case
		when 1 = 0 then NULL
		when 1 = 1 then RIGHT('000' + CAST(mc.Code as varchar(3)), 3) 
	end as CodeLabel,
	mc.GroupId,
	mc.IsSspSpecific,
	t.Text as Name, 
	t.Lcid
from [archiv].[dbo_MainCode] mc
inner join [archiv].[dbo_TextDetail] t on mc.NameTextId = t.Id
inner join [archiv].[dbo_MainCodeGroup] [g] on g.Id = mc.GroupId
GO
CREATE VIEW [archiv].[dbo_CycleDetail]
	AS 
SELECT 
	c.[Id],
 c.[Factor],
 c.[NameTextId],
 c.[Code],
 c.[faplisId],
 c.[IsSaturday],
 c.[IsExecution],
 c.[Created],
 c.[Modified],
	CASE
				when 1 = 0 then NULL
				when 1 = 1 then RIGHT('00' + CAST(c.Code as varchar(2)), 2) 
			end as CodeLabel,
			t.Text as Name, 
			t.Lcid
FROM [archiv].[dbo_Cycle] AS c 
INNER JOIN	[archiv].[dbo_TextDetail] AS t ON t.Id = c.NameTextId
GO
CREATE VIEW [archiv].[dbo_SspEffectiveMainCodeDetail] AS
select
	 SspId = ssp.Id
	,MainCodeId = mc.Id
	,MainCodeCode = mc.Code
	,MainCodeName = 
		case
			when sspMC.Name is not null then sspMC.Name
			when mainSspMC.Name is not null then mainSspMC.Name
			else mc.Name
		end
	,MainCodeLabel = mc.CodeLabel
	,Lcid = mc.Lcid
from [archiv].[dbo_ServiceSpecification] ssp
inner join [archiv].[dbo_MainCodeDetail] mc on 1=1 --ensure to expose all existing main codes
left outer join [archiv].[dbo_SspSpecificMainCode] sspMC on ssp.Id = sspMC.SspId and sspMC.MainCodeId = mc.Id
left outer join [archiv].[dbo_SspSpecificMainCode] mainSspMC on ssp.MainSspId = mainSspMC.SspId and mainSspMC.MainCodeId = mc.Id
GO
CREATE VIEW [archiv].[dbo_SspPriceAcceptedDetail] as
select
	ac.*,
	stuff(cast(mc.MainCodeCode as varchar(max)),1,0,REPLICATE('0', 3 - len(mc.MainCodeCode))) + '.' + stuff(cast(cy.Code as varchar(max)),1,0, REPLICATE('0', 2 - LEN(cy.Code))) as Number,
	mc.MainCodeName as MainCodeName,
	cy.Name as CycleCodeName,
	un.[Text] as UnitName,
	l.Lcid
from [archiv].[dbo_SspPriceAccepted] ac
inner join [archiv].[dbo_Language] l on 1 = 1
inner join [archiv].[dbo_SspEffectiveMainCodeDetail] mc on mc.MainCodeId = ac.MainCodeId and mc.SspId = ac.SspId and mc.Lcid = l.Lcid
inner join [archiv].[dbo_CycleDetail] cy on cy.Id = ac.CycleCodeId and cy.Lcid = l.Lcid
inner join [archiv].[dbo_UnitDetail] un on un.Id = ac.UnitId and un.Lcid = l.Lcid
GO
CREATE VIEW [archiv].[dbo_SspPriceAcceptedTotals] as
select 
	 p.SspId
	,TotalPricePerDay = SUM(p.PricePerDay) 
	,TotalPricePerMonth = SUM(p.PricePerMonth) 
from [archiv].[dbo_SspPriceAccepted] p
group by p.SspId
GO
CREATE VIEW [archiv].[dbo_SspPriceItemDetail] as
select
	i.SspId,
	i.MainCodeId,
	i.CycleCodeId,	 
	mcode.MainCodeCode as MainCodeCode,	
	ccd.Code as CycleCodeCode,
	ccd.[Name] AS CycleCodeName,
	mcode.MainCodeName as MainCodeName,	
	i.UnitId,
	sum(i.Units) as Units,
	u.[Text] AS UnitName,
	case 
		when ccd.IsSaturday = 1 then 4.25
		when ccd.IsSaturday = 0 then 20.83
	end as WorkDaysFactor,
	ccd.Factor as Factor,
	la.Lcid
from [archiv].[dbo_SspPriceItem] i
inner join [archiv].[dbo_Language] la on 1 = 1

inner join		[archiv].[dbo_SspEffectiveMainCodeDetail] AS mcode 
on 				i.MainCodeId = mcode.MainCodeId 
and				i.SspId = mcode.SspId
and				mcode.Lcid = la.Lcid

inner join  	[archiv].[dbo_CycleDetail] AS ccd 
on 				i.CycleCodeId = ccd.Id
and				ccd.Lcid = la.Lcid

left join		[archiv].[dbo_UnitDetail] AS u
on				u.Id = i.UnitId
and				u.Lcid = la.Lcid

group by
	i.SspId,
	i.MainCodeId,
	i.CycleCodeId,
	i.UnitId,
	ccd.[Name],
	mcode.MainCodeName,
	mcode.MainCodeCode,
	ccd.Code,
	ccd.IsSaturday,
	ccd.Factor,
	u.[Text],
	la.Lcid
GO
CREATE VIEW [archiv].[dbo_SspPriceQuotedDetail] as

select
	ac.*,
	mc.MainCodeLabel + '.' + cy.CodeLabel as Number,
	mc.MainCodeName as MainCodeName,
	cy.Name as CycleCodeName,		
	un.[Text] as UnitName,
	ac.Units * cy.Factor as UnitsPerDay,
	ac.Units * cy.Factor * ac.Value as PricePerDay,
	case
		when cy.IsSaturday = 1 then
			ac.Units * cy.Factor * ac.Value * 4.25
		else
			ac.Units * cy.Factor * ac.Value * 20.83
	end as PricePerMonth,
	l.Lcid
from [archiv].[dbo_SspPriceQuoted] ac
inner join [archiv].[dbo_Language] l on 1 = 1
inner join [archiv].[dbo_SspEffectiveMainCodeDetail] mc on mc.MainCodeId = ac.MainCodeId and mc.SspId = ac.SspId and mc.Lcid = l.Lcid
inner join [archiv].[dbo_CycleDetail] cy on cy.Id = ac.CycleCodeId and cy.Lcid = l.Lcid
inner join [archiv].[dbo_SspQuote] q on ac.QuoteId = q.Id 
inner join [archiv].[dbo_SspQuoteRequest] qr on q.RequestId = qr.Id
inner join [archiv].[dbo_Supplier] sp on sp.Id = qr.SupplierId
inner join [archiv].[dbo_UnitDetail] un on un.Id = ac.UnitId and un.Lcid = l.Lcid
GO
CREATE VIEW [archiv].[dbo_SscQuoteComparisonQuoteFlat] as
select *
from
(
	select ComparisonId = c.Id from [archiv].[dbo_SspQuoteComparison] c
) qc
cross apply
(
	select
		case row_number() over (order by q.QuoteId) when 1 then '' else ';' end + cast(q.QuoteId as varchar(max))	
	from [archiv].[dbo_SscQuoteComparisonQuote] q
	where q.ComparisonId= qc.ComparisonId
	order by q.QuoteId
	for xml path('')
) ug(QuoteIds)
GO
CREATE VIEW [archiv].[dbo_SscQuoteComparisonDetail]
	AS 
	
SELECT		sqc.*, 	
			u.Name AS CreatedByName,
			opd.Name AS OperationStateName,
			l.Lcid,
			qf.QuoteIds

FROM [archiv].[dbo_SscQuoteComparison] sqc
	INNER JOIN	[archiv].[dbo_Language] l ON sqc.Id = sqc.Id
	INNER JOIN	[archiv].[dbo_OperationStateDetail] opd ON sqc.OperationStateId = opd.Id AND opd.Lcid = l.Lcid
	INNER JOIN	[archiv].[dbo_UserName] u ON sqc.CreatedBy = u.Id
	LEFT OUTER JOIN [archiv].[dbo_SscQuoteComparisonQuoteFlat] qf ON qf.ComparisonId = sqc.Id
GO
CREATE VIEW [archiv].[dbo_SspQuoteComparisonQuoteFlat] as

select *
from
(
	select ComparisonId = c.Id from [archiv].[dbo_SspQuoteComparison] c
) qc
cross apply
(
	select
		case row_number() over (order by q.QuoteId) when 1 then '' else ';' end + cast(q.QuoteId as varchar(max))	
	from [archiv].[dbo_SspQuoteComparisonQuote] q
	where q.ComparisonId= qc.ComparisonId
	order by q.QuoteId
	for xml path('')
) ug(QuoteIds)
GO
CREATE VIEW [archiv].[dbo_SspQuoteComparisonDetail]
	AS 
	
SELECT		sqc.*, 	
			us.Name as CreatorName,			
			opd.Name AS OperationStateName,
			l.Lcid,
			qf.QuoteIds

FROM		[archiv].[dbo_SspQuoteComparison] sqc
INNER JOIN	[archiv].[dbo_Language] l
ON			sqc.Id = sqc.Id
INNER JOIN	[archiv].[dbo_OperationStateDetail] opd
ON			sqc.OperationStateId = opd.Id
AND			opd.Lcid = l.Lcid
INNER JOIN	[archiv].[dbo_UserName] us ON us.Id = sqc.CreatedBy
LEFT OUTER
JOIN		[archiv].[dbo_SspQuoteComparisonQuoteFlat] qf
ON			qf.ComparisonId = sqc.Id
GO
CREATE VIEW [archiv].[dbo_SspQuoteRequestGroupSupplierFlat] as

select *
from
(
	select GroupId = g.Id from [archiv].[dbo_SspQuoteRequestGroup] g
) rg
cross apply
(
	select
		case row_number() over (order by r.SupplierId) when 1 then '' else ';' end + cast(r.SupplierId as varchar(max))	
	from [archiv].[dbo_SspQuoteRequest] r
	where r.GroupId = rg.GroupId
	order by r.GroupId
	for xml path('')

) ug(SupplierIds)
GO
CREATE VIEW [archiv].[dbo_SspQuoteRequestGroupDetail]
	AS 
	
SELECT		sqrg.*,
			u.Name AS CreatorName,
			osd.Name AS OperationStatus,
			sf.SupplierIds as SupplierIds,
			osd.Lcid
FROM		[archiv].[dbo_SspQuoteRequestGroup] sqrg
INNER JOIN	[archiv].[dbo_UserName] u
ON			sqrg.CreatedBy = u.Id
INNER JOIN	[archiv].[dbo_OperationStateDetail] osd
ON			osd.Id = sqrg.OperationStateId
LEFT OUTER 
JOIN		[archiv].[dbo_SspQuoteRequestGroupSupplierFlat] sf
ON			sf.GroupId = sqrg.Id
GO
CREATE VIEW [archiv].[dbo_SscPriceDetail] as

select
	pr.Value,
	pr.QuoteId,
	it.Id as SscItemId,
	it.Code,
	it.[Definition],
	it.[Description],
	it.SscId,
	u.[Text] as UnitName,
	q.IsAccepted,
	l.Lcid,
	ssc.BaseSscId as BaseSscId,
	convert(bit, case
		when it.SupplementSscItemId is null then 0
		else 1 
	end) as IsAcceptedSupplement,
	suppSsc.Id as SupplementSscId
from [archiv].[dbo_SscPrice] pr
inner join [archiv].[dbo_Language] l on 1 = 1
inner join [archiv].[dbo_SscItem] it on it.Id = pr.SscItemId
inner join [archiv].[dbo_UnitDetail] u on u.Id = it.UnitId and u.Lcid = l.Lcid
inner join [archiv].[dbo_SscQuote] q on q.Id = pr.QuoteId
inner join [archiv].[dbo_StandardServicesCatalog] ssc on it.SscId = ssc.Id
left join [archiv].[dbo_SscItem] suppSscItem on it.SupplementSscItemId = suppSscItem.Id
left join [archiv].[dbo_StandardServicesCatalog] suppSsc on suppSscItem.SscId = suppSsc.Id
union all
select
	null as Value,
	null as QuoteId,
	it.Id as SscItemId,
	it.Code,
	it.[Definition],
	it.[Description],
	it.SscId,
	u.[Text] as UnitName,
	cast(0 as bit) as IsAccepted,
	l.Lcid,
	ssc.BaseSscId as BaseSscId,
	convert(bit, case
		when it.SupplementSscItemId is null then 0
		else 1 
	end) as IsAcceptedSupplement,
	suppSsc.Id as SupplementSscId
from [archiv].[dbo_SscItem] it
inner join [archiv].[dbo_Language] l on 1 = 1
inner join [archiv].[dbo_UnitDetail] u on u.Id = it.UnitId and u.Lcid = l.Lcid
inner join [archiv].[dbo_StandardServicesCatalog] ssc on it.SscId = ssc.Id
left join [archiv].[dbo_SscItem] suppSscItem on it.SupplementSscItemId = suppSscItem.Id
left join [archiv].[dbo_StandardServicesCatalog] suppSsc on suppSscItem.SscId = suppSsc.Id
union all
select
	null as Value,
	null as QuoteId,
	it.Id as SscItemId,
	it.Code,
	it.[Definition],
	it.[Description],
	it.SscId,
	u.[Text] as UnitName,
	cast(1 as bit) as IsAccepted,
	l.Lcid,
	ssc.BaseSscId as BaseSscId,
	convert(bit, case
		when it.SupplementSscItemId is null then 0
		else 1 
	end) as IsAcceptedSupplement,
	suppSsc.Id as SupplementSscId
from [archiv].[dbo_SscItem] it
inner join [archiv].[dbo_Language] l on 1 = 1
inner join [archiv].[dbo_UnitDetail] u on u.Id = it.UnitId and u.Lcid = l.Lcid
inner join [archiv].[dbo_StandardServicesCatalog] ssc on it.SscId = ssc.Id
left join [archiv].[dbo_SscItem] suppSscItem on it.SupplementSscItemId = suppSscItem.Id
left join [archiv].[dbo_StandardServicesCatalog] suppSsc on suppSscItem.SscId = suppSsc.Id
GO
CREATE VIEW [archiv].[dbo_SscPriceQuotedDetail] as

select 
	prices.SscId,
	prices.SscItemId,
	prices.QuoteId,
	prices.Value,
	convert(bit, prices.IsAccepted) as IsAccepted,
	prices.SupplierId,
	l.Lcid,
	u.[Text] as UnitName,
	ssc.BaseSscId as BaseSscId,
	sscItem.Code,
	sscItem.[Definition],
	sscItem.[Description],
	sscItem.SupplementSscItemId,
	convert(bit, case
		when sscItem.SupplementSscItemId is null then 0
		else 1 
	end) as IsAcceptedSupplement,
	suppSsc.Id as SupplementSscId
from (
	select
		it.SscId,
		it.Id as SscItemId,
		pr.Value,
		pr.QuoteId,
		q.IsAccepted,
		r.SupplierId
	from [archiv].[dbo_SscPrice] pr
	left join [archiv].[dbo_SscItem] it on it.Id = pr.SscItemId
	inner join [archiv].[dbo_SscQuote] q on pr.QuoteId = q.Id
	inner join [archiv].[dbo_SscQuoteRequest] r on r.Id = q.RequestId
	union all
	select
		it.SscId,
		it.Id as SscItemId,
		null as Value,
		null as QuoteId,
		0 as IsAccepted,
		null as SupplierId
	from [archiv].[dbo_SscItem] it) 
	as prices
	inner join [archiv].[dbo_Language] l on 1 = 1
	inner join [archiv].[dbo_StandardServicesCatalog] ssc on prices.SscId = ssc.Id
	inner join [archiv].[dbo_SscItem] sscItem on prices.SscItemId = sscItem.Id
	inner join[archiv].[dbo_UnitDetail] u on u.Id = sscItem.UnitId and u.Lcid = l.Lcid
	
	left join [archiv].[dbo_SscItem] suppSscItem on sscItem.SupplementSscItemId = suppSscItem.Id
	left join [archiv].[dbo_StandardServicesCatalog] suppSsc on suppSscItem.SscId = suppSsc.Id

where prices.IsAccepted = 0
GO
CREATE VIEW [archiv].[dbo_SscQuoteRequestDetail] as

select
	r.*,
	c.Name as CreatedByName,
	l.Lcid,
	s.Code as SupplierCode,
	s.Name as SupplierName,
	g.ReplyBy
from [archiv].[dbo_SscQuoteRequest] r
inner join [archiv].[dbo_Language] l on 1 = 1
inner join [archiv].[dbo_UserName] c on c.Id = r.CreatedBy
inner join [archiv].[dbo_Supplier] s on s.Id = r.SupplierId
inner join [archiv].[dbo_SscQuoteRequestGroup] g on g.Id = r.GroupId
GO
CREATE VIEW [archiv].[dbo_SscQuoteRequestGroupDetail] as
select
	g.*,
	o.Name as OperationStateName,
	cast(null as nvarchar(max)) SupplierIds,
	l.Lcid,
	u.Name AS CreatedByName,
	convert(bit, case
		when g.SupplementSscId is null then 0
		else 1 
	end) as IsAcceptedSupplement
from [archiv].[dbo_SscQuoteRequestGroup] g
inner join [archiv].[dbo_Language] l on 1 = 1
inner join [archiv].[dbo_OperationStateDetail] o on o.Id = g.OperationStateId and o.Lcid = l.Lcid
inner join [archiv].[dbo_UserName] u on u.Id = g.CreatedBy
GO
CREATE VIEW [archiv].[dbo_SspQuoteDetail]
	AS 

SELECT	sq.*,
			u.Name as CreatorName,
			supp.Code AS SupplierCode,
			supp.Name AS SupplierName,
			osd.Name AS OperationStatus,
			g.SspId AS SspId,
			l.Lcid
FROM		[archiv].[dbo_SspQuote] sq
INNER JOIN	[archiv].[dbo_Language] l 
on			1 = 1
INNER JOIN	[archiv].[dbo_UserName] u
ON			sq.CreatedBy = u.Id  
INNER JOIN	[archiv].[dbo_SspQuoteRequest] sqr 
ON			sq.RequestId = sqr.Id
inner join	[archiv].[dbo_SspQuoteRequestGroup] g
ON			g.Id = sqr.GroupId
INNER JOIN	[archiv].[dbo_Supplier] supp
ON			sqr.SupplierId = supp.Id 
INNER JOIN	[archiv].[dbo_OperationStateDetail] osd
ON			osd.Id = sq.OperationStateId
AND			osd.Lcid = l.Lcid
GO
CREATE VIEW [archiv].[dbo_SspQuoteRequestDetail]
	AS 
 
SELECT		sqr.*,
			u.Name as CreatorName,
			supp.Code AS SupplierCode,
			supp.Name AS SupplierName,
			sqrg.ReplyBy
FROM		[archiv].[dbo_SspQuoteRequest] sqr
INNER JOIN	[archiv].[dbo_UserName] u
ON			sqr.CreatedBy = u.Id 
INNER JOIN	[archiv].[dbo_Supplier] supp
ON			sqr.SupplierId = supp.Id
INNER JOIN	[archiv].[dbo_SspQuoteRequestGroup] sqrg
ON			sqrg.Id = sqr.GroupId
GO



CREATE NONCLUSTERED INDEX [IDX_WorkOrder_PoId]
ON [archiv].[dbo_WorkOrder] ([PoId])
INCLUDE ([Id],[OrderNo],[ContractingDate],[StateId],[AdditionalInfo],[SupplierReferenceNo],[PmNo],[Created],[Modified],[CreatedBy],[ModifiedBy],[Version],[WoCategoryId])
GO

DECLARE @dtagid INT
SELECT @dtagid = [id] FROM [archiv].[dbo_company] WHERE [Code] = N'DTAG'
DECLARE @mbagid INT
SELECT @mbagid = [id] FROM [archiv].[dbo_company] WHERE [Code] = N'MBAG'

--fix wrong supplier-ids (wrong company) in EPKs

PRINT 'fix wrong supplier-ids (wrong company) in EPKs'

UPDATE t1
SET t1.[supplierId] = dtagsupplier.[id]
FROM [archiv].[dbo_StandardServicesCatalog] t1
INNER JOIN (SELECT * FROM [archiv].[dbo_Supplier] WHERE [CompanyId] = @mbagid) mbagsupplier
	ON mbagsupplier.[id] = t1.[supplierId]
INNER JOIN (SELECT * FROM [archiv].dbo_Supplier WHERE [CompanyId] = @dtagid) dtagsupplier
	ON dtagsupplier.[code] = mbagsupplier.[code]
WHERE t1.[supplierId] IN (SELECT [Id] FROM [archiv].[dbo_Supplier] WHERE [CompanyId] = @mbagid)		-- only when assigned supplier is a MB-supplier (reduntant to first join)
AND t1.[Id] IN (SELECT [SscId] FROM [archiv].[dbo_PurchaseOrder] WHERE [CompanyId] = @dtagid)		-- only when EPK contains to a Purchaseorder for Truck
AND t1.[Id] IN (SELECT [SscId] FROM [archiv].[dbo_SscCompany] WHERE [CompanyId] = @dtagid)			-- only when EPK contains to Truck

UPDATE t1
SET t1.[supplierId] = dtagsupplier.[id]
FROM [archiv].[dbo_SscQuoteRequest] t1
INNER JOIN (SELECT * FROM [archiv].[dbo_Supplier] WHERE [CompanyId] = @mbagid) mbagsupplier
	ON mbagsupplier.[id] = t1.[supplierId]
INNER JOIN (SELECT * FROM [archiv].dbo_Supplier WHERE [CompanyId] = @dtagid) dtagsupplier
	ON dtagsupplier.[code] = mbagsupplier.[code]
WHERE t1.[supplierId] IN (SELECT [Id] FROM [archiv].[dbo_Supplier] WHERE [CompanyId] = @mbagid)		-- only when assigned supplier is a MB-supplier (reduntant to first join)
AND t1.[GroupId] IN (SELECT [id] FROM [archiv].[dbo_SscQuoteRequestGroup] WHERE [SscId] IN (327, 382, 383, 432))


--EPK
PRINT 'WoItem'
DELETE FROM [archiv].[dbo_WoItem] WHERE [WoId] NOT IN (SELECT [Id] FROM  [archiv].[dbo_WorkOrder] WHERE [PoId] IN (SELECT [id] FROM [archiv].[dbo_PurchaseOrder] WHERE [CompanyId] = @dtagid))
PRINT 'WorkOrder'
DELETE FROM [archiv].[dbo_WorkOrder] WHERE [PoId] NOT IN (SELECT [id] FROM [archiv].[dbo_PurchaseOrder] WHERE [CompanyId] = @dtagid)
PRINT 'SscPrice'
DELETE FROM [archiv].[dbo_SscPrice] WHERE [SscItemId] NOT IN (SELECT [Id] FROM  [archiv].[dbo_SscItem] WHERE [SscId] IN (SELECT [SscId] FROM  [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) = @dtagid))
PRINT 'SscQuote'
DELETE FROM [archiv].[dbo_sscQuote] WHERE [RequestId] NOT IN (SELECT [Id] FROM [archiv].[dbo_SscQuoteRequest] WHERE [GroupId] IN (SELECT [Id] FROM [archiv].[dbo_SscQuoteRequestGroup] WHERE [SscId] IN (SELECT [SscId] FROM  [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) = @dtagid)))
PRINT 'SscQuoteRequest'
DELETE FROM [archiv].[dbo_SscQuoteRequest] WHERE [GroupId] NOT IN (SELECT [Id] FROM [archiv].[dbo_SscQuoteRequestGroup] WHERE [SscId] IN (SELECT [SscId] FROM  [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) = @dtagid))
PRINT 'SscQuoteRequestGroup'
DELETE FROM [archiv].[dbo_SscQuoteRequestGroup] WHERE [SscId] NOT IN (SELECT [SscId] FROM  [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) = @dtagid)
PRINT 'SscItem'
DELETE FROM [archiv].[dbo_SscItem] WHERE [SscId] NOT IN (SELECT [SscId] FROM [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) = @dtagid)
PRINT 'Ssc'
DELETE FROM [archiv].[dbo_StandardServicesCatalog] WHERE [id] NOT IN (SELECT [SscId] FROM [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) = @dtagid)
PRINT 'SscCompany'
DELETE FROM [archiv].[dbo_SscCompany] WHERE ISNULL([CompanyId],0) <> @dtagid

--LV
PRINT 'SspPrice'
DELETE FROM [archiv].[dbo_SspPrice] WHERE [SspQuoteId] NOT IN (SELECT [Id] FROM [archiv].[dbo_SspQuote] WHERE [RequestId] IN (SELECT [Id] FROM [archiv].[dbo_SspQuoteRequest] WHERE [GroupId] IN (SELECT [Id] FROM [archiv].[dbo_SspQuoteRequestGroup] WHERE [SspId] IN (SELECT [SspId] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @dtagid))))
PRINT 'SspQuote'
DELETE FROM [archiv].[dbo_SspQuote] WHERE [RequestId] NOT IN (SELECT [Id] FROM [archiv].[dbo_SspQuoteRequest] WHERE [GroupId] IN (SELECT [Id] FROM [archiv].[dbo_SspQuoteRequestGroup] WHERE [SspId] IN (SELECT [SspId] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @dtagid)))
PRINT 'SspQuoteRequest'
DELETE FROM [archiv].[dbo_SspQuoteRequest] WHERE [GroupId] NOT IN (SELECT [Id] FROM [archiv].[dbo_SspQuoteRequestGroup] WHERE [SspId] IN (SELECT [SspId] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @dtagid))
PRINT 'SspQuoteRequestGroup'
DELETE FROM [archiv].[dbo_SspQuoteRequestGroup] WHERE [SspId] NOT IN (SELECT [SspId] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @dtagid)
PRINT 'InspectionItem'
DELETE FROM [archiv].[dbo_InspectionItem] WHERE [SspItemId] NOT IN (SELECT [Id] FROM [archiv].[dbo_SspItem] WHERE [SspId] IN (SELECT [SspId] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @dtagid))
PRINT 'SspItem'
DELETE FROM [archiv].[dbo_SspItem] WHERE [SspId] NOT IN (SELECT [SspId] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @dtagid)
PRINT 'Ssp'
DELETE FROM [archiv].[dbo_ServiceSpecification] WHERE [Id] NOT IN (SELECT [SspId] FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) = @dtagid)
PRINT 'SspCompany'
DELETE FROM [archiv].[dbo_SspCompany] WHERE ISNULL([CompanyId],0) <> @dtagid
PRINT 'SspRelease'
DELETE FROM [archiv].[dbo_SspRelease] WHERE ISNULL([CompanyId],0) <> @dtagid

--sonst
PRINT 'Supplier'
DELETE FROM [archiv].[dbo_Supplier] WHERE ISNULL([CompanyId],0) <> @dtagid
PRINT 'UserCompany'
DELETE FROM [archiv].[dbo_UserCompany] WHERE ISNULL([CompanyId],0) <> @dtagid
PRINT 'KPIAreaHistory'
DELETE FROM [archiv].[dbo_KPIAreaHistory] WHERE ISNULL([CompanyId],0) <> @dtagid
PRINT 'KPIBILLHistory'
DELETE FROM [archiv].[dbo_KPIBillHistory] WHERE ISNULL([CompanyId],0) <> @dtagid
PRINT 'KPIBillHistory'
DELETE FROM [archiv].[dbo_KPIReportHistory] WHERE ISNULL([CompanyId],0) <> @dtagid
PRINT 'PurchaseOrder'
DELETE FROM [archiv].[dbo_PurchaseOrder] WHERE ISNULL([CompanyId],0) <> @dtagid

--Aufmasse
PRINT 'Measurement for not TruckLocations'
DELETE FROM [archiv].[dbo_Measurement] WHERE [SubPlantId] IS NOT NULL AND [SubPlantId] NOT IN (SELECT [SubPlantId] FROM [archiv].[faplis_Subplant_V] WHERE [SubPlantFunctionalId] IN (SELECT [Id] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [DLM30Faplis].[mig].[truckLocation] WHERE [IdLegalEntity] = 1))
PRINT 'InternalMeasurement for not TruckLocations'
DELETE FROM [archiv].[dbo_InternalMeasurement] WHERE [SubPlantId] IS NOT NULL AND [SubPlantId] NOT IN (SELECT [SubPlantId] FROM [archiv].[faplis_Subplant_V] WHERE [SubPlantFunctionalId] IN (SELECT [Id] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [DLM30Faplis].[mig].[truckLocation] WHERE [IdLegalEntity] = 1))
PRINT 'WoItems for not TruckLocations'
DELETE FROM [archiv].[dbo_WoItem] WHERE [SubPlantId] IS NOT NULL AND [SubPlantId] NOT IN (SELECT [SubPlantId] FROM [archiv].[faplis_Subplant_V] WHERE [SubPlantFunctionalId] IN (SELECT [Id] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [DLM30Faplis].[mig].[truckLocation] WHERE [IdLegalEntity] = 1))
PRINT 'Elevations'
DELETE FROM [archiv].[faplis_Elevation] WHERE [Id] NOT IN (SELECT [ElevationId] FROM [archiv].[faplis_Elevation_V] WHERE [SubPlantFunctionalId] IN (SELECT [Id] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [DLM30Faplis].[mig].[truckLocation] WHERE [IdLegalEntity] = 1))
PRINT 'Floors'
DELETE FROM [archiv].[faplis_Floor] WHERE [Id] NOT IN (SELECT [FloorId] FROM [archiv].[faplis_Floor_V] WHERE [SubPlantFunctionalId] IN (SELECT [Id] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [DLM30Faplis].[mig].[truckLocation] WHERE [IdLegalEntity] = 1))
PRINT 'SubBuildings'
DELETE FROM [archiv].[faplis_SubBuilding] WHERE [Id] NOT IN (SELECT [SubBuildingId] FROM [archiv].[faplis_SubBuilding_V] WHERE [SubPlantFunctionalId] IN (SELECT [Id] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [DLM30Faplis].[mig].[truckLocation] WHERE [IdLegalEntity] = 1))
PRINT 'Buildings'
DELETE FROM [archiv].[faplis_Building] WHERE [Id] NOT IN (SELECT [BuildingId] FROM [archiv].[faplis_Building_V] WHERE [SubPlantFunctionalId] IN (SELECT [Id] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [DLM30Faplis].[mig].[truckLocation] WHERE [IdLegalEntity] = 1))
PRINT 'SubPlants'
DELETE FROM [archiv].[faplis_SubPlant] WHERE [Id] NOT IN (SELECT [SubPlantId] FROM [archiv].[faplis_SubPlant_V] WHERE [SubPlantFunctionalId] IN (SELECT [Id] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [DLM30Faplis].[mig].[truckLocation] WHERE [IdLegalEntity] = 1))



