BEGIN --geoRegion

    PRINT '    fill geoRegion'

    DELETE FROM [etl].[stageGeoRegion]
    
    INSERT INTO [etl].[stageGeoRegion]
               ([id]
			   ,[name]
			   ,[code]
			   ,[type]
			   ,[GPS1X]
			   ,[GPS1Y]
			   ,[GPS2X]
			   ,[GPS2Y]
			   ,[active]
			   ,[importedAt])
    SELECT     [id]
			   ,[name]
			   ,[code]
			   ,[type]
			   ,[GPS1X]
			   ,[GPS1Y]
			   ,[GPS2X]
			   ,[GPS2Y]
			   ,[active]
			   ,[importedAt]
    FROM [archiv].[stage_stageGeoRegion]

    DECLARE 
        @parJobRunningId INT = 1
        ,@parResult NVARCHAR(MAX)

    EXECUTE [etl].[sstFfg] @parJobRunningId,@parResult OUTPUT

END --geoRegion
GO
