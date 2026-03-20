BEGIN --plant

    PRINT '    fill plant'

    DROP TABLE IF EXISTS [mig].[mapPlantPlant]
    CREATE TABLE [mig].[mapPlantPlant] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [etl].[stagePlant]
    
    INSERT INTO [etl].[stagePlant]
               ([id]
               ,[wkz]
               ,[name]
               ,[idFaplis]
               ,[active]
               ,[importedAt])
    SELECT     [id]
               ,[wkz]
               ,[name]
               ,[idFaplis]
               ,[active]
               ,[importedAt]
    FROM [archiv].[stage_stagePlant] order by wkz

    DECLARE 
        @parJobRunningId INT = 1
        ,@parResult NVARCHAR(MAX)

    EXECUTE [etl].[sstPlant] @parJobRunningId,@parResult OUTPUT

    INSERT INTO [mig].[mapPlantPlant]([dlm2Id],[dlm3Id])
    SELECT dlm2.[PlantId],dlm3.[id]
    FROM [archiv].[faplis_Plant_V] dlm2
    INNER JOIN [loc].[plant] dlm3
        ON dlm2.[PlantCode] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[code]

END -- plant
GO