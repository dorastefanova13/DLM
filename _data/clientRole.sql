BEGIN --clientRole

    PRINT '    fill clientRole'

    DROP TABLE IF EXISTS [mig].[mapRoleClientRole]
    CREATE TABLE [mig].[mapRoleClientRole] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [sec].[clientRole]

    BEGIN TRY

        SET IDENTITY_INSERT [sec].[clientRole] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 1,'Planner','Planer',0,GETDATE(),1
    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 2,'PlantAdmin','Werks-Admin',0,GETDATE(),1
    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 3,'DLMAdmin','DLMAdmin',0,GETDATE(),1
    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 4,'Purchaser','Einkauf',0,GETDATE(),1
    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 5,'CleaningBoard','AK-Reinigung',0,GETDATE(),1
    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 6,'Translator','Übersetzer',0,GETDATE(),1
    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 7,'Guest', 'Gast',0,GETDATE(),1
    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 8,'Advisor', 'Betreuer',0,GETDATE(),1
    INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 9,'AreaCleaning', 'Unterhaltsreinigung',0,GETDATE(),1
	INSERT INTO [sec].[clientRole]([id],[name],[description],[isDeleted],[insertedAt],[insertedBy]) SELECT 10,'TechnicalCleaning', 'Techn. Reinigung',0,GETDATE(),1


    SET IDENTITY_INSERT [sec].[clientRole] OFF

    INSERT INTO [mig].[mapRoleClientRole](dlm2Id,dlm3Id)
    SELECT [dlm2Id],[dlm3Id] FROM
    (
        SELECT dlm2.[id] AS dlm2Id,dlm3.[id] AS dlm3Id FROM (SELECT * FROM [archiv].[dbo_Role] WHERE [key] = 'DlmAdministrator') dlm2 CROSS JOIN (SELECT * FROM [sec].[clientRole] WHERE [name] = 'DLMAdmin') dlm3
        UNION ALL
        SELECT dlm2.[id] AS dlm2Id,dlm3.[id] AS dlm3Id FROM (SELECT * FROM [archiv].[dbo_Role] WHERE [key] = 'DlmPlantAdministrator') dlm2 CROSS JOIN (SELECT * FROM [sec].[clientRole] WHERE [name] = 'PlantAdmin') dlm3
        UNION ALL
        SELECT dlm2.[id] AS dlm2Id,dlm3.[id] AS dlm3Id FROM (SELECT * FROM [archiv].[dbo_Role] WHERE [key] = 'DlmPlanner') dlm2 CROSS JOIN (SELECT * FROM [sec].[clientRole] WHERE [name] = 'Planner') dlm3
        UNION ALL
        SELECT dlm2.[id] AS dlm2Id,dlm3.[id] AS dlm3Id FROM (SELECT * FROM [archiv].[dbo_Role] WHERE [key] = 'DlmAdvisor') dlm2 CROSS JOIN (SELECT * FROM [sec].[clientRole] WHERE [name] = 'Advisor') dlm3
        UNION ALL
        SELECT dlm2.[id] AS dlm2Id,dlm3.[id] AS dlm3Id FROM (SELECT * FROM [archiv].[dbo_Role] WHERE [key] = 'DlmPurchase') dlm2 CROSS JOIN (SELECT * FROM [sec].[clientRole] WHERE [name] = 'Purchaser') dlm3
        UNION ALL
        SELECT dlm2.[id] AS dlm2Id,dlm3.[id] AS dlm3Id FROM (SELECT * FROM [archiv].[dbo_Role] WHERE [key] = 'DlmGuest') dlm2 CROSS JOIN (SELECT * FROM [sec].[clientRole] WHERE [name] = 'Guest') dlm3
    ) q

END --clientRole
GO
