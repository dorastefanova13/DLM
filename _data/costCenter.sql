BEGIN --costcenter

    PRINT '    fill costcenter'

    DELETE FROM [etl].[stageCostCenter]
    
    INSERT INTO [etl].[stageCostCenter]
               ([id]
               ,[description]
               ,[costId]
               ,[idPlant]
               ,[idOrgUnit]
               ,[active]
               ,[importedAt])
    SELECT
        [id]
        ,[description]
        ,[costId]
        ,[idPlant]
        ,[idOrgUnit]
        ,[active]
        ,[importedAt]
    FROM (        
        SELECT
            [id]
            ,[description]
            ,[costId]
            ,[idPlant]
            ,ISNULL([idOrgUnit],0) AS [idOrgUnit]
            ,[active]
            ,[importedAt]
            ,ROW_NUMBER() OVER(PARTITION BY [id] ORDER BY [importedAt] DESC) AS [row]
        FROM
        (
            SELECT
                    [id] COLLATE SQL_Latin1_General_CP1_CI_AS AS [id]
                    ,[description] COLLATE SQL_Latin1_General_CP1_CI_AS AS [description]
                    ,[costId] COLLATE SQL_Latin1_General_CP1_CI_AS AS [costId]
                    ,[idPlant]
                    ,CASE WHEN ISNULL([idOrgUnit],'') = '' THEN NULL ELSE [idOrgUnit] END AS [idOrgUnit]
                    ,[active]
                    ,[importedAt]
            FROM [archiv].[stage_stageCostCenter]
            UNION ALL 
            SELECT 
                [functionalId] COLLATE SQL_Latin1_General_CP1_CI_AS AS [id]
                ,[Name] COLLATE SQL_Latin1_General_CP1_CI_AS AS [description]
                ,[Code] COLLATE SQL_Latin1_General_CP1_CI_AS AS [costId]
                ,[PlantId] AS [idPlant]
                ,NULL AS [idOrgUnit]
                ,[isActive] AS [active]
                ,ISNULL([Modified],[Created]) AS [importedAt]
            FROM [archiv].[faplis_CostCenter_V]
        )uni
    ) q  WHERE [row] = 1

    DECLARE 
        @parJobRunningId INT = 1
        ,@parResult NVARCHAR(MAX)

    EXECUTE [etl].[sstCostCenter] @parJobRunningId,@parResult OUTPUT

END --costcenter
GO
