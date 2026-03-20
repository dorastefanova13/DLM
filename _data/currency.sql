BEGIN --fill currency

    PRINT '    fill currency'

    DROP TABLE IF EXISTS [mig].[mapCurrencyCurrency]
    CREATE TABLE [mig].[mapCurrencyCurrency] (dlm2Id INT, dlm3Id INT)

	DELETE FROM [std].[currency]

    INSERT INTO [std].[currency]([code],[name],[isDeleted],[insertedAt],[insertedBy])
    SELECT t1.[IsoCode],t.[DefaultText], 0, GETDATE(),1
	FROM [FAPLISDlm]..Currency t1 INNER JOIN [archiv].[dbo_Text] t ON t.[id] = t1.[NameTextId]

    INSERT [mig].[mapCurrencyCurrency] (dlm2Id,dlm3Id)
    SELECT dlm2.[Id],dlm3.[id]
    FROM [std].[currency] dlm3
    INNER JOIN (SELECT t1.[id],t.[DefaultText] AS [name] FROM [FAPLISDlm]..Currency t1 INNER JOIN [archiv].[dbo_Text] t ON t.[id] = t1.[NameTextId]) dlm2
        ON dlm2.[name] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[name]



END --fill currency
GO
