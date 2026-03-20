SET NOCOUNT ON

DROP TABLE IF EXISTS [mig].[logTechnicalData]
GO
CREATE TABLE [mig].[logTechnicalData]
(
    [id] INT IDENTITY(1,1),
    [srcFileName] NVARCHAR(1000),
    [srcLineNo] INT,
    [status] NVARCHAR(100),
    [record] NVARCHAR(MAX),
    [message] NVARCHAR(MAX),
)

DECLARE 
    @srcId INT
	,@plant NVARCHAR(1000)
	,@subPlant NVARCHAR(1000)
	,@building NVARCHAR(1000)
	,@subBuilding NVARCHAR(1000)
	,@floor NVARCHAR(1000)
	,@elevation NVARCHAR(1000)
	,@axis NVARCHAR(1000)
	,@trade NVARCHAR(1000)
	,@series NVARCHAR(1000)
	,@machine NVARCHAR(1000)
    ,@machineDescription NVARCHAR(1000)
    ,@machineType NVARCHAR(1000)
	,@technicalPlace NVARCHAR(1000)
    ,@technicalCleaningObjectTypeId INT
    ,@description NVARCHAR(1000)
	,@mainCode NVARCHAR(1000)
	,@turnusCode NVARCHAR(1000)
	,@positionNo NVARCHAR(1000)
	,@mainCodeDescription NVARCHAR(1000)
	,@isMainCodePosition NVARCHAR(1000)
	,@turnus NVARCHAR(1000)
	,@usageType NVARCHAR(1000)
	,@units NVARCHAR(1000)
	,@unit NVARCHAR(1000)
	,@executionPerMonth NVARCHAR(1000)
	,@srcFileName NVARCHAR(1000)
    ,@srcLineNo INT
    ,@timestamp DATETIME = GETDATE()

DECLARE @sql NVARCHAR(MAX)
DECLARE @srcFileNameOld NVARCHAR(1000) = ''
DECLARE @message NVARCHAR(MAX)
DECLARE @srcRecord NVARCHAR(MAX)

DECLARE @fileCount INT = (SELECT COUNT(DISTINCT [srcFileName]) FROM [mig].[technicalData])
DECLARE @currentLineNo INT = 0
DECLARE @currentFileNo INT = 0
DECLARE @lineCount INT

DECLARE @migId INT
DECLARE @locationId INT
DECLARE @mainCodeId INT
DECLARE @turnusCodeId INT
DECLARE @serviceCategoryId INT
DECLARE @standardId INT
DECLARE @serviceTypeId INT
DECLARE @costCenterId INT
DECLARE @costCenterCode NVARCHAR(100)
DECLARE @step NVARCHAR(100)

SELECT @serviceCategoryId = [id] FROM [std].[serviceCategory] WHERE [code] = N'TEC'
SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [code] = N'TR'
SELECT @standardId = [id] FROM [std].[standard] WHERE [code] = N'n/a'

DELETE FROM [loc].[technicalCleaningObject]
WHERE [id] NOT IN (
    SELECT ISNULL([technicalCleaningObjectId],0)
    FROM [dlm].[serviceObject]
)

DECLARE cMig CURSOR FOR
    SELECT DISTINCT [id],[plant],[subPlant],[building],[subBuilding],[floor],[elevation],[axis],[trade],[series],[machine],[machineDescription],[machineType],[technicalPlace],[description],[units],[unit],[costcenter]
    FROM [mig].[technicalData]

OPEN cMig
FETCH NEXT FROM cMig INTO @migId,@plant,@subPlant,@building,@subBuilding,@floor,@elevation,@axis,@trade,@series,@machine,@machineDescription,@machineType,@technicalPlace,@description,@units,@unit,@costCenterCode
WHILE @@FETCH_STATUS = 0
BEGIN


    SET @step = N'set Json'

    SELECT @srcRecord = (
        SELECT 
            @migId AS [id]
            ,@plant AS [plant]
            ,@subPlant AS [subPlant]
            ,@building AS [building]
            ,@subBuilding AS [subbuilding]
            ,@floor AS [floor]
            ,@elevation AS [elevation]
            ,@axis AS [axis]
            ,@trade AS [trade]
            ,@series AS [series]
            ,@machine AS [machine]
            ,@machineDescription AS [machineDescription]
            ,@machineType AS [machineType]
            ,@technicalPlace AS [technicalPlace]
            ,@description AS [description]
            ,@units AS [units]
            ,@unit AS [unit]
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )


    SET @step = N'groupswitch'

    IF @srcFileName <> @srcFileNameOld
    BEGIN

        SET @currentLineNo = 0
        SET @srcFileNameOld = @srcFileName
        SET @currentFileNo = @currentFileNo + 1
        SELECT @lineCount = COUNT(1) FROM [mig].[technicalData] WHERE [srcFileName] = @srcFileName

    END 

    SET @currentLineNo = @currentLineNo + 1

    PRINT 'File '+ CAST(@currentFileNo AS NVARCHAR) + ' of ' + CAST(@fileCount AS NVARCHAR) + ' - Line ' + CAST(@currentLineNo AS NVARCHAR) + ' of ' + CAST(@lineCount AS NVARCHAR)


    BEGIN TRY

        SET @step = N'get locationId'
        
        SET @locationId = 0
               
        SELECT @locationId = ISNULL([id],0)
        FROM [rep].[vLocation]
        WHERE [subPlantCode] = @subPlant
        AND ISNULL([buildingCode],' ') = ISNULL(@building,' ')
        AND ISNULL([subBuildingCode],' ') = ISNULL(@subBuilding,' ')
        AND ISNULL([floorCode],' ') = ISNULL(@floor,' ')
        AND ISNULL(CAST(CAST(CAST([elevationCode] AS DECIMAL(10,2)) AS INT) AS NVARCHAR),' ') = ISNULL(@elevation,' ')
        AND [subPlantId] IN (
            SELECT [locationId]
            FROM [loc].[mapLocationPlant]
            WHERE [plantId] IN (
                SELECT [id]
                FROM [loc].[plant]
                WHERE [code] = @plant
            )
        )

        IF @locationId = 0
        BEGIN

            PRINT N'no matching location found- rec: ' + CAST(@migId AS NVARCHAR)

            RAISERROR (N'no matching location found', 16, 16, 'ERROR');

        END

        SET @step = N'get CostCenterId for subbuilding from location'

        SET @costCenterId = 0
        
        SELECT @costCenterId = ISNULL(cc.[id],0)
        FROM [std].[costCenter] cc
        INNER JOIN [rep].[vLocation] l
            ON l.[plantId] = cc.[plantId]
        WHERE l.[id] = @locationId
        AND cc.[code] = @costCenterCode

        IF @costCenterId = 0
        BEGIN

            SET @message = N'no matching costcenter for subbuilding ' 
                + @subbuilding 
                + ' (locationId: ' + CAST(ISNULL(@locationId,0) AS NVARCHAR) 
                + ' (migId: ' + CAST(ISNULL(@migId,0) AS NVARCHAR) 
                + ') found'

            PRINT @message

            RAISERROR (@message, 16, 16, 'ERROR');

        END

        SET @step = N'get technicalClearningObjectId'
        
        SET @technicalCleaningObjectTypeId = 0

        SELECT @technicalCleaningObjectTypeId = tot.[id]
        FROM [std].[technicalCleaningObjectType] tot
        WHERE tot.[name] = @machineType
        OR tot.[code] = @machineType

        SET @step = N'insert technicalCleaningObject'

        INSERT INTO [loc].[technicalCleaningObject]
                   ([locationId]
                   ,[versionTimestamp]
                   ,[name]
                   ,[description]
                   ,[technicalPlace]
                   ,[productionArea]
                   ,[technicalCleaningObjectTypeId]
                   ,[costCenterId]
                   ,[isActive]
                   ,[isDeleted]
                   ,[units])
        SELECT 
            @locationId
            ,@timestamp
            ,@machine
            ,LTRIM(RTRIM(ISNULL(@axis,'') + ' ' + ISNULL(@machineDescription,'') + ' ' + ISNULL(@series,'') + ' ' + ISNULL(@description,'')))
            ,@technicalPlace
            ,@trade
            ,@technicalCleaningObjectTypeId
            ,@costCenterId
            ,1
            ,0
            ,CAST(REPLACE(@units,',','.') AS DECIMAL(10,2))
            

        SET @step = N'insert log'

        INSERT INTO [mig].[logTechnicalData]([srcFileName],[srcLineNo],[status],[message])
        SELECT @srcFileName,@srcLineNo,N'OK',N'Done'
        
    END TRY
    BEGIN CATCH

        SELECT @message =  (
            SELECT 
                ERROR_MESSAGE() AS [message]
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )

        PRINT 'error ' + @step + ' ' +  @srcRecord + ' ' +  @message + ' fields: locationId: ' + ISNULL(cast(@locationId AS nvarchar),'*') + ' locationId: ' + ISNULL(cast(@costCenterId AS nvarchar),'*') +  + ' technicalCleaningObjectTypeId: ' + ISNULL(cast(@technicalCleaningObjectTypeId AS nvarchar),'*') + ' units: ' + ISNULL(cast(@units AS nvarchar),'*')

        INSERT INTO [mig].[logTechnicalData]([srcFileName],[srcLineNo],[status],[message],[record])
        SELECT @srcFileName,@srcLineNo,N'ERROR',@message,@srcRecord
         

    END CATCH

    FETCH NEXT FROM cMig INTO @migId,@plant,@subPlant,@building,@subBuilding,@floor,@elevation,@axis,@trade,@series,@machine,@machineDescription,@machineType,@technicalPlace,@description,@units,@unit,@costCenterCode

END
CLOSE cMig
DEALLOCATE cMig
/*
SELECT * FROM [mig].[logTechnicalData] 
ORDER  BY [srcFileName],[status],[srcLineNo]



SELECT DISTINCT [plant],[subPlant],[building],[subBuilding],[floor],[elevation],[axis],[trade],[series],[machine],[machineDescription],[machineType],[technicalPlace],[description],[units],[unit]
FROM [mig].[technicalData]
ORDER BY [machine],[technicalPlace],[description]


SELECT * FROM [loc].[technicalCleaningObject]
WHERE [id] NOT IN (
    SELECT ISNULL([technicalCleaningObjectId],0)
    FROM [dlm].[serviceObject]
)
ORDER BY [name],[technicalPlace],[description]
*/