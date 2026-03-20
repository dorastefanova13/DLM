BEGIN --lvAlloc

    DELETE FROM [etl].[stageLvAlloc]
    
    INSERT INTO [etl].[stageLvAlloc]
               ([id]
               ,[name]
               ,[active]
               ,[importedAt])
    SELECT     [id]
               ,[name]
               ,[active]
               ,[importedAt]
    FROM [archiv].[stage_stageLvAlloc]

    DECLARE 
        @parJobRunningId INT = 1
        ,@parResult NVARCHAR(MAX)

    EXECUTE [etl].[sstLvAlloc] @parJobRunningId,@parResult OUTPUT

    DELETE FROM [std].[lvAlloc]

    MERGE INTO [std].[lvAlloc] t
    USING
    (
        SELECT 
            f.[functionalId] COLLATE SQL_Latin1_General_CP1_CI_AS AS [faplisId]
            ,v.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS AS [name]
            ,f.[isActive] AS [isActive]
        FROM [archiv].[faplis_LvAlloc] f
        INNER JOIN [archiv].[faplis_lvAlloc_V] v
            ON v.[id] = f.[id]
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


END --lvAlloc
GO
