BEGIN --tenderStatus

    PRINT '    fill tenderStatus'

    DELETE FROM  [std].[tenderStatus]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[tenderStatus] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH 

    INSERT INTO [std].[tenderStatus]([id],[code],[description],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,N'n/a',N'keine Zuordnung',N'keine Zuordnung',0,GETDATE(),1

	INSERT INTO [std].[tenderStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 1,N'OPEN',N'erstellt',N'Ausschreibung erstellt',0,GETDATE(),1
    INSERT INTO [std].[tenderStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 2,N'INPROGRESS',N'in Bearbeitung',N'Preisanfragen erstellt',0,GETDATE(),1
	INSERT INTO [std].[tenderStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 3,N'AWARDED',N'geschlossen',N'Ausschreibung beendet',0,GETDATE(),1
	INSERT INTO [std].[tenderStatus]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 4,N'DELETED',N'gelöscht',N'Ausschreibung gelöscht',0,GETDATE(),1

	SET IDENTITY_INSERT [std].[tenderStatus] OFF    

END --tenderStatus
GO