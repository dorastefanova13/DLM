BEGIN --settlementType

    PRINT '    fill settlementType'

    DROP TABLE IF EXISTS [mig].[mapSettlementTypeSettlementType]
    CREATE TABLE [mig].[mapSettlementTypeSettlementType] (dlm2Id INT, dlm3Id INT)

    DELETE FROM [std].[settlementType]
    
    BEGIN TRY

        SET IDENTITY_INSERT [std].[settlementType] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[settlementType]([id],[code],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT 0,N'n/a',N'keine Zuordnung',0,GETDATE(),1
    INSERT INTO [mig].[mapSettlementTypeSettlementType]([dlm2Id],[dlm3Id]) SELECT 0,0

    INSERT INTO [std].[settlementType]([id],[code],[name],[isDeleted],[insertedAt],[insertedBy])
    SELECT
		t1.[id]
		,CASE t1.[id]
			WHEN 1 THEN N'KSTBONUS'
			WHEN 2 THEN N'KST'
			WHEN 3 THEN N'BONUS'
			WHEN 4 THEN N'DOKU'
			WHEN 5 THEN N'CANCELLED'
			ELSE N'n/a'
		END
		,t.[DefaultText]
		,0
		,GETDATE()
		,1
	FROM [archiv].[dbo_SettlementType] t1 
	INNER JOIN [archiv].[dbo_Text] t 
		ON t.[id] = t1.[NameTextId]

    SET IDENTITY_INSERT [std].[settlementType] OFF    

    INSERT [mig].[mapSettlementTypeSettlementType] (dlm2Id,dlm3Id)
    SELECT dlm3.[Id],dlm3.[id]
    FROM  [std].[settlementType] dlm3

END --settlementType
GO
