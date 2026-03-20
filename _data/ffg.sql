BEGIN --ffg

    PRINT '    fill ffg'

    DELETE FROM [etl].[stageFfg]
    
    INSERT INTO [etl].[stageFfg]
               ([id]
               ,[name]
               ,[active]
               ,[idParent]
               ,[importedAt])
    SELECT     [id]
               ,[name]
               ,[active]
               ,[idParent]
               ,[importedAt]
    FROM [archiv].[stage_stageFfg]

    DECLARE 
        @parJobRunningId INT = 1
        ,@parResult NVARCHAR(MAX)

    EXECUTE [etl].[sstFfg] @parJobRunningId,@parResult OUTPUT

    MERGE INTO [std].[ffg] t
    USING
    (
        SELECT 
            f.[functionalId] COLLATE SQL_Latin1_General_CP1_CI_AS AS [faplisId]
            ,v.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS AS [name]
            ,f.[isActive] AS [isActive]
            ,f.[Created] AS [insertedAt]
            ,f.[Modified] AS [updatedAt]
        FROM [archiv].[faplis_ffg] f
        INNER JOIN [archiv].[faplis_ffg_V] v
            ON v.[id] = f.[id]
    ) s
    ON s.[faplisId] = t.[faplisId]
    WHEN NOT MATCHED THEN
        INSERT ([name],[isActive],[faplisId],[insertedAt],[insertedBy])
        VALUES (s.[name],s.[isActive],s.[faplisId],[insertedAt],1)
    WHEN MATCHED THEN
        UPDATE SET
            t.[name] = s.[name]
            ,t.[isActive] = s.[isActive]
            ,t.[updatedAt] = s.[updatedAt]
            ,t.[updatedBy] = 1
    ;

END --ffg
GO
