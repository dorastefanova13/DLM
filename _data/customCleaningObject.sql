
BEGIN --fill customCleaningObject

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '    fill customCleaningObject'
    PRINT @msg

    DECLARE 
		@dlm3Id INT
		,@dlm2Id INT
		,@locationId INT
		,@versionTimestamp DATETIME
		,@axis NVARCHAR(100)
		,@roomNo NVARCHAR(100)
		,@cycleId INT
		,@description NVARCHAR(4000)
		,@units DECIMAL(10,2)
		,@usageTypeId INT
		,@created DATETIME
		,@modified DATETIME
		,@SnowInfo NVARCHAR(1)
		,@isActive BIT 
		,@isDeleted BIT
	
	
	DROP TABLE IF EXISTS [mig].[mapCustomCleaningObjectInternalMeasurement]
    CREATE TABLE [mig].[mapCustomCleaningObjectInternalMeasurement] (dlm2Id INT, dlm3Id INT)

	DROP TABLE IF EXISTS [mig].[mapCustomCleaningObjectMeasurementManual1]
    CREATE TABLE [mig].[mapCustomCleaningObjectMeasurementManual1] (dlm2Id INT, dlm3Id INT)

	DROP TABLE IF EXISTS [mig].[mapCustomCleaningObjectWoItemManual1]
    CREATE TABLE [mig].[mapCustomCleaningObjectWoItemManual1] (dlm2Id INT, dlm3Id INT)

    DECLARE @serviceObjectTypeId INT = (SELECT [id] FROM [std].[serviceObjectType] WHERE LOWER([code]) = 'cust')

    DECLARE @rowCount BIGINT
	DECLARE @mapCount BIGINT

    BEGIN TRY
    
        DELETE FROM [loc].[customCleaningObject]

	    BEGIN --'      fill customCleaningObject from InternalMeasurement (WO)'

		    SET @msg = '      fill customCleaningObject from InternalMeasurement (WO)'
		    PRINT @msg

		    SET @rowCount = 0
		    SET @mapCount = 0

    	    INSERT INTO [loc].[customCleaningObject]([locationId],[axis],[roomNo],[cycleId],[description],[units],[usageTypeId],[created],[modified],[snow],[isActive],[isDeleted],[insertedAt],[insertedBy],[updatedBy])
            OUTPUT INSERTED.[updatedBy],INSERTED.[id]
            INTO [mig].[mapCustomCleaningObjectInternalMeasurement]([dlm2Id],[dlm3Id])
			SELECT 
				l.[dlm3id] AS [locationId]
				,m.[Axis]
				,m.[RoomNo]
				,ISNULL(cy.[id],0) AS [cycleId]
				,LTRIM(RTRIM(m.[Description] + ' ' + m.[Comment])) AS [description]
				,ISNULL(m.[Units],1)
				,ISNULL(ut.[dlm3Id],0) AS [usageTypeId]
				,m.[Created]
				,m.[Modified]
				,SUBSTRING(m.[Snowinfo],1,1) AS [SnowInfo]
				,1 AS [isActive]
				,0 AS [isDeleted]
                ,GETDATE() AS [insertedAt]
                ,1 AS [insertedBy]
                ,m.[id] AS [updatedBy]
			FROM [archiv].[dbo_InternalMeasurement] m
			LEFT OUTER JOIN [mig].[mapLocation] l
				ON l.[subPlantId] = ISNULL(m.[SubPlantId],0)
				AND l.[buildingId] = ISNULL(m.[BuildingId],0)
				AND l.[subBuildingId] = ISNULL(m.[SubBuildingId],0)
				AND l.[floorId] = ISNULL(m.[FloorId],0)
				AND l.[elevationId] = ISNULL(m.[ElevationId],0)
			LEFT OUTER JOIN [std].[cycle] cy ON cy.[faplisId] = m.[Cycle]  COLLATE SQL_Latin1_General_CP1_CI_AI 
			LEFT OUTER JOIN [mig].[mapUsageTypeUsageType] ut ON ut.[dlm2Id] = m.[UsageTypeId]
	
            SET @rowcount = @@ROWCOUNT
            SET @mapCount = @rowcount

		    PRINT '        ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

	    END --'      fill customCleaningObject from InternalMeasurement (WO)'

	    BEGIN --'      fill customCleaningObject from WoItem manual = 1'

		    SET @msg = '      fill customCleaningObject from WoItem manual = 1'
		    PRINT @msg
		
		    SET @rowCount = 0
		    SET @mapCount = 0

			INSERT INTO [loc].[customCleaningObject]([locationId],[axis],[roomNo],[cycleId],[description],[units],[usageTypeId],[created],[modified],[snow],[isActive],[isDeleted],[insertedAt],[insertedBy],[updatedBy])
            OUTPUT INSERTED.[updatedBy],INSERTED.[id]
            INTO [mig].[mapCustomCleaningObjectWoItemManual1]([dlm2Id],[dlm3Id])
			SELECT 
				l.[dlm3id] AS [locationId]
				,m.[Axis]
				,m.[Room] AS [RoomNo]
				,NULL AS [cycleId]
				,LTRIM(RTRIM(ISNULL(m.[Note],'') + ' ' + ISNULL(m.[Comment],''))) AS [description]
				,ISNULL(m.[Units],1) AS [units]
				,ISNULL(mUTUT.[dlm3Id],0) AS [usageTypeId]
				,m.[Created]
				,m.[Modified]
				,NULL AS [SnowInfo]
				,1 AS [isActive]
				,0 AS [isDeleted]
                ,GETDATE()
				,1 AS [insertedBy]
                ,m.[id]
			FROM [archiv].[dbo_WoItem] m
			LEFT OUTER JOIN [mig].[mapUsageTypeUsageType] mUTUT
				ON mUTUT.[dlm2Id] = ISNULL(m.[UsageTypeId],0)
			LEFT OUTER JOIN [mig].[mapLocation] l
				ON l.[subPlantId] = ISNULL(m.[SubPlantId],0)
				AND l.[buildingId] = ISNULL(m.[BuildingId],0)
				AND l.[subBuildingId] = ISNULL(m.[SubBuildingId],0)
				AND l.[floorId] = ISNULL(m.[FloorId],0)
				AND l.[elevationId] = ISNULL(m.[ElevationId],0)
			WHERE [isManual] = 1
            --and [SscItemId] NOT IN (SELECT [id] FROM [archiv].[dbo_SscItem] WHERE [SscId] IN (SELECT [id] FROM [archiv].[dbo_StandardServicesCatalog] WHERE ISNULL([isActive],0) = 0))
			
            SET @rowcount = @@ROWCOUNT
            SET @mapCount = @rowcount

		    PRINT '        ' + CAST(@rowCount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

	    END --'      fill customCleaningObject from WoItem manual = 1'

	    BEGIN --'      fill customCleaningObject from Measurement Manual = 1 (SP)'

		    SET @msg = '      fill customCleaningObject from Measurement Manual = 1 (SP)'
		    PRINT @msg

		    SET @rowCount = 0
		    SET @mapCount = 0

			INSERT INTO [loc].[customCleaningObject]([locationId],[axis],[roomNo],[cycleId],[description],[units],[usageTypeId],[created],[modified],[snow],[isActive],[isDeleted],[insertedAt],[insertedBy],[updatedBy])
            OUTPUT INSERTED.[updatedBy],INSERTED.[id]
            INTO [mig].[mapCustomCleaningObjectMeasurementManual1]([dlm2Id],[dlm3Id])
			SELECT 
				l.[dlm3id] AS [locationId]
				,m.[Axis]
				,m.[RoomNo]
				,ISNULL(cy.[id],0) AS [cycleId]
				,LTRIM(RTRIM(ISNULL(m.[Note], 'no Note') + ' ' + ISNULL(m.[Comment],'no Comment'))) AS [description]
				,ISNULL(m.[Units],1)
				,ISNULL(ut.[dlm3Id],0) AS [usageTypeId]
				,m.[Created]
				,m.[Modified]
				,NULL AS [SnowInfo]
				,m.[isActive]
				,0 AS [isDeleted]
                ,GETDATE() AS [insertedAt]
				,1 AS [insertedBy]
				,m.[id] AS [updatedBy]
			FROM [archiv].[dbo_Measurement] m
			LEFT OUTER JOIN [mig].[mapUserClient] cr
				ON cr.[dlm2Id] = m.[CreatedBy]
			LEFT OUTER JOIN [mig].[mapUserClient] mo
				ON mo.[dlm2Id] = m.[ModifiedBy]
			LEFT OUTER JOIN [mig].[mapLocation] l
				ON l.[subPlantId] = ISNULL(m.[SubPlantId],0)
				AND l.[buildingId] = ISNULL(m.[BuildingId],0)
				AND l.[subBuildingId] = ISNULL(m.[SubBuildingId],0)
				AND l.[floorId] = ISNULL(m.[FloorId],0)
				AND l.[elevationId] = ISNULL(m.[ElevationId],0)
			LEFT OUTER JOIN [std].[cycle] cy ON cy.[faplisId] = m.[Cycle] COLLATE SQL_Latin1_General_CP1_CI_AI 
			LEFT OUTER JOIN [mig].[mapUsageTypeUsageType] ut ON ut.[dlm2Id] = m.[UsageTypeId]
			WHERE m.[Manual] = 1

            SET @rowcount = @@ROWCOUNT
            SET @mapCount = @rowcount

		    PRINT '        ' + CAST(@rowCount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

	    END --'      fill customCleaningObject from Measurement Manual = 1 (SP)'
    
	    BEGIN --'    fill serviceObjects'
	
		    SET @msg = '    fill serviceObjects'

		    PRINT @msg

		    DELETE FROM [dlm].[serviceObject] WHERE [customCleaningObjectId] IS NOT NULL

		    INSERT INTO [dlm].[serviceObject] ([customCleaningObjectId],[serviceObjectTypeId],[isActive],[insertedAt],[insertedBy])
		    SELECT 
			    [id]
			    ,@serviceObjectTypeId
			    ,[IsActive]
				,GETDATE()
				,1
		    FROM [loc].[customCleaningObject]
		
		    SELECT @rowcount = COUNT(1) FROM [dlm].[serviceObject] WHERE [customCleaningObjectId] IS NOT NULL

		    PRINT '        ' + CAST(@rowcount AS NVARCHAR) + ' records'

	    END --'    fill serviceObjects'

    
	    BEGIN --'    reset updatedBy'
	
		    SET @msg = '    reset updatedBy'

		    PRINT @msg

            UPDATE [loc].[customCleaningObject] SET [updatedBy] = NULL

            SET @rowCount = @@ROWCOUNT

            PRINT '        ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END


    END TRY
        BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + ISNULL(@msg,' ') + ' customCleaningObject.sql'
        RAISERROR(@msg,1,16)

    END CATCH


END --fill customCleaningObject
GO
