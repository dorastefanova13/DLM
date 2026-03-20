BEGIN --turnus

    PRINT '    fill turnus'

    DROP TABLE IF EXISTS [mig].[mapCycleTurnus]
    CREATE TABLE [mig].[mapCycleTurnus] (dlm2Id INT, dlm3Id INT)

    CREATE CLUSTERED INDEX [x_mapCycleTurnus] ON [mig].[mapCycleTurnus]
    (
    	[dlm2Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

    DELETE FROM [std].[turnus]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[turnus] ON

    END TRY
    BEGIN CATCH

        PRINT '   IDENTITY_INSERT ON'

    END CATCH

    INSERT INTO [std].[turnus]([id],[code],[name],[factor],[isDeleted],[isLegacy])
    SELECT 0,'00','keine Zuordnung',0,0,1

    INSERT [mig].[mapCycleTurnus] (dlm2Id,dlm3Id)
    SELECT 0,0

    SET IDENTITY_INSERT [std].[turnus] OFF

    INSERT INTO [std].[turnus]([code],[name],[factor],[isDeleted],[isLegacy],[insertedAt],[insertedBy])
    SELECT RIGHT('0' + CAST(t1.[code] AS NVARCHAR),2) ,t.[DefaultText],t1.[Factor],0,1 ,t1.[Created],1
	FROM [archiv].[dbo_Cycle] t1 
	INNER JOIN [archiv].[dbo_Text] t ON t.[id] = t1.[NameTextId]

    INSERT [mig].[mapCycleTurnus] (dlm2Id,dlm3Id)
    SELECT dlm2.[Id],dlm3.[id]
    FROM [std].[turnus] dlm3
    INNER JOIN (SELECT t1.[id],t.[DefaultText] AS [name] FROM [FAPLISDlm]..Cycle t1 INNER JOIN [archiv].[dbo_Text] t ON t.[id] = t1.[NameTextId]) dlm2
        ON dlm2.[name] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[name]

    -- testdata for turnus

    MERGE INTO [std].[turnus] AS t
    USING
    (
        SELECT N'W01' AS [code], N'1 Ausführung(-en)/Woche' AS [name], CAST('4.345' AS FLOAT) AS [factor]
        UNION ALL SELECT N'W02' AS [code], N'2 Ausführung(-en)/Woche' AS [name], CAST('8.69' AS FLOAT) AS [factor]
        UNION ALL SELECT N'W25' AS [code], N'2,5 Ausführung(-en)/Woche' AS [name], CAST('10.863' AS FLOAT) AS [factor]
        UNION ALL SELECT N'W03' AS [code], N'3 Ausführung(-en)/Woche' AS [name], CAST('13.036' AS FLOAT) AS [factor]
        UNION ALL SELECT N'W04' AS [code], N'4 Ausführung(-en)/Woche' AS [name], CAST('17.381' AS FLOAT) AS [factor]
        UNION ALL SELECT N'W05' AS [code], N'5 Ausführung(-en)/Woche' AS [name], CAST('21.726' AS FLOAT) AS [factor]
        UNION ALL SELECT N'W06' AS [code], N'6 Ausführung(-en)/Woche' AS [name], CAST('26.071' AS FLOAT) AS [factor]
        UNION ALL SELECT N'W07' AS [code], N'7 Ausführung(-en)/Woche' AS [name], CAST('30.417' AS FLOAT) AS [factor]
        UNION ALL SELECT N'S01' AS [code], N'1 Ausführung(-en)/Woche Spätschicht' AS [name], CAST('4.345' AS FLOAT) AS [factor]
        UNION ALL SELECT N'S02' AS [code], N'2 Ausführung(-en)/Woche Spätschicht' AS [name], CAST('8.69' AS FLOAT) AS [factor]
        UNION ALL SELECT N'S25' AS [code], N'2,5 Ausführung(-en)/Woche Spätschicht' AS [name], CAST('10.863' AS FLOAT) AS [factor]
        UNION ALL SELECT N'S03' AS [code], N'3 Ausführung(-en)/Woche Spätschicht' AS [name], CAST('13.036' AS FLOAT) AS [factor]
        UNION ALL SELECT N'S04' AS [code], N'4 Ausführung(-en)/Woche Spätschicht' AS [name], CAST('17.381' AS FLOAT) AS [factor]
        UNION ALL SELECT N'S05' AS [code], N'5 Ausführung(-en)/Woche Spätschicht' AS [name], CAST('21.726' AS FLOAT) AS [factor]
        UNION ALL SELECT N'S06' AS [code], N'6 Ausführung(-en)/Woche Spätschicht' AS [name], CAST('26.071' AS FLOAT) AS [factor]
        UNION ALL SELECT N'S07' AS [code], N'7 Ausführung(-en)/Woche Spätschicht' AS [name], CAST('30.417' AS FLOAT) AS [factor]
        UNION ALL SELECT N'N01' AS [code], N'1 Ausführung(-en)/Woche Nachtschicht' AS [name], CAST('4.345' AS FLOAT) AS [factor]
        UNION ALL SELECT N'N02' AS [code], N'2 Ausführung(-en)/Woche Nachtschicht' AS [name], CAST('8.69' AS FLOAT) AS [factor]
        UNION ALL SELECT N'N25' AS [code], N'2,5 Ausführung(-en)/Woche Nachtschicht' AS [name], CAST('10.863' AS FLOAT) AS [factor]
        UNION ALL SELECT N'N03' AS [code], N'3 Ausführung(-en)/Woche Nachtschicht' AS [name], CAST('13.036' AS FLOAT) AS [factor]
        UNION ALL SELECT N'N04' AS [code], N'4 Ausführung(-en)/Woche Nachtschicht' AS [name], CAST('17.381' AS FLOAT) AS [factor]
        UNION ALL SELECT N'N05' AS [code], N'5 Ausführung(-en)/Woche Nachtschicht' AS [name], CAST('21.726' AS FLOAT) AS [factor]
        UNION ALL SELECT N'N06' AS [code], N'6 Ausführung(-en)/Woche Nachtschicht' AS [name], CAST('26.071' AS FLOAT) AS [factor]
        UNION ALL SELECT N'N07' AS [code], N'7 Ausführung(-en)/Woche Nachtschicht' AS [name], CAST('30.417' AS FLOAT) AS [factor]
        UNION ALL SELECT N'02W' AS [code], N'2-wöchige Ausführung' AS [name], CAST('0' AS FLOAT) AS [factor]
        UNION ALL SELECT N'03W' AS [code], N'3-wöchige Ausführung' AS [name], CAST('0' AS FLOAT) AS [factor]
        UNION ALL SELECT N'04W' AS [code], N'4-wöchige Ausführung' AS [name], CAST('0' AS FLOAT) AS [factor]
        UNION ALL SELECT N'01M' AS [code], N'1 Ausführung(-en)/Monat' AS [name], CAST('1' AS FLOAT) AS [factor]
        UNION ALL SELECT N'02M' AS [code], N'2 Ausführung(-en)/Monat' AS [name], CAST('2' AS FLOAT) AS [factor]
        UNION ALL SELECT N'01J' AS [code], N'1 Ausführung(-en)/Jahr' AS [name], CAST('0.083' AS FLOAT) AS [factor]
        UNION ALL SELECT N'02J' AS [code], N'2 Ausführung(-en)/Jahr' AS [name], CAST('0.167' AS FLOAT) AS [factor]
        UNION ALL SELECT N'03J' AS [code], N'3 Ausführung(-en)/Jahr' AS [name], CAST('0.25' AS FLOAT) AS [factor]
        UNION ALL SELECT N'04J' AS [code], N'4 Ausführung(-en)/Jahr' AS [name], CAST('0.333' AS FLOAT) AS [factor]
        UNION ALL SELECT N'05J' AS [code], N'5 Ausführung(-en)/Jahr' AS [name], CAST('0.417' AS FLOAT) AS [factor]
        UNION ALL SELECT N'06J' AS [code], N'6 Ausführung(-en)/Jahr' AS [name], CAST('0.5' AS FLOAT) AS [factor]
        UNION ALL SELECT N'24M' AS [code], N'2-jährige Ausführung' AS [name], CAST('0.042' AS FLOAT) AS [factor]
        UNION ALL SELECT N'36M' AS [code], N'3-jährige Ausführung' AS [name], CAST('0.028' AS FLOAT) AS [factor]
        UNION ALL SELECT N'48M' AS [code], N'4-jährige Ausführung' AS [name], CAST('0.021' AS FLOAT) AS [factor]
        UNION ALL SELECT N'Z01' AS [code], N'1 Ausführung(-en)/Zusatzschicht' AS [name], CAST('1' AS FLOAT) AS [factor]
    ) AS s
    ON s.[code] = t.[code]
    WHEN NOT MATCHED THEN 
        INSERT ([code],[name],[factor],[isDeleted],[isLegacy],[insertedAt],[insertedBy])
        VALUES (s.[code],s.[name],s.[factor],0,0,GETDATE(),1)
	WHEN MATCHED THEN
		UPDATE SET
			t.[name] = s.[name]
			,t.[factor] = s.[factor]
			,t.[updatedAt] = GETDATE()
			,t.[updatedBy] = 1
			;

END --turnus
