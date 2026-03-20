BEGIN --parameter

    PRINT '    fill parameter'

	DELETE FROM [std].[parameter]

    INSERT INTO [std].[parameter]([description],[key],[value],[isDeleted],[insertedAt],[insertedBy]) SELECT [description],[key],[value],[isDeleted],[insertedAt],[insertedBy] FROM [archiv].[stage_parameter]

END --parameter
GO


