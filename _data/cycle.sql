BEGIN --cycle

    PRINT '    fill cycle'

    DELETE FROM [etl].[stageCycle]
    
    INSERT INTO [etl].[stageCycle]
               ([id]
               ,[name]
               ,[type]
               ,[active]
               ,[importedAt])
    SELECT     [id]
               ,[name]
               ,[type]
               ,[active]
               ,[importedAt]
    FROM [archiv].[stage_stageCycle]

    DECLARE 
        @parJobRunningId INT = 1
        ,@parResult NVARCHAR(MAX)

    EXECUTE [etl].[sstCycle] @parJobRunningId,@parResult OUTPUT

    MERGE INTO [std].[cycle] t
    USING
    (
        SELECT 
            [functionalId] COLLATE SQL_Latin1_General_CP1_CI_AS AS [faplisId]
            ,[Name] COLLATE SQL_Latin1_General_CP1_CI_AS AS [name]
            ,[isActive] AS [isActive]
        FROM [archiv].[faplis_FaplisCycle]
    ) s
    ON s.[faplisId] = t.[faplisId]
    WHEN NOT MATCHED THEN
        INSERT ([name],[isActive],[faplisId],[insertedAt],[insertedBy])
        VALUES (s.[name],s.[isActive],s.[faplisId],SYSDATETIME(),1)
    WHEN MATCHED THEN
        UPDATE SET
            t.[name] = s.[name]
            ,t.[isActive] = s.[isActive]
            ,t.[updatedAt] = SYSDATETIME()
            ,t.[updatedBy] = 1
    ;


END --cycle
GO
