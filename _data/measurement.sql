BEGIN --collect measurements

    PRINT '    fill areas'

    DROP TABLE IF EXISTS [mig].[mapAreaMeasurement]

     --create temp migration-table checksum (hash) for all relevant columns as column-function

    DECLARE @rowcount BIGINT
     
    CREATE TABLE [mig].[mapAreaMeasurement](
	    [id] INT IDENTITY(1,1) NOT NULL,
        [dlm3Id] INT NULL,
	    --[IsActive] BIT NOT NULL,
	    [RoomNo] VARCHAR(40) NULL,
	    [UsageTypeId] INT NULL,
	    [Units] [decimal](10, 2) NULL,
	    [Comment] VARCHAR(200) NULL,
	    [WeightingFactor] [decimal](10, 5) NULL,
	    [Axis] VARCHAR(20) NULL,
	    [Note] VARCHAR(80) NULL,
	    [Manual] BIT NULL,
	    [ShapeId] INT NULL,
	    [FileName] VARCHAR(255) NULL,
	    [BuildingCostId] INT NULL,
	    [IsWinterService] BIT NOT NULL,
	    [FlooringDescr] VARCHAR(80) NULL,
	    [PlantId] INT NOT NULL,
	    [SubPlantId] INT NOT NULL,
	    [BuildingId] INT NULL,
	    [SubBuildingId] INT NULL,
	    [FloorId] INT NULL,
	    [ElevationId] INT NULL,
	    [DoorNo] NVARCHAR(20) NULL,
	    [TechnLocation] NVARCHAR(50) NULL,
	    [Customer] NVARCHAR(30) NULL,
	    [OrgLevel2] NVARCHAR(20) NULL,
	    [CostId] NVARCHAR(20) NULL,
	    [Cycle] NVARCHAR(30) NULL,
	    [Flooring] NVARCHAR(30) NULL,
	    [CreationDate] DATETIME NULL,
	    [ModifyDate] DATETIME NULL,
        [sspItemIds] NVARCHAR(MAX) NULL,
        [woItemIds] NVARCHAR(MAX) NULL,
        [measurementIds] NVARCHAR(MAX) NULL,
    )

    CREATE CLUSTERED INDEX [x_mapAreaMeasurement_id] ON [mig].[mapAreaMeasurement]
    (
	    [id] ASC
    )
    
    --insert distinct relevant values from [Measurement]-table into temp migration-table

    INSERT INTO [mig].[mapAreaMeasurement] (
        --[IsActive]
        --,[RoomNo]
        [RoomNo]
        ,[UsageTypeId]
        ,[Units]
        ,[Comment]
        ,[WeightingFactor]
        ,[Axis]
        ,[Note]
        ,[Manual]
        ,[ShapeId]
        ,[FileName]
        ,[BuildingCostId]
        ,[IsWinterService]
        ,[FlooringDescr]
        ,[PlantId] 
        ,[SubPlantId]
        ,[BuildingId]
        ,[SubBuildingId]
        ,[FloorId]
        ,[ElevationId]
        ,[DoorNo]
        ,[TechnLocation]
        ,[Customer]
        ,[OrgLevel2]
        ,[CostId]
        ,[Cycle]
        ,[Flooring]
        ,[CreationDate]
        ,[ModifyDate]
        ,[sspItemIds] 
        ,[woItemIds]
        ,[measurementIds]
    )
    SELECT 
        [RoomNo]
        ,[UsageTypeId]
        ,[Units]
        ,[Comment]
        ,[WeightingFactor]
        ,[Axis]
        ,[Note]
        ,[Manual]
        ,[ShapeId]
        ,[FileName]
        ,[BuildingCostId]
        ,[IsWinterService]
        ,[FlooringDescr]
        ,[PlantId] 
        ,[SubPlantId]
        ,[BuildingId]
        ,[SubBuildingId]
        ,[FloorId]
        ,[ElevationId]
        ,[DoorNo]
        ,[TechnLocation]
        ,[Customer]
        ,[OrgLevel2]
        ,[CostId]
        ,[Cycle]
        ,[Flooring]
        ,MAX([CreationDate]) AS [CreationDate]
        ,MAX([ModifyDate]) AS [ModifyDate]
        ,STRING_AGG(CAST([sspItemId] AS NVARCHAR(MAX)),',') AS [sspItemIds]
        ,STRING_AGG(CAST([woItemId] AS NVARCHAR(MAX)),',') AS [woItemIds]
        ,STRING_AGG(CAST([measurementId] AS NVARCHAR(MAX)),',') AS [measurementIds]
    FROM 
    (
        SELECT
            [RoomNo]
            ,[UsageTypeId]
            ,[Units]
            ,[Comment]
            ,[WeightingFactor]
            ,[Axis]
            ,[Note]
            ,[Manual]
            ,[ShapeId]
            ,[FileName]
            ,[BuildingCostId]
            ,[IsWinterService]
            ,[FlooringDescr]
            ,ISNULL([PlantId] ,0) AS [PlantId]
            ,ISNULL([SubPlantId],0) AS [SubPlantId]
            ,ISNULL([BuildingId],0) AS [BuildingId]
            ,ISNULL([SubBuildingId],0) AS [SubBuildingId]
            ,ISNULL([FloorId],0) AS [FloorId]
            ,ISNULL([ElevationId],0) AS [ElevationId]
            ,[DoorNo]
            ,[TechnLocation]
            ,[Customer]
            ,[OrgLevel2]
            ,[CostId]
            ,[Cycle]
            ,[Flooring]
            ,ISNULL([CreationDate],CONVERT(DATETIME,'20000101',112)) AS [CreationDate]
            ,[ModifyDate]
            ,[sspItemId]
            ,NULL AS [woItemId]
            ,[id] AS [measurementId]
        FROM [archiv].[dbo_Measurement]
        WHERE [ShapeId] IS NOT NULL
        AND [FileName] IS NOT NULL
        AND ISNULL([manual],0) = 0
        --AND [SspItemId] NOT IN (SELECT [id] FROM [archiv].[dbo_SspItem] WHERE ISNULL([isActive],0) = 0)
        UNION ALL 
        SELECT   
            [Room] AS [RoomNo]
            ,[UsageTypeId]
            ,[Units]
            ,[Comment]
            ,NULL AS [WeightingFactor]
            ,[Axis]
            ,[Note]
            ,[IsManual] AS [Manual]
            ,ISNULL([ShapeId],0)
            ,ISNULL([FileName],'n/a') 
            ,[BuildingCostId]
            ,[IsWinterService]
            ,[FlooringDescr]
            ,ISNULL([PlantId] ,0) AS [PlantId]
            ,ISNULL([SubPlantId],0) AS [SubPlantId]
            ,ISNULL([BuildingId],0) AS [BuildingId]
            ,ISNULL([SubBuildingId],0) AS [SubBuildingId]
            ,ISNULL([FloorId],0) AS [FloorId]
            ,ISNULL([ElevationId],0) AS [ElevationId]
            ,[DoorNo]
            ,[TechnLocation]
            ,[Customer]
            ,[OrgLevel2]
            ,[CostId]
            ,[Cycle]
            ,[Flooring]
            ,ISNULL([CreationDate],CONVERT(DATETIME,'20000101',112)) AS [CreationDate]
            ,[ModifyDate]
            ,NULL AS[sspItemId]
            ,[id] AS [woItemId]
            ,0 AS [measurementId]
        FROM [archiv].[dbo_WoItem] woi
        WHERE [InternalMeasurementId] IS NULL
        AND woi.[IsManual] <> 1
        AND ISNULL(woi.[InternalMeasurementId],0) = 0
        --AND [FileName] IS NOT NULL
        --AND [ShapeId] IS NOT NULL
        --AND [SscItemId] NOT IN (SELECT [id] FROM [archiv].[dbo_SscItem] WHERE [SscId] IN (SELECT [id] FROM [archiv].[dbo_StandardServicesCatalog] WHERE ISNULL([isActive],0) = 0))
    ) q
    GROUP BY
            [RoomNo]
            ,[UsageTypeId]
            ,[Units]
            ,[Comment]
            ,[WeightingFactor]
            ,[Axis]
            ,[Note]
            ,[Manual]
            ,[ShapeId]
            ,[FileName]
            ,[BuildingCostId]
            ,[IsWinterService]
            ,[FlooringDescr]
            ,[PlantId] 
            ,[SubPlantId]
            ,[BuildingId]
            ,[SubBuildingId]
            ,[FloorId]
            ,[ElevationId]
            ,[DoorNo]
            ,[TechnLocation]
            ,[Customer]
            ,[OrgLevel2]
            ,[CostId]
            ,[Cycle]
            ,[Flooring]

    SET @rowcount = @@ROWCOUNT

    PRINT '   ' + CAST(@rowcount AS NVARCHAR) + ' records'

    PRINT '    fill mapping areas SspItems'

    DROP TABLE IF EXISTS [mig].[mapAreaSspItem]
    
    SELECT 
        [id] AS [dlm3AreaId]
        ,CAST(LTRIM(RTRIM([value])) AS INT) AS [dlm2SspItemId]
    INTO [mig].[mapAreaSspItem] 
    FROM [mig].[mapAreaMeasurement] 
    CROSS APPLY STRING_SPLIT([sspItemIds],',')

    SET @rowcount = @@ROWCOUNT
   
    PRINT '   ' + CAST(@rowcount AS NVARCHAR) + ' records'

    CREATE CLUSTERED INDEX [ix_mapAreaSspItem_sspItemid] ON [mig].[mapAreaSspItem]
    (
	    [dlm2SspItemId] ASC
    )

    PRINT '    fill mapping areas WoItems'

    DROP TABLE IF EXISTS [mig].[mapAreaWoItem]

    SELECT 
        [id] AS [dlm3AreaId]
        ,CAST(LTRIM(RTRIM([value])) AS INT) AS [dlm2WoItemId]
    INTO [mig].[mapAreaWoItem]
    FROM [mig].[mapAreaMeasurement]
    CROSS APPLY STRING_SPLIT([woItemIds],',')

    SET @rowcount = @@ROWCOUNT
   
    PRINT '   ' + CAST(@rowcount AS NVARCHAR) + ' records'

    CREATE CLUSTERED INDEX [ix_mapAreaWoItem_woItemid] ON [mig].[mapAreaWoItem]
    (
	    [dlm2WoItemId] ASC
    )


    PRINT '    fill mapping areas MeasurementStatus'

    DROP TABLE IF EXISTS [mig].[mapAreaMeasurementStatus]

    SELECT a.[dlm3AreaId],m.[id] AS [dlm2MeasurementId],m.[isActive]
    INTO [mig].[mapAreaMeasurementStatus]
    FROM (
        SELECT DISTINCT
            [id] AS [dlm3AreaId]
            ,CAST(LTRIM(RTRIM([value])) AS INT) AS [dlm2MeasurementId]
        FROM [mig].[mapAreaMeasurement] m
        CROSS APPLY STRING_SPLIT([measurementIds],',')
    ) a
    INNER JOIN [archiv].[dbo_Measurement] m
        ON m.[id] = a.[dlm2MeasurementId]


    CREATE NONCLUSTERED INDEX [ix_mapAreaMeasurementStatus_measurementId] ON [mig].[mapAreaMeasurementStatus]
    (
	    [dlm2MeasurementId] ASC
    )

    CREATE NONCLUSTERED INDEX [ix_mapAreaMeasurementStatus_areaId] ON [mig].[mapAreaMeasurementStatus]
    (
	    [dlm3AreaId] ASC
    )

    SELECT @rowcount = COUNT(1) FROM [mig].[mapAreaMeasurementStatus]
   
    PRINT '   ' + CAST(@rowcount AS NVARCHAR) + ' records'

    PRINT '    set MeasurementStatus'

END --collect measurements
GO

