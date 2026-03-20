BEGIN --location

    DECLARE @msg NVARCHAR(MAX)
    
    SET @msg = '   fill Location'
    PRINT @msg

    DECLARE @rowCount INT

    DROP TABLE IF EXISTS [mig].[mapSubPlantSubPlant]
    CREATE TABLE [mig].[mapSubPlantSubPlant] (dlm2Id INT, dlm3Id INT)

	DROP TABLE IF EXISTS [mig].[mapBuildingBuilding]
    CREATE TABLE [mig].[mapBuildingBuilding] (dlm2Id INT, dlm3Id INT)

	DROP TABLE IF EXISTS [mig].[mapSubBuildingSubBuilding]
    CREATE TABLE [mig].[mapSubBuildingSubBuilding] (dlm2Id INT, dlm3Id INT)

	DROP TABLE IF EXISTS [mig].[mapFloorFloor]
    CREATE TABLE [mig].[mapFloorFloor] (dlm2Id INT, dlm3Id INT)

	DROP TABLE IF EXISTS [mig].[mapElevationElevation]
    CREATE TABLE [mig].[mapElevationElevation] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [etl].[stageLocation]
    
    SET @msg = '     fill Location SubPlant'
    PRINT @msg

    MERGE INTO [loc].[location] t
    USING
    (
        SELECT 
            ISNULL(REPLACE(REPLACE(v.[SubPlantFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1400000000000 + v.[SubPlantId] AS NVARCHAR)) AS [faplisId]
            ,MAX(v.[SubPlantId]) AS [dlm2Id]
            ,MAX(v.[SubPlantName]) COLLATE SQL_Latin1_General_CP1_CI_AS AS [name]
            ,MAX(v.[SubPlantCode]) COLLATE SQL_Latin1_General_CP1_CI_AS AS [code]
            ,MAX(CAST(ISNULL(v.[isActive],0) AS INT)) AS [isActive]
            ,N'subplant' AS [type]
        FROM [archiv].[faplis_subPlant_V] v 
        GROUP BY ISNULL(REPLACE(REPLACE(v.[SubPlantFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1400000000000 + v.[SubPlantId] AS NVARCHAR))
    ) s
    ON s.[faplisId] = t.[faplisId]
    WHEN NOT MATCHED THEN
        INSERT ([name],[code],[isActive],[faplisId],[type])
        VALUES (s.[name],s.[code],s.[isActive],s.[faplisId],s.[type])
    WHEN MATCHED THEN
        UPDATE SET
            t.[name] = s.[name]
            ,t.[code] = s.[code]
            ,t.[isActive] = s.[isActive]
    OUTPUT s.[dlm2Id],inserted.[id]
    INTO [mig].[mapSubPlantSubPlant]([dlm2Id],[dlm3Id])
    ;

    MERGE INTO [mig].[mapSubPlantSubPlant] t
    USING (
        SELECT 
            loc.[id] AS [dlm3Id]
            ,v.[subPlantFunctionalId]
            ,v.[subPlantId] AS [dlm2Id]
        FROM [loc].[location] loc
        INNER JOIN [archiv].[faplis_Subplant_V] v
            ON v.[subPlantFunctionalId]  COLLATE SQL_Latin1_General_CP1_CI_AS = loc.[faplisId]
    ) s
    ON s.[dlm3Id] = t.[dlm3Id]
    AND s.[dlm2Id] = t.[dlm2Id]
    WHEN NOT MATCHED THEN
        INSERT ([dlm2Id],[dlm3Id])
        VALUES (s.[dlm2Id],s.[dlm3Id]);

    SELECT @rowCount = COUNT(1) FROM  [mig].[mapSubPlantSubPlant]

    PRINT '       ' + CAST(@rowcount AS NVARCHAR) + ' records'

    SET @msg = '     fill Location Building'
    PRINT @msg

    MERGE INTO [loc].[location] t
    USING
    (
        SELECT 
            ISNULL(REPLACE(REPLACE(v.[BuildingFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1500000000000 + v.[BuildingId] AS NVARCHAR)) AS [faplisId]
            ,MAX(v.[BuildingId]) AS [dlm2Id]
            ,MAX(v.[BuildingName]) COLLATE SQL_Latin1_General_CP1_CI_AS AS [name]
            ,MAX(v.[BuildingCode]) COLLATE SQL_Latin1_General_CP1_CI_AS AS [code]
            ,MAX(CAST(ISNULL(v.[isActive],0) AS INT)) AS [isActive]
            ,MAX(p.[dlm3Id]) AS [parentId]
            ,N'building' AS [type]
        FROM [archiv].[faplis_Building_V] v
        INNER JOIN mig.[mapSubPlantSubPlant] p
            ON p.[dlm2Id] = v.[SubPlantId]
        GROUP BY ISNULL(REPLACE(REPLACE(v.[BuildingFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1500000000000 + v.[BuildingId] AS NVARCHAR))
    ) s
    ON s.[faplisId] = t.[faplisId]
    WHEN NOT MATCHED THEN
        INSERT ([name],[code],[isActive],[faplisId],[parentId],[type])
        VALUES (s.[name],s.[code],s.[isActive],s.[faplisId],s.[parentId],s.[type])
    WHEN MATCHED THEN
        UPDATE SET
            t.[name] = s.[name]
            ,t.[code] = s.[code]
            ,t.[isActive] = s.[isActive]
            ,t.[parentId] = s.[parentId]
    OUTPUT s.[dlm2Id],inserted.[id]
    INTO [mig].[mapBuildingBuilding]([dlm2Id],[dlm3Id])
    ;

    MERGE INTO [mig].[mapBuildingBuilding] t
    USING (
        SELECT 
            loc.[id] AS [dlm3Id]
            ,v.[buildingFunctionalId]
            ,v.[buildingId] AS [dlm2Id]
        FROM [loc].[location] loc
        INNER JOIN [archiv].[faplis_Building_V] v
            ON v.[buildingFunctionalId]  COLLATE SQL_Latin1_General_CP1_CI_AS = loc.[faplisId]
    ) s
    ON s.[dlm3Id] = t.[dlm3Id]
    AND s.[dlm2Id] = t.[dlm2Id]
    WHEN NOT MATCHED THEN
        INSERT ([dlm2Id],[dlm3Id])
        VALUES (s.[dlm2Id],s.[dlm3Id]);


    SELECT @rowCount = COUNT(1) FROM  [mig].[mapBuildingBuilding]

    PRINT '       ' + CAST(@rowcount AS NVARCHAR) + ' records'

    SET @msg = '     fill Location SubBuilding'
    PRINT @msg

    MERGE INTO [loc].[location] t
    USING
    (
        SELECT 
            ISNULL(REPLACE(REPLACE(v.[SubBuildingFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1600000000000 + v.[SubBuildingId] AS NVARCHAR)) AS [faplisId]
            ,MAX(v.[SubBuildingId]) AS [dlm2Id]
            ,MAX(v.[SubBuildingName]) COLLATE SQL_Latin1_General_CP1_CI_AS AS [name]
            ,MAX(v.[SubBuildingCode]) COLLATE SQL_Latin1_General_CP1_CI_AS AS [code]
            ,MAX(CAST(ISNULL(v.[isActive],0) AS INT)) AS [isActive]
            ,MAX(p.[dlm3Id]) AS [parentId]
            ,N'subbuilding' AS [type]
        FROM [archiv].[faplis_SubBuilding_V] v
        INNER JOIN [mig].[mapBuildingBuilding] p
            ON p.[dlm2Id] = v.[BuildingId]
        GROUP BY ISNULL(REPLACE(REPLACE(v.[SubBuildingFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1600000000000 + v.[SubBuildingId] AS NVARCHAR))
    ) s
    ON s.[faplisId] = t.[faplisId]
    WHEN NOT MATCHED THEN
        INSERT ([name],[code],[isActive],[faplisId],[parentId],[type])
        VALUES (s.[name],s.[code],s.[isActive],s.[faplisId],s.[parentId],s.[type])
    WHEN MATCHED THEN
        UPDATE SET
            t.[name] = s.[name]
            ,t.[code] = s.[code]
            ,t.[isActive] = s.[isActive]
            ,t.[parentId] = s.[parentId]
    OUTPUT s.[dlm2Id],inserted.[id]
    INTO [mig].[mapSubBuildingSubBuilding]([dlm2Id],[dlm3Id])
    ;

    MERGE INTO [mig].[mapSubBuildingSubBuilding] t
    USING (
        SELECT 
            loc.[id] AS [dlm3Id]
            ,v.[subBuildingFunctionalId]
            ,v.[subBuildingId] AS [dlm2Id]
        FROM [loc].[location] loc
        INNER JOIN [archiv].[faplis_SubBuilding_V] v
            ON v.[subBuildingFunctionalId]  COLLATE SQL_Latin1_General_CP1_CI_AS = loc.[faplisId]
    ) s
    ON s.[dlm3Id] = t.[dlm3Id]
    AND s.[dlm2Id] = t.[dlm2Id]
    WHEN NOT MATCHED THEN
        INSERT ([dlm2Id],[dlm3Id])
        VALUES (s.[dlm2Id],s.[dlm3Id]);

    SELECT @rowCount = COUNT(1) FROM [mig].[mapSubBuildingSubBuilding]

    PRINT '       ' + CAST(@rowcount AS NVARCHAR) + ' records'

    SET @msg = '     fill Location Floor'
    PRINT @msg

    MERGE INTO [loc].[location] t
    USING
    (
        SELECT 
            ISNULL(REPLACE(REPLACE(v.[FloorFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1700000000000 + v.[FloorId] AS NVARCHAR)) AS [faplisId]
            ,MAX(v.[FloorId]) AS [dlm2Id]
            ,MAX(ISNULL(v.[FloorName],v.[FloorCode])) COLLATE SQL_Latin1_General_CP1_CI_AS AS [name]
            ,MAX(v.[FloorCode]) COLLATE SQL_Latin1_General_CP1_CI_AS AS [code]
            ,MAX(CAST(ISNULL(v.[isActive],0) AS INT)) AS [isActive]
            ,MAX(p.[dlm3Id]) AS [parentId]
            ,N'floor' AS [type]
        FROM [archiv].[faplis_Floor_V] v
        INNER JOIN [mig].[mapSubBuildingSubBuilding] p
            ON p.[dlm2Id] = v.[SubBuildingId]
        GROUP BY ISNULL(REPLACE(REPLACE(v.[FloorFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1700000000000 + v.[FloorId] AS NVARCHAR))
    ) s
    ON s.[faplisId] = t.[faplisId]
    WHEN NOT MATCHED THEN
        INSERT ([name],[code],[isActive],[faplisId],[parentId],[type])
        VALUES (s.[name],s.[code],s.[isActive],s.[faplisId],s.[parentId],s.[type])
    WHEN MATCHED THEN
        UPDATE SET
            t.[name] = s.[name]
            ,t.[code] = s.[code]
            ,t.[isActive] = s.[isActive]
            ,t.[parentId] = s.[parentId]
    OUTPUT s.[dlm2Id],inserted.[id]
    INTO [mig].[mapFloorFloor]([dlm2Id],[dlm3Id])
    ;
    
    SELECT @rowCount = COUNT(1) FROM [mig].[mapFloorFloor]

    PRINT '       ' + CAST(@rowcount AS NVARCHAR) + ' records'

    SET @msg = '     fill Location Elevation'
    PRINT @msg

    MERGE INTO [loc].[location] t
    USING
    (
        SELECT 
            ISNULL(REPLACE(REPLACE(v.[ElevationFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1800000000000 + v.[ElevationId] AS NVARCHAR)) AS [faplisId]
            ,MAX(v.[ElevationId]) AS [dlm2Id]
            ,MAX(ISNULL(v.[ElevationName],CAST(v.[Elevation]AS NVARCHAR))) COLLATE SQL_Latin1_General_CP1_CI_AS AS [name]
            ,MAX(CAST(v.[Elevation] AS NVARCHAR)) COLLATE SQL_Latin1_General_CP1_CI_AS AS [code]
            ,MAX(CAST(ISNULL(v.[isActive],0) AS INT)) AS [isActive]
            ,MAX(p.[dlm3Id]) AS [parentId]
            ,N'elevation' AS [type]
        FROM [archiv].[faplis_Elevation_V] v
        INNER JOIN [mig].[mapFloorFloor] p
            ON p.[dlm2Id] = v.[FloorId]
        GROUP BY ISNULL(REPLACE(REPLACE(v.[ElevationFunctionalId] COLLATE SQL_Latin1_General_CP1_CI_AS,CHAR(10),''),CHAR(13),''),CAST(1800000000000 + v.[ElevationId] AS NVARCHAR)) 
    ) s
    ON s.[faplisId] = t.[faplisId]
    WHEN NOT MATCHED THEN
        INSERT ([name],[code],[isActive],[faplisId],[parentId],[type])
        VALUES (s.[name],s.[code],s.[isActive],s.[faplisId],s.[parentId],s.[type])
    WHEN MATCHED THEN
        UPDATE SET
            t.[name] = s.[name]
            ,t.[code] = s.[code]
            ,t.[isActive] = s.[isActive]
            ,t.[parentId] = s.[parentId]
    OUTPUT s.[dlm2Id],inserted.[id]
    INTO [mig].[mapElevationElevation]([dlm2Id],[dlm3Id])
    ;

    SELECT @rowCount = COUNT(1) FROM  [mig].[mapElevationElevation]

    PRINT '       ' + CAST(@rowcount AS NVARCHAR) + ' records'

    SET @msg = '     fill mapPLocationPlant'
    PRINT @msg

    MERGE INTO [loc].[mapLocationPlant] t
    USING (
        SELECT DISTINCT mPP.[dlm3Id] AS [plantId],mSPSP.[dlm3Id] AS [locationId]
        FROM [archiv].[faplis_Subplant_V] v
        INNER JOIN [mig].[mapPlantPlant] mPP
            ON mPP.[dlm2Id] = v.[PlantId]
        INNER JOIN [mig].[mapSubPlantSubPlant] mSPSP
            ON mSPSP.[dlm2Id] = v.[SubPlantId]
    ) s
    ON s.[plantId] = t.[plantId]
    AND s.[locationId] = t.[LocationId]
    WHEN NOT MATCHED THEN
        INSERT([plantId],[locationId])
        VALUES(s.[plantId],s.[locationId]);

    MERGE INTO [loc].[mapLocationPlant] t
    USING (
        SELECT DISTINCT mPP.[dlm3Id] AS [plantId],mBB.[dlm3Id] AS [locationId]
        FROM [archiv].[faplis_Building_V] v
        INNER JOIN [mig].[mapPlantPlant] mPP
            ON mPP.[dlm2Id] = v.[PlantId]
        INNER JOIN [mig].[mapBuildingBuilding] mBB
            ON mBB.[dlm2Id] = v.[BuildingId]
    ) s
    ON s.[plantId] = t.[plantId]
    AND s.[locationId] = t.[LocationId]
    WHEN NOT MATCHED THEN
        INSERT([plantId],[locationId])
        VALUES(s.[plantId],s.[locationId]);

    MERGE INTO [loc].[mapLocationPlant] t
    USING (
        SELECT DISTINCT mPP.[dlm3Id] AS [plantId],mSBSB.[dlm3Id] AS [locationId]
        FROM [archiv].[faplis_SubBuilding_V] v
        INNER JOIN [mig].[mapPlantPlant] mPP
            ON mPP.[dlm2Id] = v.[PlantId]
        INNER JOIN [mig].[mapSubBuildingSubBuilding] mSBSB
            ON mSBSB.[dlm2Id] = v.[SubBuildingId]
    ) s
    ON s.[plantId] = t.[plantId]
    AND s.[locationId] = t.[LocationId]
    WHEN NOT MATCHED THEN
        INSERT([plantId],[locationId])
        VALUES(s.[plantId],s.[locationId]);

    SET @msg = '     fill siteId for subPlants'
    PRINT @msg

    UPDATE t1
    SET t1.[siteId] = t2.[dlm3Id]
    FROM [loc].[location] t1
    INNER JOIN (
        SELECT DISTINCT [idSite],[id] FROM [archiv].[stage_stageLocation] WHERE [type] = N'subplant' AND [idSite] IS NOT NULL
    ) l
    ON l.[id] = t1.[faplisId]
    INNER JOIN [mig].[mapSiteSite] t2
        ON t2.[dlm2Id] = l.[idSite]

    SET @rowCount = @@ROWCOUNT

    PRINT '       ' + CAST(@rowcount AS NVARCHAR) + ' records'

END --location



GO