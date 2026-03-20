BEGIN --site

    PRINT '    fill site'

    DROP TABLE IF EXISTS [mig].[mapSiteSite]
    CREATE TABLE [mig].[mapSiteSite] (dlm2Id INT, dlm3Id INT)
    
    DELETE FROM [etl].[stageSite]
    
    INSERT INTO [etl].[stageSite]
               ([id]
               ,[name]
               ,[active]
               ,[importedAt])
    SELECT     [id]
               ,[name]
               ,[active]
               ,[importedAt]
    FROM [archiv].[stage_stageSite]

    DECLARE 
        @parJobRunningId INT = 1
        ,@parResult NVARCHAR(MAX)

    EXECUTE [etl].[sstSite] @parJobRunningId,@parResult OUTPUT

    INSERT INTO [mig].[mapSiteSite]([dlm2Id],[dlm3Id])
    SELECT dlm2.[id],dlm3.[id]
    FROM  [archiv].[stage_stageSite] dlm2
    INNER JOIN [loc].[site] dlm3
        ON dlm3.[faplisId] = dlm2.[id]

END --site
GO
