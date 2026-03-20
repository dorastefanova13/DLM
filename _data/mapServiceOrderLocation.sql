BEGIN --map serviceOrder Location

    SET NOCOUNT ON

	DECLARE @rowcount INT
    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    map serviceOrder Location'
    PRINT @msg

    DELETE FROM [dlm].[mapServiceOrderLocation]

    SET @msg = '      map serviceOrder Location UHR'
    PRINT @msg

	INSERT INTO [dlm].[mapServiceOrderLocation]([serviceOrderId],[locationId])
	SELECT DISTINCT mSSPSO.[dlm3Id],mL.[dlm3Id]
	FROM [mig].[mapServiceSpecificationServiceOrder] mSSPSO
	INNER JOIN [archiv].[dbo_SspLocation] sspl
		ON sspl.[SspId] = mSSPSO.[dlm2Id]
	INNER JOIN (SELECT * FROM [mig].[mapLocation] WHERE [floorId] = 0) mL
		ON ISNULL(sspl.[SubPlantId],0) = mL.[subPlantId]
		AND ISNULL(sspl.[BuildingId],0) = ml.[buildingId]
		AND ISNULL(sspl.[SubBuildingId],0) = ml.[subBuildingId]

	SET @rowcount = @@ROWCOUNT
	PRINT '         ' + CAST(@rowcount AS NVARCHAR) + ' records'


    SET @msg = '      map serviceOrder Location AdHoc'
    PRINT @msg

	INSERT INTO [dlm].[mapServiceOrderLocation]([serviceOrderId],[locationId])
	SELECT DISTINCT mWOSO.[dlm3Id],mL.[dlm3Id]
	FROM  [mig].[mapWorkOrderServiceOrder] mWOSO
	INNER JOIN [archiv].[dbo_WorkOrder] wo
		ON wo.[id] = mWOSO.[dlm2Id]
	INNER JOIN (SELECT * FROM [mig].[mapLocation] WHERE [subBuildingId] = 0) mL
		ON ISNULL(wo.[SubPlantId],0) = mL.[subPlantId]
		AND ISNULL(wo.[BuildingId],0) = ml.[buildingId]

	SET @rowcount = @@ROWCOUNT
	PRINT '         ' + CAST(@rowcount AS NVARCHAR) + ' records'

END
GO