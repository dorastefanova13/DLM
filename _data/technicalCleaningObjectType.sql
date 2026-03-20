BEGIN --technicalCleaningObjectType

    PRINT '    fill technicalCleaningObjectType'

    DELETE FROM [std].[technicalCleaningObjectType]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[technicalCleaningObjectType] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

        INSERT INTO [std].[technicalCleaningObjectType]
           ([id]
           ,[code]
           ,[name]
           ,[description]
           ,[isDeleted]
		   ,[insertedAt]
		   ,[insertedBy])
        SELECT 
            0
            ,N'n/a'
            ,N'keine Zuordnung'
            ,N'keine Zuordnung'
            ,0
			,GETDATE()
			,1

    SET IDENTITY_INSERT [std].[technicalCleaningObjectType] OFF

END --clientRole
GO
