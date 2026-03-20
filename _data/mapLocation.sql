BEGIN --collect areas for sspItems - mapping dlm2id with dlm3id

    PRINT '    fill mapLocation'


    DECLARE @rowCount INT = 0

    DROP TABLE IF EXISTS [mig].[mapLocation]
    CREATE TABLE [mig].[mapLocation]([dlm3Id] INT,[subPlantId] INT,[buildingId] INT,[subBuildingId] INT,[floorId] INT,[elevationId] INT)

    PRINT '  fill mapLocation subPlant'

    INSERT INTO [mig].[mapLocation]([dlm3Id],[subPlantId],[buildingId],[subBuildingId],[floorId],[elevationId])
    SELECT l1.[id],msp.[dlm2Id],0,0,0,0
    FROM (SELECT * FROM [loc].[location] WHERE [type] = 'subplant') l1
    INNER JOIN [mig].[mapSubPlantSubPlant] msp ON msp.[dlm3Id] = l1.[id]

    SET @rowCount = @rowCount + @@ROWCOUNT

    PRINT '  fill mapLocation building'

    INSERT INTO [mig].[mapLocation]([dlm3Id],[subPlantId],[buildingId],[subBuildingId],[floorId],[elevationId])
    SELECT l2.[id],msp.[dlm2Id],mb.[dlm2Id],0,0,0
    FROM (SELECT * FROM [loc].[location] WHERE [type] = 'subplant') l1
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'building') l2 ON l1.[id] = l2.[parentId]
    INNER JOIN [mig].[mapSubPlantSubPlant] msp ON msp.[dlm3Id] = l2.[parentId]
    INNER JOIN [mig].[mapBuildingBuilding] mb ON mb.[dlm3Id] = l2.[id]

    SET @rowCount = @rowCount + @@ROWCOUNT

    PRINT '  fill mapLocation subBuilding'

    INSERT INTO [mig].[mapLocation]([dlm3Id],[subPlantId],[buildingId],[subBuildingId],[floorId],[elevationId])
    SELECT l3.[id],msp.[dlm2Id],mb.[dlm2Id],msb.[dlm2Id],0,0
    FROM (SELECT * FROM [loc].[location] WHERE [type] = 'subplant') l1
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'building') l2 ON l1.[id] = l2.[parentId]
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'subbuilding') l3 ON l2.[id] = l3.[parentId]
    INNER JOIN [mig].[mapSubPlantSubPlant] msp ON msp.[dlm3Id] = l2.[parentId]
    INNER JOIN [mig].[mapBuildingBuilding] mb ON mb.[dlm3Id] = l3.[parentId]
    INNER JOIN [mig].[mapSubBuildingSubBuilding] msb ON msb.[dlm3Id] = l3.[id]

    SET @rowCount = @rowCount + @@ROWCOUNT

    PRINT '  fill mapLocation floor'

    INSERT INTO [mig].[mapLocation]([dlm3Id],[subPlantId],[buildingId],[subBuildingId],[floorId],[elevationId])
    SELECT l4.[id],msp.[dlm2Id],mb.[dlm2Id],msb.[dlm2Id],mf.[dlm2Id],0
    FROM (SELECT * FROM [loc].[location] WHERE [type] = 'subplant') l1
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'building') l2 ON l1.[id] = l2.[parentId]
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'subbuilding') l3 ON l2.[id] = l3.[parentId]
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'floor') l4 ON l3.[id] = l4.[parentId]
    INNER JOIN [mig].[mapSubPlantSubPlant] msp ON msp.[dlm3Id] = l2.[parentId]
    INNER JOIN [mig].[mapBuildingBuilding] mb ON mb.[dlm3Id] = l3.[parentId]
    INNER JOIN [mig].[mapSubBuildingSubBuilding] msb ON msb.[dlm3Id] = l4.[parentId]
    INNER JOIN [mig].[mapFloorFloor] mf ON mf.[dlm3Id] = l4.[id]

    SET @rowCount = @rowCount + @@ROWCOUNT

    PRINT '  fill mapLocation elevation'

    INSERT INTO [mig].[mapLocation]([dlm3Id],[subPlantId],[buildingId],[subBuildingId],[floorId],[elevationId])
    SELECT l5.[id],msp.[dlm2Id],mb.[dlm2Id],msb.[dlm2Id],mf.[dlm2Id],me.[dlm2Id]
    FROM (SELECT * FROM [loc].[location] WHERE [type] = 'subplant') l1
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'building') l2 ON l1.[id] = l2.[parentId]
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'subbuilding') l3 ON l2.[id] = l3.[parentId]
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'floor') l4 ON l3.[id] = l4.[parentId]
    INNER JOIN (SELECT * FROM [loc].[location] WHERE [type] = 'elevation') l5 ON l4.[id] = l5.[parentId]
    INNER JOIN [mig].[mapSubPlantSubPlant] msp ON msp.[dlm3Id] = l2.[parentId]
    INNER JOIN [mig].[mapBuildingBuilding] mb ON mb.[dlm3Id] = l3.[parentId]
    INNER JOIN [mig].[mapSubBuildingSubBuilding] msb ON msb.[dlm3Id] = l4.[parentId]
    INNER JOIN [mig].[mapFloorFloor] mf ON mf.[dlm3Id] = l4.[id]
    INNER JOIN [mig].[mapElevationElevation] me ON me.[dlm3Id] = l5.[id]

    CREATE NONCLUSTERED INDEX [x_location_dlm2Ids] ON [mig].[mapLocation]
    (
	    [subPlantId] ASC,
	    [buildingId] ASC,
	    [subBuildingId] ASC,
	    [floorId] ASC,
	    [elevationId] ASC
    )

    PRINT '   ' + CAST(@rowCount AS NVARCHAR) + ' records'

END --collect areas for sspItems
GO