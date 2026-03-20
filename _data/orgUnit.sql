BEGIN --orgUnit

    DELETE FROM [etl].[stageOrgUnit]
    
     BEGIN TRY

        SET IDENTITY_INSERT [std].[orgUnit] ON

    END TRY
    BEGIN CATCH

        PRINT '   IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[orgUnit]([id],[name],[isActive],[faplisId])
    SELECT 0,'keine Zuordnung',1,'0'

    SET IDENTITY_INSERT [std].[orgUnit] OFF

    INSERT INTO [etl].[stageOrgUnit]
               ([id]
               ,[name]
               ,[active]
               ,[importedAt])
    SELECT     [id]
               ,[name] COLLATE SQL_Latin1_General_CP1_CI_AS
               ,[active]
               ,[importedAt]
    FROM [archiv].[stage_stageOrgUnit]

    DECLARE 
        @parJobRunningId INT = 1
        ,@parResult NVARCHAR(MAX)

    EXECUTE [etl].[sstOrgUnit] @parJobRunningId,@parResult OUTPUT

END --orgUnit
GO
