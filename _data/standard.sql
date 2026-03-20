BEGIN --standard

    PRINT '    fill standard'

    DELETE FROM [std].[standard]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[standard] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[standard]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,N'n/a',N'keine Zuordnung',N'keine Zuordnung',0,GETDATE(),1

	INSERT INTO [std].[standard]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 1,N'STANDARD',N'Standard',N'Standard',0,GETDATE(),1
	INSERT INTO [std].[standard]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 2,N'NONSTANDARD',N'non Standard',N'non Standard',0,GETDATE(),1
	INSERT INTO [std].[standard]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 3,N'ECO',N'Eco',N'Eco',0,GETDATE(),1
	INSERT INTO [std].[standard]([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 4,N'BESTBENCH',N'BestBench',N'BestBench',0,GETDATE(),1

	SET IDENTITY_INSERT [std].[standard] OFF

END --standard
GO
