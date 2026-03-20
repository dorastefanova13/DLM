
BEGIN --fill ServiceObject

    PRINT '    fill ServiceObject'

    DECLARE @msg NVARCHAR(MAX)
    BEGIN TRY
    
        SET @msg =  '   fill area'
        PRINT @msg

        DECLARE @serviceObjectTypeId INT = (SELECT [id] FROM [std].[serviceObjectType] WHERE LOWER([code]) = 'area')
        DECLARE @rowCount BIGINT

        BEGIN --build Table for filenames in wrong format
            
            SET @msg =  '   fill wrongFilenames'
            PRINT @msg

            DROP TABLE IF EXISTS [mig].[mapDocumentIdWrongFilenames]

            CREATE TABLE [mig].[mapDocumentIdWrongFilenames] ([id] INT IDENTITY (1,1),[fileName] NVARCHAR(400))
            CREATE CLUSTERED INDEX [x_mapDocumentIdWrongFilenames] ON [mig].[mapDocumentIdWrongFilenames]([fileName] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

            INSERT INTO [mig].[mapDocumentIdWrongFilenames]([fileName])
            SELECT DISTINCT [FileName] 
            FROM [archiv].[dbo_Measurement]
            WHERE [FileName] NOT LIKE '100000%'

            SELECT @rowCount = @@ROWCOUNT

            SET @msg =  '   fill wrongFilenames done'
            PRINT @msg
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END 

        BEGIN --fill Area

            SET @msg =  '   fill area'
            PRINT @msg

            DELETE FROM [loc].[area]

            SET IDENTITY_INSERT [loc].[area] ON

            INSERT INTO [loc].[area] ([id],[documentId],[shapeId],[locationId],[versionTimestamp],[axis],[roomNo],[doorNo],[fileName],[flooringId],[flooringDescription],[cycleId],[ffgId],[lvAllocId],[description],[note],[units],[orgLevel2],[customer],[technicalLocation],[costCenterId],[usageTypeId],[created],[modified],[isOutsideArea],[isWinterservice],[isActive],[isDeleted],[isLastVersion])
            SELECT
                m.[id]
                ,CASE 
                    WHEN m.[FileName] LIKE '100000%' THEN [mig].[fnGetIdFromFilename](m.[FileName])
                    ELSE '990000000000000'
                END  AS [documentId]
                ,m.[ShapeId]
                ,l.[dlm3id] AS [locationId]
                ,SYSDATETIME() AS [versionTimestamp]
                ,m.[Axis]
                ,m.[RoomNo]
                ,m.[DoorNo]
                ,m.[FileName]
                ,fl.[id] AS [flooringId]
                ,m.[FlooringDescr]
                ,cy.[id] AS [cycleId]
                ,NULL AS [ffgId]
                ,NULL AS [lvAllocId]
                ,m.[Comment] AS [description]
                ,m.[Note]
                ,m.[Units]
                ,m.[OrgLevel2]
                ,m.[Customer]
                ,m.[TechnLocation]
                ,cc.[id] AS [costCenterId]
                ,ut.[dlm3Id] AS [usageTypeId]
                ,m.[CreationDate]
                ,m.[ModifyDate]
                ,NULL AS [isOutsideArea]
                ,m.[IsWinterService]
                ,st.[IsActive]
                ,0 AS [isDeleted]
				,1 AS [isLastVersion] 
            FROM [mig].[mapAreaMeasurement] m
            INNER JOIN (
                SELECT [dlm3AreaId],[dlm2MeasurementId],[isActive]
                FROM
                (
                    SELECT [dlm3AreaId],[dlm2MeasurementId],[isActive],ROW_NUMBER() OVER (PARTITION BY [dlm3AreaId] ORDER BY CAST([isActive] AS INT) DESC) AS [rownumber]
                    FROM [mig].[mapAreaMeasurementStatus]
                ) q
                WHERE [rownumber] = 1
            ) st
            ON st.[dlm3AreaId] = m.[id]
            LEFT OUTER JOIN [mig].[mapLocation] l
                ON l.[subPlantId] = ISNULL(m.[SubPlantId],0)
                AND l.[buildingId] = ISNULL(m.[BuildingId],0)
                AND l.[subBuildingId] = ISNULL(m.[SubBuildingId],0)
                AND l.[floorId] = ISNULL(m.[FloorId],0)
                AND l.[elevationId] = ISNULL(m.[ElevationId],0)
            LEFT OUTER JOIN [std].[flooring] fl ON fl.[faplisId] = m.[Flooring] COLLATE SQL_Latin1_General_CP1_CI_AS
            LEFT OUTER JOIN [std].[costCenter] cc ON cc.[faplisId] = m.[CostId] COLLATE SQL_Latin1_General_CP1_CI_AS
            LEFT OUTER JOIN [std].[cycle] cy ON cy.[faplisId] = m.[Cycle] COLLATE SQL_Latin1_General_CP1_CI_AS
            LEFT OUTER JOIN [mig].[mapUsageTypeUsageType] ut ON ut.[dlm2Id] = m.[UsageTypeId]

            INSERT INTO [loc].[area] ([id],[documentId],[shapeId],[locationId],[versionTimestamp],[axis],[roomNo],[doorNo],[fileName],[flooringId],[flooringDescription],[cycleId],[ffgId],[lvAllocId],[description],[note],[units],[orgLevel2],[customer],[technicalLocation],[costCenterId],[usageTypeId],[created],[modified],[isOutsideArea],[isWinterservice],[isActive],[isDeleted],[isLastVersion])
            SELECT
                m.[id]
                ,CASE 
                    WHEN m.[FileName] LIKE '100000%' THEN [mig].[fnGetIdFromFilename](m.[FileName])
                    ELSE '990000000000000'
                END  AS [documentId]
                ,m.[ShapeId]
                ,l.[dlm3id] AS [locationId]
                ,SYSDATETIME() AS [versionTimestamp]
                ,m.[Axis]
                ,m.[RoomNo]
                ,m.[DoorNo]
                ,m.[FileName]
                ,fl.[id] AS [flooringId]
                ,m.[FlooringDescr]
                ,cy.[id] AS [cycleId]
                ,NULL AS [ffgId]
                ,NULL AS [lvAllocId]
                ,m.[Comment] AS [description]
                ,m.[Note]
                ,m.[Units]
                ,m.[OrgLevel2]
                ,m.[Customer]
                ,m.[TechnLocation]
                ,cc.[id] AS [costCenterId]
                ,ut.[dlm3Id] AS [usageTypeId]
                ,m.[CreationDate]
                ,m.[ModifyDate]
                ,NULL AS [isOutsideArea]
                ,m.[IsWinterService]
                ,1 AS [IsActive]
                ,0 AS [isDeleted]
				,1 AS [isLastVersion] 
            FROM [mig].[mapAreaMeasurement] m
            LEFT OUTER JOIN [mig].[mapLocation] l
                ON l.[subPlantId] = ISNULL(m.[SubPlantId],0)
                AND l.[buildingId] = ISNULL(m.[BuildingId],0)
                AND l.[subBuildingId] = ISNULL(m.[SubBuildingId],0)
                AND l.[floorId] = ISNULL(m.[FloorId],0)
                AND l.[elevationId] = ISNULL(m.[ElevationId],0)
            LEFT OUTER JOIN [std].[flooring] fl ON fl.[faplisId] = m.[Flooring]	COLLATE SQL_Latin1_General_CP1_CI_AS
            LEFT OUTER JOIN [std].[costCenter] cc ON cc.[faplisId] = m.[CostId] COLLATE SQL_Latin1_General_CP1_CI_AS
            LEFT OUTER JOIN [std].[cycle] cy ON cy.[faplisId] = m.[Cycle] COLLATE SQL_Latin1_General_CP1_CI_AS
            LEFT OUTER JOIN [mig].[mapUsageTypeUsageType] ut ON ut.[dlm2Id] = m.[UsageTypeId] 
            WHERE m.[id] NOT IN (SELECT [id] FROM [loc].[area])

            SELECT @rowCount = COUNT(1) FROM [loc].[area]

            SET @msg =  '   fill area done'
            PRINT @msg
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

			BEGIN TRY
				SET IDENTITY_INSERT [loc].[area] OFF
			END TRY
			BEGIN CATCH
				PRINT '      IDENTITY_INSERT [loc].[area] could not set to OFF'
			END CATCH

        END --fill area

        BEGIN --set documentId for wrong filenames

            SET @msg = '   set documentId for wrong filenames'
            PRINT @msg

            UPDATE T1
            SET T1.[documentId] = CAST(CAST([documentId] AS BIGINT) + T2.[id] AS NVARCHAR(4000))
            FROM [loc].[area] T1
            INNER JOIN [mig].[mapDocumentIdWrongFilenames] T2
                ON T1.[fileName] = T2.[fileName]
            WHERE T1.[documentId] LIKE '990000%'

            SELECT @rowCount = @@ROWCOUNT

            SET @msg =  '   set documentId for wrong filenames done'
            PRINT @msg
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --set documentId for wrong filenames

        BEGIN --fill serviceObjects

            SET @msg = '   fill serviceObjects'
            PRINT @msg

            DELETE FROM [dlm].[serviceObject]

            SET IDENTITY_INSERT [dlm].[serviceObject] ON

            INSERT INTO [dlm].[serviceObject] ([id],[areaId],[serviceObjectTypeId],[isActive],[insertedAt],[insertedBy])
            SELECT [id],[id],@serviceObjectTypeId,[IsActive],GETDATE(),1
            FROM [loc].[area]
			WHERE [isLastVersion] = 1

            SET IDENTITY_INSERT [dlm].[serviceObject] OFF

            SELECT @rowcount = COUNT(1) FROM [dlm].[serviceObject]

            SET @msg = '   fill serviceObjects done'
            PRINT @msg
            PRINT '      ' + CAST(@rowCount AS NVARCHAR) + ' records'

        END --fill serviceObjects

        BEGIN --set lastVersion

            UPDATE [loc].[area]
            SET [isLastVersion] = 0
            WHERE [id] IN (
                SELECT [id]
                FROM (
                    SELECT [id],[documentId],[shapeId],ROW_NUMBER() OVER(PARTITION BY [documentId],[shapeId] ORDER BY ISNULL([modified],[created]) DESC,[id] DESC) AS [rownumber] FROM [loc].[area] WHERE [isLastVersion] = 1
                ) q
                WHERE [rownumber] > 1
            )

            SELECT @rowcount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowCount AS NVARCHAR) + ' records'

        END --set lastVersion

    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' serviceObject.sql'
        RAISERROR(@msg,1,16)

    END CATCH

END --fill area
GO

