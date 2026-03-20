BEGIN --appFunctionality
    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    fill appFunctionality'

    PRINT @msg

    DELETE FROM [sec].[mapRoleAppFunctionality]
    DELETE FROM [sec].[mapTableAppFunctionality]
    DELETE FROM [sec].[mapViewAppFunctionality]

    DELETE FROM [sec].[appFunctionality]

    SET IDENTITY_INSERT [sec].[appFunctionality] ON
    
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 1,N'Währungen',N'currency'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 2,N'Hauptcodes',N'mainCode'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 3,N'Leistungskategorien',N'serviceCategory'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 4,N'Reinigungsobjekttypen',N'serviceObjectType'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 5,N'Ausführung-/Abrechnungsstatus',N'serviceOrderStatus'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 6,N'Leistungstypen',N'serviceType'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 7,N'Standards',N'standard'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 8,N'Turnusse',N'turnus'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 9,N'Einheiten',N'unit'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 10,N'Lohncluster',N'wageGroup,wageCluster'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 11,N'Gesellschaften',N'company'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 12,N'Lieferanten',N'supplier'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 13,N'Standardwerte für Abzüge',N'standardDiscount'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 14,N'Kalender',N'calendar,calendarDay'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 15,N'Anlagen',N'technicalCleaningObject'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 16,N'Reinigungsobjekt (aka. Interne Flächen)',N'customCleaningObject'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 17,N'Leistungskataloge',N'serviceCatalog,servicePosition'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 18,N'Standortkataloge',N'siteCatalog,siteCatalogPosition'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 19,N'Preiskataloge',N'priceCatalog,priceCatalogPosition'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 20,N'Ausschreibung',N'priceCatalogCalculation,priceCatalogCalculationPosition'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 21,N'Leistungsabruf (Regelleistung)',N'serviceOrder,serviceOrderPosition'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 22,N'Leistungsabruf (AdHoc Leistung)',N'serviceOrder,serviceOrderPosition'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 23,N'Leistungssteuerung',N'serviceOrder,serviceOrderPosition'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 24,N'Leistungsabnahme',N'serviceOrder,serviceOrderPosition'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 25,N'Abrechnung',N'bill,billPositon'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 26,N'Reporting',N'serviceCatalog,siteCatalog,siteCatalogPosition,priceCatalog,serviceOrder,serviceOrderPosition,bill'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 27,N'Administration',N'*'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 28,N'Benutzerverwaltung',N'client'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 29,N'Übersetzungen',N'*'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 30,N'SAP-Bestellungen',N'sapOrder'
    INSERT INTO [sec].[appFunctionality]([id],[name],[mainTable]) SELECT 31,N'Abrechungstypen',N'settlementType'
    
    SET IDENTITY_INSERT [sec].[appFunctionality] OFF

    SET @msg = '    fill appFunctionality done'

    PRINT @msg

END --appFunctionality

BEGIN --mapRoleAppFunctionality

	-- which role can read,write,delete for which app-functionality

    SET @msg = '    fill mapRoleAppFunctionality'

    PRINT @msg

    DELETE FROM [sec].[mapRoleAppFunctionality]

    INSERT INTO [sec].[mapRoleAppFunctionality]([clientRoleId],[appFunctionalityId])
    SELECT
        cr.[id] as [clientRoleId]
        ,f.[id] AS [appFunctionalityId]
    FROM [sec].[clientRole] cr
    CROSS JOIN [sec].[appFunctionality] f

    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Währungen') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Hauptcodes') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskategorien') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekttypen') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausführung-/Abrechnungsstatus') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungstypen') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standards') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Turnusse') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Einheiten') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lohncluster') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Gesellschaften') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Lieferanten') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standardwerte für Abzüge') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Kalender') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Anlagen') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reinigungsobjekt (aka. Interne Flächen)') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungskataloge') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Standortkataloge') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Preiskataloge') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Ausschreibung') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (Regelleistung)') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabruf (AdHoc Leistung)') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungssteuerung') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Leistungsabnahme') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechnung') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Reporting') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Administration') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Benutzerverwaltung') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Übersetzungen') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'W' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'D' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   'R' WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'SAP-Bestellungen') --TechnicalCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --Planner
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --PlantAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))          AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --DLMAdmin
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))         AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --Purchaser
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard'))     AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --CleaningBoard
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))        AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --Translator
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))             AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --Guest
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))           AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --Advisor
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('AreaCleaning'))      AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --AreaCleaning
    UPDATE [sec].[mapRoleAppFunctionality] SET [permission] =   ''  WHERE [clientRoleId] = (SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('TechnicalCleaning')) AND [appFunctionalityId] = (SELECT [id] FROM [sec].[appFunctionality] WHERE [name] = 'Abrechungstypen') --TechnicalCleaning

    SET @msg = '    fill mapRoleAppFunctionality done'

    PRINT @msg

END --mapRoleAppFunctionality

BEGIN --mapTableAppFunctionality

	-- which app-functionality can read,write,delete on which table

    SET @msg = '    fill mapTableAppFunctionality'

    PRINT @msg

    DELETE FROM [sec].[mapTableAppFunctionality]

    INSERT INTO [sec].[mapTableAppFunctionality]([table],[permission],[appFunctionalityId],[appFunctionalityPermission])
              SELECT 'client', 'R', 1, 'R'                                            --Währungen (currency) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 1, 'R'                                  --Währungen (currency) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 1, 'R'                                        --Währungen (currency) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 1, 'R'                                           --Währungen (currency) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 1, 'R'                                          --Währungen (currency) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 1, 'R'                                          --Währungen (currency) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 1, 'R'                         --Währungen (currency) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 1, 'R'                                  --Währungen (currency) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 1, 'R'                   --Währungen (currency) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 1, 'R'                                    --Währungen (currency) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 1, 'R'                              --Währungen (currency) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 1, 'R'                       --Währungen (currency) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 1, 'R'                             --Währungen (currency) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 1, 'R'                                         --Währungen (currency) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 1, 'R'                                             --Währungen (currency) READ   -> plant READ
    UNION ALL SELECT 'plant', 'R', 1, 'W'                                             --Währungen (currency) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 1, 'W'                                         --Währungen (currency) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 1, 'W'                             --Währungen (currency) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 1, 'W'                       --Währungen (currency) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 1, 'W'                              --Währungen (currency) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 1, 'W'                                    --Währungen (currency) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 1, 'W'                   --Währungen (currency) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 1, 'W'                                  --Währungen (currency) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 1, 'W'                         --Währungen (currency) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 1, 'W'                                          --Währungen (currency) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 1, 'W'                                          --Währungen (currency) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 1, 'W'                                           --Währungen (currency) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 1, 'W'                                        --Währungen (currency) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 1, 'W'                                  --Währungen (currency) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 1, 'W'                                            --Währungen (currency) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 1, 'D'                                  --Währungen (currency) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 1, 'D'                                        --Währungen (currency) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 1, 'D'                                           --Währungen (currency) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 1, 'D'                                          --Währungen (currency) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 1, 'D'                                          --Währungen (currency) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 1, 'D'                         --Währungen (currency) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 1, 'D'                                  --Währungen (currency) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 1, 'D'                   --Währungen (currency) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 1, 'D'                                    --Währungen (currency) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 1, 'D'                              --Währungen (currency) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 1, 'D'                       --Währungen (currency) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 1, 'D'                             --Währungen (currency) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 1, 'D'                                         --Währungen (currency) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 1, 'D'                                             --Währungen (currency) DELETE -> plant READ
    UNION ALL SELECT 'client', 'R', 1, 'D'                                            --Währungen (currency) DELETE -> client READ
    UNION ALL SELECT 'parameter', 'R', 2, 'R'                                         --Hauptcodes (mainCode) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 2, 'R'                             --Hauptcodes (mainCode) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 2, 'R'                       --Hauptcodes (mainCode) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 2, 'R'                              --Hauptcodes (mainCode) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 2, 'R'                                    --Hauptcodes (mainCode) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 2, 'R'                   --Hauptcodes (mainCode) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 2, 'R'                                  --Hauptcodes (mainCode) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 2, 'R'                         --Hauptcodes (mainCode) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 2, 'R'                                          --Hauptcodes (mainCode) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 2, 'R'                                          --Hauptcodes (mainCode) READ   -> language READ
    UNION ALL SELECT 'plant', 'R', 2, 'R'                                             --Hauptcodes (mainCode) READ   -> plant READ
    UNION ALL SELECT 'company', 'R', 2, 'R'                                           --Hauptcodes (mainCode) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 2, 'R'                                        --Hauptcodes (mainCode) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 2, 'R'                                  --Hauptcodes (mainCode) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 2, 'R'                                            --Hauptcodes (mainCode) READ   -> client READ
    UNION ALL SELECT 'usageType', 'R', 2, 'R'                                         --Hauptcodes (mainCode) READ   -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 2, 'R'                                       --Hauptcodes (mainCode) READ   -> wageCluster READ
    UNION ALL SELECT 'mainCode', 'W', 2, 'W'                                          --Hauptcodes (mainCode) WRITE  -> mainCode WRITE
    UNION ALL SELECT 'wageCluster', 'R', 2, 'W'                                       --Hauptcodes (mainCode) WRITE  -> wageCluster READ
    UNION ALL SELECT 'wageGroup', 'R', 2, 'W'                                         --Hauptcodes (mainCode) WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 2, 'W'                                         --Hauptcodes (mainCode) WRITE  -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 2, 'W'                                         --Hauptcodes (mainCode) WRITE  -> usageType READ
    UNION ALL SELECT 'usageType', 'D', 2, 'W'                                         --Hauptcodes (mainCode) WRITE  -> usageType DELETE
    UNION ALL SELECT 'usageType', 'W', 2, 'W'                                         --Hauptcodes (mainCode) WRITE  -> usageType WRITE
    UNION ALL SELECT 'clientRole', 'R', 2, 'W'                                        --Hauptcodes (mainCode) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 2, 'W'                                  --Hauptcodes (mainCode) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 2, 'W'                                            --Hauptcodes (mainCode) WRITE  -> client READ
    UNION ALL SELECT 'plant', 'R', 2, 'W'                                             --Hauptcodes (mainCode) WRITE  -> plant READ
    UNION ALL SELECT 'language', 'R', 2, 'W'                                          --Hauptcodes (mainCode) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 2, 'W'                                           --Hauptcodes (mainCode) WRITE  -> company READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 2, 'W'                         --Hauptcodes (mainCode) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 2, 'W'                                          --Hauptcodes (mainCode) WRITE  -> mainCode READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 2, 'W'                   --Hauptcodes (mainCode) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 2, 'W'                                  --Hauptcodes (mainCode) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'W', 2, 'W'                              --Hauptcodes (mainCode) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 2, 'W'                                    --Hauptcodes (mainCode) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 2, 'W'                             --Hauptcodes (mainCode) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 2, 'W'                       --Hauptcodes (mainCode) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'parameter', 'R', 2, 'W'                                         --Hauptcodes (mainCode) WRITE  -> parameter READ
    UNION ALL SELECT 'parameter', 'R', 2, 'D'                                         --Hauptcodes (mainCode) DELETE -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 2, 'D'                             --Hauptcodes (mainCode) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapClientPlant', 'R', 2, 'D'                                    --Hauptcodes (mainCode) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'W', 2, 'D'                              --Hauptcodes (mainCode) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 2, 'D'                       --Hauptcodes (mainCode) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 2, 'D'                   --Hauptcodes (mainCode) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 2, 'D'                         --Hauptcodes (mainCode) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 2, 'D'                                  --Hauptcodes (mainCode) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mainCode', 'R', 2, 'D'                                          --Hauptcodes (mainCode) DELETE -> mainCode READ
    UNION ALL SELECT 'language', 'R', 2, 'D'                                          --Hauptcodes (mainCode) DELETE -> language READ
    UNION ALL SELECT 'plant', 'R', 2, 'D'                                             --Hauptcodes (mainCode) DELETE -> plant READ
    UNION ALL SELECT 'clientPermission', 'R', 2, 'D'                                  --Hauptcodes (mainCode) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 2, 'D'                                        --Hauptcodes (mainCode) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 2, 'D'                                           --Hauptcodes (mainCode) DELETE -> company READ
    UNION ALL SELECT 'wageCluster', 'R', 2, 'D'                                       --Hauptcodes (mainCode) DELETE -> wageCluster READ
    UNION ALL SELECT 'wageGroup', 'R', 2, 'D'                                         --Hauptcodes (mainCode) DELETE -> wageGroup READ    
    UNION ALL SELECT 'usageType', 'W', 2, 'D'                                         --Hauptcodes (mainCode) DELETE -> usageType WRITE
    UNION ALL SELECT 'usageType', 'D', 2, 'D'                                         --Hauptcodes (mainCode) DELETE -> usageType DELETE
    UNION ALL SELECT 'client', 'R', 2, 'D'                                            --Hauptcodes (mainCode) DELETE -> client READ
    UNION ALL SELECT 'usageType', 'R', 2, 'D'                                         --Hauptcodes (mainCode) DELETE -> usageType READ
    UNION ALL SELECT 'client', 'R', 3, 'R'                                            --Leistungskategorien (serviceCategory) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 3, 'R'                                  --Leistungskategorien (serviceCategory) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 3, 'R'                                        --Leistungskategorien (serviceCategory) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 3, 'R'                                           --Leistungskategorien (serviceCategory) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 3, 'R'                                          --Leistungskategorien (serviceCategory) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 3, 'R'                                          --Leistungskategorien (serviceCategory) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 3, 'R'                         --Leistungskategorien (serviceCategory) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 3, 'R'                                  --Leistungskategorien (serviceCategory) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 3, 'R'                   --Leistungskategorien (serviceCategory) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 3, 'R'                                    --Leistungskategorien (serviceCategory) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 3, 'R'                              --Leistungskategorien (serviceCategory) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 3, 'R'                       --Leistungskategorien (serviceCategory) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 3, 'R'                             --Leistungskategorien (serviceCategory) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 3, 'R'                                         --Leistungskategorien (serviceCategory) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 3, 'R'                                             --Leistungskategorien (serviceCategory) READ   -> plant READ
    UNION ALL SELECT 'plant', 'R', 3, 'W'                                             --Leistungskategorien (serviceCategory) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 3, 'W'                                         --Leistungskategorien (serviceCategory) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 3, 'W'                             --Leistungskategorien (serviceCategory) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 3, 'W'                       --Leistungskategorien (serviceCategory) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 3, 'W'                              --Leistungskategorien (serviceCategory) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 3, 'W'                                    --Leistungskategorien (serviceCategory) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 3, 'W'                   --Leistungskategorien (serviceCategory) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 3, 'W'                                  --Leistungskategorien (serviceCategory) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 3, 'W'                         --Leistungskategorien (serviceCategory) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 3, 'W'                                          --Leistungskategorien (serviceCategory) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 3, 'W'                                          --Leistungskategorien (serviceCategory) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 3, 'W'                                           --Leistungskategorien (serviceCategory) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 3, 'W'                                        --Leistungskategorien (serviceCategory) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 3, 'W'                                  --Leistungskategorien (serviceCategory) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 3, 'W'                                            --Leistungskategorien (serviceCategory) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 3, 'D'                                  --Leistungskategorien (serviceCategory) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 3, 'D'                                            --Leistungskategorien (serviceCategory) DELETE -> client READ
    UNION ALL SELECT 'clientRole', 'R', 3, 'D'                                        --Leistungskategorien (serviceCategory) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 3, 'D'                                           --Leistungskategorien (serviceCategory) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 3, 'D'                                          --Leistungskategorien (serviceCategory) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 3, 'D'                                          --Leistungskategorien (serviceCategory) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 3, 'D'                         --Leistungskategorien (serviceCategory) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 3, 'D'                                  --Leistungskategorien (serviceCategory) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 3, 'D'                   --Leistungskategorien (serviceCategory) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 3, 'D'                                    --Leistungskategorien (serviceCategory) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 3, 'D'                              --Leistungskategorien (serviceCategory) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 3, 'D'                       --Leistungskategorien (serviceCategory) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 3, 'D'                             --Leistungskategorien (serviceCategory) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 3, 'D'                                         --Leistungskategorien (serviceCategory) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 3, 'D'                                             --Leistungskategorien (serviceCategory) DELETE -> plant READ
    UNION ALL SELECT 'plant', 'R', 4, 'R'                                             --Reinigungsobjekttypen (serviceObjectType) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 4, 'R'                                         --Reinigungsobjekttypen (serviceObjectType) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 4, 'R'                             --Reinigungsobjekttypen (serviceObjectType) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 4, 'R'                       --Reinigungsobjekttypen (serviceObjectType) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 4, 'R'                              --Reinigungsobjekttypen (serviceObjectType) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 4, 'R'                                    --Reinigungsobjekttypen (serviceObjectType) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 4, 'R'                   --Reinigungsobjekttypen (serviceObjectType) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 4, 'R'                                  --Reinigungsobjekttypen (serviceObjectType) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 4, 'R'                         --Reinigungsobjekttypen (serviceObjectType) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 4, 'R'                                          --Reinigungsobjekttypen (serviceObjectType) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 4, 'R'                                          --Reinigungsobjekttypen (serviceObjectType) READ   -> language READ
    UNION ALL SELECT 'company', 'R', 4, 'R'                                           --Reinigungsobjekttypen (serviceObjectType) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 4, 'R'                                        --Reinigungsobjekttypen (serviceObjectType) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 4, 'R'                                  --Reinigungsobjekttypen (serviceObjectType) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 4, 'R'                                            --Reinigungsobjekttypen (serviceObjectType) READ   -> client READ
    UNION ALL SELECT 'clientRole', 'R', 4, 'W'                                        --Reinigungsobjekttypen (serviceObjectType) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 4, 'W'                                  --Reinigungsobjekttypen (serviceObjectType) WRITE  -> clientPermission READ
    UNION ALL SELECT 'language', 'R', 4, 'W'                                          --Reinigungsobjekttypen (serviceObjectType) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 4, 'W'                                           --Reinigungsobjekttypen (serviceObjectType) WRITE  -> company READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 4, 'W'                         --Reinigungsobjekttypen (serviceObjectType) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 4, 'W'                                          --Reinigungsobjekttypen (serviceObjectType) WRITE  -> mainCode READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 4, 'W'                   --Reinigungsobjekttypen (serviceObjectType) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 4, 'W'                                  --Reinigungsobjekttypen (serviceObjectType) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'client', 'R', 4, 'W'                                            --Reinigungsobjekttypen (serviceObjectType) WRITE  -> client READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 4, 'W'                              --Reinigungsobjekttypen (serviceObjectType) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 4, 'W'                                    --Reinigungsobjekttypen (serviceObjectType) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 4, 'W'                             --Reinigungsobjekttypen (serviceObjectType) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 4, 'W'                       --Reinigungsobjekttypen (serviceObjectType) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'parameter', 'R', 4, 'W'                                         --Reinigungsobjekttypen (serviceObjectType) WRITE  -> parameter READ
    UNION ALL SELECT 'plant', 'R', 4, 'W'                                             --Reinigungsobjekttypen (serviceObjectType) WRITE  -> plant READ
    UNION ALL SELECT 'plant', 'R', 4, 'D'                                             --Reinigungsobjekttypen (serviceObjectType) DELETE -> plant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 4, 'D'                             --Reinigungsobjekttypen (serviceObjectType) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 4, 'D'                                         --Reinigungsobjekttypen (serviceObjectType) DELETE -> parameter READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 4, 'D'                       --Reinigungsobjekttypen (serviceObjectType) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 4, 'D'                              --Reinigungsobjekttypen (serviceObjectType) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientCompany', 'R', 4, 'D'                                  --Reinigungsobjekttypen (serviceObjectType) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 4, 'D'                   --Reinigungsobjekttypen (serviceObjectType) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 4, 'D'                                    --Reinigungsobjekttypen (serviceObjectType) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 4, 'D'                         --Reinigungsobjekttypen (serviceObjectType) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'language', 'R', 4, 'D'                                          --Reinigungsobjekttypen (serviceObjectType) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 4, 'D'                                          --Reinigungsobjekttypen (serviceObjectType) DELETE -> mainCode READ
    UNION ALL SELECT 'company', 'R', 4, 'D'                                           --Reinigungsobjekttypen (serviceObjectType) DELETE -> company READ
    UNION ALL SELECT 'clientRole', 'R', 4, 'D'                                        --Reinigungsobjekttypen (serviceObjectType) DELETE -> clientRole READ
    UNION ALL SELECT 'client', 'R', 4, 'D'                                            --Reinigungsobjekttypen (serviceObjectType) DELETE -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 4, 'D'                                  --Reinigungsobjekttypen (serviceObjectType) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 5, 'R'                                            --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 5, 'R'                                  --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> clientPermission READ
    UNION ALL SELECT 'plant', 'R', 5, 'R'                                             --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> plant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 5, 'R'                              --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 5, 'R'                       --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 5, 'R'                             --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 5, 'R'                                         --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> parameter READ
    UNION ALL SELECT 'clientRole', 'R', 5, 'R'                                        --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 5, 'R'                                           --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 5, 'R'                                          --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 5, 'R'                                          --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 5, 'R'                         --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 5, 'R'                                  --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 5, 'R'                   --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 5, 'R'                                    --Ausführung-/Abrechnungsstatus (serviceOrderStatus) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 5, 'W'                                    --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 5, 'W'                   --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 5, 'W'                                  --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 5, 'W'                         --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 5, 'W'                                          --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 5, 'W'                                          --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 5, 'W'                                           --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 5, 'W'                                        --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> clientRole READ
    UNION ALL SELECT 'parameter', 'R', 5, 'W'                                         --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 5, 'W'                             --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 5, 'W'                       --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 5, 'W'                              --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'plant', 'R', 5, 'W'                                             --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> plant READ
    UNION ALL SELECT 'clientPermission', 'R', 5, 'W'                                  --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 5, 'W'                                            --Ausführung-/Abrechnungsstatus (serviceOrderStatus) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 5, 'D'                                  --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 5, 'D'                                        --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> clientRole READ
    UNION ALL SELECT 'client', 'R', 5, 'D'                                            --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> client READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 5, 'D'                       --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 5, 'D'                             --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 5, 'D'                                         --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 5, 'D'                                             --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> plant READ
    UNION ALL SELECT 'company', 'R', 5, 'D'                                           --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 5, 'D'                                          --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 5, 'D'                                          --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 5, 'D'                         --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 5, 'D'                                  --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 5, 'D'                   --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 5, 'D'                                    --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 5, 'D'                              --Ausführung-/Abrechnungsstatus (serviceOrderStatus) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'plant', 'R', 6, 'R'                                             --Leistungstypen (serviceType) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 6, 'R'                                         --Leistungstypen (serviceType) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 6, 'R'                             --Leistungstypen (serviceType) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 6, 'R'                       --Leistungstypen (serviceType) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 6, 'R'                              --Leistungstypen (serviceType) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 6, 'R'                                    --Leistungstypen (serviceType) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 6, 'R'                   --Leistungstypen (serviceType) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 6, 'R'                                  --Leistungstypen (serviceType) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 6, 'R'                         --Leistungstypen (serviceType) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 6, 'R'                                          --Leistungstypen (serviceType) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 6, 'R'                                          --Leistungstypen (serviceType) READ   -> language READ
    UNION ALL SELECT 'company', 'R', 6, 'R'                                           --Leistungstypen (serviceType) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 6, 'R'                                        --Leistungstypen (serviceType) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 6, 'R'                                  --Leistungstypen (serviceType) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 6, 'R'                                            --Leistungstypen (serviceType) READ   -> client READ
    UNION ALL SELECT 'clientRole', 'R', 6, 'W'                                        --Leistungstypen (serviceType) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 6, 'W'                                  --Leistungstypen (serviceType) WRITE  -> clientPermission READ
    UNION ALL SELECT 'language', 'R', 6, 'W'                                          --Leistungstypen (serviceType) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 6, 'W'                                           --Leistungstypen (serviceType) WRITE  -> company READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 6, 'W'                         --Leistungstypen (serviceType) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 6, 'W'                                          --Leistungstypen (serviceType) WRITE  -> mainCode READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 6, 'W'                   --Leistungstypen (serviceType) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 6, 'W'                                  --Leistungstypen (serviceType) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 6, 'W'                              --Leistungstypen (serviceType) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 6, 'W'                                    --Leistungstypen (serviceType) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 6, 'W'                             --Leistungstypen (serviceType) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 6, 'W'                       --Leistungstypen (serviceType) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'parameter', 'R', 6, 'W'                                         --Leistungstypen (serviceType) WRITE  -> parameter READ
    UNION ALL SELECT 'plant', 'R', 6, 'W'                                             --Leistungstypen (serviceType) WRITE  -> plant READ
    UNION ALL SELECT 'client', 'R', 6, 'W'                                            --Leistungstypen (serviceType) WRITE  -> client READ
    UNION ALL SELECT 'plant', 'R', 6, 'D'                                             --Leistungstypen (serviceType) DELETE -> plant READ
    UNION ALL SELECT 'parameter', 'R', 6, 'D'                                         --Leistungstypen (serviceType) DELETE -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 6, 'D'                             --Leistungstypen (serviceType) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 6, 'D'                              --Leistungstypen (serviceType) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 6, 'D'                       --Leistungstypen (serviceType) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 6, 'D'                                    --Leistungstypen (serviceType) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 6, 'D'                   --Leistungstypen (serviceType) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mainCode', 'R', 6, 'D'                                          --Leistungstypen (serviceType) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 6, 'D'                         --Leistungstypen (serviceType) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 6, 'D'                                  --Leistungstypen (serviceType) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'language', 'R', 6, 'D'                                          --Leistungstypen (serviceType) DELETE -> language READ
    UNION ALL SELECT 'clientRole', 'R', 6, 'D'                                        --Leistungstypen (serviceType) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 6, 'D'                                           --Leistungstypen (serviceType) DELETE -> company READ
    UNION ALL SELECT 'clientPermission', 'R', 6, 'D'                                  --Leistungstypen (serviceType) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 6, 'D'                                            --Leistungstypen (serviceType) DELETE -> client READ
    UNION ALL SELECT 'client', 'R', 7, 'R'                                            --Standards (standard) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 7, 'R'                                  --Standards (standard) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 7, 'R'                                        --Standards (standard) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 7, 'R'                                           --Standards (standard) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 7, 'R'                                          --Standards (standard) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 7, 'R'                                          --Standards (standard) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 7, 'R'                         --Standards (standard) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 7, 'R'                                  --Standards (standard) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 7, 'R'                   --Standards (standard) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 7, 'R'                                    --Standards (standard) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 7, 'R'                              --Standards (standard) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 7, 'R'                       --Standards (standard) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 7, 'R'                             --Standards (standard) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 7, 'R'                                         --Standards (standard) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 7, 'R'                                             --Standards (standard) READ   -> plant READ
    UNION ALL SELECT 'plant', 'R', 7, 'W'                                             --Standards (standard) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 7, 'W'                                         --Standards (standard) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 7, 'W'                             --Standards (standard) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 7, 'W'                       --Standards (standard) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 7, 'W'                              --Standards (standard) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 7, 'W'                                    --Standards (standard) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 7, 'W'                   --Standards (standard) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 7, 'W'                                  --Standards (standard) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 7, 'W'                         --Standards (standard) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 7, 'W'                                          --Standards (standard) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 7, 'W'                                          --Standards (standard) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 7, 'W'                                           --Standards (standard) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 7, 'W'                                        --Standards (standard) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 7, 'W'                                  --Standards (standard) WRITE  -> clientPermission READ
    UNION ALL SELECT 'standard', 'R', 7, 'W'                                          --Standards (standard) WRITE  -> standard READ
    UNION ALL SELECT 'standard', 'W', 7, 'W'                                          --Standards (standard) WRITE  -> standard WRITE
    UNION ALL SELECT 'client', 'R', 7, 'W'                                            --Standards (standard) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 7, 'D'                                  --Standards (standard) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 7, 'D'                                            --Standards (standard) DELETE -> client READ
    UNION ALL SELECT 'clientRole', 'R', 7, 'D'                                        --Standards (standard) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 7, 'D'                                           --Standards (standard) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 7, 'D'                                          --Standards (standard) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 7, 'D'                                          --Standards (standard) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 7, 'D'                         --Standards (standard) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 7, 'D'                                  --Standards (standard) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 7, 'D'                   --Standards (standard) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 7, 'D'                                    --Standards (standard) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 7, 'D'                              --Standards (standard) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 7, 'D'                       --Standards (standard) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 7, 'D'                             --Standards (standard) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 7, 'D'                                         --Standards (standard) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 7, 'D'                                             --Standards (standard) DELETE -> plant READ
    UNION ALL SELECT 'plant', 'R', 8, 'R'                                             --Turnusse (turnus) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 8, 'R'                                         --Turnusse (turnus) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 8, 'R'                             --Turnusse (turnus) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 8, 'R'                       --Turnusse (turnus) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'turnus', 'R', 8, 'R'                                            --Turnusse (turnus) READ   -> turnus READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 8, 'R'                              --Turnusse (turnus) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 8, 'R'                                    --Turnusse (turnus) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 8, 'R'                   --Turnusse (turnus) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 8, 'R'                                  --Turnusse (turnus) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 8, 'R'                         --Turnusse (turnus) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 8, 'R'                                          --Turnusse (turnus) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 8, 'R'                                          --Turnusse (turnus) READ   -> language READ
    UNION ALL SELECT 'company', 'R', 8, 'R'                                           --Turnusse (turnus) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 8, 'R'                                        --Turnusse (turnus) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 8, 'R'                                  --Turnusse (turnus) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 8, 'R'                                            --Turnusse (turnus) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 8, 'W'                                  --Turnusse (turnus) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 8, 'W'                                            --Turnusse (turnus) WRITE  -> client READ
    UNION ALL SELECT 'company', 'R', 8, 'W'                                           --Turnusse (turnus) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 8, 'W'                                        --Turnusse (turnus) WRITE  -> clientRole READ
    UNION ALL SELECT 'mainCode', 'R', 8, 'W'                                          --Turnusse (turnus) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 8, 'W'                                          --Turnusse (turnus) WRITE  -> language READ
    UNION ALL SELECT 'mapClientCompany', 'R', 8, 'W'                                  --Turnusse (turnus) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 8, 'W'                         --Turnusse (turnus) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientPlant', 'R', 8, 'W'                                    --Turnusse (turnus) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 8, 'W'                   --Turnusse (turnus) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'turnus', 'W', 8, 'W'                                            --Turnusse (turnus) WRITE  -> turnus WRITE
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 8, 'W'                              --Turnusse (turnus) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'turnus', 'R', 8, 'W'                                            --Turnusse (turnus) WRITE  -> turnus READ
    UNION ALL SELECT 'turnus', 'D', 8, 'W'                                            --Turnusse (turnus) WRITE  -> turnus DELETE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 8, 'W'                             --Turnusse (turnus) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 8, 'W'                       --Turnusse (turnus) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'parameter', 'R', 8, 'W'                                         --Turnusse (turnus) WRITE  -> parameter READ
    UNION ALL SELECT 'plant', 'R', 8, 'W'                                             --Turnusse (turnus) WRITE  -> plant READ
    UNION ALL SELECT 'plant', 'R', 8, 'D'                                             --Turnusse (turnus) DELETE -> plant READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 8, 'D'                       --Turnusse (turnus) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'turnus', 'R', 8, 'D'                                            --Turnusse (turnus) DELETE -> turnus READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 8, 'D'                             --Turnusse (turnus) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 8, 'D'                                         --Turnusse (turnus) DELETE -> parameter READ
    UNION ALL SELECT 'turnus', 'W', 8, 'D'                                            --Turnusse (turnus) DELETE -> turnus WRITE
    UNION ALL SELECT 'turnus', 'D', 8, 'D'                                            --Turnusse (turnus) DELETE -> turnus DELETE
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 8, 'D'                              --Turnusse (turnus) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 8, 'D'                                    --Turnusse (turnus) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 8, 'D'                                  --Turnusse (turnus) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 8, 'D'                   --Turnusse (turnus) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 8, 'D'                         --Turnusse (turnus) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 8, 'D'                                          --Turnusse (turnus) DELETE -> mainCode READ
    UNION ALL SELECT 'clientRole', 'R', 8, 'D'                                        --Turnusse (turnus) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 8, 'D'                                           --Turnusse (turnus) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 8, 'D'                                          --Turnusse (turnus) DELETE -> language READ
    UNION ALL SELECT 'clientPermission', 'R', 8, 'D'                                  --Turnusse (turnus) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 8, 'D'                                            --Turnusse (turnus) DELETE -> client READ
    UNION ALL SELECT 'client', 'R', 9, 'R'                                            --Einheiten (unit) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 9, 'R'                                  --Einheiten (unit) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 9, 'R'                                        --Einheiten (unit) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 9, 'R'                                           --Einheiten (unit) READ   -> company READ
    UNION ALL SELECT 'executionDay', 'R', 9, 'R'                                      --Einheiten (unit) READ   -> executionDay READ
    UNION ALL SELECT 'language', 'R', 9, 'R'                                          --Einheiten (unit) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 9, 'R'                                          --Einheiten (unit) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 9, 'R'                         --Einheiten (unit) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 9, 'R'                                  --Einheiten (unit) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 9, 'R'                   --Einheiten (unit) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 9, 'R'                                    --Einheiten (unit) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 9, 'R'                              --Einheiten (unit) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'unit', 'R', 9, 'R'                                              --Einheiten (unit) READ   -> unit READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 9, 'R'                       --Einheiten (unit) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 9, 'R'                             --Einheiten (unit) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 9, 'R'                                         --Einheiten (unit) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 9, 'R'                                             --Einheiten (unit) READ   -> plant READ
    UNION ALL SELECT 'plant', 'R', 9, 'W'                                             --Einheiten (unit) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 9, 'W'                                         --Einheiten (unit) WRITE  -> parameter READ
    UNION ALL SELECT 'unit', 'D', 9, 'W'                                              --Einheiten (unit) WRITE  -> unit DELETE
    UNION ALL SELECT 'unit', 'W', 9, 'W'                                              --Einheiten (unit) WRITE  -> unit WRITE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 9, 'W'                             --Einheiten (unit) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 9, 'W'                       --Einheiten (unit) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'unit', 'R', 9, 'W'                                              --Einheiten (unit) WRITE  -> unit READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 9, 'W'                              --Einheiten (unit) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 9, 'W'                                    --Einheiten (unit) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 9, 'W'                   --Einheiten (unit) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 9, 'W'                                  --Einheiten (unit) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 9, 'W'                         --Einheiten (unit) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 9, 'W'                                          --Einheiten (unit) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 9, 'W'                                          --Einheiten (unit) WRITE  -> language READ
    UNION ALL SELECT 'executionDay', 'R', 9, 'W'                                      --Einheiten (unit) WRITE  -> executionDay READ
    UNION ALL SELECT 'executionDay', 'D', 9, 'W'                                      --Einheiten (unit) WRITE  -> executionDay DELETE
    UNION ALL SELECT 'executionDay', 'W', 9, 'W'                                      --Einheiten (unit) WRITE  -> executionDay WRITE
    UNION ALL SELECT 'company', 'R', 9, 'W'                                           --Einheiten (unit) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 9, 'W'                                        --Einheiten (unit) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 9, 'W'                                  --Einheiten (unit) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 9, 'W'                                            --Einheiten (unit) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 9, 'D'                                  --Einheiten (unit) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 9, 'D'                                            --Einheiten (unit) DELETE -> client READ
    UNION ALL SELECT 'clientRole', 'R', 9, 'D'                                        --Einheiten (unit) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 9, 'D'                                           --Einheiten (unit) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 9, 'D'                                          --Einheiten (unit) DELETE -> language READ
    UNION ALL SELECT 'executionDay', 'D', 9, 'D'                                      --Einheiten (unit) DELETE -> executionDay DELETE
    UNION ALL SELECT 'executionDay', 'R', 9, 'D'                                      --Einheiten (unit) DELETE -> executionDay READ
    UNION ALL SELECT 'executionDay', 'W', 9, 'D'                                      --Einheiten (unit) DELETE -> executionDay WRITE
    UNION ALL SELECT 'mainCode', 'R', 9, 'D'                                          --Einheiten (unit) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 9, 'D'                         --Einheiten (unit) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 9, 'D'                                  --Einheiten (unit) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 9, 'D'                   --Einheiten (unit) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 9, 'D'                                    --Einheiten (unit) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 9, 'D'                              --Einheiten (unit) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'unit', 'R', 9, 'D'                                              --Einheiten (unit) DELETE -> unit READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 9, 'D'                       --Einheiten (unit) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 9, 'D'                             --Einheiten (unit) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 9, 'D'                                         --Einheiten (unit) DELETE -> parameter READ
    UNION ALL SELECT 'unit', 'W', 9, 'D'                                              --Einheiten (unit) DELETE -> unit WRITE
    UNION ALL SELECT 'plant', 'R', 9, 'D'                                             --Einheiten (unit) DELETE -> plant READ
    UNION ALL SELECT 'unit', 'D', 9, 'D'                                              --Einheiten (unit) DELETE -> unit DELETE
    UNION ALL SELECT 'parameter', 'R', 10, 'R'                                        --Lohncluster (wageGroup) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 10, 'R'                            --Lohncluster (wageGroup) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'wageCluster', 'R', 10, 'R'                                      --Lohncluster (wageGroup) READ   -> wageCluster READ
    UNION ALL SELECT 'wageGroup', 'R', 10, 'R'                                        --Lohncluster (wageGroup) READ   -> wageGroup READ
    UNION ALL SELECT 'currency', 'R', 10, 'R'                                         --Lohncluster (wageGroup) READ   -> currency READ
	UNION ALL SELECT 'plant', 'R', 10, 'R'                                            --Lohncluster (wageGroup) READ   -> plant READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 10, 'R'                      --Lohncluster (wageGroup) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 10, 'R'                             --Lohncluster (wageGroup) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 10, 'R'                                   --Lohncluster (wageGroup) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 10, 'R'                  --Lohncluster (wageGroup) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 10, 'R'                                 --Lohncluster (wageGroup) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 10, 'R'                        --Lohncluster (wageGroup) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 10, 'R'                                         --Lohncluster (wageGroup) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 10, 'R'                                         --Lohncluster (wageGroup) READ   -> language READ
    UNION ALL SELECT 'company', 'R', 10, 'R'                                          --Lohncluster (wageGroup) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 10, 'R'                                       --Lohncluster (wageGroup) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 10, 'R'                                 --Lohncluster (wageGroup) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 10, 'R'                                           --Lohncluster (wageGroup) READ   -> client READ
    UNION ALL SELECT 'clientRole', 'R', 10, 'W'                                       --Lohncluster (wageGroup) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 10, 'W'                                 --Lohncluster (wageGroup) WRITE  -> clientPermission READ
    UNION ALL SELECT 'language', 'R', 10, 'W'                                         --Lohncluster (wageGroup) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 10, 'W'                                          --Lohncluster (wageGroup) WRITE  -> company READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 10, 'W'                        --Lohncluster (wageGroup) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 10, 'W'                                         --Lohncluster (wageGroup) WRITE  -> mainCode READ
    UNION ALL SELECT 'client', 'R', 10, 'W'                                           --Lohncluster (wageGroup) WRITE  -> client READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 10, 'W'                  --Lohncluster (wageGroup) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 10, 'W'                                 --Lohncluster (wageGroup) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 10, 'W'                             --Lohncluster (wageGroup) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 10, 'W'                                   --Lohncluster (wageGroup) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'wageCluster', 'W', 10, 'W'                                      --Lohncluster (wageGroup) WRITE  -> wageGroup WRITE
    UNION ALL SELECT 'wageGroup', 'W', 10, 'W'                                        --Lohncluster (wageGroup) WRITE  -> wageGroup WRITE
    UNION ALL SELECT 'currency', 'R', 10, 'W'                                         --Lohncluster (wageGroup) WRITE  -> currency READ
    UNION ALL SELECT 'plant', 'R', 10, 'W'                                            --Lohncluster (wageGroup) WRITE  -> plant READ
    UNION ALL SELECT 'wageCluster', 'D', 10, 'W'                                      --Lohncluster (wageGroup) WRITE  -> wageGroup DELETE
    UNION ALL SELECT 'wageGroup', 'D', 10, 'W'                                        --Lohncluster (wageGroup) WRITE  -> wageGroup DELETE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 10, 'W'                            --Lohncluster (wageGroup) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 10, 'W'                      --Lohncluster (wageGroup) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'parameter', 'R', 10, 'W'                                        --Lohncluster (wageGroup) WRITE  -> parameter READ
    UNION ALL SELECT 'wageCluster', 'R', 10, 'W'                                      --Lohncluster (wageGroup) WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 10, 'W'                                        --Lohncluster (wageGroup) WRITE  -> wageGroup READ
    UNION ALL SELECT 'parameter', 'R', 10, 'D'                                        --Lohncluster (wageGroup) DELETE -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 10, 'D'                            --Lohncluster (wageGroup) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'wageCluster', 'W', 10, 'D'                                      --Lohncluster (wageGroup) DELETE -> wageGroup WRITE
    UNION ALL SELECT 'wageCluster', 'R', 10, 'D'                                      --Lohncluster (wageGroup) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageCluster', 'D', 10, 'D'                                      --Lohncluster (wageGroup) DELETE -> wageGroup DELETE
    UNION ALL SELECT 'wageGroup', 'W', 10, 'D'                                        --Lohncluster (wageGroup) DELETE -> wageGroup WRITE
    UNION ALL SELECT 'wageGroup', 'R', 10, 'D'                                        --Lohncluster (wageGroup) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'D', 10, 'D'                                        --Lohncluster (wageGroup) DELETE -> wageGroup DELETE
    UNION ALL SELECT 'currency', 'R', 10, 'D'                                         --Lohncluster (wageGroup) DELETE -> currency READ
    UNION ALL SELECT 'plant', 'R', 10, 'D'                                            --Lohncluster (wageGroup) DELETE -> plant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 10, 'D'                                   --Lohncluster (wageGroup) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 10, 'D'                             --Lohncluster (wageGroup) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 10, 'D'                      --Lohncluster (wageGroup) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 10, 'D'                  --Lohncluster (wageGroup) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 10, 'D'                        --Lohncluster (wageGroup) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 10, 'D'                                 --Lohncluster (wageGroup) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mainCode', 'R', 10, 'D'                                         --Lohncluster (wageGroup) DELETE -> mainCode READ
    UNION ALL SELECT 'language', 'R', 10, 'D'                                         --Lohncluster (wageGroup) DELETE -> language READ
    UNION ALL SELECT 'clientPermission', 'R', 10, 'D'                                 --Lohncluster (wageGroup) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 10, 'D'                                       --Lohncluster (wageGroup) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 10, 'D'                                          --Lohncluster (wageGroup) DELETE -> company READ
    UNION ALL SELECT 'client', 'R', 10, 'D'                                           --Lohncluster (wageGroup) DELETE -> client READ
    UNION ALL SELECT 'client', 'R', 11, 'R'                                           --Gesellschaften (company) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 11, 'R'                                 --Gesellschaften (company) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 11, 'R'                                       --Gesellschaften (company) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 11, 'R'                                          --Gesellschaften (company) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 11, 'R'                                         --Gesellschaften (company) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 11, 'R'                                         --Gesellschaften (company) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 11, 'R'                        --Gesellschaften (company) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 11, 'R'                                 --Gesellschaften (company) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 11, 'R'                  --Gesellschaften (company) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 11, 'R'                                   --Gesellschaften (company) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 11, 'R'                             --Gesellschaften (company) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 11, 'R'                      --Gesellschaften (company) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 11, 'R'                            --Gesellschaften (company) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 11, 'R'                                        --Gesellschaften (company) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 11, 'R'                                            --Gesellschaften (company) READ   -> plant READ
    UNION ALL SELECT 'plant', 'R', 11, 'W'                                            --Gesellschaften (company) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 11, 'W'                                        --Gesellschaften (company) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 11, 'W'                            --Gesellschaften (company) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 11, 'W'                      --Gesellschaften (company) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 11, 'W'                             --Gesellschaften (company) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 11, 'W'                                   --Gesellschaften (company) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 11, 'W'                  --Gesellschaften (company) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 11, 'W'                                 --Gesellschaften (company) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 11, 'W'                        --Gesellschaften (company) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 11, 'W'                                         --Gesellschaften (company) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 11, 'W'                                         --Gesellschaften (company) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 11, 'W'                                          --Gesellschaften (company) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 11, 'W'                                       --Gesellschaften (company) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 11, 'W'                                 --Gesellschaften (company) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 11, 'W'                                           --Gesellschaften (company) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 11, 'D'                                 --Gesellschaften (company) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 11, 'D'                                           --Gesellschaften (company) DELETE -> client READ
    UNION ALL SELECT 'clientRole', 'R', 11, 'D'                                       --Gesellschaften (company) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 11, 'D'                                          --Gesellschaften (company) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 11, 'D'                                         --Gesellschaften (company) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 11, 'D'                                         --Gesellschaften (company) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 11, 'D'                        --Gesellschaften (company) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 11, 'D'                                 --Gesellschaften (company) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 11, 'D'                  --Gesellschaften (company) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 11, 'D'                                   --Gesellschaften (company) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 11, 'D'                             --Gesellschaften (company) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 11, 'D'                      --Gesellschaften (company) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 11, 'D'                            --Gesellschaften (company) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 11, 'D'                                        --Gesellschaften (company) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 11, 'D'                                            --Gesellschaften (company) DELETE -> plant READ
    UNION ALL SELECT 'plant', 'R', 12, 'R'                                            --Lieferanten (supplier) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 12, 'R'                                        --Lieferanten (supplier) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 12, 'R'                            --Lieferanten (supplier) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 12, 'R'                      --Lieferanten (supplier) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'supplier', 'R', 12, 'R'                                         --Lieferanten (supplier) READ   -> supplier READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 12, 'R'                             --Lieferanten (supplier) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 12, 'R'                                   --Lieferanten (supplier) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 12, 'R'                  --Lieferanten (supplier) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 12, 'R'                                 --Lieferanten (supplier) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 12, 'R'                        --Lieferanten (supplier) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 12, 'R'                                         --Lieferanten (supplier) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 12, 'R'                                         --Lieferanten (supplier) READ   -> language READ
    UNION ALL SELECT 'company', 'R', 12, 'R'                                          --Lieferanten (supplier) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 12, 'R'                                       --Lieferanten (supplier) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 12, 'R'                                 --Lieferanten (supplier) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 12, 'R'                                           --Lieferanten (supplier) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 12, 'W'                                 --Lieferanten (supplier) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 12, 'W'                                           --Lieferanten (supplier) WRITE  -> client READ
    UNION ALL SELECT 'company', 'R', 12, 'W'                                          --Lieferanten (supplier) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 12, 'W'                                       --Lieferanten (supplier) WRITE  -> clientRole READ
    UNION ALL SELECT 'mainCode', 'R', 12, 'W'                                         --Lieferanten (supplier) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 12, 'W'                                         --Lieferanten (supplier) WRITE  -> language READ
    UNION ALL SELECT 'mapClientCompany', 'R', 12, 'W'                                 --Lieferanten (supplier) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 12, 'W'                        --Lieferanten (supplier) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientPlant', 'R', 12, 'W'                                   --Lieferanten (supplier) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 12, 'W'                  --Lieferanten (supplier) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'supplier', 'W', 12, 'W'                                         --Lieferanten (supplier) WRITE  -> supplier WRITE
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 12, 'W'                             --Lieferanten (supplier) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'supplier', 'R', 12, 'W'                                         --Lieferanten (supplier) WRITE  -> supplier READ
    UNION ALL SELECT 'supplier', 'D', 12, 'W'                                         --Lieferanten (supplier) WRITE  -> supplier DELETE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 12, 'W'                            --Lieferanten (supplier) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 12, 'W'                      --Lieferanten (supplier) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'parameter', 'R', 12, 'W'                                        --Lieferanten (supplier) WRITE  -> parameter READ
    UNION ALL SELECT 'plant', 'R', 12, 'W'                                            --Lieferanten (supplier) WRITE  -> plant READ
    UNION ALL SELECT 'plant', 'R', 12, 'D'                                            --Lieferanten (supplier) DELETE -> plant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 12, 'D'                            --Lieferanten (supplier) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 12, 'D'                                        --Lieferanten (supplier) DELETE -> parameter READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 12, 'D'                      --Lieferanten (supplier) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'supplier', 'R', 12, 'D'                                         --Lieferanten (supplier) DELETE -> supplier READ
    UNION ALL SELECT 'supplier', 'W', 12, 'D'                                         --Lieferanten (supplier) DELETE -> supplier WRITE
    UNION ALL SELECT 'supplier', 'D', 12, 'D'                                         --Lieferanten (supplier) DELETE -> supplier DELETE
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 12, 'D'                             --Lieferanten (supplier) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 12, 'D'                                   --Lieferanten (supplier) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 12, 'D'                        --Lieferanten (supplier) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 12, 'D'                                 --Lieferanten (supplier) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 12, 'D'                  --Lieferanten (supplier) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mainCode', 'R', 12, 'D'                                         --Lieferanten (supplier) DELETE -> mainCode READ
    UNION ALL SELECT 'company', 'R', 12, 'D'                                          --Lieferanten (supplier) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 12, 'D'                                         --Lieferanten (supplier) DELETE -> language READ
    UNION ALL SELECT 'clientRole', 'R', 12, 'D'                                       --Lieferanten (supplier) DELETE -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 12, 'D'                                 --Lieferanten (supplier) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 12, 'D'                                           --Lieferanten (supplier) DELETE -> client READ
    UNION ALL SELECT 'client', 'R', 13, 'R'                                           --Standardwerte für Abzüge (standardDiscount) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 13, 'R'                                 --Standardwerte für Abzüge (standardDiscount) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 13, 'R'                                       --Standardwerte für Abzüge (standardDiscount) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 13, 'R'                                          --Standardwerte für Abzüge (standardDiscount) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 13, 'R'                                         --Standardwerte für Abzüge (standardDiscount) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 13, 'R'                                         --Standardwerte für Abzüge (standardDiscount) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 13, 'R'                        --Standardwerte für Abzüge (standardDiscount) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 13, 'R'                                 --Standardwerte für Abzüge (standardDiscount) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 13, 'R'                  --Standardwerte für Abzüge (standardDiscount) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 13, 'R'                             --Standardwerte für Abzüge (standardDiscount) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'standardDiscount', 'R', 13, 'R'                                 --Standardwerte für Abzüge (standardDiscount) READ   -> standardDiscount READ
    UNION ALL SELECT 'mapClientPlant', 'R', 13, 'R'                                   --Standardwerte für Abzüge (standardDiscount) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 13, 'R'                      --Standardwerte für Abzüge (standardDiscount) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 13, 'R'                            --Standardwerte für Abzüge (standardDiscount) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 13, 'R'                                        --Standardwerte für Abzüge (standardDiscount) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 13, 'R'                                            --Standardwerte für Abzüge (standardDiscount) READ   -> plant READ
    UNION ALL SELECT 'plant', 'R', 13, 'W'                                            --Standardwerte für Abzüge (standardDiscount) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 13, 'W'                                        --Standardwerte für Abzüge (standardDiscount) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 13, 'W'                            --Standardwerte für Abzüge (standardDiscount) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 13, 'W'                      --Standardwerte für Abzüge (standardDiscount) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 13, 'W'                                   --Standardwerte für Abzüge (standardDiscount) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'standardDiscount', 'R', 13, 'W'                                 --Standardwerte für Abzüge (standardDiscount) WRITE  -> standardDiscount READ
    UNION ALL SELECT 'standardDiscount', 'D', 13, 'W'                                 --Standardwerte für Abzüge (standardDiscount) WRITE  -> standardDiscount DELETE
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 13, 'W'                             --Standardwerte für Abzüge (standardDiscount) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'standardDiscount', 'W', 13, 'W'                                 --Standardwerte für Abzüge (standardDiscount) WRITE  -> standardDiscount WRITE
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 13, 'W'                  --Standardwerte für Abzüge (standardDiscount) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 13, 'W'                                 --Standardwerte für Abzüge (standardDiscount) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 13, 'W'                        --Standardwerte für Abzüge (standardDiscount) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 13, 'W'                                         --Standardwerte für Abzüge (standardDiscount) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 13, 'W'                                         --Standardwerte für Abzüge (standardDiscount) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 13, 'W'                                          --Standardwerte für Abzüge (standardDiscount) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 13, 'W'                                       --Standardwerte für Abzüge (standardDiscount) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 13, 'W'                                 --Standardwerte für Abzüge (standardDiscount) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 13, 'W'                                           --Standardwerte für Abzüge (standardDiscount) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 13, 'D'                                 --Standardwerte für Abzüge (standardDiscount) DELETE -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 13, 'D'                                           --Standardwerte für Abzüge (standardDiscount) DELETE -> client READ
    UNION ALL SELECT 'clientRole', 'R', 13, 'D'                                       --Standardwerte für Abzüge (standardDiscount) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 13, 'D'                                          --Standardwerte für Abzüge (standardDiscount) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 13, 'D'                                         --Standardwerte für Abzüge (standardDiscount) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 13, 'D'                                         --Standardwerte für Abzüge (standardDiscount) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 13, 'D'                        --Standardwerte für Abzüge (standardDiscount) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 13, 'D'                                 --Standardwerte für Abzüge (standardDiscount) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 13, 'D'                  --Standardwerte für Abzüge (standardDiscount) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 13, 'D'                                   --Standardwerte für Abzüge (standardDiscount) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'standardDiscount', 'D', 13, 'D'                                 --Standardwerte für Abzüge (standardDiscount) DELETE -> standardDiscount DELETE
    UNION ALL SELECT 'standardDiscount', 'R', 13, 'D'                                 --Standardwerte für Abzüge (standardDiscount) DELETE -> standardDiscount READ
    UNION ALL SELECT 'standardDiscount', 'W', 13, 'D'                                 --Standardwerte für Abzüge (standardDiscount) DELETE -> standardDiscount WRITE
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 13, 'D'                      --Standardwerte für Abzüge (standardDiscount) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 13, 'D'                             --Standardwerte für Abzüge (standardDiscount) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 13, 'D'                            --Standardwerte für Abzüge (standardDiscount) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 13, 'D'                                        --Standardwerte für Abzüge (standardDiscount) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 13, 'D'                                            --Standardwerte für Abzüge (standardDiscount) DELETE -> plant READ
    UNION ALL SELECT 'plant', 'R', 14, 'R'                                            --Kalender (calendar) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 14, 'R'                                        --Kalender (calendar) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 14, 'R'                            --Kalender (calendar) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 14, 'R'                      --Kalender (calendar) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 14, 'R'                             --Kalender (calendar) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 14, 'R'                                   --Kalender (calendar) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 14, 'R'                  --Kalender (calendar) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 14, 'R'                                 --Kalender (calendar) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 14, 'R'                        --Kalender (calendar) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 14, 'R'                             --Kalender (calendar) READ   -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mainCode', 'R', 14, 'R'                                         --Kalender (calendar) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 14, 'R'                                         --Kalender (calendar) READ   -> language READ
    UNION ALL SELECT 'dayType', 'R', 14, 'R'                                          --Kalender (calendar) READ   -> dayType READ
    UNION ALL SELECT 'company', 'R', 14, 'R'                                          --Kalender (calendar) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 14, 'R'                                       --Kalender (calendar) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 14, 'R'                                 --Kalender (calendar) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 14, 'R'                                           --Kalender (calendar) READ   -> client READ
    UNION ALL SELECT 'calendarDay', 'R', 14, 'R'                                      --Kalender (calendar) READ   -> calendarDay READ
    UNION ALL SELECT 'calendar', 'R', 14, 'R'                                         --Kalender (calendar) READ   -> calendar READ
    UNION ALL SELECT 'calendar', 'R', 14, 'W'                                         --Kalender (calendar) WRITE  -> calendar READ
    UNION ALL SELECT 'calendar', 'D', 14, 'W'                                         --Kalender (calendar) WRITE  -> calendar DELETE
    UNION ALL SELECT 'calendarDay', 'R', 14, 'W'                                      --Kalender (calendar) WRITE  -> calendarDay READ
    UNION ALL SELECT 'calendarDay', 'W', 14, 'W'                                      --Kalender (calendar) WRITE  -> calendarDay WRITE
    UNION ALL SELECT 'calendar', 'W', 14, 'W'                                         --Kalender (calendar) WRITE  -> calendar WRITE
    UNION ALL SELECT 'calendarDay', 'D', 14, 'W'                                      --Kalender (calendar) WRITE  -> calendarDay DELETE
    UNION ALL SELECT 'clientPermission', 'R', 14, 'W'                                 --Kalender (calendar) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 14, 'W'                                           --Kalender (calendar) WRITE  -> client READ
    UNION ALL SELECT 'language', 'R', 14, 'W'                                         --Kalender (calendar) WRITE  -> language READ
    UNION ALL SELECT 'clientRole', 'R', 14, 'W'                                       --Kalender (calendar) WRITE  -> clientRole READ
    UNION ALL SELECT 'dayType', 'R', 14, 'W'                                          --Kalender (calendar) WRITE  -> dayType READ
    UNION ALL SELECT 'company', 'R', 14, 'W'                                          --Kalender (calendar) WRITE  -> company READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 14, 'W'                        --Kalender (calendar) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 14, 'W'                                         --Kalender (calendar) WRITE  -> mainCode READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 14, 'W'                             --Kalender (calendar) WRITE  -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'D', 14, 'W'                             --Kalender (calendar) WRITE  -> mapCalendarPlantSite DELETE
    UNION ALL SELECT 'mapClientPlant', 'R', 14, 'W'                                   --Kalender (calendar) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 14, 'W'                                 --Kalender (calendar) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'W', 14, 'W'                             --Kalender (calendar) WRITE  -> mapCalendarPlantSite WRITE
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 14, 'W'                  --Kalender (calendar) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 14, 'W'                      --Kalender (calendar) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 14, 'W'                             --Kalender (calendar) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'parameter', 'R', 14, 'W'                                        --Kalender (calendar) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 14, 'W'                            --Kalender (calendar) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'plant', 'R', 14, 'W'                                            --Kalender (calendar) WRITE  -> plant READ
    UNION ALL SELECT 'plant', 'R', 14, 'D'                                            --Kalender (calendar) DELETE -> plant READ
    UNION ALL SELECT 'parameter', 'R', 14, 'D'                                        --Kalender (calendar) DELETE -> parameter READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 14, 'D'                      --Kalender (calendar) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 14, 'D'                            --Kalender (calendar) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 14, 'D'                             --Kalender (calendar) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 14, 'D'                                   --Kalender (calendar) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 14, 'D'                  --Kalender (calendar) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 14, 'D'                        --Kalender (calendar) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 14, 'D'                             --Kalender (calendar) DELETE -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapClientCompany', 'R', 14, 'D'                                 --Kalender (calendar) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'W', 14, 'D'                             --Kalender (calendar) DELETE -> mapCalendarPlantSite WRITE
    UNION ALL SELECT 'mapCalendarPlantSite', 'D', 14, 'D'                             --Kalender (calendar) DELETE -> mapCalendarPlantSite DELETE
    UNION ALL SELECT 'mainCode', 'R', 14, 'D'                                         --Kalender (calendar) DELETE -> mainCode READ
    UNION ALL SELECT 'language', 'R', 14, 'D'                                         --Kalender (calendar) DELETE -> language READ
    UNION ALL SELECT 'dayType', 'R', 14, 'D'                                          --Kalender (calendar) DELETE -> dayType READ
    UNION ALL SELECT 'company', 'R', 14, 'D'                                          --Kalender (calendar) DELETE -> company READ
    UNION ALL SELECT 'client', 'R', 14, 'D'                                           --Kalender (calendar) DELETE -> client READ
    UNION ALL SELECT 'calendar', 'W', 14, 'D'                                         --Kalender (calendar) DELETE -> calendar WRITE
    UNION ALL SELECT 'clientPermission', 'R', 14, 'D'                                 --Kalender (calendar) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 14, 'D'                                       --Kalender (calendar) DELETE -> clientRole READ
    UNION ALL SELECT 'calendarDay', 'R', 14, 'D'                                      --Kalender (calendar) DELETE -> calendarDay READ
    UNION ALL SELECT 'calendarDay', 'D', 14, 'D'                                      --Kalender (calendar) DELETE -> calendarDay DELETE
    UNION ALL SELECT 'calendar', 'D', 14, 'D'                                         --Kalender (calendar) DELETE -> calendar DELETE
    UNION ALL SELECT 'calendarDay', 'W', 14, 'D'                                      --Kalender (calendar) DELETE -> calendarDay WRITE
    UNION ALL SELECT 'calendar', 'R', 14, 'D'                                         --Kalender (calendar) DELETE -> calendar READ
    UNION ALL SELECT 'client', 'R', 15, 'R'                                           --Anlagen (technicalCleaningObject) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 15, 'R'                                 --Anlagen (technicalCleaningObject) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 15, 'R'                                       --Anlagen (technicalCleaningObject) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 15, 'R'                                          --Anlagen (technicalCleaningObject) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 15, 'R'                                         --Anlagen (technicalCleaningObject) READ   -> language READ
    UNION ALL SELECT 'location', 'R', 15, 'R'                                         --Anlagen (technicalCleaningObject) READ   -> location READ
	UNION ALL SELECT 'mainCode', 'R', 15, 'R'                                         --Anlagen (technicalCleaningObject) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 15, 'R'                        --Anlagen (technicalCleaningObject) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 15, 'R'                                 --Anlagen (technicalCleaningObject) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 15, 'R'                  --Anlagen (technicalCleaningObject) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 15, 'R'                                   --Anlagen (technicalCleaningObject) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 15, 'R'                             --Anlagen (technicalCleaningObject) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 15, 'R'                      --Anlagen (technicalCleaningObject) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 15, 'R'                            --Anlagen (technicalCleaningObject) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 15, 'R'                                        --Anlagen (technicalCleaningObject) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 15, 'R'                                            --Anlagen (technicalCleaningObject) READ   -> plant READ
    UNION ALL SELECT 'servicePosition', 'R', 15, 'R'                                  --Anlagen (technicalCleaningObject) READ   -> servicePosition READ
    UNION ALL SELECT 'serviceType', 'R', 15, 'R'                                      --Anlagen (technicalCleaningObject) READ   -> serviceType READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 15, 'R'                          --Anlagen (technicalCleaningObject) READ   -> technicalCleaningObject READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 15, 'R'                      --Anlagen (technicalCleaningObject) READ   -> technicalCleaningObjectType READ
    UNION ALL SELECT 'serviceObject', 'R', 15, 'R'                                    --Anlagen (technicalCleaningObject) READ   -> serviceObject READ
    UNION ALL SELECT 'serviceObjectType', 'R', 15, 'R'                                --Anlagen (technicalCleaningObject) READ   -> serviceObjectType READ
    UNION ALL SELECT 'serviceObjectType', 'R', 15, 'W'                                --Anlagen (technicalCleaningObject) WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'location', 'R', 15, 'W'                                         --Anlagen (technicalCleaningObject) WRITE  -> location READ
    UNION ALL SELECT 'serviceObject', 'R', 15, 'W'                                    --Anlagen (technicalCleaningObject) WRITE  -> serviceObject READ
    UNION ALL SELECT 'serviceObject', 'D', 15, 'W'                                    --Anlagen (technicalCleaningObject) WRITE  -> serviceObject DELETE
    UNION ALL SELECT 'serviceObject', 'W', 15, 'W'                                    --Anlagen (technicalCleaningObject) WRITE  -> serviceObject WRITE
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 15, 'W'                      --Anlagen (technicalCleaningObject) WRITE  -> technicalCleaningObjectType READ
    UNION ALL SELECT 'technicalCleaningObject', 'W', 15, 'W'                          --Anlagen (technicalCleaningObject) WRITE  -> technicalCleaningObject WRITE
    UNION ALL SELECT 'technicalCleaningObject', 'R', 15, 'W'                          --Anlagen (technicalCleaningObject) WRITE  -> technicalCleaningObject READ
    UNION ALL SELECT 'technicalCleaningObject', 'D', 15, 'W'                          --Anlagen (technicalCleaningObject) WRITE  -> technicalCleaningObject DELETE
    UNION ALL SELECT 'serviceType', 'R', 15, 'W'                                      --Anlagen (technicalCleaningObject) WRITE  -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'R', 15, 'W'                                  --Anlagen (technicalCleaningObject) WRITE  -> servicePosition READ
    UNION ALL SELECT 'plant', 'R', 15, 'W'                                            --Anlagen (technicalCleaningObject) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 15, 'W'                                        --Anlagen (technicalCleaningObject) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 15, 'W'                            --Anlagen (technicalCleaningObject) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 15, 'W'                      --Anlagen (technicalCleaningObject) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 15, 'W'                             --Anlagen (technicalCleaningObject) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 15, 'W'                                   --Anlagen (technicalCleaningObject) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 15, 'W'                  --Anlagen (technicalCleaningObject) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 15, 'W'                                 --Anlagen (technicalCleaningObject) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 15, 'W'                        --Anlagen (technicalCleaningObject) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 15, 'W'                                         --Anlagen (technicalCleaningObject) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 15, 'W'                                         --Anlagen (technicalCleaningObject) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 15, 'W'                                          --Anlagen (technicalCleaningObject) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 15, 'W'                                       --Anlagen (technicalCleaningObject) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 15, 'W'                                 --Anlagen (technicalCleaningObject) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 15, 'W'                                           --Anlagen (technicalCleaningObject) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 15, 'D'                                 --Anlagen (technicalCleaningObject) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 15, 'D'                                       --Anlagen (technicalCleaningObject) DELETE -> clientRole READ
    UNION ALL SELECT 'client', 'R', 15, 'D'                                           --Anlagen (technicalCleaningObject) DELETE -> client READ
    UNION ALL SELECT 'company', 'R', 15, 'D'                                          --Anlagen (technicalCleaningObject) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 15, 'D'                                         --Anlagen (technicalCleaningObject) DELETE -> language READ
    UNION ALL SELECT 'location', 'R', 15, 'D'                                         --Anlagen (technicalCleaningObject) DELETE -> location READ
    UNION ALL SELECT 'mainCode', 'R', 15, 'D'                                         --Anlagen (technicalCleaningObject) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 15, 'D'                        --Anlagen (technicalCleaningObject) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 15, 'D'                                 --Anlagen (technicalCleaningObject) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 15, 'D'                  --Anlagen (technicalCleaningObject) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 15, 'D'                                   --Anlagen (technicalCleaningObject) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 15, 'D'                             --Anlagen (technicalCleaningObject) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 15, 'D'                      --Anlagen (technicalCleaningObject) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 15, 'D'                            --Anlagen (technicalCleaningObject) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 15, 'D'                                        --Anlagen (technicalCleaningObject) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 15, 'D'                                            --Anlagen (technicalCleaningObject) DELETE -> plant READ
    UNION ALL SELECT 'serviceType', 'R', 15, 'D'                                      --Anlagen (technicalCleaningObject) DELETE -> serviceType READ
    UNION ALL SELECT 'technicalCleaningObject', 'D', 15, 'D'                          --Anlagen (technicalCleaningObject) DELETE -> technicalCleaningObject DELETE
    UNION ALL SELECT 'technicalCleaningObject', 'R', 15, 'D'                          --Anlagen (technicalCleaningObject) DELETE -> technicalCleaningObject READ
    UNION ALL SELECT 'technicalCleaningObject', 'W', 15, 'D'                          --Anlagen (technicalCleaningObject) DELETE -> technicalCleaningObject WRITE
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 15, 'D'                      --Anlagen (technicalCleaningObject) DELETE -> technicalCleaningObjectType READ
    UNION ALL SELECT 'serviceObject', 'R', 15, 'D'                                    --Anlagen (technicalCleaningObject) DELETE -> serviceObject READ
    UNION ALL SELECT 'serviceObjectType', 'R', 15, 'D'                                --Anlagen (technicalCleaningObject) DELETE -> serviceObjectType READ
    UNION ALL SELECT 'serviceObject', 'D', 15, 'D'                                    --Anlagen (technicalCleaningObject) DELETE -> serviceObject DELETE
    UNION ALL SELECT 'serviceObject', 'W', 15, 'D'                                    --Anlagen (technicalCleaningObject) DELETE -> serviceObject WRITE
    UNION ALL SELECT 'servicePosition', 'R', 15, 'D'                                  --Anlagen (technicalCleaningObject) DELETE -> servicePosition READ
    UNION ALL SELECT 'serviceObjectType', 'R', 16, 'R'                                --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> serviceObjectType READ
    UNION ALL SELECT 'serviceObject', 'R', 16, 'R'                                    --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> serviceObject READ
    UNION ALL SELECT 'serviceType', 'R', 16, 'R'                                      --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'R', 16, 'R'                                  --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> servicePosition READ
    UNION ALL SELECT 'plant', 'R', 16, 'R'                                            --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 16, 'R'                                        --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 16, 'R'                            --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 16, 'R'                      --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 16, 'R'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 16, 'R'                                   --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 16, 'R'                  --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 16, 'R'                                 --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 16, 'R'                        --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 16, 'R'                                         --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 16, 'R'                                         --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> language READ
    UNION ALL SELECT 'customCleaningObject', 'R', 16, 'R'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> customCleaningObject READ
    UNION ALL SELECT 'company', 'R', 16, 'R'                                          --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 16, 'R'                                       --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 16, 'R'                                 --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 16, 'R'                                           --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 16, 'W'                                 --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 16, 'W'                                           --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> client READ
    UNION ALL SELECT 'company', 'R', 16, 'W'                                          --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 16, 'W'                                       --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> clientRole READ
    UNION ALL SELECT 'customCleaningObject', 'R', 16, 'W'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> customCleaningObject READ
    UNION ALL SELECT 'customCleaningObject', 'D', 16, 'W'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> customCleaningObject DELETE
    UNION ALL SELECT 'customCleaningObject', 'W', 16, 'W'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> customCleaningObject WRITE
    UNION ALL SELECT 'mainCode', 'R', 16, 'W'                                         --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 16, 'W'                                         --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> language READ
    UNION ALL SELECT 'mapClientCompany', 'R', 16, 'W'                                 --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 16, 'W'                        --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientPlant', 'R', 16, 'W'                                   --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 16, 'W'                  --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 16, 'W'                      --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 16, 'W'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'parameter', 'R', 16, 'W'                                        --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 16, 'W'                            --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'plant', 'R', 16, 'W'                                            --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> plant READ
    UNION ALL SELECT 'serviceType', 'R', 16, 'W'                                      --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'R', 16, 'W'                                  --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> servicePosition READ
    UNION ALL SELECT 'serviceObjectType', 'R', 16, 'W'                                --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'serviceObject', 'R', 16, 'W'                                    --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> serviceObject READ
    UNION ALL SELECT 'serviceObject', 'W', 16, 'W'                                    --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> serviceObject WRITE
    UNION ALL SELECT 'serviceObject', 'D', 16, 'W'                                    --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) WRITE  -> serviceObject DELETE
    UNION ALL SELECT 'serviceObject', 'D', 16, 'D'                                    --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> serviceObject DELETE
    UNION ALL SELECT 'serviceObjectType', 'R', 16, 'D'                                --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> serviceObjectType READ
    UNION ALL SELECT 'serviceObject', 'R', 16, 'D'                                    --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> serviceObject READ
    UNION ALL SELECT 'servicePosition', 'R', 16, 'D'                                  --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> servicePosition READ
    UNION ALL SELECT 'serviceObject', 'W', 16, 'D'                                    --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> serviceObject WRITE
    UNION ALL SELECT 'serviceType', 'R', 16, 'D'                                      --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> serviceType READ
    UNION ALL SELECT 'plant', 'R', 16, 'D'                                            --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> plant READ
    UNION ALL SELECT 'parameter', 'R', 16, 'D'                                        --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> parameter READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 16, 'D'                      --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 16, 'D'                            --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 16, 'D'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 16, 'D'                                   --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 16, 'D'                        --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 16, 'D'                                 --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 16, 'D'                  --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mainCode', 'R', 16, 'D'                                         --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> mainCode READ
    UNION ALL SELECT 'customCleaningObject', 'D', 16, 'D'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> customCleaningObject DELETE
    UNION ALL SELECT 'customCleaningObject', 'R', 16, 'D'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> customCleaningObject READ
    UNION ALL SELECT 'language', 'R', 16, 'D'                                         --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> language READ
    UNION ALL SELECT 'customCleaningObject', 'W', 16, 'D'                             --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> customCleaningObject WRITE
    UNION ALL SELECT 'company', 'R', 16, 'D'                                          --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> company READ
    UNION ALL SELECT 'client', 'R', 16, 'D'                                           --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 16, 'D'                                 --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 16, 'D'                                       --Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) DELETE -> clientRole READ
    UNION ALL SELECT 'client', 'R', 17, 'R'                                           --Leistungskataloge (serviceCatalog) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 17, 'R'                                 --Leistungskataloge (serviceCatalog) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 17, 'R'                                       --Leistungskataloge (serviceCatalog) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 17, 'R'                                          --Leistungskataloge (serviceCatalog) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 17, 'R'                                         --Leistungskataloge (serviceCatalog) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 17, 'R'                                         --Leistungskataloge (serviceCatalog) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 17, 'R'                        --Leistungskataloge (serviceCatalog) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 17, 'R'                                 --Leistungskataloge (serviceCatalog) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 17, 'R'                  --Leistungskataloge (serviceCatalog) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 17, 'R'                                   --Leistungskataloge (serviceCatalog) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 17, 'R'                             --Leistungskataloge (serviceCatalog) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 17, 'R'                 --Leistungskataloge (serviceCatalog) READ   -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 17, 'R'                      --Leistungskataloge (serviceCatalog) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 17, 'R'                            --Leistungskataloge (serviceCatalog) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 17, 'R'                                        --Leistungskataloge (serviceCatalog) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 17, 'R'                                            --Leistungskataloge (serviceCatalog) READ   -> plant READ
    UNION ALL SELECT 'servicePosition', 'R', 17, 'R'                                  --Leistungskataloge (serviceCatalog) READ   -> servicePosition READ
    UNION ALL SELECT 'serviceType', 'R', 17, 'R'                                      --Leistungskataloge (serviceCatalog) READ   -> serviceType READ
    UNION ALL SELECT 'standard', 'R', 17, 'R'                                         --Leistungskataloge (serviceCatalog) READ   -> standard READ
    UNION ALL SELECT 'turnus', 'R', 17, 'R'                                           --Leistungskataloge (serviceCatalog) READ   -> turnus READ
    UNION ALL SELECT 'unit', 'R', 17, 'R'                                             --Leistungskataloge (serviceCatalog) READ   -> unit READ
    UNION ALL SELECT 'serviceCatalog', 'R', 17, 'R'                                   --Leistungskataloge (serviceCatalog) READ   -> serviceCatalog READ
    UNION ALL SELECT 'wageCluster', 'R', 17, 'R'                                      --Leistungskataloge (serviceCatalog) READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 17, 'R'                                        --Leistungskataloge (serviceCatalog) READ   -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 17, 'R'                                        --Leistungskataloge (serviceCatalog) READ   -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 17, 'W'                                      --Leistungskataloge (serviceCatalog) WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 17, 'W'                                        --Leistungskataloge (serviceCatalog) WRITE  -> wageGroup READ
    UNION ALL SELECT 'servicePosition', 'D', 17, 'W'                                  --Leistungskataloge (serviceCatalog) WRITE  -> servicePosition DELETE
    UNION ALL SELECT 'serviceCatalog', 'R', 17, 'W'                                   --Leistungskataloge (serviceCatalog) WRITE  -> serviceCatalog READ
    UNION ALL SELECT 'serviceCatalog', 'D', 17, 'W'                                   --Leistungskataloge (serviceCatalog) WRITE  -> serviceCatalog DELETE
    UNION ALL SELECT 'serviceCatalog', 'W', 17, 'W'                                   --Leistungskataloge (serviceCatalog) WRITE  -> serviceCatalog WRITE
    UNION ALL SELECT 'unit', 'R', 17, 'W'                                             --Leistungskataloge (serviceCatalog) WRITE  -> unit READ
    UNION ALL SELECT 'standard', 'R', 17, 'W'                                         --Leistungskataloge (serviceCatalog) WRITE  -> standard READ
    UNION ALL SELECT 'serviceType', 'R', 17, 'W'                                      --Leistungskataloge (serviceCatalog) WRITE  -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'W', 17, 'W'                                  --Leistungskataloge (serviceCatalog) WRITE  -> servicePosition WRITE
    UNION ALL SELECT 'servicePosition', 'R', 17, 'W'                                  --Leistungskataloge (serviceCatalog) WRITE  -> servicePosition READ
    UNION ALL SELECT 'plant', 'R', 17, 'W'                                            --Leistungskataloge (serviceCatalog) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 17, 'W'                                        --Leistungskataloge (serviceCatalog) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 17, 'W'                            --Leistungskataloge (serviceCatalog) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'D', 17, 'W'                      --Leistungskataloge (serviceCatalog) WRITE  -> mapServicePositionUsageType DELETE
    UNION ALL SELECT 'mapServicePositionUsageType', 'W', 17, 'W'                      --Leistungskataloge (serviceCatalog) WRITE  -> mapServicePositionUsageType WRITE
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 17, 'W'                      --Leistungskataloge (serviceCatalog) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 17, 'W'                 --Leistungskataloge (serviceCatalog) WRITE  -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'D', 17, 'W'                 --Leistungskataloge (serviceCatalog) WRITE  -> mapServiceCatalogServicePosition DELETE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'W', 17, 'W'                 --Leistungskataloge (serviceCatalog) WRITE  -> mapServiceCatalogServicePosition WRITE
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 17, 'W'                             --Leistungskataloge (serviceCatalog) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 17, 'W'                                   --Leistungskataloge (serviceCatalog) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 17, 'W'                  --Leistungskataloge (serviceCatalog) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 17, 'W'                                 --Leistungskataloge (serviceCatalog) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 17, 'W'                        --Leistungskataloge (serviceCatalog) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 17, 'W'                                         --Leistungskataloge (serviceCatalog) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 17, 'W'                                         --Leistungskataloge (serviceCatalog) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 17, 'W'                                          --Leistungskataloge (serviceCatalog) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 17, 'W'                                       --Leistungskataloge (serviceCatalog) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 17, 'W'                                 --Leistungskataloge (serviceCatalog) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 17, 'W'                                           --Leistungskataloge (serviceCatalog) WRITE  -> client READ
    UNION ALL SELECT 'turnus', 'R', 17, 'W'                                           --Leistungskataloge (serviceCatalog) WRITE  -> turnus READ
    UNION ALL SELECT 'usageType', 'R', 17, 'W'                                        --Leistungskataloge (serviceCatalog) WRITE  -> usageType READ
    UNION ALL SELECT 'clientPermission', 'R', 17, 'D'                                 --Leistungskataloge (serviceCatalog) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 17, 'D'                                       --Leistungskataloge (serviceCatalog) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 17, 'D'                                          --Leistungskataloge (serviceCatalog) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 17, 'D'                                         --Leistungskataloge (serviceCatalog) DELETE -> language READ
    UNION ALL SELECT 'client', 'R', 17, 'D'                                           --Leistungskataloge (serviceCatalog) DELETE -> client READ
    UNION ALL SELECT 'mainCode', 'R', 17, 'D'                                         --Leistungskataloge (serviceCatalog) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 17, 'D'                        --Leistungskataloge (serviceCatalog) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 17, 'D'                                 --Leistungskataloge (serviceCatalog) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 17, 'D'                  --Leistungskataloge (serviceCatalog) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 17, 'D'                                   --Leistungskataloge (serviceCatalog) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 17, 'D'                             --Leistungskataloge (serviceCatalog) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 17, 'D'                 --Leistungskataloge (serviceCatalog) DELETE -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 17, 'D'                      --Leistungskataloge (serviceCatalog) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'D', 17, 'D'                      --Leistungskataloge (serviceCatalog) DELETE -> mapServicePositionUsageType DELETE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'W', 17, 'D'                 --Leistungskataloge (serviceCatalog) DELETE -> mapServiceCatalogServicePosition WRITE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'D', 17, 'D'                 --Leistungskataloge (serviceCatalog) DELETE -> mapServiceCatalogServicePosition DELETE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 17, 'D'                            --Leistungskataloge (serviceCatalog) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'W', 17, 'D'                      --Leistungskataloge (serviceCatalog) DELETE -> mapServicePositionUsageType WRITE
    UNION ALL SELECT 'parameter', 'R', 17, 'D'                                        --Leistungskataloge (serviceCatalog) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 17, 'D'                                            --Leistungskataloge (serviceCatalog) DELETE -> plant READ
    UNION ALL SELECT 'serviceType', 'R', 17, 'D'                                      --Leistungskataloge (serviceCatalog) DELETE -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'W', 17, 'D'                                  --Leistungskataloge (serviceCatalog) DELETE -> servicePosition WRITE
    UNION ALL SELECT 'standard', 'R', 17, 'D'                                         --Leistungskataloge (serviceCatalog) DELETE -> standard READ
    UNION ALL SELECT 'turnus', 'R', 17, 'D'                                           --Leistungskataloge (serviceCatalog) DELETE -> turnus READ
    UNION ALL SELECT 'unit', 'R', 17, 'D'                                             --Leistungskataloge (serviceCatalog) DELETE -> unit READ
    UNION ALL SELECT 'serviceCatalog', 'R', 17, 'D'                                   --Leistungskataloge (serviceCatalog) DELETE -> serviceCatalog READ
    UNION ALL SELECT 'serviceCatalog', 'D', 17, 'D'                                   --Leistungskataloge (serviceCatalog) DELETE -> serviceCatalog DELETE
    UNION ALL SELECT 'servicePosition', 'R', 17, 'D'                                  --Leistungskataloge (serviceCatalog) DELETE -> servicePosition READ
    UNION ALL SELECT 'servicePosition', 'D', 17, 'D'                                  --Leistungskataloge (serviceCatalog) DELETE -> servicePosition DELETE
    UNION ALL SELECT 'serviceCatalog', 'W', 17, 'D'                                   --Leistungskataloge (serviceCatalog) DELETE -> serviceCatalog WRITE
    UNION ALL SELECT 'wageCluster', 'R', 17, 'D'                                      --Leistungskataloge (serviceCatalog) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 17, 'D'                                        --Leistungskataloge (serviceCatalog) DELETE -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 17, 'D'                                        --Leistungskataloge (serviceCatalog) DELETE -> usageType READ
    UNION ALL SELECT 'usageType', 'R', 18, 'R'                                        --Standortkataloge (siteCatalog) READ   -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 18, 'R'                                      --Standortkataloge (siteCatalog) READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 18, 'R'                                        --Standortkataloge (siteCatalog) READ   -> wageGroup READ
    UNION ALL SELECT 'serviceObjectType', 'R', 18, 'R'                                --Standortkataloge (siteCatalog) READ   -> serviceObjectType READ
    UNION ALL SELECT 'serviceCatalog', 'R', 18, 'R'                                   --Standortkataloge (siteCatalog) READ   -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 18, 'R'                                    --Standortkataloge (siteCatalog) READ   -> serviceObject READ
    UNION ALL SELECT 'serviceCategory', 'R', 18, 'R'                                  --Standortkataloge (siteCatalog) READ   -> serviceCategory READ
    UNION ALL SELECT 'unit', 'R', 18, 'R'                                             --Standortkataloge (siteCatalog) READ   -> unit READ
    UNION ALL SELECT 'turnus', 'R', 18, 'R'                                           --Standortkataloge (siteCatalog) READ   -> turnus READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 18, 'R'                          --Standortkataloge (siteCatalog) READ   -> technicalCleaningObject READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 18, 'R'                      --Standortkataloge (siteCatalog) READ   -> technicalCleaningObjectType READ
    UNION ALL SELECT 'standard', 'R', 18, 'R'                                         --Standortkataloge (siteCatalog) READ   -> standard READ
    UNION ALL SELECT 'site', 'R', 18, 'R'                                             --Standortkataloge (siteCatalog) READ   -> site READ
    UNION ALL SELECT 'siteCatalog', 'R', 18, 'R'                                      --Standortkataloge (siteCatalog) READ   -> siteCatalog READ
    UNION ALL SELECT 'siteCatalogPosition', 'R', 18, 'R'                              --Standortkataloge (siteCatalog) READ   -> siteCatalogPosition READ
    UNION ALL SELECT 'serviceType', 'R', 18, 'R'                                      --Standortkataloge (siteCatalog) READ   -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'R', 18, 'R'                                  --Standortkataloge (siteCatalog) READ   -> servicePosition READ
    UNION ALL SELECT 'plant', 'R', 18, 'R'                                            --Standortkataloge (siteCatalog) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 18, 'R'                                        --Standortkataloge (siteCatalog) READ   -> parameter READ
    UNION ALL SELECT 'orgUnit', 'R', 18, 'R'                                          --Standortkataloge (siteCatalog) READ   -> orgUnit READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 18, 'R'                            --Standortkataloge (siteCatalog) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 18, 'R'                             --Standortkataloge (siteCatalog) READ   -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 18, 'R'                              --Standortkataloge (siteCatalog) READ   -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 18, 'R'               --Standortkataloge (siteCatalog) READ   -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 18, 'R'              --Standortkataloge (siteCatalog) READ   -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 18, 'R'                               --Standortkataloge (siteCatalog) READ   -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 18, 'R'                      --Standortkataloge (siteCatalog) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 18, 'R'                 --Standortkataloge (siteCatalog) READ   -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 18, 'R'                             --Standortkataloge (siteCatalog) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 18, 'R'                                   --Standortkataloge (siteCatalog) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 18, 'R'                  --Standortkataloge (siteCatalog) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 18, 'R'                                 --Standortkataloge (siteCatalog) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 18, 'R'                        --Standortkataloge (siteCatalog) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 18, 'R'                                         --Standortkataloge (siteCatalog) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 18, 'R'                                         --Standortkataloge (siteCatalog) READ   -> language READ
    UNION ALL SELECT 'flooring', 'R', 18, 'R'                                         --Standortkataloge (siteCatalog) READ   -> flooring READ
    UNION ALL SELECT 'location', 'R', 18, 'R'                                         --Standortkataloge (siteCatalog) READ   -> location READ
    UNION ALL SELECT 'ffg', 'R', 18, 'R'                                              --Standortkataloge (siteCatalog) READ   -> ffg READ
    UNION ALL SELECT 'lvAlloc', 'R', 18, 'R'                                          --Standortkataloge (siteCatalog) READ   -> lvAlloc READ
    UNION ALL SELECT 'executionDay', 'R', 18, 'R'                                     --Standortkataloge (siteCatalog) READ   -> executionDay READ
    UNION ALL SELECT 'customCleaningObject', 'R', 18, 'R'                             --Standortkataloge (siteCatalog) READ   -> customCleaningObject READ
    UNION ALL SELECT 'cycle', 'R', 18, 'R'                                            --Standortkataloge (siteCatalog) READ   -> cycle READ
    UNION ALL SELECT 'currency', 'R', 18, 'R'                                         --Standortkataloge (siteCatalog) READ   -> currency READ
    UNION ALL SELECT 'costCenter', 'R', 18, 'R'                                       --Standortkataloge (siteCatalog) READ   -> costCenter READ
    UNION ALL SELECT 'company', 'R', 18, 'R'                                          --Standortkataloge (siteCatalog) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 18, 'R'                                       --Standortkataloge (siteCatalog) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 18, 'R'                                 --Standortkataloge (siteCatalog) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 18, 'R'                                           --Standortkataloge (siteCatalog) READ   -> client READ
    UNION ALL SELECT 'area', 'R', 18, 'R'                                             --Standortkataloge (siteCatalog) READ   -> area READ
    UNION ALL SELECT 'area', 'R', 18, 'W'                                             --Standortkataloge (siteCatalog) WRITE  -> area READ
    UNION ALL SELECT 'clientPermission', 'R', 18, 'W'                                 --Standortkataloge (siteCatalog) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 18, 'W'                                           --Standortkataloge (siteCatalog) WRITE  -> client READ
    UNION ALL SELECT 'executionDay', 'R', 18, 'W'                                     --Standortkataloge (siteCatalog) WRITE  -> executionDay READ
    UNION ALL SELECT 'clientRole', 'R', 18, 'W'                                       --Standortkataloge (siteCatalog) WRITE  -> clientRole READ
    UNION ALL SELECT 'company', 'R', 18, 'W'                                          --Standortkataloge (siteCatalog) WRITE  -> company READ
    UNION ALL SELECT 'currency', 'R', 18, 'W'                                         --Standortkataloge (siteCatalog) WRITE  -> currency READ
    UNION ALL SELECT 'costCenter', 'R', 18, 'W'                                       --Standortkataloge (siteCatalog) WRITE  -> costCenter READ
    UNION ALL SELECT 'cycle', 'R', 18, 'W'                                            --Standortkataloge (siteCatalog) WRITE  -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'R', 18, 'W'                             --Standortkataloge (siteCatalog) WRITE  -> customCleaningObject READ
    UNION ALL SELECT 'executionDay', 'D', 18, 'W'                                     --Standortkataloge (siteCatalog) WRITE  -> executionDay DELETE
    UNION ALL SELECT 'executionDay', 'W', 18, 'W'                                     --Standortkataloge (siteCatalog) WRITE  -> executionDay WRITE
    UNION ALL SELECT 'ffg', 'R', 18, 'W'                                              --Standortkataloge (siteCatalog) WRITE  -> ffg READ
    UNION ALL SELECT 'location', 'R', 18, 'W'                                         --Standortkataloge (siteCatalog) WRITE  -> location READ
    UNION ALL SELECT 'flooring', 'R', 18, 'W'                                         --Standortkataloge (siteCatalog) WRITE  -> flooring READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 18, 'W'                        --Standortkataloge (siteCatalog) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'language', 'R', 18, 'W'                                         --Standortkataloge (siteCatalog) WRITE  -> language READ
    UNION ALL SELECT 'mainCode', 'R', 18, 'W'                                         --Standortkataloge (siteCatalog) WRITE  -> mainCode READ
    UNION ALL SELECT 'lvAlloc', 'R', 18, 'W'                                          --Standortkataloge (siteCatalog) WRITE  -> lvAlloc READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 18, 'W'                  --Standortkataloge (siteCatalog) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 18, 'W'                                 --Standortkataloge (siteCatalog) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 18, 'W'                             --Standortkataloge (siteCatalog) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 18, 'W'                                   --Standortkataloge (siteCatalog) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'W', 18, 'W'                               --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogSite WRITE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 18, 'W'                 --Standortkataloge (siteCatalog) WRITE  -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 18, 'W'                      --Standortkataloge (siteCatalog) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 18, 'W'                               --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'D', 18, 'W'                               --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogSite DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'W', 18, 'W'               --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPositionExecutionDay WRITE
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'W', 18, 'W'              --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPositionServiceObject WRITE
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 18, 'W'              --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'D', 18, 'W'              --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPositionServiceObject DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 18, 'W'               --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'D', 18, 'W'               --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPositionExecutionDay DELETE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 18, 'W'                              --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'D', 18, 'W'                              --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPlant DELETE
    UNION ALL SELECT 'mapSiteCatalogClient', 'W', 18, 'W'                             --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogClient WRITE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'W', 18, 'W'                              --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogPlant WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 18, 'W'                             --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'D', 18, 'W'                             --Standortkataloge (siteCatalog) WRITE  -> mapSiteCatalogClient DELETE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 18, 'W'                            --Standortkataloge (siteCatalog) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'orgUnit', 'R', 18, 'W'                                          --Standortkataloge (siteCatalog) WRITE  -> orgUnit READ
    UNION ALL SELECT 'servicePosition', 'R', 18, 'W'                                  --Standortkataloge (siteCatalog) WRITE  -> servicePosition READ
    UNION ALL SELECT 'parameter', 'R', 18, 'W'                                        --Standortkataloge (siteCatalog) WRITE  -> parameter READ
    UNION ALL SELECT 'plant', 'R', 18, 'W'                                            --Standortkataloge (siteCatalog) WRITE  -> plant READ
    UNION ALL SELECT 'siteCatalogPosition', 'R', 18, 'W'                              --Standortkataloge (siteCatalog) WRITE  -> siteCatalogPosition READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 18, 'W'                          --Standortkataloge (siteCatalog) WRITE  -> technicalCleaningObject READ
    UNION ALL SELECT 'serviceType', 'R', 18, 'W'                                      --Standortkataloge (siteCatalog) WRITE  -> serviceType READ
    UNION ALL SELECT 'siteCatalog', 'R', 18, 'W'                                      --Standortkataloge (siteCatalog) WRITE  -> siteCatalog READ
    UNION ALL SELECT 'siteCatalog', 'D', 18, 'W'                                      --Standortkataloge (siteCatalog) WRITE  -> siteCatalog DELETE
    UNION ALL SELECT 'siteCatalog', 'W', 18, 'W'                                      --Standortkataloge (siteCatalog) WRITE  -> siteCatalog WRITE
    UNION ALL SELECT 'siteCatalogPosition', 'D', 18, 'W'                              --Standortkataloge (siteCatalog) WRITE  -> siteCatalogPosition DELETE
    UNION ALL SELECT 'site', 'R', 18, 'W'                                             --Standortkataloge (siteCatalog) WRITE  -> site READ
    UNION ALL SELECT 'siteCatalogPosition', 'W', 18, 'W'                              --Standortkataloge (siteCatalog) WRITE  -> siteCatalogPosition WRITE
	UNION ALL SELECT 'customCleaningObject', 'W', 18, 'W'                             --Standortkataloge (siteCatalog) WRITE  -> customCleaningObject WRITE
    UNION ALL SELECT 'standard', 'R', 18, 'W'                                         --Standortkataloge (siteCatalog) WRITE  -> standard READ
    UNION ALL SELECT 'turnus', 'R', 18, 'W'                                           --Standortkataloge (siteCatalog) WRITE  -> turnus READ
    UNION ALL SELECT 'wageCluster', 'R', 18, 'W'                                      --Standortkataloge (siteCatalog) WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 18, 'W'                                        --Standortkataloge (siteCatalog) WRITE  -> wageGroup READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 18, 'W'                      --Standortkataloge (siteCatalog) WRITE  -> technicalCleaningObjectType READ
    UNION ALL SELECT 'unit', 'R', 18, 'W'                                             --Standortkataloge (siteCatalog) WRITE  -> unit READ
    UNION ALL SELECT 'serviceCategory', 'R', 18, 'W'                                  --Standortkataloge (siteCatalog) WRITE  -> serviceCategory READ
    UNION ALL SELECT 'serviceObjectType', 'R', 18, 'W'                                --Standortkataloge (siteCatalog) WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'serviceCatalog', 'R', 18, 'W'                                   --Standortkataloge (siteCatalog) WRITE  -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 18, 'W'                                    --Standortkataloge (siteCatalog) WRITE  -> serviceObject READ
    UNION ALL SELECT 'usageType', 'R', 18, 'W'                                        --Standortkataloge (siteCatalog) WRITE  -> usageType READ
    UNION ALL SELECT 'usageType', 'R', 18, 'D'                                        --Standortkataloge (siteCatalog) DELETE -> usageType READ
    UNION ALL SELECT 'serviceObjectType', 'R', 18, 'D'                                --Standortkataloge (siteCatalog) DELETE -> serviceObjectType READ
    UNION ALL SELECT 'wageCluster', 'R', 18, 'D'                                      --Standortkataloge (siteCatalog) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 18, 'D'                                        --Standortkataloge (siteCatalog) DELETE -> wageGroup READ
    UNION ALL SELECT 'servicePosition', 'R', 18, 'D'                                  --Standortkataloge (siteCatalog) DELETE -> servicePosition READ
    UNION ALL SELECT 'unit', 'R', 18, 'D'                                             --Standortkataloge (siteCatalog) DELETE -> unit READ
    UNION ALL SELECT 'serviceCategory', 'R', 18, 'D'                                  --Standortkataloge (siteCatalog) DELETE -> serviceCategory READ
    UNION ALL SELECT 'serviceCatalog', 'R', 18, 'D'                                   --Standortkataloge (siteCatalog) DELETE -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 18, 'D'                                    --Standortkataloge (siteCatalog) DELETE -> serviceObject READ
    UNION ALL SELECT 'turnus', 'R', 18, 'D'                                           --Standortkataloge (siteCatalog) DELETE -> turnus READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 18, 'D'                          --Standortkataloge (siteCatalog) DELETE -> technicalCleaningObject READ
    UNION ALL SELECT 'standard', 'R', 18, 'D'                                         --Standortkataloge (siteCatalog) DELETE -> standard READ
    UNION ALL SELECT 'siteCatalogPosition', 'W', 18, 'D'                              --Standortkataloge (siteCatalog) DELETE -> siteCatalogPosition WRITE
	UNION ALL SELECT 'customCleaningObject', 'W', 18, 'W'                             --Standortkataloge (siteCatalog) WRITE  -> customCleaningObject WRITE
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 18, 'D'                      --Standortkataloge (siteCatalog) DELETE -> technicalCleaningObjectType READ
    UNION ALL SELECT 'siteCatalog', 'D', 18, 'D'                                      --Standortkataloge (siteCatalog) DELETE -> siteCatalog DELETE
    UNION ALL SELECT 'siteCatalogPosition', 'R', 18, 'D'                              --Standortkataloge (siteCatalog) DELETE -> siteCatalogPosition READ
    UNION ALL SELECT 'siteCatalogPosition', 'D', 18, 'D'                              --Standortkataloge (siteCatalog) DELETE -> siteCatalogPosition DELETE
    UNION ALL SELECT 'siteCatalog', 'R', 18, 'D'                                      --Standortkataloge (siteCatalog) DELETE -> siteCatalog READ
    UNION ALL SELECT 'siteCatalog', 'W', 18, 'D'                                      --Standortkataloge (siteCatalog) DELETE -> siteCatalog WRITE
    UNION ALL SELECT 'site', 'R', 18, 'D'                                             --Standortkataloge (siteCatalog) DELETE -> site READ
    UNION ALL SELECT 'serviceType', 'R', 18, 'D'                                      --Standortkataloge (siteCatalog) DELETE -> serviceType READ
    UNION ALL SELECT 'plant', 'R', 18, 'D'                                            --Standortkataloge (siteCatalog) DELETE -> plant READ
    UNION ALL SELECT 'orgUnit', 'R', 18, 'D'                                          --Standortkataloge (siteCatalog) DELETE -> orgUnit READ
    UNION ALL SELECT 'parameter', 'R', 18, 'D'                                        --Standortkataloge (siteCatalog) DELETE -> parameter READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'W', 18, 'D'                             --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogClient WRITE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 18, 'D'                            --Standortkataloge (siteCatalog) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'D', 18, 'D'                             --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogClient DELETE
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 18, 'D'                             --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'D', 18, 'D'               --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPositionExecutionDay DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 18, 'D'               --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'D', 18, 'D'                              --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPlant DELETE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 18, 'D'                              --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'W', 18, 'D'                              --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPlant WRITE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'W', 18, 'D'               --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPositionExecutionDay WRITE
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'W', 18, 'D'              --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPositionServiceObject WRITE
    UNION ALL SELECT 'mapSiteCatalogSite', 'D', 18, 'D'                               --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogSite DELETE
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 18, 'D'                               --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'D', 18, 'D'              --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPositionServiceObject DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 18, 'D'              --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'W', 18, 'D'                               --Standortkataloge (siteCatalog) DELETE -> mapSiteCatalogSite WRITE
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 18, 'D'                      --Standortkataloge (siteCatalog) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 18, 'D'                             --Standortkataloge (siteCatalog) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 18, 'D'                 --Standortkataloge (siteCatalog) DELETE -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapClientPlant', 'R', 18, 'D'                                   --Standortkataloge (siteCatalog) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 18, 'D'                  --Standortkataloge (siteCatalog) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mainCode', 'R', 18, 'D'                                         --Standortkataloge (siteCatalog) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 18, 'D'                        --Standortkataloge (siteCatalog) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 18, 'D'                                 --Standortkataloge (siteCatalog) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'lvAlloc', 'R', 18, 'D'                                          --Standortkataloge (siteCatalog) DELETE -> lvAlloc READ
    UNION ALL SELECT 'location', 'R', 18, 'D'                                         --Standortkataloge (siteCatalog) DELETE -> location READ
    UNION ALL SELECT 'flooring', 'R', 18, 'D'                                         --Standortkataloge (siteCatalog) DELETE -> flooring READ
    UNION ALL SELECT 'executionDay', 'D', 18, 'D'                                     --Standortkataloge (siteCatalog) DELETE -> executionDay DELETE
    UNION ALL SELECT 'executionDay', 'R', 18, 'D'                                     --Standortkataloge (siteCatalog) DELETE -> executionDay READ
    UNION ALL SELECT 'executionDay', 'W', 18, 'D'                                     --Standortkataloge (siteCatalog) DELETE -> executionDay WRITE
    UNION ALL SELECT 'language', 'R', 18, 'D'                                         --Standortkataloge (siteCatalog) DELETE -> language READ
    UNION ALL SELECT 'ffg', 'R', 18, 'D'                                              --Standortkataloge (siteCatalog) DELETE -> ffg READ
    UNION ALL SELECT 'customCleaningObject', 'R', 18, 'D'                             --Standortkataloge (siteCatalog) DELETE -> customCleaningObject READ
    UNION ALL SELECT 'cycle', 'R', 18, 'D'                                            --Standortkataloge (siteCatalog) DELETE -> cycle READ
    UNION ALL SELECT 'costCenter', 'R', 18, 'D'                                       --Standortkataloge (siteCatalog) DELETE -> costCenter READ
    UNION ALL SELECT 'currency', 'R', 18, 'D'                                         --Standortkataloge (siteCatalog) DELETE -> currency READ
    UNION ALL SELECT 'company', 'R', 18, 'D'                                          --Standortkataloge (siteCatalog) DELETE -> company READ
    UNION ALL SELECT 'client', 'R', 18, 'D'                                           --Standortkataloge (siteCatalog) DELETE -> client READ
    UNION ALL SELECT 'area', 'R', 18, 'D'                                             --Standortkataloge (siteCatalog) DELETE -> area READ
    UNION ALL SELECT 'clientPermission', 'R', 18, 'D'                                 --Standortkataloge (siteCatalog) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 18, 'D'                                       --Standortkataloge (siteCatalog) DELETE -> clientRole READ
    UNION ALL SELECT 'additionalShift', 'R', 19, 'R'                                  --Preiskataloge (priceCatalog) READ   -> additionalShift READ
    UNION ALL SELECT 'attachedDocument', 'R', 19, 'R'                                 --Preiskataloge (priceCatalog) READ   -> attachedDocument READ
    UNION ALL SELECT 'client', 'R', 19, 'R'                                           --Preiskataloge (priceCatalog) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 19, 'R'                                 --Preiskataloge (priceCatalog) READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 19, 'R'                                       --Preiskataloge (priceCatalog) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 19, 'R'                                          --Preiskataloge (priceCatalog) READ   -> company READ
    UNION ALL SELECT 'mainCode', 'R', 19, 'R'                                         --Preiskataloge (priceCatalog) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 19, 'R'                                         --Preiskataloge (priceCatalog) READ   -> language READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 19, 'R'                        --Preiskataloge (priceCatalog) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 19, 'R'                                 --Preiskataloge (priceCatalog) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 19, 'R'                  --Preiskataloge (priceCatalog) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 19, 'R'                                   --Preiskataloge (priceCatalog) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 19, 'R'                             --Preiskataloge (priceCatalog) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 19, 'R'                   --Preiskataloge (priceCatalog) READ   -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 19, 'R'                 --Preiskataloge (priceCatalog) READ   -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 19, 'R'                            --Preiskataloge (priceCatalog) READ   -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 19, 'R'                  --Preiskataloge (priceCatalog) READ   -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 19, 'R'                      --Preiskataloge (priceCatalog) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 19, 'R'                                 --Preiskataloge (priceCatalog) READ   -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 19, 'R'                               --Preiskataloge (priceCatalog) READ   -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 19, 'R'              --Preiskataloge (priceCatalog) READ   -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 19, 'R'               --Preiskataloge (priceCatalog) READ   -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 19, 'R'                              --Preiskataloge (priceCatalog) READ   -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 19, 'R'                             --Preiskataloge (priceCatalog) READ   -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 19, 'R'                            --Preiskataloge (priceCatalog) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 19, 'R'                                        --Preiskataloge (priceCatalog) READ   -> parameter READ
    UNION ALL SELECT 'priceCatalog', 'R', 19, 'R'                                     --Preiskataloge (priceCatalog) READ   -> priceCatalog READ
    UNION ALL SELECT 'plant', 'R', 19, 'R'                                            --Preiskataloge (priceCatalog) READ   -> plant READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 19, 'R'                          --Preiskataloge (priceCatalog) READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 19, 'R'                  --Preiskataloge (priceCatalog) READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 19, 'R'                    --Preiskataloge (priceCatalog) READ   -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'servicePosition', 'R', 19, 'R'                                  --Preiskataloge (priceCatalog) READ   -> servicePosition READ
    UNION ALL SELECT 'serviceType', 'R', 19, 'R'                                      --Preiskataloge (priceCatalog) READ   -> serviceType READ
    UNION ALL SELECT 'siteCatalogPosition', 'R', 19, 'R'                              --Preiskataloge (priceCatalog) READ   -> siteCatalogPosition READ
    UNION ALL SELECT 'siteCatalog', 'R', 19, 'R'                                      --Preiskataloge (priceCatalog) READ   -> siteCatalog READ
    UNION ALL SELECT 'site', 'R', 19, 'R'                                             --Preiskataloge (priceCatalog) READ   -> site READ
    UNION ALL SELECT 'standardDiscount', 'R', 19, 'R'                                 --Preiskataloge (priceCatalog) READ   -> standardDiscount READ
    UNION ALL SELECT 'supplier', 'R', 19, 'R'                                         --Preiskataloge (priceCatalog) READ   -> supplier READ
    UNION ALL SELECT 'turnus', 'R', 19, 'R'                                           --Preiskataloge (priceCatalog) READ   -> turnus READ
    UNION ALL SELECT 'unit', 'R', 19, 'R'                                             --Preiskataloge (priceCatalog) READ   -> unit READ
    UNION ALL SELECT 'serviceCategory', 'R', 19, 'R'                                  --Preiskataloge (priceCatalog) READ   -> serviceCategory READ
    UNION ALL SELECT 'serviceObject', 'R', 19, 'R'                                    --Preiskataloge (priceCatalog) READ   -> serviceObject READ
    UNION ALL SELECT 'serviceCatalog', 'R', 19, 'R'                                   --Preiskataloge (priceCatalog) READ   -> serviceCatalog READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 19, 'R'                             --Preiskataloge (priceCatalog) READ   -> priceCatalogPosition READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 19, 'R'                               --Preiskataloge (priceCatalog) READ   -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 19, 'R'                                --Preiskataloge (priceCatalog) READ   -> serviceObjectType READ
    UNION ALL SELECT 'wageCluster', 'R', 19, 'R'                                      --Preiskataloge (priceCatalog) READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 19, 'R'                                        --Preiskataloge (priceCatalog) READ   -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 19, 'R'                                        --Preiskataloge (priceCatalog) READ   -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 19, 'W'                                      --Preiskataloge (priceCatalog) WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 19, 'W'                                        --Preiskataloge (priceCatalog) WRITE  -> wageGroup READ
    UNION ALL SELECT 'serviceObject', 'R', 19, 'W'                                    --Preiskataloge (priceCatalog) WRITE  -> serviceObject READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 19, 'W'                               --Preiskataloge (priceCatalog) WRITE  -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 19, 'W'                                --Preiskataloge (priceCatalog) WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 19, 'W'                             --Preiskataloge (priceCatalog) WRITE  -> priceCatalogPosition READ
    UNION ALL SELECT 'priceCatalogPosition', 'W', 19, 'W'                             --Preiskataloge (priceCatalog) WRITE  -> priceCatalogPosition WRITE
    UNION ALL SELECT 'serviceCatalog', 'R', 19, 'W'                                   --Preiskataloge (priceCatalog) WRITE  -> serviceCatalog READ
    UNION ALL SELECT 'turnus', 'R', 19, 'W'                                           --Preiskataloge (priceCatalog) WRITE  -> turnus READ
    UNION ALL SELECT 'serviceCategory', 'R', 19, 'W'                                  --Preiskataloge (priceCatalog) WRITE  -> serviceCategory READ
    UNION ALL SELECT 'unit', 'R', 19, 'W'                                             --Preiskataloge (priceCatalog) WRITE  -> unit READ
    UNION ALL SELECT 'site', 'R', 19, 'W'                                             --Preiskataloge (priceCatalog) WRITE  -> site READ
    UNION ALL SELECT 'supplier', 'R', 19, 'W'                                         --Preiskataloge (priceCatalog) WRITE  -> supplier READ
    UNION ALL SELECT 'standardDiscount', 'R', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> standardDiscount READ
    UNION ALL SELECT 'siteCatalogPosition', 'R', 19, 'W'                              --Preiskataloge (priceCatalog) WRITE  -> siteCatalogPosition READ
    UNION ALL SELECT 'siteCatalog', 'R', 19, 'W'                                      --Preiskataloge (priceCatalog) WRITE  -> siteCatalog READ
    UNION ALL SELECT 'serviceType', 'R', 19, 'W'                                      --Preiskataloge (priceCatalog) WRITE  -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'R', 19, 'W'                                  --Preiskataloge (priceCatalog) WRITE  -> servicePosition READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 19, 'W'                    --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'D', 19, 'W'                    --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculationStatus DELETE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'W', 19, 'W'                    --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculationStatus WRITE
    UNION ALL SELECT 'priceCatalog', 'W', 19, 'W'                                     --Preiskataloge (priceCatalog) WRITE  -> priceCatalog WRITE
    UNION ALL SELECT 'priceCatalogPosition', 'D', 19, 'W'                             --Preiskataloge (priceCatalog) WRITE  -> priceCatalogPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 19, 'W'                  --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 19, 'W'                  --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 19, 'W'                          --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 19, 'W'                  --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'usageType', 'R', 19, 'W'                                        --Preiskataloge (priceCatalog) WRITE  -> usageType READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 19, 'W'                          --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculation', 'D', 19, 'W'                          --Preiskataloge (priceCatalog) WRITE  -> priceCatalogCalculation DELETE
    UNION ALL SELECT 'plant', 'R', 19, 'W'                                            --Preiskataloge (priceCatalog) WRITE  -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 19, 'W'                                     --Preiskataloge (priceCatalog) WRITE  -> priceCatalog READ
    UNION ALL SELECT 'parameter', 'R', 19, 'W'                                        --Preiskataloge (priceCatalog) WRITE  -> parameter READ
    UNION ALL SELECT 'mapSupplierPlant', 'W', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> mapSupplierPlant WRITE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 19, 'W'                            --Preiskataloge (priceCatalog) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'priceCatalog', 'D', 19, 'W'                                     --Preiskataloge (priceCatalog) WRITE  -> priceCatalog DELETE
    UNION ALL SELECT 'mapSupplierPlant', 'D', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> mapSupplierPlant DELETE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 19, 'W'                              --Preiskataloge (priceCatalog) WRITE  -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 19, 'W'                             --Preiskataloge (priceCatalog) WRITE  -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 19, 'W'              --Preiskataloge (priceCatalog) WRITE  -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 19, 'W'               --Preiskataloge (priceCatalog) WRITE  -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 19, 'W'                               --Preiskataloge (priceCatalog) WRITE  -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'W', 19, 'W'                  --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogAttachedDocument WRITE
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 19, 'W'                      --Preiskataloge (priceCatalog) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 19, 'W'                 --Preiskataloge (priceCatalog) WRITE  -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'W', 19, 'W'                            --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogClient WRITE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 19, 'W'                  --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'D', 19, 'W'                  --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogAttachedDocument DELETE
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 19, 'W'                   --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'D', 19, 'W'                   --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogAdditionalShift DELETE
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'W', 19, 'W'                   --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogAdditionalShift WRITE
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 19, 'W'                            --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'D', 19, 'W'                            --Preiskataloge (priceCatalog) WRITE  -> mapPriceCatalogClient DELETE
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 19, 'W'                             --Preiskataloge (priceCatalog) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 19, 'W'                                   --Preiskataloge (priceCatalog) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 19, 'W'                  --Preiskataloge (priceCatalog) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 19, 'W'                        --Preiskataloge (priceCatalog) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'language', 'R', 19, 'W'                                         --Preiskataloge (priceCatalog) WRITE  -> language READ
    UNION ALL SELECT 'mainCode', 'R', 19, 'W'                                         --Preiskataloge (priceCatalog) WRITE  -> mainCode READ
    UNION ALL SELECT 'company', 'R', 19, 'W'                                          --Preiskataloge (priceCatalog) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 19, 'W'                                       --Preiskataloge (priceCatalog) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 19, 'W'                                           --Preiskataloge (priceCatalog) WRITE  -> client READ
    UNION ALL SELECT 'attachedDocument', 'W', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> attachedDocument WRITE
    UNION ALL SELECT 'attachedDocument', 'R', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> attachedDocument READ
    UNION ALL SELECT 'attachedDocument', 'D', 19, 'W'                                 --Preiskataloge (priceCatalog) WRITE  -> attachedDocument DELETE
    UNION ALL SELECT 'additionalShift', 'R', 19, 'W'                                  --Preiskataloge (priceCatalog) WRITE  -> additionalShift READ
    UNION ALL SELECT 'additionalShift', 'R', 19, 'D'                                  --Preiskataloge (priceCatalog) DELETE -> additionalShift READ
    UNION ALL SELECT 'attachedDocument', 'D', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> attachedDocument DELETE
    UNION ALL SELECT 'attachedDocument', 'W', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> attachedDocument WRITE
    UNION ALL SELECT 'attachedDocument', 'R', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> attachedDocument READ
    UNION ALL SELECT 'client', 'R', 19, 'D'                                           --Preiskataloge (priceCatalog) DELETE -> client READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 19, 'D'                  --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'clientPermission', 'R', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 19, 'D'                                       --Preiskataloge (priceCatalog) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 19, 'D'                                          --Preiskataloge (priceCatalog) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 19, 'D'                                         --Preiskataloge (priceCatalog) DELETE -> language READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 19, 'D'                        --Preiskataloge (priceCatalog) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 19, 'D'                                         --Preiskataloge (priceCatalog) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientCompany', 'R', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 19, 'D'                  --Preiskataloge (priceCatalog) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 19, 'D'                                   --Preiskataloge (priceCatalog) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 19, 'D'                             --Preiskataloge (priceCatalog) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'D', 19, 'D'                   --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogAdditionalShift DELETE
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 19, 'D'                   --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'W', 19, 'D'                            --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogClient WRITE
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 19, 'D'                            --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 19, 'D'                 --Preiskataloge (priceCatalog) DELETE -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'D', 19, 'D'                  --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogAttachedDocument DELETE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 19, 'D'                  --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'W', 19, 'D'                   --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogAdditionalShift WRITE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'W', 19, 'D'                  --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogAttachedDocument WRITE
    UNION ALL SELECT 'mapSupplierPlant', 'D', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> mapSupplierPlant DELETE
    UNION ALL SELECT 'mapSupplierPlant', 'R', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> mapSupplierPlant READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'D', 19, 'D'                            --Preiskataloge (priceCatalog) DELETE -> mapPriceCatalogClient DELETE
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 19, 'D'                      --Preiskataloge (priceCatalog) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 19, 'D'               --Preiskataloge (priceCatalog) DELETE -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 19, 'D'              --Preiskataloge (priceCatalog) DELETE -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 19, 'D'                               --Preiskataloge (priceCatalog) DELETE -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 19, 'D'                              --Preiskataloge (priceCatalog) DELETE -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSupplierPlant', 'W', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> mapSupplierPlant WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 19, 'D'                             --Preiskataloge (priceCatalog) DELETE -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 19, 'D'                            --Preiskataloge (priceCatalog) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'priceCatalog', 'R', 19, 'D'                                     --Preiskataloge (priceCatalog) DELETE -> priceCatalog READ
    UNION ALL SELECT 'parameter', 'R', 19, 'D'                                        --Preiskataloge (priceCatalog) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 19, 'D'                                            --Preiskataloge (priceCatalog) DELETE -> plant READ
    UNION ALL SELECT 'priceCatalog', 'D', 19, 'D'                                     --Preiskataloge (priceCatalog) DELETE -> priceCatalog DELETE
    UNION ALL SELECT 'priceCatalog', 'W', 19, 'D'                                     --Preiskataloge (priceCatalog) DELETE -> priceCatalog WRITE
    UNION ALL SELECT 'priceCatalogCalculation', 'D', 19, 'D'                          --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculation DELETE
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 19, 'D'                          --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 19, 'D'                          --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 19, 'D'                  --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 19, 'D'                  --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'D', 19, 'D'                    --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculationStatus DELETE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 19, 'D'                  --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'priceCatalogPosition', 'D', 19, 'D'                             --Preiskataloge (priceCatalog) DELETE -> priceCatalogPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 19, 'D'                    --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'W', 19, 'D'                    --Preiskataloge (priceCatalog) DELETE -> priceCatalogCalculationStatus WRITE
    UNION ALL SELECT 'serviceType', 'R', 19, 'D'                                      --Preiskataloge (priceCatalog) DELETE -> serviceType READ
    UNION ALL SELECT 'site', 'R', 19, 'D'                                             --Preiskataloge (priceCatalog) DELETE -> site READ
    UNION ALL SELECT 'siteCatalogPosition', 'R', 19, 'D'                              --Preiskataloge (priceCatalog) DELETE -> siteCatalogPosition READ
    UNION ALL SELECT 'siteCatalog', 'R', 19, 'D'                                      --Preiskataloge (priceCatalog) DELETE -> siteCatalog READ
    UNION ALL SELECT 'standardDiscount', 'R', 19, 'D'                                 --Preiskataloge (priceCatalog) DELETE -> standardDiscount READ
    UNION ALL SELECT 'supplier', 'R', 19, 'D'                                         --Preiskataloge (priceCatalog) DELETE -> supplier READ
    UNION ALL SELECT 'turnus', 'R', 19, 'D'                                           --Preiskataloge (priceCatalog) DELETE -> turnus READ
    UNION ALL SELECT 'unit', 'R', 19, 'D'                                             --Preiskataloge (priceCatalog) DELETE -> unit READ
    UNION ALL SELECT 'priceCatalogPosition', 'W', 19, 'D'                             --Preiskataloge (priceCatalog) DELETE -> priceCatalogPosition WRITE
    UNION ALL SELECT 'priceCatalogPosition', 'R', 19, 'D'                             --Preiskataloge (priceCatalog) DELETE -> priceCatalogPosition READ
    UNION ALL SELECT 'serviceObject', 'R', 19, 'D'                                    --Preiskataloge (priceCatalog) DELETE -> serviceObject READ
    UNION ALL SELECT 'serviceCatalog', 'R', 19, 'D'                                   --Preiskataloge (priceCatalog) DELETE -> serviceCatalog READ
    UNION ALL SELECT 'serviceCategory', 'R', 19, 'D'                                  --Preiskataloge (priceCatalog) DELETE -> serviceCategory READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 19, 'D'                               --Preiskataloge (priceCatalog) DELETE -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 19, 'D'                                --Preiskataloge (priceCatalog) DELETE -> serviceObjectType READ
    UNION ALL SELECT 'servicePosition', 'R', 19, 'D'                                  --Preiskataloge (priceCatalog) DELETE -> servicePosition READ
    UNION ALL SELECT 'wageCluster', 'R', 19, 'D'                                      --Preiskataloge (priceCatalog) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 19, 'D'                                        --Preiskataloge (priceCatalog) DELETE -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 19, 'D'                                        --Preiskataloge (priceCatalog) DELETE -> usageType READ
    UNION ALL SELECT 'supplier', 'R', 20, 'R'                                         --Ausschreibung (priceCatalogCalculation) READ   -> supplier READ
    UNION ALL SELECT 'plant', 'R', 20, 'R'                                            --Ausschreibung (priceCatalogCalculation) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 20, 'R'                                        --Ausschreibung (priceCatalogCalculation) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 20, 'R'                            --Ausschreibung (priceCatalogCalculation) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 20, 'R'                      --Ausschreibung (priceCatalogCalculation) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 20, 'R'                             --Ausschreibung (priceCatalogCalculation) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 20, 'R'                                   --Ausschreibung (priceCatalogCalculation) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 20, 'R'                  --Ausschreibung (priceCatalogCalculation) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 20, 'R'                                 --Ausschreibung (priceCatalogCalculation) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 20, 'R'                        --Ausschreibung (priceCatalogCalculation) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 20, 'R'                                         --Ausschreibung (priceCatalogCalculation) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 20, 'R'                                         --Ausschreibung (priceCatalogCalculation) READ   -> language READ
    UNION ALL SELECT 'company', 'R', 20, 'R'                                          --Ausschreibung (priceCatalogCalculation) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 20, 'R'                                       --Ausschreibung (priceCatalogCalculation) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 20, 'R'                                 --Ausschreibung (priceCatalogCalculation) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 20, 'R'                                           --Ausschreibung (priceCatalogCalculation) READ   -> client READ
    UNION ALL SELECT 'clientRole', 'R', 20, 'W'                                       --Ausschreibung (priceCatalogCalculation) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 20, 'W'                                 --Ausschreibung (priceCatalogCalculation) WRITE  -> clientPermission READ
    UNION ALL SELECT 'language', 'R', 20, 'W'                                         --Ausschreibung (priceCatalogCalculation) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 20, 'W'                                          --Ausschreibung (priceCatalogCalculation) WRITE  -> company READ
    UNION ALL SELECT 'client', 'R', 20, 'W'                                           --Ausschreibung (priceCatalogCalculation) WRITE  -> client READ
    UNION ALL SELECT 'mainCode', 'R', 20, 'W'                                         --Ausschreibung (priceCatalogCalculation) WRITE  -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 20, 'W'                        --Ausschreibung (priceCatalogCalculation) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 20, 'W'                  --Ausschreibung (priceCatalogCalculation) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 20, 'W'                                 --Ausschreibung (priceCatalogCalculation) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 20, 'W'                             --Ausschreibung (priceCatalogCalculation) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 20, 'W'                                   --Ausschreibung (priceCatalogCalculation) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 20, 'W'                            --Ausschreibung (priceCatalogCalculation) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 20, 'W'                      --Ausschreibung (priceCatalogCalculation) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'parameter', 'R', 20, 'W'                                        --Ausschreibung (priceCatalogCalculation) WRITE  -> parameter READ
    UNION ALL SELECT 'supplier', 'R', 20, 'W'                                         --Ausschreibung (priceCatalogCalculation) WRITE  -> supplier READ
    UNION ALL SELECT 'plant', 'R', 20, 'W'                                            --Ausschreibung (priceCatalogCalculation) WRITE  -> plant READ
    UNION ALL SELECT 'supplier', 'R', 20, 'D'                                         --Ausschreibung (priceCatalogCalculation) DELETE -> supplier READ
    UNION ALL SELECT 'plant', 'R', 20, 'D'                                            --Ausschreibung (priceCatalogCalculation) DELETE -> plant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 20, 'D'                            --Ausschreibung (priceCatalogCalculation) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 20, 'D'                                        --Ausschreibung (priceCatalogCalculation) DELETE -> parameter READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 20, 'D'                      --Ausschreibung (priceCatalogCalculation) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 20, 'D'                             --Ausschreibung (priceCatalogCalculation) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientCompany', 'R', 20, 'D'                                 --Ausschreibung (priceCatalogCalculation) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 20, 'D'                  --Ausschreibung (priceCatalogCalculation) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 20, 'D'                                   --Ausschreibung (priceCatalogCalculation) DELETE -> mapClientPlant READ
	UNION ALL SELECT 'mapClientClientPermission', 'R', 20, 'D'                        --Ausschreibung (priceCatalogCalculation) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'company', 'R', 20, 'D'                                          --Ausschreibung (priceCatalogCalculation) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 20, 'D'                                         --Ausschreibung (priceCatalogCalculation) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 20, 'D'                                         --Ausschreibung (priceCatalogCalculation) DELETE -> mainCode READ
    UNION ALL SELECT 'clientRole', 'R', 20, 'D'                                       --Ausschreibung (priceCatalogCalculation) DELETE -> clientRole READ
    UNION ALL SELECT 'client', 'R', 20, 'D'                                           --Ausschreibung (priceCatalogCalculation) DELETE -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 20, 'D'                                 --Ausschreibung (priceCatalogCalculation) DELETE -> clientPermission READ
    UNION ALL SELECT 'calendar', 'R', 21, 'R'                                         --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> calendar READ
    UNION ALL SELECT 'client', 'R', 21, 'R'                                           --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 21, 'R'                                 --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> clientPermission READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 21, 'R'                  --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 21, 'R'                          --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'attachedDocument', 'R', 21, 'R'                                 --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> attachedDocument READ
    UNION ALL SELECT 'additionalShift', 'R', 21, 'R'                                  --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> additionalShift READ
    UNION ALL SELECT 'area', 'R', 21, 'R'                                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> area READ
    UNION ALL SELECT 'clientRole', 'R', 21, 'R'                                       --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 21, 'R'                                          --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> company READ
    UNION ALL SELECT 'ffg', 'R', 21, 'R'                                              --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> ffg READ
    UNION ALL SELECT 'dayType', 'R', 21, 'R'                                          --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> dayType READ
    UNION ALL SELECT 'costCenter', 'R', 21, 'R'                                       --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> costCenter READ
    UNION ALL SELECT 'currency', 'R', 21, 'R'                                         --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> currency READ
    UNION ALL SELECT 'cycle', 'R', 21, 'R'                                            --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'R', 21, 'R'                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> customCleaningObject READ
    UNION ALL SELECT 'language', 'R', 21, 'R'                                         --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> language READ
    UNION ALL SELECT 'lvAlloc', 'R', 21, 'R'                                          --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> lvAlloc READ
    UNION ALL SELECT 'location', 'R', 21, 'R'                                         --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> location READ
    UNION ALL SELECT 'flooring', 'R', 21, 'R'                                         --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> flooring READ
    UNION ALL SELECT 'mainCode', 'R', 21, 'R'                                         --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mainCode READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 21, 'R'                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 21, 'R'                        --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 21, 'R'                                 --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 21, 'R'                  --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 21, 'R'                                   --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 21, 'R'                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 21, 'R'                   --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 21, 'R'                  --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 21, 'R'                            --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 21, 'R'                 --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 21, 'R'                      --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 21, 'R'             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 21, 'R'                            --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 21, 'R'                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 21, 'R'                  --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 21, 'R'                              --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 21, 'R'               --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 21, 'R'              --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 21, 'R'                               --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 21, 'R'                                 --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapSupplierPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 21, 'R'                            --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'orgUnit', 'R', 21, 'R'                                          --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> orgUnit READ
    UNION ALL SELECT 'parameter', 'R', 21, 'R'                                        --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 21, 'R'                                            --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 21, 'R'                                     --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> priceCatalog READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 21, 'R'                    --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 21, 'R'                  --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 21, 'R'                          --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'supplier', 'R', 21, 'R'                                         --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> supplier READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 21, 'R'                          --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> technicalCleaningObject READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 21, 'R'                      --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> technicalCleaningObjectType READ
    UNION ALL SELECT 'unit', 'R', 21, 'R'                                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> unit READ
    UNION ALL SELECT 'turnus', 'R', 21, 'R'                                           --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> turnus READ
    UNION ALL SELECT 'standardDiscount', 'R', 21, 'R'                                 --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> standardDiscount READ
    UNION ALL SELECT 'settlementType', 'R', 21, 'R'                                   --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> settlementType READ
    UNION ALL SELECT 'site', 'R', 21, 'R'                                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> site READ
    UNION ALL SELECT 'serviceType', 'R', 21, 'R'                                      --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'R', 21, 'R'                                  --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> servicePosition READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 21, 'R'                               --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 21, 'R'                       --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 21, 'R'                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceObjectType', 'R', 21, 'R'                                --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrder', 'R', 21, 'R'                                     --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 21, 'R'                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceOrderCalendar READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 21, 'R'                               --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 21, 'R'                             --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> priceCatalogPosition READ
    UNION ALL SELECT 'sapOrder', 'R', 21, 'R'                                         --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> sapOrder READ
    UNION ALL SELECT 'serviceCatalog', 'R', 21, 'R'                                   --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 21, 'R'                                    --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceObject READ
    UNION ALL SELECT 'serviceCategory', 'R', 21, 'R'                                  --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> serviceCategory READ
    UNION ALL SELECT 'usageType', 'R', 21, 'R'                                        --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 21, 'R'                                      --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 21, 'R'                                        --Leistungsabruf (Regelleistung) (serviceOrder) READ   -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 21, 'W'                                        --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> usageType READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalogPosition READ
    UNION ALL SELECT 'wageCluster', 'R', 21, 'W'                                      --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 21, 'W'                                        --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> wageGroup READ
    UNION ALL SELECT 'serviceCategory', 'R', 21, 'W'                                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceCategory READ
    UNION ALL SELECT 'serviceCatalog', 'R', 21, 'W'                                   --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceCatalog READ
    UNION ALL SELECT 'sapOrder', 'D', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> sapOrder DELETE
    UNION ALL SELECT 'sapOrder', 'W', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> sapOrder WRITE
    UNION ALL SELECT 'sapOrder', 'R', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> sapOrder READ
    UNION ALL SELECT 'servicePosition', 'R', 21, 'W'                                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> servicePosition READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 21, 'W'                               --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 21, 'W'                    --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 21, 'W'                       --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceObject', 'R', 21, 'W'                                    --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceObject READ
    UNION ALL SELECT 'serviceOrder', 'W', 21, 'W'                                     --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrder WRITE
    UNION ALL SELECT 'serviceOrder', 'R', 21, 'W'                                     --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrder READ
    UNION ALL SELECT 'serviceOrder', 'D', 21, 'W'                                     --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrderCalendar DELETE
    UNION ALL SELECT 'serviceOrderCalendar', 'W', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrderCalendar WRITE
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceOrderCalendar', 'D', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrder DELETE
    UNION ALL SELECT 'serviceObjectType', 'R', 21, 'W'                                --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderPosition', 'D', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrderPosition DELETE
    UNION ALL SELECT 'serviceOrderStatus', 'R', 21, 'W'                               --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceOrderPosition', 'W', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceOrderPosition WRITE
	UNION ALL SELECT 'customCleaningObject', 'W', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> customCleaningObject WRITE
    UNION ALL SELECT 'site', 'R', 21, 'W'                                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> site READ
    UNION ALL SELECT 'settlementType', 'R', 21, 'W'                                   --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> settlementType READ
    UNION ALL SELECT 'serviceType', 'R', 21, 'W'                                      --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> serviceType READ
    UNION ALL SELECT 'standardDiscount', 'R', 21, 'W'                                 --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> standardDiscount READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 21, 'W'                      --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> technicalCleaningObjectType READ
    UNION ALL SELECT 'turnus', 'R', 21, 'W'                                           --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> turnus READ
    UNION ALL SELECT 'unit', 'R', 21, 'W'                                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> unit READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 21, 'W'                          --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> technicalCleaningObject READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 21, 'W'                          --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'supplier', 'R', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> supplier READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 21, 'W'                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 21, 'W'                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'orgUnit', 'R', 21, 'W'                                          --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> orgUnit READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 21, 'W'                    --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'plant', 'R', 21, 'W'                                            --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 21, 'W'                                     --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalog READ
    UNION ALL SELECT 'parameter', 'R', 21, 'W'                                        --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 21, 'W'                            --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 21, 'W'                               --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 21, 'W'                                 --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 21, 'W'              --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 21, 'W'               --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 21, 'W'                              --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'W', 21, 'W'             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderPositionServiceObject WRITE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'D', 21, 'W'             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderPositionServiceObject DELETE
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 21, 'W'                            --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderClient', 'D', 21, 'W'                            --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderClient DELETE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 21, 'W'                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 21, 'W'                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 21, 'W'             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 21, 'W'                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 21, 'W'                      --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 21, 'W'                 --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServiceOrderClient', 'W', 21, 'W'                            --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapServiceOrderClient WRITE
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 21, 'W'                   --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 21, 'W'                            --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 21, 'W'                                   --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 21, 'W'                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 21, 'W'                                 --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 21, 'W'                        --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mapCalendarPlantSite READ
    UNION ALL SELECT 'lvAlloc', 'R', 21, 'W'                                          --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> lvAlloc READ
    UNION ALL SELECT 'mainCode', 'R', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> mainCode READ
    UNION ALL SELECT 'flooring', 'R', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> flooring READ
    UNION ALL SELECT 'dayType', 'R', 21, 'W'                                          --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> dayType READ
    UNION ALL SELECT 'location', 'R', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> location READ
    UNION ALL SELECT 'language', 'R', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> language READ
    UNION ALL SELECT 'customCleaningObject', 'D', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> customCleaningObject DELETE
    UNION ALL SELECT 'cycle', 'R', 21, 'W'                                            --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> cycle READ
    UNION ALL SELECT 'costCenter', 'R', 21, 'W'                                       --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> costCenter READ
    UNION ALL SELECT 'currency', 'R', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> currency READ
    UNION ALL SELECT 'area', 'R', 21, 'W'                                             --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> area READ
    UNION ALL SELECT 'ffg', 'R', 21, 'W'                                              --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> ffg READ
    UNION ALL SELECT 'company', 'R', 21, 'W'                                          --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 21, 'W'                                       --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 21, 'W'                                 --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> clientPermission READ
    UNION ALL SELECT 'additionalShift', 'R', 21, 'W'                                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> additionalShift READ
    UNION ALL SELECT 'attachedDocument', 'D', 21, 'W'                                 --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> attachedDocument DELETE
    UNION ALL SELECT 'attachedDocument', 'W', 21, 'W'                                 --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> attachedDocument WRITE
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 21, 'W'                          --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'attachedDocument', 'R', 21, 'W'                                 --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> attachedDocument READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 21, 'W'                  --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'client', 'R', 21, 'W'                                           --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> client READ
    UNION ALL SELECT 'calendar', 'R', 21, 'W'                                         --Leistungsabruf (Regelleistung) (serviceOrder) WRITE  -> calendar READ
    UNION ALL SELECT 'calendar', 'R', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> calendar READ
    UNION ALL SELECT 'clientPermission', 'R', 21, 'D'                                 --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> clientPermission READ
    UNION ALL SELECT 'attachedDocument', 'W', 21, 'D'                                 --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> attachedDocument WRITE
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 21, 'D'                          --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 21, 'D'                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'client', 'R', 21, 'D'                                           --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> client READ
    UNION ALL SELECT 'attachedDocument', 'D', 21, 'D'                                 --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> attachedDocument DELETE
    UNION ALL SELECT 'area', 'R', 21, 'D'                                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> area READ
    UNION ALL SELECT 'additionalShift', 'R', 21, 'D'                                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> additionalShift READ
    UNION ALL SELECT 'attachedDocument', 'R', 21, 'D'                                 --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> attachedDocument READ
    UNION ALL SELECT 'clientRole', 'R', 21, 'D'                                       --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 21, 'D'                                          --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> company READ
    UNION ALL SELECT 'costCenter', 'R', 21, 'D'                                       --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> costCenter READ
    UNION ALL SELECT 'language', 'R', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> language READ
    UNION ALL SELECT 'flooring', 'R', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> flooring READ
    UNION ALL SELECT 'ffg', 'R', 21, 'D'                                              --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> ffg READ
    UNION ALL SELECT 'dayType', 'R', 21, 'D'                                          --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> dayType READ
    UNION ALL SELECT 'currency', 'R', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> currency READ
    UNION ALL SELECT 'cycle', 'R', 21, 'D'                                            --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'D', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> customCleaningObject DELETE
    UNION ALL SELECT 'lvAlloc', 'R', 21, 'D'                                          --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> lvAlloc READ
    UNION ALL SELECT 'mainCode', 'R', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mainCode READ
    UNION ALL SELECT 'location', 'R', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> location READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 21, 'D'                        --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapClientCompany', 'R', 21, 'D'                                 --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 21, 'D'                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 21, 'D'                                   --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 21, 'D'                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 21, 'D'                   --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 21, 'D'                            --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'D', 21, 'D'             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderPositionServiceObject DELETE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 21, 'D'             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 21, 'D'                 --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 21, 'D'                      --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 21, 'D'                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 21, 'D'                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 21, 'D'                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 21, 'D'                            --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderClient', 'W', 21, 'D'                            --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderClient WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'W', 21, 'D'             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderPositionServiceObject WRITE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 21, 'D'                              --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 21, 'D'               --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapServiceOrderClient', 'D', 21, 'D'                            --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapServiceOrderClient DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 21, 'D'              --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 21, 'D'                               --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 21, 'D'                                 --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapSupplierPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 21, 'D'                            --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'orgUnit', 'R', 21, 'D'                                          --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> orgUnit READ
    UNION ALL SELECT 'parameter', 'R', 21, 'D'                                        --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 21, 'D'                                            --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 21, 'D'                                     --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalog READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 21, 'D'                    --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'supplier', 'R', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> supplier READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 21, 'D'                          --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> technicalCleaningObject READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 21, 'D'                          --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 21, 'D'                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 21, 'D'                      --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> technicalCleaningObjectType READ
    UNION ALL SELECT 'unit', 'R', 21, 'D'                                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> unit READ
    UNION ALL SELECT 'turnus', 'R', 21, 'D'                                           --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> turnus READ
    UNION ALL SELECT 'standardDiscount', 'R', 21, 'D'                                 --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> standardDiscount READ
    UNION ALL SELECT 'settlementType', 'R', 21, 'D'                                   --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> settlementType READ
    UNION ALL SELECT 'site', 'R', 21, 'D'                                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> site READ
    UNION ALL SELECT 'serviceType', 'R', 21, 'D'                                      --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceType READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 21, 'D'                               --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrderStatus READ
    UNION ALL SELECT 'servicePosition', 'R', 21, 'D'                                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> servicePosition READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 21, 'D'                       --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderPosition', 'W', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrderPosition WRITE
	UNION ALL SELECT 'customCleaningObject', 'W', 21, 'W'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> customCleaningObject WRITE
    UNION ALL SELECT 'serviceOrder', 'D', 21, 'D'                                     --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrder DELETE
    UNION ALL SELECT 'serviceOrder', 'R', 21, 'D'                                     --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrder READ
    UNION ALL SELECT 'serviceOrder', 'W', 21, 'D'                                     --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrder WRITE
    UNION ALL SELECT 'serviceOrderCalendar', 'D', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrderCalendar DELETE
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceOrderCalendar', 'W', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrderCalendar WRITE
    UNION ALL SELECT 'serviceOrderPosition', 'D', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceOrderPosition DELETE
    UNION ALL SELECT 'serviceObjectType', 'R', 21, 'D'                                --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceObjectType READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 21, 'D'                               --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 21, 'D'                    --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalogStatus READ
    UNION ALL SELECT 'sapOrder', 'W', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> sapOrder WRITE
    UNION ALL SELECT 'sapOrder', 'D', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> sapOrder DELETE
    UNION ALL SELECT 'sapOrder', 'R', 21, 'D'                                         --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> sapOrder READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 21, 'D'                             --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> priceCatalogPosition READ
    UNION ALL SELECT 'serviceCatalog', 'R', 21, 'D'                                   --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 21, 'D'                                    --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceObject READ
    UNION ALL SELECT 'serviceCategory', 'R', 21, 'D'                                  --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> serviceCategory READ
    UNION ALL SELECT 'usageType', 'R', 21, 'D'                                        --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 21, 'D'                                      --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 21, 'D'                                        --Leistungsabruf (Regelleistung) (serviceOrder) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageCluster', 'R', 22, 'R'                                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 22, 'R'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 22, 'R'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> usageType READ
    UNION ALL SELECT 'serviceCategory', 'R', 22, 'R'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceCategory READ
    UNION ALL SELECT 'serviceObject', 'R', 22, 'R'                                    --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceObject READ
    UNION ALL SELECT 'serviceCatalog', 'R', 22, 'R'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceCatalog READ
    UNION ALL SELECT 'sapOrder', 'R', 22, 'R'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> sapOrder READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 22, 'R'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> priceCatalogPosition READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 22, 'R'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceOrder', 'R', 22, 'R'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 22, 'R'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceObjectType', 'R', 22, 'R'                                --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 22, 'R'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 22, 'R'                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 22, 'R'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceOrderStatus READ
    UNION ALL SELECT 'servicePosition', 'R', 22, 'R'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> servicePosition READ
    UNION ALL SELECT 'serviceType', 'R', 22, 'R'                                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> serviceType READ
    UNION ALL SELECT 'settlementType', 'R', 22, 'R'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> settlementType READ
    UNION ALL SELECT 'site', 'R', 22, 'R'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> site READ
    UNION ALL SELECT 'standardDiscount', 'R', 22, 'R'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> standardDiscount READ
    UNION ALL SELECT 'turnus', 'R', 22, 'R'                                           --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> turnus READ
    UNION ALL SELECT 'unit', 'R', 22, 'R'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> unit READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 22, 'R'                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> technicalCleaningObjectType READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 22, 'R'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> technicalCleaningObject READ
    UNION ALL SELECT 'supplier', 'R', 22, 'R'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> supplier READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 22, 'R'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 22, 'R'                    --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 22, 'R'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalog', 'R', 22, 'R'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> priceCatalog READ
    UNION ALL SELECT 'plant', 'R', 22, 'R'                                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 22, 'R'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> parameter READ
    UNION ALL SELECT 'orgUnit', 'R', 22, 'R'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> orgUnit READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 22, 'R'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 22, 'R'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 22, 'R'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 22, 'R'              --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 22, 'R'               --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 22, 'R'                              --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 22, 'R'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 22, 'R'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 22, 'R'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 22, 'R'                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 22, 'R'             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 22, 'R'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 22, 'R'                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 22, 'R'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 22, 'R'                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 22, 'R'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 22, 'R'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 22, 'R'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 22, 'R'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 22, 'R'                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 22, 'R'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mainCode', 'R', 22, 'R'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> mainCode READ
    UNION ALL SELECT 'flooring', 'R', 22, 'R'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> flooring READ
    UNION ALL SELECT 'location', 'R', 22, 'R'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> location READ
    UNION ALL SELECT 'lvAlloc', 'R', 22, 'R'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> lvAlloc READ
    UNION ALL SELECT 'language', 'R', 22, 'R'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> language READ
    UNION ALL SELECT 'customCleaningObject', 'R', 22, 'R'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> customCleaningObject READ
    UNION ALL SELECT 'cycle', 'R', 22, 'R'                                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> cycle READ
    UNION ALL SELECT 'currency', 'R', 22, 'R'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> currency READ
    UNION ALL SELECT 'costCenter', 'R', 22, 'R'                                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> costCenter READ
    UNION ALL SELECT 'dayType', 'R', 22, 'R'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> dayType READ
    UNION ALL SELECT 'ffg', 'R', 22, 'R'                                              --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> ffg READ
    UNION ALL SELECT 'company', 'R', 22, 'R'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 22, 'R'                                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> clientRole READ
    UNION ALL SELECT 'area', 'R', 22, 'R'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> area READ
    UNION ALL SELECT 'additionalShift', 'R', 22, 'R'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> additionalShift READ
    UNION ALL SELECT 'attachedDocument', 'R', 22, 'R'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> attachedDocument READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 22, 'R'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 22, 'R'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'clientPermission', 'R', 22, 'R'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 22, 'R'                                           --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> client READ
    UNION ALL SELECT 'calendar', 'R', 22, 'R'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) READ   -> calendar READ
    UNION ALL SELECT 'calendar', 'R', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> calendar READ
    UNION ALL SELECT 'clientPermission', 'R', 22, 'W'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 22, 'W'                                           --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> client READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 22, 'W'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 22, 'W'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'attachedDocument', 'W', 22, 'W'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> attachedDocument WRITE
    UNION ALL SELECT 'attachedDocument', 'R', 22, 'W'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> attachedDocument READ
    UNION ALL SELECT 'attachedDocument', 'D', 22, 'W'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> attachedDocument DELETE
    UNION ALL SELECT 'additionalShift', 'R', 22, 'W'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> additionalShift READ
    UNION ALL SELECT 'area', 'R', 22, 'W'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> area READ
    UNION ALL SELECT 'company', 'R', 22, 'W'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 22, 'W'                                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> clientRole READ
    UNION ALL SELECT 'ffg', 'R', 22, 'W'                                              --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> ffg READ
    UNION ALL SELECT 'dayType', 'R', 22, 'W'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> dayType READ
    UNION ALL SELECT 'currency', 'R', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> currency READ
    UNION ALL SELECT 'costCenter', 'R', 22, 'W'                                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> costCenter READ
    UNION ALL SELECT 'cycle', 'R', 22, 'W'                                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'D', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> customCleaningObject DELETE
    UNION ALL SELECT 'language', 'R', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> language READ
    UNION ALL SELECT 'location', 'R', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> location READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 22, 'W'                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'flooring', 'R', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> flooring READ
    UNION ALL SELECT 'mainCode', 'R', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mainCode READ
    UNION ALL SELECT 'lvAlloc', 'R', 22, 'W'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> lvAlloc READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 22, 'W'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 22, 'W'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 22, 'W'                              --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 22, 'W'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 22, 'W'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 22, 'W'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 22, 'W'                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapServiceOrderClient', 'W', 22, 'W'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderClient WRITE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 22, 'W'             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 22, 'W'                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 22, 'W'                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 22, 'W'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 22, 'W'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 22, 'W'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapServiceOrderClient', 'D', 22, 'W'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderClient DELETE
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 22, 'W'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'D', 22, 'W'             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderPositionServiceObject DELETE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'W', 22, 'W'             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapServiceOrderPositionServiceObject WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 22, 'W'              --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 22, 'W'               --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 22, 'W'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 22, 'W'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 22, 'W'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 22, 'W'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> technicalCleaningObject READ
    UNION ALL SELECT 'parameter', 'R', 22, 'W'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> parameter READ
    UNION ALL SELECT 'priceCatalog', 'R', 22, 'W'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalog READ
    UNION ALL SELECT 'plant', 'R', 22, 'W'                                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> plant READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 22, 'W'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 22, 'W'                    --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'orgUnit', 'R', 22, 'W'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> orgUnit READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 22, 'W'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'supplier', 'R', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> supplier READ
    UNION ALL SELECT 'unit', 'R', 22, 'W'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> unit READ
    UNION ALL SELECT 'standardDiscount', 'R', 22, 'W'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> standardDiscount READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 22, 'W'                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> technicalCleaningObjectType READ
    UNION ALL SELECT 'site', 'R', 22, 'W'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> site READ
    UNION ALL SELECT 'turnus', 'R', 22, 'W'                                           --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> turnus READ
    UNION ALL SELECT 'serviceType', 'R', 22, 'W'                                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceType READ
    UNION ALL SELECT 'settlementType', 'R', 22, 'W'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> settlementType READ
    UNION ALL SELECT 'servicePosition', 'R', 22, 'W'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> servicePosition READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 22, 'W'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceOrderPosition', 'D', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrderPosition DELETE
    UNION ALL SELECT 'serviceOrderPosition', 'R', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrderPosition READ
    UNION ALL SELECT 'usageType', 'R', 22, 'W'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> usageType READ
    UNION ALL SELECT 'serviceObjectType', 'R', 22, 'W'                                --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'serviceObject', 'R', 22, 'W'                                    --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceObject READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 22, 'W'                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderPosition', 'W', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrderPosition WRITE
	UNION ALL SELECT 'customCleaningObject', 'W', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> customCleaningObject WRITE
    UNION ALL SELECT 'serviceOrder', 'D', 22, 'W'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrder DELETE
    UNION ALL SELECT 'serviceOrder', 'R', 22, 'W'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrder READ
    UNION ALL SELECT 'serviceOrder', 'W', 22, 'W'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrder WRITE
    UNION ALL SELECT 'serviceOrderCalendar', 'D', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrderCalendar DELETE
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceOrderCalendar', 'W', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceOrderCalendar WRITE
    UNION ALL SELECT 'priceCatalogStatus', 'R', 22, 'W'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 22, 'W'                    --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> priceCatalogPosition READ
    UNION ALL SELECT 'sapOrder', 'R', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> sapOrder READ
    UNION ALL SELECT 'sapOrder', 'W', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> sapOrder WRITE
    UNION ALL SELECT 'sapOrder', 'D', 22, 'W'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> sapOrder DELETE
    UNION ALL SELECT 'serviceCatalog', 'R', 22, 'W'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceCatalog READ
    UNION ALL SELECT 'serviceCategory', 'R', 22, 'W'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> serviceCategory READ
    UNION ALL SELECT 'wageCluster', 'R', 22, 'W'                                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 22, 'W'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) WRITE  -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 22, 'D'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 22, 'D'                                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 22, 'D'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> wageGroup READ
    UNION ALL SELECT 'serviceCategory', 'R', 22, 'D'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceCategory READ
    UNION ALL SELECT 'serviceObject', 'R', 22, 'D'                                    --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceObject READ
    UNION ALL SELECT 'serviceCatalog', 'R', 22, 'D'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceCatalog READ
    UNION ALL SELECT 'sapOrder', 'D', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> sapOrder DELETE
    UNION ALL SELECT 'sapOrder', 'W', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> sapOrder WRITE
    UNION ALL SELECT 'sapOrder', 'R', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> sapOrder READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> priceCatalogPosition READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 22, 'D'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceOrder', 'W', 22, 'D'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrder WRITE
    UNION ALL SELECT 'serviceOrder', 'R', 22, 'D'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrder READ
    UNION ALL SELECT 'serviceOrder', 'D', 22, 'D'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrder DELETE
    UNION ALL SELECT 'serviceOrderCalendar', 'W', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrderCalendar WRITE
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceOrderCalendar', 'D', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrderCalendar DELETE
    UNION ALL SELECT 'serviceOrderPosition', 'D', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrderPosition DELETE
    UNION ALL SELECT 'serviceOrderPosition', 'W', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrderPosition WRITE
	UNION ALL SELECT 'customCleaningObject', 'W', 22, 'W'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> customCleaningObject WRITE
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 22, 'D'                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 22, 'D'                                --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 22, 'D'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceOrderStatus READ
    UNION ALL SELECT 'servicePosition', 'R', 22, 'D'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> servicePosition READ
    UNION ALL SELECT 'serviceType', 'R', 22, 'D'                                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> serviceType READ
    UNION ALL SELECT 'settlementType', 'R', 22, 'D'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> settlementType READ
    UNION ALL SELECT 'site', 'R', 22, 'D'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> site READ
    UNION ALL SELECT 'turnus', 'R', 22, 'D'                                           --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> turnus READ
    UNION ALL SELECT 'standardDiscount', 'R', 22, 'D'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> standardDiscount READ
    UNION ALL SELECT 'unit', 'R', 22, 'D'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> unit READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 22, 'D'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> technicalCleaningObject READ
    UNION ALL SELECT 'supplier', 'R', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> supplier READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 22, 'D'                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> technicalCleaningObjectType READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 22, 'D'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 22, 'D'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalog', 'R', 22, 'D'                                     --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> priceCatalog READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 22, 'D'                    --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'plant', 'R', 22, 'D'                                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> plant READ
    UNION ALL SELECT 'parameter', 'R', 22, 'D'                                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> parameter READ
    UNION ALL SELECT 'orgUnit', 'R', 22, 'D'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> orgUnit READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 22, 'D'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 22, 'D'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 22, 'D'               --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 22, 'D'              --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 22, 'D'                               --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 22, 'D'                              --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'W', 22, 'D'             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderPositionServiceObject WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderClient', 'W', 22, 'D'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderClient WRITE
    UNION ALL SELECT 'mapServiceOrderClient', 'D', 22, 'D'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderClient DELETE
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 22, 'D'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 22, 'D'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 22, 'D'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 22, 'D'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 22, 'D'                      --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 22, 'D'                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 22, 'D'             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'D', 22, 'D'             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapServiceOrderPositionServiceObject DELETE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 22, 'D'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 22, 'D'                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 22, 'D'                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 22, 'D'                                   --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 22, 'D'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 22, 'D'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 22, 'D'                        --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> mainCode READ
    UNION ALL SELECT 'location', 'R', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> location READ
    UNION ALL SELECT 'lvAlloc', 'R', 22, 'D'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> lvAlloc READ
    UNION ALL SELECT 'customCleaningObject', 'D', 22, 'D'                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> customCleaningObject DELETE
    UNION ALL SELECT 'cycle', 'R', 22, 'D'                                            --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> cycle READ
    UNION ALL SELECT 'ffg', 'R', 22, 'D'                                              --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> ffg READ
    UNION ALL SELECT 'currency', 'R', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> currency READ
    UNION ALL SELECT 'dayType', 'R', 22, 'D'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> dayType READ
    UNION ALL SELECT 'flooring', 'R', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> flooring READ
    UNION ALL SELECT 'language', 'R', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> language READ
    UNION ALL SELECT 'costCenter', 'R', 22, 'D'                                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> costCenter READ
    UNION ALL SELECT 'company', 'R', 22, 'D'                                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> company READ
    UNION ALL SELECT 'attachedDocument', 'D', 22, 'D'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> attachedDocument DELETE
    UNION ALL SELECT 'clientRole', 'R', 22, 'D'                                       --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> clientRole READ
    UNION ALL SELECT 'additionalShift', 'R', 22, 'D'                                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> additionalShift READ
    UNION ALL SELECT 'area', 'R', 22, 'D'                                             --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> area READ
    UNION ALL SELECT 'attachedDocument', 'W', 22, 'D'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> attachedDocument WRITE
    UNION ALL SELECT 'attachedDocument', 'R', 22, 'D'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> attachedDocument READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 22, 'D'                          --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 22, 'D'                  --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'clientPermission', 'R', 22, 'D'                                 --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> clientPermission READ
    UNION ALL SELECT 'calendar', 'R', 22, 'D'                                         --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> calendar READ
    UNION ALL SELECT 'client', 'R', 22, 'D'                                           --Leistungsabruf (AdHoc Leistung) (serviceOrder) DELETE -> client READ
    UNION ALL SELECT 'calendar', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> calendar READ
    UNION ALL SELECT 'client', 'R', 23, 'R'                                           --Leistungssteuerung () READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 23, 'R'                                 --Leistungssteuerung () READ   -> clientPermission READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 23, 'R'                  --Leistungssteuerung () READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'attachedDocument', 'R', 23, 'R'                                 --Leistungssteuerung () READ   -> attachedDocument READ
    UNION ALL SELECT 'area', 'R', 23, 'R'                                             --Leistungssteuerung () READ   -> area READ
    UNION ALL SELECT 'clientRole', 'R', 23, 'R'                                       --Leistungssteuerung () READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 23, 'R'                                          --Leistungssteuerung () READ   -> company READ
    UNION ALL SELECT 'ffg', 'R', 23, 'R'                                              --Leistungssteuerung () READ   -> ffg READ
    UNION ALL SELECT 'dayType', 'R', 23, 'R'                                          --Leistungssteuerung () READ   -> dayType READ
    UNION ALL SELECT 'costCenter', 'R', 23, 'R'                                       --Leistungssteuerung () READ   -> costCenter READ
    UNION ALL SELECT 'currency', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> currency READ
    UNION ALL SELECT 'cycle', 'R', 23, 'R'                                            --Leistungssteuerung () READ   -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'R', 23, 'R'                             --Leistungssteuerung () READ   -> customCleaningObject READ
    UNION ALL SELECT 'language', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> language READ
    UNION ALL SELECT 'lvAlloc', 'R', 23, 'R'                                          --Leistungssteuerung () READ   -> lvAlloc READ
    UNION ALL SELECT 'location', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> location READ
    UNION ALL SELECT 'flooring', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> flooring READ
    UNION ALL SELECT 'mainCode', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> mainCode READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 23, 'R'                             --Leistungssteuerung () READ   -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 23, 'R'                        --Leistungssteuerung () READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 23, 'R'                                 --Leistungssteuerung () READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 23, 'R'                  --Leistungssteuerung () READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 23, 'R'                                   --Leistungssteuerung () READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 23, 'R'                              --Leistungssteuerung () READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 23, 'R'                    --Leistungssteuerung () READ   -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 23, 'R'                   --Leistungssteuerung () READ   -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 23, 'R'                  --Leistungssteuerung () READ   -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 23, 'R'                             --Leistungssteuerung () READ   -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 23, 'R'              --Leistungssteuerung () READ   -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 23, 'R'                       --Leistungssteuerung () READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 23, 'R'                   --Leistungssteuerung () READ   -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 23, 'R'                             --Leistungssteuerung () READ   -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 23, 'R'                              --Leistungssteuerung () READ   -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 23, 'R'                               --Leistungssteuerung () READ   -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 23, 'R'                --Leistungssteuerung () READ   -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 23, 'R'               --Leistungssteuerung () READ   -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 23, 'R'                                --Leistungssteuerung () READ   -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 23, 'R'                                  --Leistungssteuerung () READ   -> mapSupplierPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 23, 'R'                             --Leistungssteuerung () READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'orgUnit', 'R', 23, 'R'                                           --Leistungssteuerung () READ   -> orgUnit READ
    UNION ALL SELECT 'parameter', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 23, 'R'                                             --Leistungssteuerung () READ   -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 23, 'R'                                      --Leistungssteuerung () READ   -> priceCatalog READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 23, 'R'                     --Leistungssteuerung () READ   -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 23, 'R'                   --Leistungssteuerung () READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 23, 'R'                           --Leistungssteuerung () READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'supplier', 'R', 23, 'R'                                          --Leistungssteuerung () READ   -> supplier READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 23, 'R'                           --Leistungssteuerung () READ   -> technicalCleaningObject READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 23, 'R'                       --Leistungssteuerung () READ   -> technicalCleaningObjectType READ
    UNION ALL SELECT 'unit', 'R', 23, 'R'                                              --Leistungssteuerung () READ   -> unit READ
    UNION ALL SELECT 'turnus', 'R', 23, 'R'                                            --Leistungssteuerung () READ   -> turnus READ
    UNION ALL SELECT 'settlementType', 'R', 23, 'R'                                    --Leistungssteuerung () READ   -> settlementType READ
    UNION ALL SELECT 'site', 'R', 23, 'R'                                              --Leistungssteuerung () READ   -> site READ
    UNION ALL SELECT 'serviceType', 'R', 23, 'R'                                       --Leistungssteuerung () READ   -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'R', 23, 'R'                                   --Leistungssteuerung () READ   -> servicePosition READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 23, 'R'                                --Leistungssteuerung () READ   -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 23, 'R'                        --Leistungssteuerung () READ   -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 23, 'R'                              --Leistungssteuerung () READ   -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceObjectType', 'R', 23, 'R'                                 --Leistungssteuerung () READ   -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrder', 'R', 23, 'R'                                      --Leistungssteuerung () READ   -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 23, 'R'                              --Leistungssteuerung () READ   -> serviceOrderCalendar READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 23, 'R'                                --Leistungssteuerung () READ   -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 23, 'R'                              --Leistungssteuerung () READ   -> priceCatalogPosition READ
    UNION ALL SELECT 'sapOrder', 'R', 23, 'R'                                          --Leistungssteuerung () READ   -> sapOrder READ
    UNION ALL SELECT 'serviceCatalog', 'R', 23, 'R'                                    --Leistungssteuerung () READ   -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 23, 'R'                                     --Leistungssteuerung () READ   -> serviceObject READ
    UNION ALL SELECT 'serviceCategory', 'R', 23, 'R'                                   --Leistungssteuerung () READ   -> serviceCategory READ
    UNION ALL SELECT 'usageType', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 23, 'R'                                       --Leistungssteuerung () READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 23, 'R'                                         --Leistungssteuerung () READ   -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 23, 'W'                                         --Leistungssteuerung () WRITE  -> usageType READ
    UNION ALL SELECT 'serviceCategory', 'R', 23, 'W'                                   --Leistungssteuerung () WRITE  -> serviceCategory READ
    UNION ALL SELECT 'serviceCatalog', 'R', 23, 'W'                                    --Leistungssteuerung () WRITE  -> serviceCatalog READ
    UNION ALL SELECT 'sapOrder', 'R', 23, 'W'                                          --Leistungssteuerung () WRITE  -> sapOrder READ
    UNION ALL SELECT 'wageCluster', 'R', 23, 'W'                                       --Leistungssteuerung () WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 23, 'W'                                         --Leistungssteuerung () WRITE  -> wageGroup READ
    UNION ALL SELECT 'servicePosition', 'R', 23, 'W'                                   --Leistungssteuerung () WRITE  -> servicePosition READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 23, 'W'                              --Leistungssteuerung () WRITE  -> priceCatalogPosition READ
    UNION ALL SELECT 'serviceOrder', 'R', 23, 'W'                                      --Leistungssteuerung () WRITE  -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 23, 'W'                              --Leistungssteuerung () WRITE  -> serviceOrderCalendar READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 23, 'W'                                --Leistungssteuerung () WRITE  -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 23, 'W'                                 --Leistungssteuerung () WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 23, 'W'                        --Leistungssteuerung () WRITE  -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceObject', 'R', 23, 'W'                                     --Leistungssteuerung () WRITE  -> serviceObject READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 23, 'W'                              --Leistungssteuerung () WRITE  -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 23, 'W'                                --Leistungssteuerung () WRITE  -> serviceOrderStatus READ
    UNION ALL SELECT 'site', 'R', 23, 'W'                                              --Leistungssteuerung () WRITE  -> site READ
    UNION ALL SELECT 'settlementType', 'R', 23, 'W'                                    --Leistungssteuerung () WRITE  -> settlementType READ
    UNION ALL SELECT 'serviceType', 'R', 23, 'W'                                       --Leistungssteuerung () WRITE  -> serviceType READ
    UNION ALL SELECT 'turnus', 'R', 23, 'W'                                            --Leistungssteuerung () WRITE  -> turnus READ
    UNION ALL SELECT 'supplier', 'R', 23, 'W'                                          --Leistungssteuerung () WRITE  -> supplier READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 23, 'W'                       --Leistungssteuerung () WRITE  -> technicalCleaningObjectType READ
    UNION ALL SELECT 'unit', 'R', 23, 'W'                                              --Leistungssteuerung () WRITE  -> unit READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 23, 'W'                           --Leistungssteuerung () WRITE  -> technicalCleaningObject READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 23, 'W'                   --Leistungssteuerung () WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 23, 'W'                           --Leistungssteuerung () WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'orgUnit', 'R', 23, 'W'                                           --Leistungssteuerung () WRITE  -> orgUnit READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 23, 'W'                     --Leistungssteuerung () WRITE  -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'plant', 'R', 23, 'W'                                             --Leistungssteuerung () WRITE  -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 23, 'W'                                      --Leistungssteuerung () WRITE  -> priceCatalog READ
    UNION ALL SELECT 'parameter', 'R', 23, 'W'                                         --Leistungssteuerung () WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 23, 'W'                             --Leistungssteuerung () WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 23, 'W'                                --Leistungssteuerung () WRITE  -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 23, 'W'                                  --Leistungssteuerung () WRITE  -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 23, 'W'               --Leistungssteuerung () WRITE  -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 23, 'W'                --Leistungssteuerung () WRITE  -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 23, 'W'                               --Leistungssteuerung () WRITE  -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 23, 'W'                              --Leistungssteuerung () WRITE  -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 23, 'W'                             --Leistungssteuerung () WRITE  -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 23, 'W'                   --Leistungssteuerung () WRITE  -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 23, 'W'                   --Leistungssteuerung () WRITE  -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 23, 'W'                   --Leistungssteuerung () WRITE  -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 23, 'W'                       --Leistungssteuerung () WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 23, 'W'                  --Leistungssteuerung () WRITE  -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 23, 'W'              --Leistungssteuerung () WRITE  -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 23, 'W'                    --Leistungssteuerung () WRITE  -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 23, 'W'                             --Leistungssteuerung () WRITE  -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 23, 'W'                              --Leistungssteuerung () WRITE  -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 23, 'W'                   --Leistungssteuerung () WRITE  -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 23, 'W'                              --Leistungssteuerung () WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 23, 'W'                                    --Leistungssteuerung () WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 23, 'W'                   --Leistungssteuerung () WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 23, 'W'                                  --Leistungssteuerung () WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 23, 'W'                         --Leistungssteuerung () WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'lvAlloc', 'R', 23, 'W'                                           --Leistungssteuerung () WRITE  -> lvAlloc READ
    UNION ALL SELECT 'mainCode', 'R', 23, 'W'                                          --Leistungssteuerung () WRITE  -> mainCode READ
    UNION ALL SELECT 'flooring', 'R', 23, 'W'                                          --Leistungssteuerung () WRITE  -> flooring READ
    UNION ALL SELECT 'dayType', 'R', 23, 'W'                                           --Leistungssteuerung () WRITE  -> dayType READ
    UNION ALL SELECT 'location', 'R', 23, 'W'                                          --Leistungssteuerung () WRITE  -> location READ
    UNION ALL SELECT 'language', 'R', 23, 'W'                                          --Leistungssteuerung () WRITE  -> language READ
    UNION ALL SELECT 'customCleaningObject', 'R', 23, 'W'                              --Leistungssteuerung () WRITE  -> customCleaningObject READ
    UNION ALL SELECT 'cycle', 'R', 23, 'W'                                             --Leistungssteuerung () WRITE  -> cycle READ
    UNION ALL SELECT 'costCenter', 'R', 23, 'W'                                        --Leistungssteuerung () WRITE  -> costCenter READ
    UNION ALL SELECT 'currency', 'R', 23, 'W'                                          --Leistungssteuerung () WRITE  -> currency READ
    UNION ALL SELECT 'area', 'R', 23, 'W'                                              --Leistungssteuerung () WRITE  -> area READ
    UNION ALL SELECT 'ffg', 'R', 23, 'W'                                               --Leistungssteuerung () WRITE  -> ffg READ
    UNION ALL SELECT 'company', 'R', 23, 'W'                                           --Leistungssteuerung () WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 23, 'W'                                        --Leistungssteuerung () WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 23, 'W'                                  --Leistungssteuerung () WRITE  -> clientPermission READ
    UNION ALL SELECT 'attachedDocument', 'D', 23, 'W'                                  --Leistungssteuerung () WRITE  -> attachedDocument DELETE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 23, 'W'                   --Leistungssteuerung () WRITE  -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 23, 'W'                           --Leistungssteuerung () WRITE  -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 23, 'W'                   --Leistungssteuerung () WRITE  -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'attachedDocument', 'W', 23, 'W'                                  --Leistungssteuerung () WRITE  -> attachedDocument WRITE
    UNION ALL SELECT 'calendar', 'R', 23, 'W'                                          --Leistungssteuerung () WRITE  -> calendar READ
    UNION ALL SELECT 'attachedDocument', 'R', 23, 'W'                                  --Leistungssteuerung () WRITE  -> attachedDocument READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 23, 'W'                   --Leistungssteuerung () WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'client', 'R', 23, 'W'                                            --Leistungssteuerung () WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 23, 'D'                                  --Leistungssteuerung () DELETE -> clientPermission READ
    UNION ALL SELECT 'calendar', 'R', 23, 'D'                                          --Leistungssteuerung () DELETE -> calendar READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 23, 'D'                   --Leistungssteuerung () DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'client', 'R', 23, 'D'                                            --Leistungssteuerung () DELETE -> client READ
    UNION ALL SELECT 'attachedDocument', 'W', 23, 'D'                                  --Leistungssteuerung () DELETE -> attachedDocument WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 23, 'D'                   --Leistungssteuerung () DELETE -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 23, 'D'                           --Leistungssteuerung () DELETE -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 23, 'D'                   --Leistungssteuerung () DELETE -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'attachedDocument', 'D', 23, 'D'                                  --Leistungssteuerung () DELETE -> attachedDocument DELETE
    UNION ALL SELECT 'attachedDocument', 'R', 23, 'D'                                  --Leistungssteuerung () DELETE -> attachedDocument READ
    UNION ALL SELECT 'area', 'R', 23, 'D'                                              --Leistungssteuerung () DELETE -> area READ
    UNION ALL SELECT 'clientRole', 'R', 23, 'D'                                        --Leistungssteuerung () DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 23, 'D'                                           --Leistungssteuerung () DELETE -> company READ
    UNION ALL SELECT 'costCenter', 'R', 23, 'D'                                        --Leistungssteuerung () DELETE -> costCenter READ
    UNION ALL SELECT 'language', 'R', 23, 'D'                                          --Leistungssteuerung () DELETE -> language READ
    UNION ALL SELECT 'flooring', 'R', 23, 'D'                                          --Leistungssteuerung () DELETE -> flooring READ
    UNION ALL SELECT 'ffg', 'R', 23, 'D'                                               --Leistungssteuerung () DELETE -> ffg READ
    UNION ALL SELECT 'dayType', 'R', 23, 'D'                                           --Leistungssteuerung () DELETE -> dayType READ
    UNION ALL SELECT 'currency', 'R', 23, 'D'                                          --Leistungssteuerung () DELETE -> currency READ
    UNION ALL SELECT 'cycle', 'R', 23, 'D'                                             --Leistungssteuerung () DELETE -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'R', 23, 'D'                              --Leistungssteuerung () DELETE -> customCleaningObject READ
    UNION ALL SELECT 'lvAlloc', 'R', 23, 'D'                                           --Leistungssteuerung () DELETE -> lvAlloc READ
    UNION ALL SELECT 'mainCode', 'R', 23, 'D'                                          --Leistungssteuerung () DELETE -> mainCode READ
    UNION ALL SELECT 'location', 'R', 23, 'D'                                          --Leistungssteuerung () DELETE -> location READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 23, 'D'                         --Leistungssteuerung () DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 23, 'D'                                  --Leistungssteuerung () DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 23, 'D'                              --Leistungssteuerung () DELETE -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 23, 'D'                   --Leistungssteuerung () DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 23, 'D'                                    --Leistungssteuerung () DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 23, 'D'                              --Leistungssteuerung () DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 23, 'D'                    --Leistungssteuerung () DELETE -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 23, 'D'                   --Leistungssteuerung () DELETE -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 23, 'D'                  --Leistungssteuerung () DELETE -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 23, 'D'                       --Leistungssteuerung () DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 23, 'D'              --Leistungssteuerung () DELETE -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 23, 'D'                             --Leistungssteuerung () DELETE -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 23, 'D'                   --Leistungssteuerung () DELETE -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 23, 'D'                   --Leistungssteuerung () DELETE -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 23, 'D'                             --Leistungssteuerung () DELETE -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 23, 'D'                   --Leistungssteuerung () DELETE -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 23, 'D'                              --Leistungssteuerung () DELETE -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 23, 'D'                               --Leistungssteuerung () DELETE -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 23, 'D'                --Leistungssteuerung () DELETE -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 23, 'D'               --Leistungssteuerung () DELETE -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 23, 'D'                                --Leistungssteuerung () DELETE -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 23, 'D'                                  --Leistungssteuerung () DELETE -> mapSupplierPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 23, 'D'                             --Leistungssteuerung () DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'orgUnit', 'R', 23, 'D'                                           --Leistungssteuerung () DELETE -> orgUnit READ
    UNION ALL SELECT 'parameter', 'R', 23, 'D'                                         --Leistungssteuerung () DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 23, 'D'                                             --Leistungssteuerung () DELETE -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 23, 'D'                                      --Leistungssteuerung () DELETE -> priceCatalog READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 23, 'D'                           --Leistungssteuerung () DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 23, 'D'                   --Leistungssteuerung () DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 23, 'D'                     --Leistungssteuerung () DELETE -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 23, 'D'                       --Leistungssteuerung () DELETE -> technicalCleaningObjectType READ
    UNION ALL SELECT 'supplier', 'R', 23, 'D'                                          --Leistungssteuerung () DELETE -> supplier READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 23, 'D'                           --Leistungssteuerung () DELETE -> technicalCleaningObject READ
    UNION ALL SELECT 'unit', 'R', 23, 'D'                                              --Leistungssteuerung () DELETE -> unit READ
    UNION ALL SELECT 'turnus', 'R', 23, 'D'                                            --Leistungssteuerung () DELETE -> turnus READ
    UNION ALL SELECT 'settlementType', 'R', 23, 'D'                                    --Leistungssteuerung () DELETE -> settlementType READ
    UNION ALL SELECT 'site', 'R', 23, 'D'                                              --Leistungssteuerung () DELETE -> site READ
    UNION ALL SELECT 'serviceType', 'R', 23, 'D'                                       --Leistungssteuerung () DELETE -> serviceType READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 23, 'D'                                --Leistungssteuerung () DELETE -> serviceOrderStatus READ
    UNION ALL SELECT 'servicePosition', 'R', 23, 'D'                                   --Leistungssteuerung () DELETE -> servicePosition READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 23, 'D'                              --Leistungssteuerung () DELETE -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 23, 'D'                        --Leistungssteuerung () DELETE -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 23, 'D'                                 --Leistungssteuerung () DELETE -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrder', 'R', 23, 'D'                                      --Leistungssteuerung () DELETE -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 23, 'D'                              --Leistungssteuerung () DELETE -> serviceOrderCalendar READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 23, 'D'                                --Leistungssteuerung () DELETE -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 23, 'D'                              --Leistungssteuerung () DELETE -> priceCatalogPosition READ
    UNION ALL SELECT 'sapOrder', 'R', 23, 'D'                                          --Leistungssteuerung () DELETE -> sapOrder READ
    UNION ALL SELECT 'serviceCategory', 'R', 23, 'D'                                   --Leistungssteuerung () DELETE -> serviceCategory READ
    UNION ALL SELECT 'serviceCatalog', 'R', 23, 'D'                                    --Leistungssteuerung () DELETE -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 23, 'D'                                     --Leistungssteuerung () DELETE -> serviceObject READ
    UNION ALL SELECT 'usageType', 'R', 23, 'D'                                         --Leistungssteuerung () DELETE -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 23, 'D'                                       --Leistungssteuerung () DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 23, 'D'                                         --Leistungssteuerung () DELETE -> wageGroup READ
    UNION ALL SELECT 'wageCluster', 'R', 24, 'R'                                       --Leistungsabnahme () READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 24, 'R'                                         --Leistungsabnahme () READ   -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 24, 'R'                                         --Leistungsabnahme () READ   -> usageType READ
    UNION ALL SELECT 'serviceCategory', 'R', 24, 'R'                                   --Leistungsabnahme () READ   -> serviceCategory READ
    UNION ALL SELECT 'serviceObject', 'R', 24, 'R'                                     --Leistungsabnahme () READ   -> serviceObject READ
    UNION ALL SELECT 'serviceCatalog', 'R', 24, 'R'                                    --Leistungsabnahme () READ   -> serviceCatalog READ
    UNION ALL SELECT 'sapOrder', 'R', 24, 'R'                                          --Leistungsabnahme () READ   -> sapOrder READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 24, 'R'                              --Leistungsabnahme () READ   -> priceCatalogPosition READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 24, 'R'                                --Leistungsabnahme () READ   -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceOrder', 'R', 24, 'R'                                      --Leistungsabnahme () READ   -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 24, 'R'                              --Leistungsabnahme () READ   -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceObjectType', 'R', 24, 'R'                                 --Leistungsabnahme () READ   -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 24, 'R'                              --Leistungsabnahme () READ   -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 24, 'R'                        --Leistungsabnahme () READ   -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 24, 'R'                                --Leistungsabnahme () READ   -> serviceOrderStatus READ
    UNION ALL SELECT 'servicePosition', 'R', 24, 'R'                                   --Leistungsabnahme () READ   -> servicePosition READ
    UNION ALL SELECT 'serviceType', 'R', 24, 'R'                                       --Leistungsabnahme () READ   -> serviceType READ
    UNION ALL SELECT 'settlementType', 'R', 24, 'R'                                    --Leistungsabnahme () READ   -> settlementType READ
    UNION ALL SELECT 'site', 'R', 24, 'R'                                              --Leistungsabnahme () READ   -> site READ
    UNION ALL SELECT 'turnus', 'R', 24, 'R'                                            --Leistungsabnahme () READ   -> turnus READ
    UNION ALL SELECT 'unit', 'R', 24, 'R'                                              --Leistungsabnahme () READ   -> unit READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 24, 'R'                       --Leistungsabnahme () READ   -> technicalCleaningObjectType READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 24, 'R'                           --Leistungsabnahme () READ   -> technicalCleaningObject READ
    UNION ALL SELECT 'supplier', 'R', 24, 'R'                                          --Leistungsabnahme () READ   -> supplier READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 24, 'R'                           --Leistungsabnahme () READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 24, 'R'                     --Leistungsabnahme () READ   -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 24, 'R'                   --Leistungsabnahme () READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalog', 'R', 24, 'R'                                      --Leistungsabnahme () READ   -> priceCatalog READ
    UNION ALL SELECT 'plant', 'R', 24, 'R'                                             --Leistungsabnahme () READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 24, 'R'                                         --Leistungsabnahme () READ   -> parameter READ
    UNION ALL SELECT 'orgUnit', 'R', 24, 'R'                                           --Leistungsabnahme () READ   -> orgUnit READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 24, 'R'                             --Leistungsabnahme () READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 24, 'R'                                  --Leistungsabnahme () READ   -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 24, 'R'                                --Leistungsabnahme () READ   -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 24, 'R'               --Leistungsabnahme () READ   -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 24, 'R'                --Leistungsabnahme () READ   -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 24, 'R'                               --Leistungsabnahme () READ   -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 24, 'R'                              --Leistungsabnahme () READ   -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 24, 'R'                             --Leistungsabnahme () READ   -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 24, 'R'                   --Leistungsabnahme () READ   -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 24, 'R'              --Leistungsabnahme () READ   -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 24, 'R'                       --Leistungsabnahme () READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 24, 'R'                  --Leistungsabnahme () READ   -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 24, 'R'                             --Leistungsabnahme () READ   -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 24, 'R'                   --Leistungsabnahme () READ   -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 24, 'R'                    --Leistungsabnahme () READ   -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 24, 'R'                              --Leistungsabnahme () READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 24, 'R'                                    --Leistungsabnahme () READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 24, 'R'                   --Leistungsabnahme () READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 24, 'R'                                  --Leistungsabnahme () READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 24, 'R'                         --Leistungsabnahme () READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 24, 'R'                              --Leistungsabnahme () READ   -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mainCode', 'R', 24, 'R'                                          --Leistungsabnahme () READ   -> mainCode READ
    UNION ALL SELECT 'flooring', 'R', 24, 'R'                                          --Leistungsabnahme () READ   -> flooring READ
    UNION ALL SELECT 'location', 'R', 24, 'R'                                          --Leistungsabnahme () READ   -> location READ
    UNION ALL SELECT 'lvAlloc', 'R', 24, 'R'                                           --Leistungsabnahme () READ   -> lvAlloc READ
    UNION ALL SELECT 'language', 'R', 24, 'R'                                          --Leistungsabnahme () READ   -> language READ
    UNION ALL SELECT 'customCleaningObject', 'R', 24, 'R'                              --Leistungsabnahme () READ   -> customCleaningObject READ
    UNION ALL SELECT 'cycle', 'R', 24, 'R'                                             --Leistungsabnahme () READ   -> cycle READ
    UNION ALL SELECT 'currency', 'R', 24, 'R'                                          --Leistungsabnahme () READ   -> currency READ
    UNION ALL SELECT 'costCenter', 'R', 24, 'R'                                        --Leistungsabnahme () READ   -> costCenter READ
    UNION ALL SELECT 'dayType', 'R', 24, 'R'                                           --Leistungsabnahme () READ   -> dayType READ
    UNION ALL SELECT 'ffg', 'R', 24, 'R'                                               --Leistungsabnahme () READ   -> ffg READ
    UNION ALL SELECT 'company', 'R', 24, 'R'                                           --Leistungsabnahme () READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 24, 'R'                                        --Leistungsabnahme () READ   -> clientRole READ
    UNION ALL SELECT 'area', 'R', 24, 'R'                                              --Leistungsabnahme () READ   -> area READ
    UNION ALL SELECT 'attachedDocument', 'R', 24, 'R'                                  --Leistungsabnahme () READ   -> attachedDocument READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 24, 'R'                   --Leistungsabnahme () READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'clientPermission', 'R', 24, 'R'                                  --Leistungsabnahme () READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 24, 'R'                                            --Leistungsabnahme () READ   -> client READ
    UNION ALL SELECT 'calendar', 'R', 24, 'R'                                          --Leistungsabnahme () READ   -> calendar READ
    UNION ALL SELECT 'calendar', 'R', 24, 'W'                                          --Leistungsabnahme () WRITE  -> calendar READ
    UNION ALL SELECT 'clientPermission', 'R', 24, 'W'                                  --Leistungsabnahme () WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 24, 'W'                                            --Leistungsabnahme () WRITE  -> client READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 24, 'W'                   --Leistungsabnahme () WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'attachedDocument', 'W', 24, 'W'                                  --Leistungsabnahme () WRITE  -> attachedDocument WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 24, 'W'                   --Leistungsabnahme () WRITE  -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'attachedDocument', 'R', 24, 'W'                                  --Leistungsabnahme () WRITE  -> attachedDocument READ
    UNION ALL SELECT 'attachedDocument', 'D', 24, 'W'                                  --Leistungsabnahme () WRITE  -> attachedDocument DELETE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 24, 'W'                   --Leistungsabnahme () WRITE  -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 24, 'W'                           --Leistungsabnahme () WRITE  -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'area', 'R', 24, 'W'                                              --Leistungsabnahme () WRITE  -> area READ
    UNION ALL SELECT 'company', 'R', 24, 'W'                                           --Leistungsabnahme () WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 24, 'W'                                        --Leistungsabnahme () WRITE  -> clientRole READ
    UNION ALL SELECT 'ffg', 'R', 24, 'W'                                               --Leistungsabnahme () WRITE  -> ffg READ
    UNION ALL SELECT 'dayType', 'R', 24, 'W'                                           --Leistungsabnahme () WRITE  -> dayType READ
    UNION ALL SELECT 'currency', 'R', 24, 'W'                                          --Leistungsabnahme () WRITE  -> currency READ
    UNION ALL SELECT 'costCenter', 'R', 24, 'W'                                        --Leistungsabnahme () WRITE  -> costCenter READ
    UNION ALL SELECT 'cycle', 'R', 24, 'W'                                             --Leistungsabnahme () WRITE  -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'R', 24, 'W'                              --Leistungsabnahme () WRITE  -> customCleaningObject READ
    UNION ALL SELECT 'language', 'R', 24, 'W'                                          --Leistungsabnahme () WRITE  -> language READ
    UNION ALL SELECT 'location', 'R', 24, 'W'                                          --Leistungsabnahme () WRITE  -> location READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 24, 'W'                         --Leistungsabnahme () WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'flooring', 'R', 24, 'W'                                          --Leistungsabnahme () WRITE  -> flooring READ
    UNION ALL SELECT 'mainCode', 'R', 24, 'W'                                          --Leistungsabnahme () WRITE  -> mainCode READ
    UNION ALL SELECT 'lvAlloc', 'R', 24, 'W'                                           --Leistungsabnahme () WRITE  -> lvAlloc READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 24, 'W'                              --Leistungsabnahme () WRITE  -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 24, 'W'                   --Leistungsabnahme () WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 24, 'W'                                  --Leistungsabnahme () WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 24, 'W'                             --Leistungsabnahme () WRITE  -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapClientPlant', 'R', 24, 'W'                                    --Leistungsabnahme () WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 24, 'W'                              --Leistungsabnahme () WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 24, 'W'                   --Leistungsabnahme () WRITE  -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 24, 'W'                             --Leistungsabnahme () WRITE  -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 24, 'W'                    --Leistungsabnahme () WRITE  -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 24, 'W'              --Leistungsabnahme () WRITE  -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 24, 'W'                   --Leistungsabnahme () WRITE  -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 24, 'W'                  --Leistungsabnahme () WRITE  -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 24, 'W'                       --Leistungsabnahme () WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 24, 'W'                   --Leistungsabnahme () WRITE  -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 24, 'W'                   --Leistungsabnahme () WRITE  -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 24, 'W'                               --Leistungsabnahme () WRITE  -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 24, 'W'                              --Leistungsabnahme () WRITE  -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 24, 'W'               --Leistungsabnahme () WRITE  -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 24, 'W'                --Leistungsabnahme () WRITE  -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 24, 'W'                                  --Leistungsabnahme () WRITE  -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 24, 'W'                                --Leistungsabnahme () WRITE  -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 24, 'W'                             --Leistungsabnahme () WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 24, 'W'                           --Leistungsabnahme () WRITE  -> technicalCleaningObject READ
    UNION ALL SELECT 'parameter', 'R', 24, 'W'                                         --Leistungsabnahme () WRITE  -> parameter READ
    UNION ALL SELECT 'priceCatalog', 'R', 24, 'W'                                      --Leistungsabnahme () WRITE  -> priceCatalog READ
    UNION ALL SELECT 'plant', 'R', 24, 'W'                                             --Leistungsabnahme () WRITE  -> plant READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 24, 'W'                   --Leistungsabnahme () WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 24, 'W'                     --Leistungsabnahme () WRITE  -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'orgUnit', 'R', 24, 'W'                                           --Leistungsabnahme () WRITE  -> orgUnit READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 24, 'W'                           --Leistungsabnahme () WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'supplier', 'R', 24, 'W'                                          --Leistungsabnahme () WRITE  -> supplier READ
    UNION ALL SELECT 'unit', 'R', 24, 'W'                                              --Leistungsabnahme () WRITE  -> unit READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 24, 'W'                       --Leistungsabnahme () WRITE  -> technicalCleaningObjectType READ
    UNION ALL SELECT 'site', 'R', 24, 'W'                                              --Leistungsabnahme () WRITE  -> site READ
    UNION ALL SELECT 'turnus', 'R', 24, 'W'                                            --Leistungsabnahme () WRITE  -> turnus READ
    UNION ALL SELECT 'serviceType', 'R', 24, 'W'                                       --Leistungsabnahme () WRITE  -> serviceType READ
    UNION ALL SELECT 'settlementType', 'R', 24, 'W'                                    --Leistungsabnahme () WRITE  -> settlementType READ
    UNION ALL SELECT 'servicePosition', 'R', 24, 'W'                                   --Leistungsabnahme () WRITE  -> servicePosition READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 24, 'W'                                --Leistungsabnahme () WRITE  -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 24, 'W'                                 --Leistungsabnahme () WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 24, 'W'                              --Leistungsabnahme () WRITE  -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceObject', 'R', 24, 'W'                                     --Leistungsabnahme () WRITE  -> serviceObject READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 24, 'W'                        --Leistungsabnahme () WRITE  -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 24, 'W'                                --Leistungsabnahme () WRITE  -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceOrder', 'R', 24, 'W'                                      --Leistungsabnahme () WRITE  -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 24, 'W'                              --Leistungsabnahme () WRITE  -> serviceOrderCalendar READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 24, 'W'                              --Leistungsabnahme () WRITE  -> priceCatalogPosition READ
    UNION ALL SELECT 'sapOrder', 'R', 24, 'W'                                          --Leistungsabnahme () WRITE  -> sapOrder READ
    UNION ALL SELECT 'serviceCatalog', 'R', 24, 'W'                                    --Leistungsabnahme () WRITE  -> serviceCatalog READ
    UNION ALL SELECT 'serviceCategory', 'R', 24, 'W'                                   --Leistungsabnahme () WRITE  -> serviceCategory READ
    UNION ALL SELECT 'usageType', 'R', 24, 'W'                                         --Leistungsabnahme () WRITE  -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 24, 'W'                                       --Leistungsabnahme () WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 24, 'W'                                         --Leistungsabnahme () WRITE  -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 24, 'D'                                         --Leistungsabnahme () DELETE -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 24, 'D'                                       --Leistungsabnahme () DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 24, 'D'                                         --Leistungsabnahme () DELETE -> wageGroup READ
    UNION ALL SELECT 'serviceObject', 'R', 24, 'D'                                     --Leistungsabnahme () DELETE -> serviceObject READ
    UNION ALL SELECT 'serviceCatalog', 'R', 24, 'D'                                    --Leistungsabnahme () DELETE -> serviceCatalog READ
    UNION ALL SELECT 'serviceCategory', 'R', 24, 'D'                                   --Leistungsabnahme () DELETE -> serviceCategory READ
    UNION ALL SELECT 'sapOrder', 'R', 24, 'D'                                          --Leistungsabnahme () DELETE -> sapOrder READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 24, 'D'                              --Leistungsabnahme () DELETE -> priceCatalogPosition READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 24, 'D'                                --Leistungsabnahme () DELETE -> priceCatalogStatus READ
    UNION ALL SELECT 'serviceOrder', 'R', 24, 'D'                                      --Leistungsabnahme () DELETE -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 24, 'D'                              --Leistungsabnahme () DELETE -> serviceOrderalendar READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 24, 'D'                        --Leistungsabnahme () DELETE -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 24, 'D'                                 --Leistungsabnahme () DELETE -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 24, 'D'                              --Leistungsabnahme () DELETE -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 24, 'D'                                --Leistungsabnahme () DELETE -> serviceOrderStatus READ
    UNION ALL SELECT 'servicePosition', 'R', 24, 'D'                                   --Leistungsabnahme () DELETE -> servicePosition READ
    UNION ALL SELECT 'serviceType', 'R', 24, 'D'                                       --Leistungsabnahme () DELETE -> serviceType READ
    UNION ALL SELECT 'settlementType', 'R', 24, 'D'                                    --Leistungsabnahme () DELETE -> settlementType READ
    UNION ALL SELECT 'site', 'R', 24, 'D'                                              --Leistungsabnahme () DELETE -> site READ
    UNION ALL SELECT 'turnus', 'R', 24, 'D'                                            --Leistungsabnahme () DELETE -> turnus READ
    UNION ALL SELECT 'unit', 'R', 24, 'D'                                              --Leistungsabnahme () DELETE -> unit READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 24, 'D'                           --Leistungsabnahme () DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 24, 'D'                   --Leistungsabnahme () DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 24, 'D'                           --Leistungsabnahme () DELETE -> technicalCleaningObject READ
    UNION ALL SELECT 'supplier', 'R', 24, 'D'                                          --Leistungsabnahme () DELETE -> supplier READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 24, 'D'                       --Leistungsabnahme () DELETE -> technicalCleaningObjectType READ
    UNION ALL SELECT 'priceCatalog', 'R', 24, 'D'                                      --Leistungsabnahme () DELETE -> priceCatalog READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 24, 'D'                     --Leistungsabnahme () DELETE -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'plant', 'R', 24, 'D'                                             --Leistungsabnahme () DELETE -> plant READ
    UNION ALL SELECT 'parameter', 'R', 24, 'D'                                         --Leistungsabnahme () DELETE -> parameter READ
    UNION ALL SELECT 'orgUnit', 'R', 24, 'D'                                           --Leistungsabnahme () DELETE -> orgUnit READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 24, 'D'                             --Leistungsabnahme () DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 24, 'D'                                  --Leistungsabnahme () DELETE -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 24, 'D'               --Leistungsabnahme () DELETE -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 24, 'D'                                --Leistungsabnahme () DELETE -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 24, 'D'                --Leistungsabnahme () DELETE -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 24, 'D'                               --Leistungsabnahme () DELETE -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 24, 'D'                   --Leistungsabnahme () DELETE -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 24, 'D'                             --Leistungsabnahme () DELETE -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 24, 'D'                   --Leistungsabnahme () DELETE -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 24, 'D'                              --Leistungsabnahme () DELETE -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 24, 'D'                   --Leistungsabnahme () DELETE -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 24, 'D'              --Leistungsabnahme () DELETE -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 24, 'D'                       --Leistungsabnahme () DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 24, 'D'                  --Leistungsabnahme () DELETE -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 24, 'D'                             --Leistungsabnahme () DELETE -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 24, 'D'                   --Leistungsabnahme () DELETE -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 24, 'D'                    --Leistungsabnahme () DELETE -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 24, 'D'                              --Leistungsabnahme () DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientCompany', 'R', 24, 'D'                                  --Leistungsabnahme () DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 24, 'D'                   --Leistungsabnahme () DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 24, 'D'                                    --Leistungsabnahme () DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 24, 'D'                         --Leistungsabnahme () DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 24, 'D'                              --Leistungsabnahme () DELETE -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mainCode', 'R', 24, 'D'                                          --Leistungsabnahme () DELETE -> mainCode READ
    UNION ALL SELECT 'location', 'R', 24, 'D'                                          --Leistungsabnahme () DELETE -> location READ
    UNION ALL SELECT 'lvAlloc', 'R', 24, 'D'                                           --Leistungsabnahme () DELETE -> lvAlloc READ
    UNION ALL SELECT 'customCleaningObject', 'R', 24, 'D'                              --Leistungsabnahme () DELETE -> customCleaningObject READ
    UNION ALL SELECT 'cycle', 'R', 24, 'D'                                             --Leistungsabnahme () DELETE -> cycle READ
    UNION ALL SELECT 'ffg', 'R', 24, 'D'                                               --Leistungsabnahme () DELETE -> ffg READ
    UNION ALL SELECT 'currency', 'R', 24, 'D'                                          --Leistungsabnahme () DELETE -> currency READ
    UNION ALL SELECT 'dayType', 'R', 24, 'D'                                           --Leistungsabnahme () DELETE -> dayType READ
    UNION ALL SELECT 'flooring', 'R', 24, 'D'                                          --Leistungsabnahme () DELETE -> flooring READ
    UNION ALL SELECT 'language', 'R', 24, 'D'                                          --Leistungsabnahme () DELETE -> language READ
    UNION ALL SELECT 'costCenter', 'R', 24, 'D'                                        --Leistungsabnahme () DELETE -> costCenter READ
    UNION ALL SELECT 'company', 'R', 24, 'D'                                           --Leistungsabnahme () DELETE -> company READ
    UNION ALL SELECT 'attachedDocument', 'D', 24, 'D'                                  --Leistungsabnahme () DELETE -> attachedDocument DELETE
    UNION ALL SELECT 'clientRole', 'R', 24, 'D'                                        --Leistungsabnahme () DELETE -> clientRole READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 24, 'D'                   --Leistungsabnahme () DELETE -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 24, 'D'                           --Leistungsabnahme () DELETE -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'area', 'R', 24, 'D'                                              --Leistungsabnahme () DELETE -> area READ
    UNION ALL SELECT 'attachedDocument', 'R', 24, 'D'                                  --Leistungsabnahme () DELETE -> attachedDocument READ
    UNION ALL SELECT 'attachedDocument', 'W', 24, 'D'                                  --Leistungsabnahme () DELETE -> attachedDocument WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 24, 'D'                   --Leistungsabnahme () DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 24, 'D'                   --Leistungsabnahme () DELETE -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'clientPermission', 'R', 24, 'D'                                  --Leistungsabnahme () DELETE -> clientPermission READ
    UNION ALL SELECT 'calendar', 'R', 24, 'D'                                          --Leistungsabnahme () DELETE -> calendar READ
    UNION ALL SELECT 'client', 'R', 24, 'D'                                            --Leistungsabnahme () DELETE -> client READ
    UNION ALL SELECT 'calendar', 'R', 25, 'R'                                          --Abrechnung (bill) READ   -> calendar READ
    UNION ALL SELECT 'billStatus', 'R', 25, 'R'                                        --Abrechnung (bill) READ   -> billStatus READ
    UNION ALL SELECT 'client', 'R', 25, 'R'                                            --Abrechnung (bill) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 25, 'R'                                  --Abrechnung (bill) READ   -> clientPermission READ
    UNION ALL SELECT 'bill', 'R', 25, 'R'                                              --Abrechnung (bill) READ   -> bill READ
    UNION ALL SELECT 'billPosition', 'R', 25, 'R'                                      --Abrechnung (bill) READ   -> billPosition READ
    UNION ALL SELECT 'additionalShift', 'R', 25, 'R'                                   --Abrechnung (bill) READ   -> additionalShift READ
    UNION ALL SELECT 'clientRole', 'R', 25, 'R'                                        --Abrechnung (bill) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 25, 'R'                                           --Abrechnung (bill) READ   -> company READ
    UNION ALL SELECT 'dayType', 'R', 25, 'R'                                           --Abrechnung (bill) READ   -> dayType READ
    UNION ALL SELECT 'language', 'R', 25, 'R'                                          --Abrechnung (bill) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 25, 'R'                                          --Abrechnung (bill) READ   -> mainCode READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 25, 'R'                              --Abrechnung (bill) READ   -> mapCalendarPlantSite READ
	UNION ALL SELECT 'mapBillBillStatus', 'R', 25, 'R'                                 --Abrechnung (bill) READ   -> mapBillBillStatus READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 25, 'R'                         --Abrechnung (bill) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 25, 'R'                                  --Abrechnung (bill) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 25, 'R'                   --Abrechnung (bill) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 25, 'R'                                    --Abrechnung (bill) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 25, 'R'                              --Abrechnung (bill) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 25, 'R'                       --Abrechnung (bill) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 25, 'R'                   --Abrechnung (bill) READ   -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 25, 'R'                             --Abrechnung (bill) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 25, 'R'                                         --Abrechnung (bill) READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 25, 'R'                                             --Abrechnung (bill) READ   -> plant READ
    UNION ALL SELECT 'supplier', 'R', 25, 'R'                                          --Abrechnung (bill) READ   -> supplier READ
    UNION ALL SELECT 'unit', 'R', 25, 'R'                                              --Abrechnung (bill) READ   -> unit READ
    UNION ALL SELECT 'turnus', 'R', 25, 'R'                                            --Abrechnung (bill) READ   -> turnus READ
    UNION ALL SELECT 'standardDiscount', 'R', 25, 'R'                                  --Abrechnung (bill) READ   -> standardDiscount READ
    UNION ALL SELECT 'settlementType', 'R', 25, 'R'                                    --Abrechnung (bill) READ   -> settlementType READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 25, 'R'                                --Abrechnung (bill) READ   -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 25, 'R'                        --Abrechnung (bill) READ   -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 25, 'R'                              --Abrechnung (bill) READ   -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrder', 'R', 25, 'R'                                      --Abrechnung (bill) READ   -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 25, 'R'                              --Abrechnung (bill) READ   -> serviceOrderCalendar READ
    UNION ALL SELECT 'sapOrder', 'R', 25, 'R'                                          --Abrechnung (bill) READ   -> sapOrder READ
    UNION ALL SELECT 'usageType', 'R', 25, 'R'                                         --Abrechnung (bill) READ   -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 25, 'R'                                       --Abrechnung (bill) READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 25, 'R'                                         --Abrechnung (bill) READ   -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 25, 'W'                                         --Abrechnung (bill) WRITE  -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 25, 'W'                                       --Abrechnung (bill) WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 25, 'W'                                         --Abrechnung (bill) WRITE  -> wageGroup READ
    UNION ALL SELECT 'serviceOrder', 'R', 25, 'W'                                      --Abrechnung (bill) WRITE  -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 25, 'W'                              --Abrechnung (bill) WRITE  -> serviceOrderCalendar READ
    UNION ALL SELECT 'sapOrder', 'R', 25, 'W'                                          --Abrechnung (bill) WRITE  -> sapOrder READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 25, 'W'                              --Abrechnung (bill) WRITE  -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 25, 'W'                        --Abrechnung (bill) WRITE  -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 25, 'W'                                --Abrechnung (bill) WRITE  -> serviceOrderStatus READ
    UNION ALL SELECT 'settlementType', 'R', 25, 'W'                                    --Abrechnung (bill) WRITE  -> settlementType READ
    UNION ALL SELECT 'standardDiscount', 'R', 25, 'W'                                  --Abrechnung (bill) WRITE  -> standardDiscount READ
    UNION ALL SELECT 'turnus', 'R', 25, 'W'                                            --Abrechnung (bill) WRITE  -> turnus READ
    UNION ALL SELECT 'unit', 'R', 25, 'W'                                              --Abrechnung (bill) WRITE  -> unit READ
    UNION ALL SELECT 'plant', 'R', 25, 'W'                                             --Abrechnung (bill) WRITE  -> plant READ
    UNION ALL SELECT 'supplier', 'R', 25, 'W'                                          --Abrechnung (bill) WRITE  -> supplier READ
    UNION ALL SELECT 'parameter', 'R', 25, 'W'                                         --Abrechnung (bill) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 25, 'W'                             --Abrechnung (bill) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 25, 'W'                   --Abrechnung (bill) WRITE  -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 25, 'W'                       --Abrechnung (bill) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 25, 'W'                              --Abrechnung (bill) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 25, 'W'                                    --Abrechnung (bill) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 25, 'W'                   --Abrechnung (bill) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 25, 'W'                                  --Abrechnung (bill) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapBillBillStatus', 'D', 25, 'W'                                 --Abrechnung (bill) WRITE  -> mapBillBillStatus DELETE
    UNION ALL SELECT 'mapClientClientPermission', 'R', 25, 'W'                         --Abrechnung (bill) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 25, 'W'                              --Abrechnung (bill) WRITE  -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapBillBillStatus', 'W', 25, 'W'                                 --Abrechnung (bill) WRITE  -> mapBillBillStatus WRITE
    UNION ALL SELECT 'mapBillBillStatus', 'R', 25, 'W'                                 --Abrechnung (bill) WRITE  -> mapBillBillStatus READ
    UNION ALL SELECT 'mainCode', 'R', 25, 'W'                                          --Abrechnung (bill) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 25, 'W'                                          --Abrechnung (bill) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 25, 'W'                                           --Abrechnung (bill) WRITE  -> company READ
    UNION ALL SELECT 'calendar', 'R', 25, 'W'                                          --Abrechnung (bill) WRITE  -> calendar READ
    UNION ALL SELECT 'dayType', 'R', 25, 'W'                                           --Abrechnung (bill) WRITE  -> dayType READ
    UNION ALL SELECT 'clientRole', 'R', 25, 'W'                                        --Abrechnung (bill) WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 25, 'W'                                  --Abrechnung (bill) WRITE  -> clientPermission READ
    UNION ALL SELECT 'additionalShift', 'R', 25, 'W'                                   --Abrechnung (bill) WRITE  -> additionalShift READ
    UNION ALL SELECT 'bill', 'W', 25, 'W'                                              --Abrechnung (bill) WRITE  -> bill WRITE
    UNION ALL SELECT 'attachedDocument', 'R', 25, 'W'                                  --Abrechnung (bill) WRITE  -> attachedDocument READ
    UNION ALL SELECT 'attachedDocument', 'D', 25, 'W'                                  --Abrechnung (bill) WRITE  -> attachedDocument DELETE
    UNION ALL SELECT 'billPosition', 'D', 25, 'W'                                      --Abrechnung (bill) WRITE  -> billPosition DELETE
    UNION ALL SELECT 'bill', 'R', 25, 'W'                                              --Abrechnung (bill) WRITE  -> bill READ
    UNION ALL SELECT 'bill', 'D', 25, 'W'                                              --Abrechnung (bill) WRITE  -> bill DELETE
    UNION ALL SELECT 'client', 'R', 25, 'W'                                            --Abrechnung (bill) WRITE  -> client READ
    UNION ALL SELECT 'billStatus', 'R', 25, 'W'                                        --Abrechnung (bill) WRITE  -> billStatus READ
    UNION ALL SELECT 'billPosition', 'W', 25, 'W'                                      --Abrechnung (bill) WRITE  -> billPosition WRITE
    UNION ALL SELECT 'billPosition', 'R', 25, 'W'                                      --Abrechnung (bill) WRITE  -> billPosition READ
    UNION ALL SELECT 'billPosition', 'W', 25, 'D'                                      --Abrechnung (bill) DELETE -> billPosition WRITE
    UNION ALL SELECT 'calendar', 'R', 25, 'D'                                          --Abrechnung (bill) DELETE -> calendar READ
    UNION ALL SELECT 'billStatus', 'R', 25, 'D'                                        --Abrechnung (bill) DELETE -> billStatus READ
    UNION ALL SELECT 'clientPermission', 'R', 25, 'D'                                  --Abrechnung (bill) DELETE -> clientPermission READ
    UNION ALL SELECT 'bill', 'D', 25, 'D'                                              --Abrechnung (bill) DELETE -> bill DELETE
    UNION ALL SELECT 'bill', 'R', 25, 'D'                                              --Abrechnung (bill) DELETE -> bill READ
    UNION ALL SELECT 'bill', 'W', 25, 'D'                                              --Abrechnung (bill) DELETE -> bill WRITE
    UNION ALL SELECT 'attachedDocument', 'R', 25, 'W'                                  --Abrechnung (bill) DELETE  -> attachedDocument READ
    UNION ALL SELECT 'attachedDocument', 'D', 25, 'W'                                  --Abrechnung (bill) DELETE  -> attachedDocument DELETE
    UNION ALL SELECT 'client', 'R', 25, 'D'                                            --Abrechnung (bill) DELETE -> client READ
    UNION ALL SELECT 'billPosition', 'R', 25, 'D'                                      --Abrechnung (bill) DELETE -> billPosition READ
    UNION ALL SELECT 'billPosition', 'D', 25, 'D'                                      --Abrechnung (bill) DELETE -> billPosition DELETE
    UNION ALL SELECT 'additionalShift', 'R', 25, 'D'                                   --Abrechnung (bill) DELETE -> additionalShift READ
    UNION ALL SELECT 'clientRole', 'R', 25, 'D'                                        --Abrechnung (bill) DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 25, 'D'                                           --Abrechnung (bill) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 25, 'D'                                          --Abrechnung (bill) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 25, 'D'                                          --Abrechnung (bill) DELETE -> mainCode READ
    UNION ALL SELECT 'dayType', 'R', 25, 'D'                                           --Abrechnung (bill) DELETE -> dayType READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 25, 'D'                         --Abrechnung (bill) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 25, 'D'                              --Abrechnung (bill) DELETE -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapBillBillStatus', 'W', 25, 'D'                                 --Abrechnung (bill) DELETE -> mapBillBillStatus WRITE
    UNION ALL SELECT 'mapBillBillStatus', 'D', 25, 'D'                                 --Abrechnung (bill) DELETE -> mapBillBillStatus DELETE
    UNION ALL SELECT 'mapClientCompany', 'R', 25, 'D'                                  --Abrechnung (bill) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapBillBillStatus', 'R', 25, 'D'                                 --Abrechnung (bill) DELETE -> mapBillBillStatus READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 25, 'D'                   --Abrechnung (bill) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 25, 'D'                                    --Abrechnung (bill) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 25, 'D'                              --Abrechnung (bill) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 25, 'D'                       --Abrechnung (bill) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 25, 'D'                   --Abrechnung (bill) DELETE -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 25, 'D'                             --Abrechnung (bill) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 25, 'D'                                         --Abrechnung (bill) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 25, 'D'                                             --Abrechnung (bill) DELETE -> plant READ
    UNION ALL SELECT 'supplier', 'R', 25, 'D'                                          --Abrechnung (bill) DELETE -> supplier READ
    UNION ALL SELECT 'unit', 'R', 25, 'D'                                              --Abrechnung (bill) DELETE -> unit READ
    UNION ALL SELECT 'turnus', 'R', 25, 'D'                                            --Abrechnung (bill) DELETE -> turnus READ
    UNION ALL SELECT 'standardDiscount', 'R', 25, 'D'                                  --Abrechnung (bill) DELETE -> standardDiscount READ
    UNION ALL SELECT 'settlementType', 'R', 25, 'D'                                    --Abrechnung (bill) DELETE -> settlementType READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 25, 'D'                              --Abrechnung (bill) DELETE -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 25, 'D'                                --Abrechnung (bill) DELETE -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceOrder', 'R', 25, 'D'                                      --Abrechnung (bill) DELETE -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 25, 'D'                              --Abrechnung (bill) DELETE -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 25, 'D'                        --Abrechnung (bill) DELETE -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'sapOrder', 'R', 25, 'D'                                          --Abrechnung (bill) DELETE -> sapOrder READ
    UNION ALL SELECT 'usageType', 'R', 25, 'D'                                         --Abrechnung (bill) DELETE -> usageType READ
    UNION ALL SELECT 'wageCluster', 'R', 25, 'D'                                       --Abrechnung (bill) DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 25, 'D'                                         --Abrechnung (bill) DELETE -> wageGroup READ
    UNION ALL SELECT 'plant', 'R', 26, 'R'                                             --Reporting () READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 26, 'R'                                         --Reporting () READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 26, 'R'                             --Reporting () READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 26, 'R'                       --Reporting () READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 26, 'R'                              --Reporting () READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 26, 'R'                                    --Reporting () READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 26, 'R'                   --Reporting () READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 26, 'R'                                  --Reporting () READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 26, 'R'                         --Reporting () READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 26, 'R'                                          --Reporting () READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 26, 'R'                                          --Reporting () READ   -> language READ
    UNION ALL SELECT 'currency', 'R', 26, 'R'                                          --Reporting () READ   -> currency READ
    UNION ALL SELECT 'company', 'R', 26, 'R'                                           --Reporting () READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 26, 'R'                                        --Reporting () READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 26, 'R'                                  --Reporting () READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 26, 'R'                                            --Reporting () READ   -> client READ
    UNION ALL SELECT 'client', 'R', 26, 'W'                                            --Reporting () WRITE  -> client READ
    UNION ALL SELECT 'clientRole', 'R', 26, 'W'                                        --Reporting () WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 26, 'W'                                  --Reporting () WRITE  -> clientPermission READ
    UNION ALL SELECT 'company', 'R', 26, 'W'                                           --Reporting () WRITE  -> company READ
    UNION ALL SELECT 'language', 'R', 26, 'W'                                          --Reporting () WRITE  -> language READ
    UNION ALL SELECT 'currency', 'R', 26, 'W'                                          --Reporting () WRITE  -> currency READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 26, 'W'                         --Reporting () WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 26, 'W'                                          --Reporting () WRITE  -> mainCode READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 26, 'W'                   --Reporting () WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 26, 'W'                                  --Reporting () WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 26, 'W'                              --Reporting () WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 26, 'W'                                    --Reporting () WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 26, 'W'                             --Reporting () WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 26, 'W'                       --Reporting () WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'parameter', 'R', 26, 'W'                                         --Reporting () WRITE  -> parameter READ
    UNION ALL SELECT 'plant', 'R', 26, 'W'                                             --Reporting () WRITE  -> plant READ
    UNION ALL SELECT 'plant', 'R', 26, 'D'                                             --Reporting () DELETE -> plant READ
    UNION ALL SELECT 'parameter', 'R', 26, 'D'                                         --Reporting () DELETE -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 26, 'D'                             --Reporting () DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapClientPlant', 'R', 26, 'D'                                    --Reporting () DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 26, 'D'                              --Reporting () DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 26, 'D'                       --Reporting () DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 26, 'D'                   --Reporting () DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 26, 'D'                         --Reporting () DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 26, 'D'                                  --Reporting () DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mainCode', 'R', 26, 'D'                                          --Reporting () DELETE -> mainCode READ
    UNION ALL SELECT 'language', 'R', 26, 'D'                                          --Reporting () DELETE -> language READ
    UNION ALL SELECT 'currency', 'R', 26, 'D'                                          --Reporting () DELETE -> currency READ
    UNION ALL SELECT 'company', 'R', 26, 'D'                                           --Reporting () DELETE -> company READ
    UNION ALL SELECT 'clientRole', 'R', 26, 'D'                                        --Reporting () DELETE -> clientRole READ
    UNION ALL SELECT 'client', 'R', 26, 'D'                                            --Reporting () DELETE -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 26, 'D'                                  --Reporting () DELETE -> clientPermission READ
    UNION ALL SELECT 'billStatus', 'R', 27, 'R'                                        --Administration () READ   -> billStatus READ
    UNION ALL SELECT 'calendar', 'R', 27, 'R'                                          --Administration () READ   -> calendar READ
    UNION ALL SELECT 'client', 'R', 27, 'R'                                            --Administration () READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 27, 'R'                                  --Administration () READ   -> clientPermission READ
    UNION ALL SELECT 'additionalShift', 'R', 27, 'R'                                   --Administration () READ   -> additionalShift READ
    UNION ALL SELECT 'area', 'R', 27, 'R'                                              --Administration () READ   -> area READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 27, 'R'                                   --Administration () READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'attachedDocument', 'R', 27, 'R'                                  --Administration () READ   -> attachedDocument READ
    UNION ALL SELECT 'billPosition', 'R', 27, 'R'                                      --Administration () READ   -> billPosition READ
    UNION ALL SELECT 'bill', 'R', 27, 'R'                                              --Administration () READ   -> bill READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 27, 'R'                           --Administration () READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'clientRole', 'R', 27, 'R'                                        --Administration () READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 27, 'R'                                           --Administration () READ   -> company READ
    UNION ALL SELECT 'costCenter', 'R', 27, 'R'                                        --Administration () READ   -> costCenter READ
    UNION ALL SELECT 'cycle', 'R', 27, 'R'                                             --Administration () READ   -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'R', 27, 'R'                              --Administration () READ   -> customCleaningObject READ
    UNION ALL SELECT 'ffg', 'R', 27, 'R'                                               --Administration () READ   -> ffg READ
    UNION ALL SELECT 'dayType', 'R', 27, 'R'                                           --Administration () READ   -> dayType READ
    UNION ALL SELECT 'executionDay', 'R', 27, 'R'                                      --Administration () READ   -> executionDay READ
    UNION ALL SELECT 'language', 'R', 27, 'R'                                          --Administration () READ   -> language READ
    UNION ALL SELECT 'lvAlloc', 'R', 27, 'R'                                           --Administration () READ   -> lvAlloc READ
    UNION ALL SELECT 'location', 'R', 27, 'R'                                          --Administration () READ   -> location READ
    UNION ALL SELECT 'flooring', 'R', 27, 'R'                                          --Administration () READ   -> flooring READ
    UNION ALL SELECT 'mainCode', 'R', 27, 'R'                                          --Administration () READ   -> mainCode READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 27, 'R'                              --Administration () READ   -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapBillBillStatus', 'R', 27, 'R'                                 --Administration () READ   -> mapBillBillStatus READ
    UNION ALL SELECT 'mappriceCatalogCalculationAdditionalShift', 'R', 27, 'R'                 --Administration () READ   -> mappriceCatalogCalculationAdditionalShift READ
    UNION ALL SELECT 'mappriceCatalogCalculationSite', 'R', 27, 'R'                            --Administration () READ   -> mappriceCatalogCalculationSite READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 27, 'R'                         --Administration () READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 27, 'R'                                  --Administration () READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 27, 'R'                   --Administration () READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 27, 'R'                                    --Administration () READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 27, 'R'                    --Administration () READ   -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 27, 'R'                              --Administration () READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 27, 'R'                   --Administration () READ   -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 27, 'R'                  --Administration () READ   -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 27, 'R'                             --Administration () READ   -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 27, 'R'                       --Administration () READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 27, 'R'              --Administration () READ   -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 27, 'R'                             --Administration () READ   -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 27, 'R'                   --Administration () READ   -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 27, 'R'                              --Administration () READ   -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 27, 'R'                               --Administration () READ   -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 27, 'R'                --Administration () READ   -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 27, 'R'               --Administration () READ   -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 27, 'R'                                --Administration () READ   -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSupplierPlant', 'R', 27, 'R'                                  --Administration () READ   -> mapSupplierPlant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 27, 'R'                             --Administration () READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'orgUnit', 'R', 27, 'R'                                           --Administration () READ   -> orgUnit READ
    UNION ALL SELECT 'plant', 'R', 27, 'R'                                             --Administration () READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 27, 'R'                                         --Administration () READ   -> parameter READ
    UNION ALL SELECT 'priceCatalog', 'R', 27, 'R'                                      --Administration () READ   -> priceCatalog READ
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 27, 'R'                     --Administration () READ   -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 27, 'R'                   --Administration () READ   -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 27, 'R'                           --Administration () READ   -> priceCatalogCalculation READ
    UNION ALL SELECT 'sapOrder', 'R', 27, 'R'                                          --Administration () READ   -> sapOrder READ
    UNION ALL SELECT 'priceCatalogStatus', 'R', 27, 'R'                                --Administration () READ   -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogPosition', 'R', 27, 'R'                              --Administration () READ   -> priceCatalogPosition READ
    UNION ALL SELECT 'serviceCatalog', 'R', 27, 'R'                                    --Administration () READ   -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 27, 'R'                                     --Administration () READ   -> serviceObject READ
    UNION ALL SELECT 'serviceCategory', 'R', 27, 'R'                                   --Administration () READ   -> serviceCategory READ
    UNION ALL SELECT 'serviceOrder', 'R', 27, 'R'                                      --Administration () READ   -> serviceOrder READ
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 27, 'R'                              --Administration () READ   -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceObjectType', 'R', 27, 'R'                                 --Administration () READ   -> serviceObjectType READ
    UNION ALL SELECT 'serviceOrderPosition', 'R', 27, 'R'                              --Administration () READ   -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 27, 'R'                        --Administration () READ   -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderStatus', 'R', 27, 'R'                                --Administration () READ   -> serviceOrderStatus READ
    UNION ALL SELECT 'settlementType', 'R', 27, 'R'                                    --Administration () READ   -> settlementType READ
    UNION ALL SELECT 'serviceType', 'R', 27, 'R'                                       --Administration () READ   -> serviceType READ
    UNION ALL SELECT 'servicePosition', 'R', 27, 'R'                                   --Administration () READ   -> servicePosition READ
    UNION ALL SELECT 'standardDiscount', 'R', 27, 'R'                                  --Administration () READ   -> standardDiscount READ
    UNION ALL SELECT 'standard', 'R', 27, 'R'                                          --Administration () READ   -> standard READ
    UNION ALL SELECT 'site', 'R', 27, 'R'                                              --Administration () READ   -> site READ
    UNION ALL SELECT 'siteCatalog', 'R', 27, 'R'                                       --Administration () READ   -> siteCatalog READ
    UNION ALL SELECT 'siteCatalogPosition', 'R', 27, 'R'                               --Administration () READ   -> siteCatalogPosition READ
    UNION ALL SELECT 'turnus', 'R', 27, 'R'                                            --Administration () READ   -> turnus READ
    UNION ALL SELECT 'unit', 'R', 27, 'R'                                              --Administration () READ   -> unit READ
    UNION ALL SELECT 'supplier', 'R', 27, 'R'                                          --Administration () READ   -> supplier READ
    UNION ALL SELECT 'technicalCleaningObject', 'R', 27, 'R'                           --Administration () READ   -> technicalCleaningObject READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 27, 'R'                       --Administration () READ   -> technicalCleaningObjectType READ
    UNION ALL SELECT 'wageCluster', 'R', 27, 'R'                                       --Administration () READ   -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 27, 'R'                                         --Administration () READ   -> wageGroup READ
    UNION ALL SELECT 'usageType', 'R', 27, 'R'                                         --Administration () READ   -> usageType READ
    UNION ALL SELECT 'wageCluster', 'W', 27, 'W'                                       --Administration () WRITE  -> wageGroup WRITE
    UNION ALL SELECT 'wageGroup', 'W', 27, 'W'                                         --Administration () WRITE  -> wageGroup WRITE
    UNION ALL SELECT 'wageCluster', 'D', 27, 'W'                                       --Administration () WRITE  -> wageGroup DELETE
    UNION ALL SELECT 'wageGroup', 'D', 27, 'W'                                         --Administration () WRITE  -> wageGroup DELETE
    UNION ALL SELECT 'wageCluster', 'R', 27, 'W'                                       --Administration () WRITE  -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 27, 'W'                                         --Administration () WRITE  -> wageGroup READ
    UNION ALL SELECT 'unit', 'W', 27, 'W'                                              --Administration () WRITE  -> unit WRITE
    UNION ALL SELECT 'unit', 'D', 27, 'W'                                              --Administration () WRITE  -> unit DELETE
    UNION ALL SELECT 'supplier', 'W', 27, 'W'                                          --Administration () WRITE  -> supplier WRITE
    UNION ALL SELECT 'usageType', 'R', 27, 'W'                                         --Administration () WRITE  -> usageType READ
    UNION ALL SELECT 'technicalCleaningObject', 'W', 27, 'W'                           --Administration () WRITE  -> technicalCleaningObject WRITE
    UNION ALL SELECT 'technicalCleaningObject', 'R', 27, 'W'                           --Administration () WRITE  -> technicalCleaningObject READ
    UNION ALL SELECT 'turnus', 'D', 27, 'W'                                            --Administration () WRITE  -> turnus DELETE
    UNION ALL SELECT 'supplier', 'D', 27, 'W'                                          --Administration () WRITE  -> supplier DELETE
    UNION ALL SELECT 'technicalCleaningObjectType', 'D', 27, 'W'                       --Administration () WRITE  -> technicalCleaningObjectType DELETE
    UNION ALL SELECT 'technicalCleaningObject', 'D', 27, 'W'                           --Administration () WRITE  -> technicalCleaningObject DELETE
    UNION ALL SELECT 'usageType', 'W', 27, 'W'                                         --Administration () WRITE  -> usageType WRITE
    UNION ALL SELECT 'usageType', 'D', 27, 'W'                                         --Administration () WRITE  -> usageType DELETE
    UNION ALL SELECT 'supplier', 'R', 27, 'W'                                          --Administration () WRITE  -> supplier READ
    UNION ALL SELECT 'standardDiscount', 'W', 27, 'W'                                  --Administration () WRITE  -> standardDiscount WRITE
    UNION ALL SELECT 'turnus', 'W', 27, 'W'                                            --Administration () WRITE  -> turnus WRITE
    UNION ALL SELECT 'unit', 'R', 27, 'W'                                              --Administration () WRITE  -> unit READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'W', 27, 'W'                       --Administration () WRITE  -> technicalCleaningObjectType WRITE
    UNION ALL SELECT 'turnus', 'R', 27, 'W'                                            --Administration () WRITE  -> turnus READ
    UNION ALL SELECT 'siteCatalogPosition', 'R', 27, 'W'                               --Administration () WRITE  -> siteCatalogPosition READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 27, 'W'                       --Administration () WRITE  -> technicalCleaningObjectType READ
    UNION ALL SELECT 'siteCatalog', 'D', 27, 'W'                                       --Administration () WRITE  -> siteCatalog DELETE
    UNION ALL SELECT 'siteCatalog', 'R', 27, 'W'                                       --Administration () WRITE  -> siteCatalog READ
    UNION ALL SELECT 'siteCatalog', 'W', 27, 'W'                                       --Administration () WRITE  -> siteCatalog WRITE
    UNION ALL SELECT 'standardDiscount', 'D', 27, 'W'                                  --Administration () WRITE  -> standardDiscount DELETE
    UNION ALL SELECT 'siteCatalogPosition', 'D', 27, 'W'                               --Administration () WRITE  -> siteCatalogPosition DELETE
    UNION ALL SELECT 'site', 'R', 27, 'W'                                              --Administration () WRITE  -> site READ
    UNION ALL SELECT 'standard', 'D', 27, 'W'                                          --Administration () WRITE  -> standard DELETE
    UNION ALL SELECT 'standard', 'R', 27, 'W'                                          --Administration () WRITE  -> standard READ
    UNION ALL SELECT 'standard', 'W', 27, 'W'                                          --Administration () WRITE  -> standard WRITE
    UNION ALL SELECT 'siteCatalogPosition', 'W', 27, 'W'                               --Administration () WRITE  -> siteCatalogPosition WRITE
    UNION ALL SELECT 'standardDiscount', 'R', 27, 'W'                                  --Administration () WRITE  -> standardDiscount READ
    UNION ALL SELECT 'settlementType', 'W', 27, 'W'                                    --Administration () WRITE  -> settlementType WRITE
    UNION ALL SELECT 'servicePosition', 'R', 27, 'W'                                   --Administration () WRITE  -> servicePosition READ
    UNION ALL SELECT 'settlementType', 'D', 27, 'W'                                    --Administration () WRITE  -> settlementType DELETE
    UNION ALL SELECT 'settlementType', 'R', 27, 'W'                                    --Administration () WRITE  -> settlementType READ
    UNION ALL SELECT 'servicePosition', 'D', 27, 'W'                                   --Administration () WRITE  -> servicePosition DELETE
    UNION ALL SELECT 'serviceOrderStatus', 'R', 27, 'W'                                --Administration () WRITE  -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceOrderStatus', 'W', 27, 'W'                                --Administration () WRITE  -> serviceOrderStatus WRITE
    UNION ALL SELECT 'servicePosition', 'W', 27, 'W'                                   --Administration () WRITE  -> servicePosition WRITE
    UNION ALL SELECT 'serviceType', 'D', 27, 'W'                                       --Administration () WRITE  -> serviceType DELETE
    UNION ALL SELECT 'serviceType', 'R', 27, 'W'                                       --Administration () WRITE  -> serviceType READ
    UNION ALL SELECT 'serviceType', 'W', 27, 'W'                                       --Administration () WRITE  -> serviceType WRITE
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 27, 'W'                        --Administration () WRITE  -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceOrderPositionStatus', 'W', 27, 'W'                        --Administration () WRITE  -> serviceOrderPositionStatus WRITE
    UNION ALL SELECT 'serviceObject', 'D', 27, 'W'                                     --Administration () WRITE  -> serviceObject DELETE
    UNION ALL SELECT 'serviceObject', 'W', 27, 'W'                                     --Administration () WRITE  -> serviceObject WRITE
    UNION ALL SELECT 'serviceObjectType', 'D', 27, 'W'                                 --Administration () WRITE  -> serviceObjectType DELETE
    UNION ALL SELECT 'serviceOrderStatus', 'D', 27, 'W'                                --Administration () WRITE  -> serviceOrderStatus DELETE
    UNION ALL SELECT 'serviceOrderPosition', 'W', 27, 'W'                              --Administration () WRITE  -> serviceOrderPosition WRITE
	UNION ALL SELECT 'customCleaningObject', 'W', 27, 'W'                              --Administration () WRITE  -> customCleaningObject WRITE
    UNION ALL SELECT 'serviceOrderPositionStatus', 'D', 27, 'W'                        --Administration () WRITE  -> serviceOrderPositionStatus DELETE
    UNION ALL SELECT 'serviceOrderPosition', 'R', 27, 'W'                              --Administration () WRITE  -> serviceOrderPosition READ
    UNION ALL SELECT 'serviceOrderPosition', 'D', 27, 'W'                              --Administration () WRITE  -> serviceOrderPosition DELETE
    UNION ALL SELECT 'serviceOrder', 'D', 27, 'W'                                      --Administration () WRITE  -> serviceOrder DELETE
    UNION ALL SELECT 'serviceOrder', 'R', 27, 'W'                                      --Administration () WRITE  -> serviceOrder READ
    UNION ALL SELECT 'serviceOrder', 'W', 27, 'W'                                      --Administration () WRITE  -> serviceOrder WRITE
    UNION ALL SELECT 'serviceOrderCalendar', 'D', 27, 'W'                              --Administration () WRITE  -> serviceOrderCalendar DELETE
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 27, 'W'                              --Administration () WRITE  -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceOrderCalendar', 'W', 27, 'W'                              --Administration () WRITE  -> serviceOrderCalendar WRITE
    UNION ALL SELECT 'serviceCategory', 'W', 27, 'W'                                   --Administration () WRITE  -> serviceCategory WRITE
    UNION ALL SELECT 'serviceCategory', 'R', 27, 'W'                                   --Administration () WRITE  -> serviceCategory READ
    UNION ALL SELECT 'serviceObjectType', 'R', 27, 'W'                                 --Administration () WRITE  -> serviceObjectType READ
    UNION ALL SELECT 'serviceObjectType', 'W', 27, 'W'                                 --Administration () WRITE  -> serviceObjectType WRITE
    UNION ALL SELECT 'serviceObject', 'R', 27, 'W'                                     --Administration () WRITE  -> serviceObject READ
    UNION ALL SELECT 'priceCatalogStatus', 'D', 27, 'W'                                --Administration () WRITE  -> priceCatalogStatus DELETE
    UNION ALL SELECT 'serviceCatalog', 'D', 27, 'W'                                    --Administration () WRITE  -> serviceCatalog DELETE
    UNION ALL SELECT 'serviceCatalog', 'R', 27, 'W'                                    --Administration () WRITE  -> serviceCatalog READ
    UNION ALL SELECT 'serviceCatalog', 'W', 27, 'W'                                    --Administration () WRITE  -> serviceCatalog WRITE
    UNION ALL SELECT 'serviceCategory', 'D', 27, 'W'                                   --Administration () WRITE  -> serviceCategory DELETE
    UNION ALL SELECT 'priceCatalogPosition', 'R', 27, 'W'                              --Administration () WRITE  -> priceCatalogPosition READ
    UNION ALL SELECT 'priceCatalogPosition', 'W', 27, 'W'                              --Administration () WRITE  -> priceCatalogPosition WRITE
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 27, 'W'                           --Administration () WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogStatus', 'W', 27, 'W'                                --Administration () WRITE  -> priceCatalogStatus WRITE
    UNION ALL SELECT 'sapOrder', 'D', 27, 'W'                                          --Administration () WRITE  -> sapOrder DELETE
    UNION ALL SELECT 'sapOrder', 'R', 27, 'W'                                          --Administration () WRITE  -> sapOrder READ
    UNION ALL SELECT 'sapOrder', 'W', 27, 'W'                                          --Administration () WRITE  -> sapOrder WRITE
    UNION ALL SELECT 'priceCatalogStatus', 'R', 27, 'W'                                --Administration () WRITE  -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogCalculation', 'D', 27, 'W'                           --Administration () WRITE  -> priceCatalogCalculation DELETE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 27, 'W'                   --Administration () WRITE  -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 27, 'W'                           --Administration () WRITE  -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 27, 'W'                   --Administration () WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 27, 'W'                   --Administration () WRITE  -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'W', 27, 'W'                     --Administration () WRITE  -> priceCatalogCalculationStatus WRITE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'D', 27, 'W'                     --Administration () WRITE  -> priceCatalogCalculationStatus DELETE
    UNION ALL SELECT 'priceCatalogPosition', 'D', 27, 'W'                              --Administration () WRITE  -> priceCatalogPosition DELETE
    UNION ALL SELECT 'parameter', 'W', 27, 'W'                                         --Administration () WRITE  -> parameter WRITE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 27, 'W'                     --Administration () WRITE  -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'orgUnit', 'R', 27, 'W'                                           --Administration () WRITE  -> orgUnit READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'W', 27, 'W'                             --Administration () WRITE  -> mapTurnusExecutionDay WRITE
    UNION ALL SELECT 'parameter', 'R', 27, 'W'                                         --Administration () WRITE  -> parameter READ
    UNION ALL SELECT 'parameter', 'D', 27, 'W'                                         --Administration () WRITE  -> parameter DELETE
    UNION ALL SELECT 'priceCatalog', 'D', 27, 'W'                                      --Administration () WRITE  -> priceCatalog DELETE
    UNION ALL SELECT 'plant', 'R', 27, 'W'                                             --Administration () WRITE  -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 27, 'W'                                      --Administration () WRITE  -> priceCatalog READ
    UNION ALL SELECT 'priceCatalog', 'W', 27, 'W'                                      --Administration () WRITE  -> priceCatalog WRITE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'D', 27, 'W'                             --Administration () WRITE  -> mapTurnusExecutionDay DELETE
    UNION ALL SELECT 'mapSupplierPlant', 'D', 27, 'W'                                  --Administration () WRITE  -> mapSupplierPlant DELETE
    UNION ALL SELECT 'mapSupplierPlant', 'W', 27, 'W'                                  --Administration () WRITE  -> mapSupplierPlant WRITE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 27, 'W'                             --Administration () WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'W', 27, 'W'                                --Administration () WRITE  -> mapSiteCatalogSite WRITE
    UNION ALL SELECT 'mapSiteCatalogSite', 'D', 27, 'W'                                --Administration () WRITE  -> mapSiteCatalogSite DELETE
    UNION ALL SELECT 'mapSupplierPlant', 'R', 27, 'W'                                  --Administration () WRITE  -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 27, 'W'                                --Administration () WRITE  -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'D', 27, 'W'               --Administration () WRITE  -> mapSiteCatalogPositionServiceObject DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 27, 'W'               --Administration () WRITE  -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'W', 27, 'W'               --Administration () WRITE  -> mapSiteCatalogPositionServiceObject WRITE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'D', 27, 'W'                --Administration () WRITE  -> mapSiteCatalogPositionExecutionDay DELETE
    UNION ALL SELECT 'mapSiteCatalogClient', 'W', 27, 'W'                              --Administration () WRITE  -> mapSiteCatalogClient WRITE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'W', 27, 'W'                --Administration () WRITE  -> mapSiteCatalogPositionExecutionDay WRITE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 27, 'W'                               --Administration () WRITE  -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'W', 27, 'W'                               --Administration () WRITE  -> mapSiteCatalogPlant WRITE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'D', 27, 'W'                               --Administration () WRITE  -> mapSiteCatalogPlant DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 27, 'W'                --Administration () WRITE  -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 27, 'W'                              --Administration () WRITE  -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'D', 27, 'W'                  --Administration () WRITE  -> mapServiceCatalogServicePosition DELETE
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 27, 'W'                   --Administration () WRITE  -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 27, 'W'                  --Administration () WRITE  -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapPriceCatalogClient', 'W', 27, 'W'                             --Administration () WRITE  -> mapPriceCatalogClient WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'D', 27, 'W'                              --Administration () WRITE  -> mapSiteCatalogClient DELETE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'W', 27, 'W'              --Administration () WRITE  -> mapServiceOrderPositionServiceObject WRITE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'D', 27, 'W'              --Administration () WRITE  -> mapServiceOrderPositionServiceObject DELETE
    UNION ALL SELECT 'mapServicePositionUsageType', 'W', 27, 'W'                       --Administration () WRITE  -> mapServicePositionUsageType WRITE
    UNION ALL SELECT 'mapServicePositionUsageType', 'D', 27, 'W'                       --Administration () WRITE  -> mapServicePositionUsageType DELETE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'W', 27, 'W'                  --Administration () WRITE  -> mapServiceCatalogServicePosition WRITE
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 27, 'W'                             --Administration () WRITE  -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderClient', 'D', 27, 'W'                             --Administration () WRITE  -> mapServiceOrderClient DELETE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 27, 'W'              --Administration () WRITE  -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 27, 'W'                   --Administration () WRITE  -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 27, 'W'                       --Administration () WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 27, 'W'                   --Administration () WRITE  -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderClient', 'W', 27, 'W'                             --Administration () WRITE  -> mapServiceOrderClient WRITE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'D', 27, 'W'                   --Administration () WRITE  -> mapPriceCatalogAttachedDocument DELETE
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'W', 27, 'W'                    --Administration () WRITE  -> mapPriceCatalogAdditionalShift WRITE
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 27, 'W'                    --Administration () WRITE  -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'D', 27, 'W'                    --Administration () WRITE  -> mapPriceCatalogAdditionalShift DELETE
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 27, 'W'                             --Administration () WRITE  -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapClientPlant', 'D', 27, 'W'                                    --Administration () WRITE  -> mapClientPlant DELETE
    UNION ALL SELECT 'mapPriceCatalogClient', 'D', 27, 'W'                             --Administration () WRITE  -> mapPriceCatalogClient DELETE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'W', 27, 'W'                   --Administration () WRITE  -> mapPriceCatalogAttachedDocument WRITE
    UNION ALL SELECT 'mapClientPlant', 'W', 27, 'W'                                    --Administration () WRITE  -> mapClientPlant WRITE
    UNION ALL SELECT 'mapMainCodeUsageType', 'D', 27, 'W'                              --Administration () WRITE  -> mapMainCodeUsageType DELETE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 27, 'W'                   --Administration () WRITE  -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 27, 'W'                              --Administration () WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'W', 27, 'W'                              --Administration () WRITE  -> mapMainCodeUsageType WRITE
    UNION ALL SELECT 'mapClientPlant', 'R', 27, 'W'                                    --Administration () WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'W', 27, 'W'                   --Administration () WRITE  -> mapClientPermissionDefaultPlant WRITE
    UNION ALL SELECT 'mapClientCompany', 'W', 27, 'W'                                  --Administration () WRITE  -> mapClientCompany WRITE
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'D', 27, 'W'                   --Administration () WRITE  -> mapClientPermissionDefaultPlant DELETE
    UNION ALL SELECT 'mapCalendarPlantSite', 'W', 27, 'W'                              --Administration () WRITE  -> mapCalendarPlantSite WRITE
    UNION ALL SELECT 'mapClientClientPermission', 'D', 27, 'W'                         --Administration () WRITE  -> mapClientClientPermission DELETE
    UNION ALL SELECT 'mapClientClientPermission', 'W', 27, 'W'                         --Administration () WRITE  -> mapClientClientPermission WRITE
    UNION ALL SELECT 'mapClientCompany', 'D', 27, 'W'                                  --Administration () WRITE  -> mapClientCompany DELETE
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 27, 'W'                   --Administration () WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 27, 'W'                                  --Administration () WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 27, 'W'                         --Administration () WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mapBillBillStatus', 'D', 27, 'W'                                 --Administration () WRITE  -> mapBillBillStatus DELETE
    UNION ALL SELECT 'mapBillBillStatus', 'R', 27, 'W'                                 --Administration () WRITE  -> mapBillBillStatus READ
    UNION ALL SELECT 'mapBillBillStatus', 'W', 27, 'W'                                 --Administration () WRITE  -> mapBillBillStatus WRITE
    UNION ALL SELECT 'location', 'R', 27, 'W'                                          --Administration () WRITE  -> location READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'D', 27, 'W'                              --Administration () WRITE  -> mapCalendarPlantSite DELETE
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 27, 'W'                              --Administration () WRITE  -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mainCode', 'W', 27, 'W'                                          --Administration () WRITE  -> mainCode WRITE
    UNION ALL SELECT 'mainCode', 'D', 27, 'W'                                          --Administration () WRITE  -> mainCode DELETE
    UNION ALL SELECT 'language', 'D', 27, 'W'                                          --Administration () WRITE  -> language DELETE
    UNION ALL SELECT 'language', 'W', 27, 'W'                                          --Administration () WRITE  -> language WRITE
    UNION ALL SELECT 'mainCode', 'R', 27, 'W'                                          --Administration () WRITE  -> mainCode READ
    UNION ALL SELECT 'lvAlloc', 'R', 27, 'W'                                           --Administration () WRITE  -> lvAlloc READ
    UNION ALL SELECT 'flooring', 'R', 27, 'W'                                          --Administration () WRITE  -> flooring READ
    UNION ALL SELECT 'language', 'R', 27, 'W'                                          --Administration () WRITE  -> language READ
    UNION ALL SELECT 'executionDay', 'R', 27, 'W'                                      --Administration () WRITE  -> executionDay READ
    UNION ALL SELECT 'dayType', 'W', 27, 'W'                                           --Administration () WRITE  -> dayType WRITE
    UNION ALL SELECT 'customCleaningObject', 'W', 27, 'W'                              --Administration () WRITE  -> customCleaningObject WRITE
    UNION ALL SELECT 'dayType', 'R', 27, 'W'                                           --Administration () WRITE  -> dayType READ
    UNION ALL SELECT 'executionDay', 'W', 27, 'W'                                      --Administration () WRITE  -> executionDay WRITE
    UNION ALL SELECT 'executionDay', 'D', 27, 'W'                                      --Administration () WRITE  -> executionDay DELETE
    UNION ALL SELECT 'customCleaningObject', 'R', 27, 'W'                              --Administration () WRITE  -> customCleaningObject READ
    UNION ALL SELECT 'customCleaningObject', 'D', 27, 'W'                              --Administration () WRITE  -> customCleaningObject DELETE
    UNION ALL SELECT 'dayType', 'D', 27, 'W'                                           --Administration () WRITE  -> dayType DELETE
    UNION ALL SELECT 'ffg', 'R', 27, 'W'                                               --Administration () WRITE  -> ffg READ
    UNION ALL SELECT 'costCenter', 'R', 27, 'W'                                        --Administration () WRITE  -> costCenter READ
    UNION ALL SELECT 'currency', 'D', 27, 'W'                                          --Administration () WRITE  -> currency DELETE
    UNION ALL SELECT 'cycle', 'R', 27, 'W'                                             --Administration () WRITE  -> cycle READ
    UNION ALL SELECT 'company', 'W', 27, 'W'                                           --Administration () WRITE  -> company WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 27, 'W'                   --Administration () WRITE  -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'currency', 'W', 27, 'W'                                          --Administration () WRITE  -> currency WRITE
    UNION ALL SELECT 'client', 'W', 27, 'W'                                            --Administration () WRITE  -> client WRITE
    UNION ALL SELECT 'clientPermission', 'D', 27, 'W'                                  --Administration () WRITE  -> clientPermission DELETE
    UNION ALL SELECT 'clientPermission', 'W', 27, 'W'                                  --Administration () WRITE  -> clientPermission WRITE
    UNION ALL SELECT 'clientRole', 'D', 27, 'W'                                        --Administration () WRITE  -> clientRole DELETE
    UNION ALL SELECT 'company', 'R', 27, 'W'                                           --Administration () WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'W', 27, 'W'                                        --Administration () WRITE  -> clientRole WRITE
    UNION ALL SELECT 'company', 'D', 27, 'W'                                           --Administration () WRITE  -> company DELETE
    UNION ALL SELECT 'clientRole', 'R', 27, 'W'                                        --Administration () WRITE  -> clientRole READ
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 27, 'W'                           --Administration () WRITE  -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'clientPermission', 'R', 27, 'W'                                  --Administration () WRITE  -> clientPermission READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 27, 'W'                   --Administration () WRITE  -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 27, 'W'                           --Administration () WRITE  -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogCalculation', 'D', 27, 'W'                           --Administration () WRITE  -> priceCatalogCalculation DELETE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 27, 'W'                   --Administration () WRITE  -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'bill', 'D', 27, 'W'                                              --Administration () WRITE  -> bill DELETE
    UNION ALL SELECT 'billPosition', 'D', 27, 'W'                                      --Administration () WRITE  -> billPosition DELETE
    UNION ALL SELECT 'bill', 'W', 27, 'W'                                              --Administration () WRITE  -> bill WRITE
    UNION ALL SELECT 'attachedDocument', 'R', 27, 'W'                                  --Administration () WRITE  -> attachedDocument READ
    UNION ALL SELECT 'bill', 'R', 27, 'W'                                              --Administration () WRITE  -> bill READ
    UNION ALL SELECT 'attachedDocument', 'D', 27, 'W'                                  --Administration () WRITE  -> attachedDocument DELETE
    UNION ALL SELECT 'area', 'R', 27, 'W'                                              --Administration () WRITE  -> area READ
    UNION ALL SELECT 'additionalShift', 'D', 27, 'W'                                   --Administration () WRITE  -> additionalShift DELETE
    UNION ALL SELECT 'attachedDocument', 'W', 27, 'W'                                  --Administration () WRITE  -> attachedDocument WRITE
    UNION ALL SELECT 'additionalShift', 'R', 27, 'W'                                   --Administration () WRITE  -> additionalShift READ
    UNION ALL SELECT 'additionalShift', 'W', 27, 'W'                                   --Administration () WRITE  -> additionalShift WRITE
    UNION ALL SELECT 'client', 'R', 27, 'W'                                            --Administration () WRITE  -> client READ
    UNION ALL SELECT 'calendar', 'R', 27, 'W'                                          --Administration () WRITE  -> calendar READ
    UNION ALL SELECT 'calendar', 'D', 27, 'W'                                          --Administration () WRITE  -> calendar DELETE
    UNION ALL SELECT 'billPosition', 'W', 27, 'W'                                      --Administration () WRITE  -> billPosition WRITE
    UNION ALL SELECT 'billStatus', 'D', 27, 'W'                                        --Administration () WRITE  -> billStatus DELETE
    UNION ALL SELECT 'billPosition', 'R', 27, 'W'                                      --Administration () WRITE  -> billPosition READ
    UNION ALL SELECT 'calendarDay', 'W', 27, 'W'                                       --Administration () WRITE  -> calendarDay WRITE
    UNION ALL SELECT 'client', 'D', 27, 'W'                                            --Administration () WRITE  -> client DELETE
    UNION ALL SELECT 'billStatus', 'W', 27, 'W'                                        --Administration () WRITE  -> billStatus WRITE
    UNION ALL SELECT 'billStatus', 'R', 27, 'W'                                        --Administration () WRITE  -> billStatus READ
    UNION ALL SELECT 'calendarDay', 'D', 27, 'W'                                       --Administration () WRITE  -> calendarDay DELETE
    UNION ALL SELECT 'calendar', 'W', 27, 'W'                                          --Administration () WRITE  -> calendar WRITE
    UNION ALL SELECT 'calendar', 'W', 27, 'D'                                          --Administration () DELETE -> calendar WRITE
    UNION ALL SELECT 'calendarDay', 'D', 27, 'D'                                       --Administration () DELETE -> calendarDay DELETE
    UNION ALL SELECT 'billStatus', 'W', 27, 'D'                                        --Administration () DELETE -> billStatus WRITE
    UNION ALL SELECT 'calendarDay', 'W', 27, 'D'                                       --Administration () DELETE -> calendarDay WRITE
    UNION ALL SELECT 'client', 'D', 27, 'D'                                            --Administration () DELETE -> client DELETE
    UNION ALL SELECT 'client', 'R', 27, 'D'                                            --Administration () DELETE -> client READ
    UNION ALL SELECT 'calendar', 'R', 27, 'D'                                          --Administration () DELETE -> calendar READ
    UNION ALL SELECT 'billPosition', 'W', 27, 'D'                                      --Administration () DELETE -> billPosition WRITE
    UNION ALL SELECT 'billStatus', 'D', 27, 'D'                                        --Administration () DELETE -> billStatus DELETE
    UNION ALL SELECT 'billStatus', 'R', 27, 'D'                                        --Administration () DELETE -> billStatus READ
    UNION ALL SELECT 'calendar', 'D', 27, 'D'                                          --Administration () DELETE -> calendar DELETE
    UNION ALL SELECT 'clientPermission', 'R', 27, 'D'                                  --Administration () DELETE -> clientPermission READ
    UNION ALL SELECT 'additionalShift', 'R', 27, 'D'                                   --Administration () DELETE -> additionalShift READ
    UNION ALL SELECT 'area', 'R', 27, 'D'                                              --Administration () DELETE -> area READ
    UNION ALL SELECT 'additionalShift', 'W', 27, 'D'                                   --Administration () DELETE -> additionalShift WRITE
    UNION ALL SELECT 'priceCatalogCalculation', 'D', 27, 'D'                           --Administration () DELETE -> priceCatalogCalculation DELETE
    UNION ALL SELECT 'additionalShift', 'D', 27, 'D'                                   --Administration () DELETE -> additionalShift DELETE
    UNION ALL SELECT 'attachedDocument', 'D', 27, 'D'                                  --Administration () DELETE -> attachedDocument DELETE
    UNION ALL SELECT 'attachedDocument', 'R', 27, 'D'                                  --Administration () DELETE -> attachedDocument READ
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 27, 'D'                           --Administration () DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'attachedDocument', 'W', 27, 'D'                                  --Administration () DELETE -> attachedDocument WRITE
    UNION ALL SELECT 'bill', 'W', 27, 'D'                                              --Administration () DELETE -> bill WRITE
    UNION ALL SELECT 'billPosition', 'D', 27, 'D'                                      --Administration () DELETE -> billPosition DELETE
    UNION ALL SELECT 'billPosition', 'R', 27, 'D'                                      --Administration () DELETE -> billPosition READ
    UNION ALL SELECT 'bill', 'D', 27, 'D'                                              --Administration () DELETE -> bill DELETE
    UNION ALL SELECT 'bill', 'R', 27, 'D'                                              --Administration () DELETE -> bill READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 27, 'D'                   --Administration () DELETE -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 27, 'D'                   --Administration () DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 27, 'D'                   --Administration () DELETE -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 27, 'D'                           --Administration () DELETE -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'clientRole', 'R', 27, 'D'                                        --Administration () DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 27, 'D'                                           --Administration () DELETE -> company READ
    UNION ALL SELECT 'client', 'W', 27, 'D'                                            --Administration () DELETE -> client WRITE
    UNION ALL SELECT 'company', 'D', 27, 'D'                                           --Administration () DELETE -> company DELETE
    UNION ALL SELECT 'costCenter', 'R', 27, 'D'                                        --Administration () DELETE -> costCenter READ
    UNION ALL SELECT 'clientRole', 'W', 27, 'D'                                        --Administration () DELETE -> clientRole WRITE
    UNION ALL SELECT 'customCleaningObject', 'D', 27, 'D'                              --Administration () DELETE -> customCleaningObject DELETE
    UNION ALL SELECT 'company', 'W', 27, 'D'                                           --Administration () DELETE -> company WRITE
    UNION ALL SELECT 'clientRole', 'D', 27, 'D'                                        --Administration () DELETE -> clientRole DELETE
    UNION ALL SELECT 'clientPermission', 'W', 27, 'D'                                  --Administration () DELETE -> clientPermission WRITE
    UNION ALL SELECT 'clientPermission', 'D', 27, 'D'                                  --Administration () DELETE -> clientPermission DELETE
    UNION ALL SELECT 'currency', 'W', 27, 'D'                                          --Administration () DELETE -> currency WRITE
    UNION ALL SELECT 'dayType', 'D', 27, 'D'                                           --Administration () DELETE -> dayType DELETE
    UNION ALL SELECT 'currency', 'D', 27, 'D'                                          --Administration () DELETE -> currency DELETE
    UNION ALL SELECT 'language', 'R', 27, 'D'                                          --Administration () DELETE -> language READ
    UNION ALL SELECT 'flooring', 'R', 27, 'D'                                          --Administration () DELETE -> flooring READ
    UNION ALL SELECT 'customCleaningObject', 'W', 27, 'D'                              --Administration () DELETE -> customCleaningObject WRITE
    UNION ALL SELECT 'cycle', 'R', 27, 'D'                                             --Administration () DELETE -> cycle READ
    UNION ALL SELECT 'customCleaningObject', 'R', 27, 'D'                              --Administration () DELETE -> customCleaningObject READ
    UNION ALL SELECT 'executionDay', 'R', 27, 'D'                                      --Administration () DELETE -> executionDay READ
    UNION ALL SELECT 'executionDay', 'D', 27, 'D'                                      --Administration () DELETE -> executionDay DELETE
    UNION ALL SELECT 'dayType', 'W', 27, 'D'                                           --Administration () DELETE -> dayType WRITE
    UNION ALL SELECT 'ffg', 'R', 27, 'D'                                               --Administration () DELETE -> ffg READ
    UNION ALL SELECT 'dayType', 'R', 27, 'D'                                           --Administration () DELETE -> dayType READ
    UNION ALL SELECT 'executionDay', 'W', 27, 'D'                                      --Administration () DELETE -> executionDay WRITE
    UNION ALL SELECT 'lvAlloc', 'R', 27, 'D'                                           --Administration () DELETE -> lvAlloc READ
    UNION ALL SELECT 'language', 'D', 27, 'D'                                          --Administration () DELETE -> language DELETE
    UNION ALL SELECT 'location', 'R', 27, 'D'                                          --Administration () DELETE -> location READ
    UNION ALL SELECT 'mainCode', 'D', 27, 'D'                                          --Administration () DELETE -> mainCode DELETE
    UNION ALL SELECT 'mainCode', 'W', 27, 'D'                                          --Administration () DELETE -> mainCode WRITE
    UNION ALL SELECT 'mainCode', 'R', 27, 'D'                                          --Administration () DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 27, 'D'                         --Administration () DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'R', 27, 'D'                              --Administration () DELETE -> mapCalendarPlantSite READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'W', 27, 'D'                              --Administration () DELETE -> mapCalendarPlantSite WRITE
    UNION ALL SELECT 'mapBillBillStatus', 'R', 27, 'D'                                 --Administration () DELETE -> mapBillBillStatus READ
    UNION ALL SELECT 'mapCalendarPlantSite', 'D', 27, 'D'                              --Administration () DELETE -> mapCalendarPlantSite DELETE
    UNION ALL SELECT 'mapBillBillStatus', 'D', 27, 'D'                                 --Administration () DELETE -> mapBillBillStatus DELETE
    UNION ALL SELECT 'mapBillBillStatus', 'W', 27, 'D'                                 --Administration () DELETE -> mapBillBillStatus WRITE
    UNION ALL SELECT 'mapClientCompany', 'R', 27, 'D'                                  --Administration () DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 27, 'D'                   --Administration () DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 27, 'D'                                    --Administration () DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapClientCompany', 'W', 27, 'D'                                  --Administration () DELETE -> mapClientCompany WRITE
    UNION ALL SELECT 'mapClientCompany', 'D', 27, 'D'                                  --Administration () DELETE -> mapClientCompany DELETE
    UNION ALL SELECT 'mapClientClientPermission', 'W', 27, 'D'                         --Administration () DELETE -> mapClientClientPermission WRITE
    UNION ALL SELECT 'mapClientClientPermission', 'D', 27, 'D'                         --Administration () DELETE -> mapClientClientPermission DELETE
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'W', 27, 'D'                   --Administration () DELETE -> mapClientPermissionDefaultPlant WRITE
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'D', 27, 'D'                   --Administration () DELETE -> mapClientPermissionDefaultPlant DELETE
    UNION ALL SELECT 'mapClientPlant', 'D', 27, 'D'                                    --Administration () DELETE -> mapClientPlant DELETE
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 27, 'D'                              --Administration () DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'W', 27, 'D'                                    --Administration () DELETE -> mapClientPlant WRITE
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'R', 27, 'D'                    --Administration () DELETE -> mapPriceCatalogAdditionalShift READ
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'D', 27, 'D'                    --Administration () DELETE -> mapPriceCatalogAdditionalShift DELETE
    UNION ALL SELECT 'mapMainCodeUsageType', 'W', 27, 'D'                              --Administration () DELETE -> mapMainCodeUsageType WRITE
    UNION ALL SELECT 'mapMainCodeUsageType', 'D', 27, 'D'                              --Administration () DELETE -> mapMainCodeUsageType DELETE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'W', 27, 'D'                   --Administration () DELETE -> mapPriceCatalogAttachedDocument WRITE
    UNION ALL SELECT 'mapPriceCatalogClient', 'D', 27, 'D'                             --Administration () DELETE -> mapPriceCatalogClient DELETE
    UNION ALL SELECT 'mapPriceCatalogClient', 'W', 27, 'D'                             --Administration () DELETE -> mapPriceCatalogClient WRITE
    UNION ALL SELECT 'mapPriceCatalogAdditionalShift', 'W', 27, 'D'                    --Administration () DELETE -> mapPriceCatalogAdditionalShift WRITE
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'R', 27, 'D'                   --Administration () DELETE -> mapPriceCatalogAttachedDocument READ
    UNION ALL SELECT 'mapPriceCatalogAttachedDocument', 'D', 27, 'D'                   --Administration () DELETE -> mapPriceCatalogAttachedDocument DELETE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'D', 27, 'D'              --Administration () DELETE -> mapServiceOrderPositionServiceObject DELETE
    UNION ALL SELECT 'mapPriceCatalogClient', 'R', 27, 'D'                             --Administration () DELETE -> mapPriceCatalogClient READ
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'R', 27, 'D'                  --Administration () DELETE -> mapServiceCatalogServicePosition READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 27, 'D'                       --Administration () DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'R', 27, 'D'              --Administration () DELETE -> mapServiceOrderPositionServiceObject READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'W', 27, 'D'                   --Administration () DELETE -> mapServiceOrderAttachedDocument WRITE
    UNION ALL SELECT 'mapServiceOrderClient', 'D', 27, 'D'                             --Administration () DELETE -> mapServiceOrderClient DELETE
    UNION ALL SELECT 'mapServiceOrderClient', 'W', 27, 'D'                             --Administration () DELETE -> mapServiceOrderClient WRITE
    UNION ALL SELECT 'mapServiceOrderClient', 'R', 27, 'D'                             --Administration () DELETE -> mapServiceOrderClient READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'R', 27, 'D'                   --Administration () DELETE -> mapServiceOrderAttachedDocument READ
    UNION ALL SELECT 'mapServiceOrderAttachedDocument', 'D', 27, 'D'                   --Administration () DELETE -> mapServiceOrderAttachedDocument DELETE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'R', 27, 'D'                               --Administration () DELETE -> mapSiteCatalogPlant READ
    UNION ALL SELECT 'mapSiteCatalogPlant', 'D', 27, 'D'                               --Administration () DELETE -> mapSiteCatalogPlant DELETE
    UNION ALL SELECT 'mapServicePositionUsageType', 'W', 27, 'D'                       --Administration () DELETE -> mapServicePositionUsageType WRITE
    UNION ALL SELECT 'mapServiceOrderPositionServiceObject', 'W', 27, 'D'              --Administration () DELETE -> mapServiceOrderPositionServiceObject WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'D', 27, 'D'                              --Administration () DELETE -> mapSiteCatalogClient DELETE
    UNION ALL SELECT 'mapServicePositionUsageType', 'D', 27, 'D'                       --Administration () DELETE -> mapServicePositionUsageType DELETE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'D', 27, 'D'                  --Administration () DELETE -> mapServiceCatalogServicePosition DELETE
    UNION ALL SELECT 'mapServiceCatalogServicePosition', 'W', 27, 'D'                  --Administration () DELETE -> mapServiceCatalogServicePosition WRITE
    UNION ALL SELECT 'mapSiteCatalogClient', 'R', 27, 'D'                              --Administration () DELETE -> mapSiteCatalogClient READ
    UNION ALL SELECT 'mapSiteCatalogClient', 'W', 27, 'D'                              --Administration () DELETE -> mapSiteCatalogClient WRITE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'W', 27, 'D'                --Administration () DELETE -> mapSiteCatalogPositionExecutionDay WRITE
    UNION ALL SELECT 'mapSiteCatalogPlant', 'W', 27, 'D'                               --Administration () DELETE -> mapSiteCatalogPlant WRITE
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'R', 27, 'D'                --Administration () DELETE -> mapSiteCatalogPositionExecutionDay READ
    UNION ALL SELECT 'mapSiteCatalogPositionExecutionDay', 'D', 27, 'D'                --Administration () DELETE -> mapSiteCatalogPositionExecutionDay DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'R', 27, 'D'               --Administration () DELETE -> mapSiteCatalogPositionServiceObject READ
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'D', 27, 'D'               --Administration () DELETE -> mapSiteCatalogPositionServiceObject DELETE
    UNION ALL SELECT 'mapSiteCatalogPositionServiceObject', 'W', 27, 'D'               --Administration () DELETE -> mapSiteCatalogPositionServiceObject WRITE
    UNION ALL SELECT 'mapSiteCatalogSite', 'D', 27, 'D'                                --Administration () DELETE -> mapSiteCatalogSite DELETE
    UNION ALL SELECT 'mapSiteCatalogSite', 'R', 27, 'D'                                --Administration () DELETE -> mapSiteCatalogSite READ
    UNION ALL SELECT 'mapSiteCatalogSite', 'W', 27, 'D'                                --Administration () DELETE -> mapSiteCatalogSite WRITE
    UNION ALL SELECT 'mapSupplierPlant', 'R', 27, 'D'                                  --Administration () DELETE -> mapSupplierPlant READ
    UNION ALL SELECT 'mapSupplierPlant', 'D', 27, 'D'                                  --Administration () DELETE -> mapSupplierPlant DELETE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 27, 'D'                             --Administration () DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'D', 27, 'D'                             --Administration () DELETE -> mapTurnusExecutionDay DELETE
    UNION ALL SELECT 'orgUnit', 'R', 27, 'D'                                           --Administration () DELETE -> orgUnit READ
    UNION ALL SELECT 'parameter', 'R', 27, 'D'                                         --Administration () DELETE -> parameter READ
    UNION ALL SELECT 'mapSupplierPlant', 'W', 27, 'D'                                  --Administration () DELETE -> mapSupplierPlant WRITE
    UNION ALL SELECT 'priceCatalog', 'W', 27, 'D'                                      --Administration () DELETE -> priceCatalog WRITE
    UNION ALL SELECT 'priceCatalog', 'D', 27, 'D'                                      --Administration () DELETE -> priceCatalog DELETE
    UNION ALL SELECT 'mapTurnusExecutionDay', 'W', 27, 'D'                             --Administration () DELETE -> mapTurnusExecutionDay WRITE
    UNION ALL SELECT 'plant', 'R', 27, 'D'                                             --Administration () DELETE -> plant READ
    UNION ALL SELECT 'priceCatalog', 'R', 27, 'D'                                      --Administration () DELETE -> priceCatalog READ
    UNION ALL SELECT 'parameter', 'W', 27, 'D'                                         --Administration () DELETE -> parameter WRITE
    UNION ALL SELECT 'parameter', 'D', 27, 'D'                                         --Administration () DELETE -> parameter DELETE
    UNION ALL SELECT 'priceCatalogPosition', 'D', 27, 'D'                              --Administration () DELETE -> priceCatalogPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'D', 27, 'D'                     --Administration () DELETE -> priceCatalogCalculationStatus DELETE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'W', 27, 'D'                     --Administration () DELETE -> priceCatalogCalculationStatus WRITE
    UNION ALL SELECT 'priceCatalogCalculationStatus', 'R', 27, 'D'                     --Administration () DELETE -> priceCatalogCalculationStatus READ
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'W', 27, 'D'                   --Administration () DELETE -> priceCatalogCalculationPosition WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'R', 27, 'D'                   --Administration () DELETE -> priceCatalogCalculationPosition READ
    UNION ALL SELECT 'priceCatalogCalculation', 'W', 27, 'D'                           --Administration () DELETE -> priceCatalogCalculation WRITE
    UNION ALL SELECT 'priceCatalogCalculationPosition', 'D', 27, 'D'                   --Administration () DELETE -> priceCatalogCalculationPosition DELETE
    UNION ALL SELECT 'priceCatalogCalculation', 'D', 27, 'D'                           --Administration () DELETE -> priceCatalogCalculation DELETE
    UNION ALL SELECT 'priceCatalogCalculation', 'R', 27, 'D'                           --Administration () DELETE -> priceCatalogCalculation READ
    UNION ALL SELECT 'priceCatalogStatus', 'W', 27, 'D'                                --Administration () DELETE -> priceCatalogStatus WRITE
    UNION ALL SELECT 'priceCatalogPosition', 'W', 27, 'D'                              --Administration () DELETE -> priceCatalogPosition WRITE
    UNION ALL SELECT 'serviceCatalog', 'D', 27, 'D'                                    --Administration () DELETE -> serviceCatalog DELETE
    UNION ALL SELECT 'sapOrder', 'W', 27, 'D'                                          --Administration () DELETE -> sapOrder WRITE
    UNION ALL SELECT 'sapOrder', 'R', 27, 'D'                                          --Administration () DELETE -> sapOrder READ
    UNION ALL SELECT 'sapOrder', 'D', 27, 'D'                                          --Administration () DELETE -> sapOrder DELETE
    UNION ALL SELECT 'priceCatalogStatus', 'R', 27, 'D'                                --Administration () DELETE -> priceCatalogStatus READ
    UNION ALL SELECT 'priceCatalogStatus', 'D', 27, 'D'                                --Administration () DELETE -> priceCatalogStatus DELETE
    UNION ALL SELECT 'priceCatalogPosition', 'R', 27, 'D'                              --Administration () DELETE -> priceCatalogPosition READ
    UNION ALL SELECT 'serviceCatalog', 'W', 27, 'D'                                    --Administration () DELETE -> serviceCatalog WRITE
    UNION ALL SELECT 'serviceCategory', 'D', 27, 'D'                                   --Administration () DELETE -> serviceCategory DELETE
    UNION ALL SELECT 'serviceCatalog', 'R', 27, 'D'                                    --Administration () DELETE -> serviceCatalog READ
    UNION ALL SELECT 'serviceObject', 'R', 27, 'D'                                     --Administration () DELETE -> serviceObject READ
    UNION ALL SELECT 'serviceObject', 'D', 27, 'D'                                     --Administration () DELETE -> serviceObject DELETE
    UNION ALL SELECT 'serviceObjectType', 'W', 27, 'D'                                 --Administration () DELETE -> serviceObjectType WRITE
    UNION ALL SELECT 'serviceOrderPosition', 'D', 27, 'D'                              --Administration () DELETE -> serviceOrderPosition DELETE
    UNION ALL SELECT 'serviceOrder', 'R', 27, 'D'                                      --Administration () DELETE -> serviceOrder READ
    UNION ALL SELECT 'serviceOrder', 'D', 27, 'D'                                      --Administration () DELETE -> serviceOrder DELETE
    UNION ALL SELECT 'serviceOrder', 'W', 27, 'D'                                      --Administration () DELETE -> serviceOrder WRITE
    UNION ALL SELECT 'serviceOrderCalendar', 'R', 27, 'D'                              --Administration () DELETE -> serviceOrderCalendar READ
    UNION ALL SELECT 'serviceOrderCalendar', 'D', 27, 'D'                              --Administration () DELETE -> serviceOrderCalendar DELETE
    UNION ALL SELECT 'serviceOrderCalendar', 'W', 27, 'D'                              --Administration () DELETE -> serviceOrderCalendar WRITE
    UNION ALL SELECT 'serviceObject', 'W', 27, 'D'                                     --Administration () DELETE -> serviceObject WRITE
    UNION ALL SELECT 'serviceCategory', 'W', 27, 'D'                                   --Administration () DELETE -> serviceCategory WRITE
    UNION ALL SELECT 'serviceCategory', 'R', 27, 'D'                                   --Administration () DELETE -> serviceCategory READ
    UNION ALL SELECT 'serviceOrderPosition', 'W', 27, 'D'                              --Administration () DELETE -> serviceOrderPosition WRITE
    UNION ALL SELECT 'serviceOrderPosition', 'W', 27, 'W'                              --Administration () DELETE -> serviceOrderPosition WRITE
    UNION ALL SELECT 'serviceOrderPositionStatus', 'D', 27, 'D'                        --Administration () DELETE -> serviceOrderPositionStatus DELETE
    UNION ALL SELECT 'serviceOrderPositionStatus', 'R', 27, 'D'                        --Administration () DELETE -> serviceOrderPositionStatus READ
    UNION ALL SELECT 'serviceObjectType', 'R', 27, 'D'                                 --Administration () DELETE -> serviceObjectType READ
    UNION ALL SELECT 'serviceObjectType', 'D', 27, 'D'                                 --Administration () DELETE -> serviceObjectType DELETE
    UNION ALL SELECT 'serviceOrderStatus', 'D', 27, 'D'                                --Administration () DELETE -> serviceOrderStatus DELETE
    UNION ALL SELECT 'serviceOrderPositionStatus', 'W', 27, 'D'                        --Administration () DELETE -> serviceOrderPositionStatus WRITE
    UNION ALL SELECT 'settlementType', 'D', 27, 'D'                                    --Administration () DELETE -> settlementType DELETE
    UNION ALL SELECT 'serviceType', 'W', 27, 'D'                                       --Administration () DELETE -> serviceType WRITE
    UNION ALL SELECT 'serviceType', 'D', 27, 'D'                                       --Administration () DELETE -> serviceType DELETE
    UNION ALL SELECT 'serviceOrderStatus', 'R', 27, 'D'                                --Administration () DELETE -> serviceOrderStatus READ
    UNION ALL SELECT 'serviceOrderStatus', 'W', 27, 'D'                                --Administration () DELETE -> serviceOrderStatus WRITE
    UNION ALL SELECT 'serviceOrderPosition', 'R', 27, 'D'                              --Administration () DELETE -> serviceOrderPosition READ
    UNION ALL SELECT 'servicePosition', 'D', 27, 'D'                                   --Administration () DELETE -> servicePosition DELETE
    UNION ALL SELECT 'servicePosition', 'R', 27, 'D'                                   --Administration () DELETE -> servicePosition READ
    UNION ALL SELECT 'settlementType', 'R', 27, 'D'                                    --Administration () DELETE -> settlementType READ
    UNION ALL SELECT 'serviceType', 'R', 27, 'D'                                       --Administration () DELETE -> serviceType READ
    UNION ALL SELECT 'site', 'R', 27, 'D'                                              --Administration () DELETE -> site READ
    UNION ALL SELECT 'servicePosition', 'W', 27, 'D'                                   --Administration () DELETE -> servicePosition WRITE
    UNION ALL SELECT 'settlementType', 'W', 27, 'D'                                    --Administration () DELETE -> settlementType WRITE
    UNION ALL SELECT 'standardDiscount', 'W', 27, 'D'                                  --Administration () DELETE -> standardDiscount WRITE
    UNION ALL SELECT 'standardDiscount', 'D', 27, 'D'                                  --Administration () DELETE -> standardDiscount DELETE
    UNION ALL SELECT 'standardDiscount', 'R', 27, 'D'                                  --Administration () DELETE -> standardDiscount READ
    UNION ALL SELECT 'standard', 'D', 27, 'D'                                          --Administration () DELETE -> standard DELETE
    UNION ALL SELECT 'standard', 'W', 27, 'D'                                          --Administration () DELETE -> standard WRITE
    UNION ALL SELECT 'siteCatalogPosition', 'W', 27, 'D'                               --Administration () DELETE -> siteCatalogPosition WRITE
    UNION ALL SELECT 'standard', 'R', 27, 'D'                                          --Administration () DELETE -> standard READ
    UNION ALL SELECT 'siteCatalog', 'R', 27, 'D'                                       --Administration () DELETE -> siteCatalog READ
    UNION ALL SELECT 'siteCatalogPosition', 'R', 27, 'D'                               --Administration () DELETE -> siteCatalogPosition READ
    UNION ALL SELECT 'siteCatalog', 'W', 27, 'D'                                       --Administration () DELETE -> siteCatalog WRITE
    UNION ALL SELECT 'siteCatalogPosition', 'D', 27, 'D'                               --Administration () DELETE -> siteCatalogPosition DELETE
    UNION ALL SELECT 'siteCatalog', 'D', 27, 'D'                                       --Administration () DELETE -> siteCatalog DELETE
    UNION ALL SELECT 'technicalCleaningObjectType', 'W', 27, 'D'                       --Administration () DELETE -> technicalCleaningObjectType WRITE
    UNION ALL SELECT 'turnus', 'R', 27, 'D'                                            --Administration () DELETE -> turnus READ
    UNION ALL SELECT 'turnus', 'W', 27, 'D'                                            --Administration () DELETE -> turnus WRITE
    UNION ALL SELECT 'unit', 'R', 27, 'D'                                              --Administration () DELETE -> unit READ
    UNION ALL SELECT 'supplier', 'D', 27, 'D'                                          --Administration () DELETE -> supplier DELETE
    UNION ALL SELECT 'supplier', 'W', 27, 'D'                                          --Administration () DELETE -> supplier WRITE
    UNION ALL SELECT 'usageType', 'D', 27, 'D'                                         --Administration () DELETE -> usageType DELETE
    UNION ALL SELECT 'usageType', 'W', 27, 'D'                                         --Administration () DELETE -> usageType WRITE
    UNION ALL SELECT 'wageCluster', 'R', 27, 'D'                                       --Administration () DELETE -> wageGroup READ
    UNION ALL SELECT 'wageGroup', 'R', 27, 'D'                                         --Administration () DELETE -> wageGroup READ
    UNION ALL SELECT 'technicalCleaningObject', 'W', 27, 'D'                           --Administration () DELETE -> technicalCleaningObject WRITE
    UNION ALL SELECT 'technicalCleaningObject', 'R', 27, 'D'                           --Administration () DELETE -> technicalCleaningObject READ
    UNION ALL SELECT 'technicalCleaningObject', 'D', 27, 'D'                           --Administration () DELETE -> technicalCleaningObject DELETE
    UNION ALL SELECT 'turnus', 'D', 27, 'D'                                            --Administration () DELETE -> turnus DELETE
    UNION ALL SELECT 'supplier', 'R', 27, 'D'                                          --Administration () DELETE -> supplier READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'R', 27, 'D'                       --Administration () DELETE -> technicalCleaningObjectType READ
    UNION ALL SELECT 'technicalCleaningObjectType', 'D', 27, 'D'                       --Administration () DELETE -> technicalCleaningObjectType DELETE
    UNION ALL SELECT 'unit', 'D', 27, 'D'                                              --Administration () DELETE -> unit DELETE
    UNION ALL SELECT 'unit', 'W', 27, 'D'                                              --Administration () DELETE -> unit WRITE
    UNION ALL SELECT 'usageType', 'R', 27, 'D'                                         --Administration () DELETE -> usageType READ
    UNION ALL SELECT 'wageCluster', 'D', 27, 'D'                                       --Administration () DELETE -> wageGroup DELETE
    UNION ALL SELECT 'wageGroup', 'D', 27, 'D'                                         --Administration () DELETE -> wageGroup DELETE
    UNION ALL SELECT 'wageCluster', 'W', 27, 'D'                                       --Administration () DELETE -> wageGroup WRITE
    UNION ALL SELECT 'wageGroup', 'W', 27, 'D'                                         --Administration () DELETE -> wageGroup WRITE
    UNION ALL SELECT 'plant', 'R', 28, 'R'                                             --Benutzerverwaltung (client) READ   -> plant READ
    UNION ALL SELECT 'parameter', 'R', 28, 'R'                                         --Benutzerverwaltung (client) READ   -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 28, 'R'                             --Benutzerverwaltung (client) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 28, 'R'                       --Benutzerverwaltung (client) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 28, 'R'                              --Benutzerverwaltung (client) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 28, 'R'                                    --Benutzerverwaltung (client) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 28, 'R'                   --Benutzerverwaltung (client) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 28, 'R'                                  --Benutzerverwaltung (client) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 28, 'R'                         --Benutzerverwaltung (client) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 28, 'R'                                          --Benutzerverwaltung (client) READ   -> mainCode READ
    UNION ALL SELECT 'language', 'R', 28, 'R'                                          --Benutzerverwaltung (client) READ   -> language READ
    UNION ALL SELECT 'company', 'R', 28, 'R'                                           --Benutzerverwaltung (client) READ   -> company READ
    UNION ALL SELECT 'clientRole', 'R', 28, 'R'                                        --Benutzerverwaltung (client) READ   -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 28, 'R'                                  --Benutzerverwaltung (client) READ   -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 28, 'R'                                            --Benutzerverwaltung (client) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 28, 'W'                                  --Benutzerverwaltung (client) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 28, 'W'                                            --Benutzerverwaltung (client) WRITE  -> client READ
    UNION ALL SELECT 'company', 'R', 28, 'W'                                           --Benutzerverwaltung (client) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 28, 'W'                                        --Benutzerverwaltung (client) WRITE  -> clientRole READ
    UNION ALL SELECT 'mainCode', 'R', 28, 'W'                                          --Benutzerverwaltung (client) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 28, 'W'                                          --Benutzerverwaltung (client) WRITE  -> language READ
    UNION ALL SELECT 'mapClientCompany', 'R', 28, 'W'                                  --Benutzerverwaltung (client) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 28, 'W'                         --Benutzerverwaltung (client) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientPlant', 'R', 28, 'W'                                    --Benutzerverwaltung (client) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 28, 'W'                   --Benutzerverwaltung (client) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 28, 'W'                       --Benutzerverwaltung (client) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 28, 'W'                              --Benutzerverwaltung (client) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'parameter', 'R', 28, 'W'                                         --Benutzerverwaltung (client) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 28, 'W'                             --Benutzerverwaltung (client) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'plant', 'R', 28, 'W'                                             --Benutzerverwaltung (client) WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 28, 'D'                                         --Benutzerverwaltung (client) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 28, 'D'                                             --Benutzerverwaltung (client) DELETE -> plant READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 28, 'D'                             --Benutzerverwaltung (client) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 28, 'D'                       --Benutzerverwaltung (client) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 28, 'D'                   --Benutzerverwaltung (client) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 28, 'D'                                    --Benutzerverwaltung (client) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 28, 'D'                              --Benutzerverwaltung (client) DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientCompany', 'R', 28, 'D'                                  --Benutzerverwaltung (client) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mainCode', 'R', 28, 'D'                                          --Benutzerverwaltung (client) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 28, 'D'                         --Benutzerverwaltung (client) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'language', 'R', 28, 'D'                                          --Benutzerverwaltung (client) DELETE -> language READ
    UNION ALL SELECT 'company', 'R', 28, 'D'                                           --Benutzerverwaltung (client) DELETE -> company READ
    UNION ALL SELECT 'client', 'R', 28, 'D'                                            --Benutzerverwaltung (client) DELETE -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 28, 'D'                                  --Benutzerverwaltung (client) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 28, 'D'                                        --Benutzerverwaltung (client) DELETE -> clientRole READ
    UNION ALL SELECT 'client', 'R', 29, 'R'                                            --Übersetzungen () READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 29, 'R'                                  --Übersetzungen () READ   -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 29, 'R'                                        --Übersetzungen () READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 29, 'R'                                           --Übersetzungen () READ   -> company READ
    UNION ALL SELECT 'language', 'R', 29, 'R'                                          --Übersetzungen () READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 29, 'R'                                          --Übersetzungen () READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 29, 'R'                         --Übersetzungen () READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 29, 'R'                                  --Übersetzungen () READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 29, 'R'                   --Übersetzungen () READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 29, 'R'                                    --Übersetzungen () READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 29, 'R'                              --Übersetzungen () READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 29, 'R'                       --Übersetzungen () READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 29, 'R'                             --Übersetzungen () READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 29, 'R'                                         --Übersetzungen () READ   -> parameter READ
    UNION ALL SELECT 'plant', 'R', 29, 'R'                                             --Übersetzungen () READ   -> plant READ
    UNION ALL SELECT 'plant', 'R', 29, 'W'                                             --Übersetzungen () WRITE  -> plant READ
    UNION ALL SELECT 'parameter', 'R', 29, 'W'                                         --Übersetzungen () WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 29, 'W'                             --Übersetzungen () WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 29, 'W'                       --Übersetzungen () WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 29, 'W'                              --Übersetzungen () WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapClientPlant', 'R', 29, 'W'                                    --Übersetzungen () WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 29, 'W'                   --Übersetzungen () WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 29, 'W'                                  --Übersetzungen () WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 29, 'W'                         --Übersetzungen () WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 29, 'W'                                          --Übersetzungen () WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 29, 'W'                                          --Übersetzungen () WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 29, 'W'                                           --Übersetzungen () WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 29, 'W'                                        --Übersetzungen () WRITE  -> clientRole READ
    UNION ALL SELECT 'clientPermission', 'R', 29, 'W'                                  --Übersetzungen () WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 29, 'W'                                            --Übersetzungen () WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 29, 'D'                                  --Übersetzungen () DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 29, 'D'                                        --Übersetzungen () DELETE -> clientRole READ
    UNION ALL SELECT 'company', 'R', 29, 'D'                                           --Übersetzungen () DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 29, 'D'                                          --Übersetzungen () DELETE -> language READ
    UNION ALL SELECT 'client', 'R', 29, 'D'                                            --Übersetzungen () DELETE -> client READ
    UNION ALL SELECT 'mainCode', 'R', 29, 'D'                                          --Übersetzungen () DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 29, 'D'                         --Übersetzungen () DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 29, 'D'                                  --Übersetzungen () DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 29, 'D'                   --Übersetzungen () DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 29, 'D'                                    --Übersetzungen () DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 29, 'D'                              --Übersetzungen () DELETE -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 29, 'D'                       --Übersetzungen () DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 29, 'D'                             --Übersetzungen () DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 29, 'D'                                         --Übersetzungen () DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 29, 'D'                                             --Übersetzungen () DELETE -> plant READ
    UNION ALL SELECT 'settlementType', 'R', 30, 'R'                                    --SAP-Bestellungen () READ   -> settlementType READ
    UNION ALL SELECT 'sapOrder', 'R', 30, 'R'                                          --SAP-Bestellungen () READ   -> sapOrder READ
    UNION ALL SELECT 'sapOrder', 'W', 30, 'W'                                          --SAP-Bestellungen () WRITE  -> sapOrder WRITE
    UNION ALL SELECT 'sapOrder', 'R', 30, 'W'                                          --SAP-Bestellungen () WRITE  -> sapOrder READ
    UNION ALL SELECT 'sapOrder', 'D', 30, 'W'                                          --SAP-Bestellungen () WRITE  -> sapOrder DELETE
    UNION ALL SELECT 'settlementType', 'R', 30, 'W'                                    --SAP-Bestellungen () WRITE  -> settlementType READ
    UNION ALL SELECT 'settlementType', 'R', 30, 'D'                                    --SAP-Bestellungen () DELETE -> settlementType READ
    UNION ALL SELECT 'sapOrder', 'D', 30, 'D'                                          --SAP-Bestellungen () DELETE -> sapOrder DELETE
    UNION ALL SELECT 'sapOrder', 'R', 30, 'D'                                          --SAP-Bestellungen () DELETE -> sapOrder READ
    UNION ALL SELECT 'sapOrder', 'W', 30, 'D'                                          --SAP-Bestellungen () DELETE -> sapOrder WRITE
    UNION ALL SELECT 'client', 'R', 31, 'R'                                            --Abrechnungstypen (settlementType) READ   -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 31, 'R'                                  --Abrechnungstypen (settlementType) READ   -> clientPermission READ
    UNION ALL SELECT 'plant', 'R', 31, 'R'                                             --Abrechnungstypen (settlementType) READ   -> plant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 31, 'R'                              --Abrechnungstypen (settlementType) READ   -> mapMainCodeUsageType READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 31, 'R'                       --Abrechnungstypen (settlementType) READ   -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 31, 'R'                             --Abrechnungstypen (settlementType) READ   -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 31, 'R'                                         --Abrechnungstypen (settlementType) READ   -> parameter READ
    UNION ALL SELECT 'clientRole', 'R', 31, 'R'                                        --Abrechnungstypen (settlementType) READ   -> clientRole READ
    UNION ALL SELECT 'company', 'R', 31, 'R'                                           --Abrechnungstypen (settlementType) READ   -> company READ
    UNION ALL SELECT 'language', 'R', 31, 'R'                                          --Abrechnungstypen (settlementType) READ   -> language READ
    UNION ALL SELECT 'mainCode', 'R', 31, 'R'                                          --Abrechnungstypen (settlementType) READ   -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 31, 'R'                         --Abrechnungstypen (settlementType) READ   -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 31, 'R'                                  --Abrechnungstypen (settlementType) READ   -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 31, 'R'                   --Abrechnungstypen (settlementType) READ   -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 31, 'R'                                    --Abrechnungstypen (settlementType) READ   -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 31, 'W'                                    --Abrechnungstypen (settlementType) WRITE  -> mapClientPlant READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 31, 'W'                   --Abrechnungstypen (settlementType) WRITE  -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientCompany', 'R', 31, 'W'                                  --Abrechnungstypen (settlementType) WRITE  -> mapClientCompany READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 31, 'W'                         --Abrechnungstypen (settlementType) WRITE  -> mapClientClientPermission READ
    UNION ALL SELECT 'mainCode', 'R', 31, 'W'                                          --Abrechnungstypen (settlementType) WRITE  -> mainCode READ
    UNION ALL SELECT 'language', 'R', 31, 'W'                                          --Abrechnungstypen (settlementType) WRITE  -> language READ
    UNION ALL SELECT 'company', 'R', 31, 'W'                                           --Abrechnungstypen (settlementType) WRITE  -> company READ
    UNION ALL SELECT 'clientRole', 'R', 31, 'W'                                        --Abrechnungstypen (settlementType) WRITE  -> clientRole READ
    UNION ALL SELECT 'parameter', 'R', 31, 'W'                                         --Abrechnungstypen (settlementType) WRITE  -> parameter READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 31, 'W'                             --Abrechnungstypen (settlementType) WRITE  -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 31, 'W'                       --Abrechnungstypen (settlementType) WRITE  -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 31, 'W'                              --Abrechnungstypen (settlementType) WRITE  -> mapMainCodeUsageType READ
    UNION ALL SELECT 'plant', 'R', 31, 'W'                                             --Abrechnungstypen (settlementType) WRITE  -> plant READ
    UNION ALL SELECT 'clientPermission', 'R', 31, 'W'                                  --Abrechnungstypen (settlementType) WRITE  -> clientPermission READ
    UNION ALL SELECT 'client', 'R', 31, 'W'                                            --Abrechnungstypen (settlementType) WRITE  -> client READ
    UNION ALL SELECT 'clientPermission', 'R', 31, 'D'                                  --Abrechnungstypen (settlementType) DELETE -> clientPermission READ
    UNION ALL SELECT 'clientRole', 'R', 31, 'D'                                        --Abrechnungstypen (settlementType) DELETE -> clientRole READ
    UNION ALL SELECT 'client', 'R', 31, 'D'                                            --Abrechnungstypen (settlementType) DELETE -> client READ
    UNION ALL SELECT 'mapServicePositionUsageType', 'R', 31, 'D'                       --Abrechnungstypen (settlementType) DELETE -> mapServicePositionUsageType READ
    UNION ALL SELECT 'mapTurnusExecutionDay', 'R', 31, 'D'                             --Abrechnungstypen (settlementType) DELETE -> mapTurnusExecutionDay READ
    UNION ALL SELECT 'parameter', 'R', 31, 'D'                                         --Abrechnungstypen (settlementType) DELETE -> parameter READ
    UNION ALL SELECT 'plant', 'R', 31, 'D'                                             --Abrechnungstypen (settlementType) DELETE -> plant READ
    UNION ALL SELECT 'company', 'R', 31, 'D'                                           --Abrechnungstypen (settlementType) DELETE -> company READ
    UNION ALL SELECT 'language', 'R', 31, 'D'                                          --Abrechnungstypen (settlementType) DELETE -> language READ
    UNION ALL SELECT 'mainCode', 'R', 31, 'D'                                          --Abrechnungstypen (settlementType) DELETE -> mainCode READ
    UNION ALL SELECT 'mapClientClientPermission', 'R', 31, 'D'                         --Abrechnungstypen (settlementType) DELETE -> mapClientClientPermission READ
    UNION ALL SELECT 'mapClientCompany', 'R', 31, 'D'                                  --Abrechnungstypen (settlementType) DELETE -> mapClientCompany READ
    UNION ALL SELECT 'mapClientPermissionDefaultPlant', 'R', 31, 'D'                   --Abrechnungstypen (settlementType) DELETE -> mapClientPermissionDefaultPlant READ
    UNION ALL SELECT 'mapClientPlant', 'R', 31, 'D'                                    --Abrechnungstypen (settlementType) DELETE -> mapClientPlant READ
    UNION ALL SELECT 'mapMainCodeUsageType', 'R', 31, 'D'                              --Abrechnungstypen (settlementType) DELETE -> mapMainCodeUsageType READ

    SET @msg = '    fill mapTableAppFunctionality done'

    PRINT @msg

END --mapTableAppFunctionality

BEGIN --mapViewAppFunctionality

    SET @msg = '    fill mapViewAppFunctionality'

    PRINT @msg

    DELETE FROM [sec].[mapViewAppFunctionality]

    INSERT INTO [sec].[mapViewAppFunctionality]([view],[permission],[appFunctionalityId],[appFunctionalityPermission])
              SELECT 'currency', 'R', 1, 'R'                                          					--Währungen (currency) 
    UNION ALL SELECT 'currency', 'W', 1, 'W'                                          					--Währungen (currency) 
    UNION ALL SELECT 'currency', 'D', 1, 'D'                                          					--Währungen (currency) 
    UNION ALL SELECT 'mainCode', 'R', 2, 'R'                                          					--Hauptcodes (mainCode) 
    UNION ALL SELECT 'mainCode', 'W', 2, 'W'                                          					--Hauptcodes (mainCode) 
    UNION ALL SELECT 'mainCode', 'D', 2, 'D'                                          					--Hauptcodes (mainCode) 
    UNION ALL SELECT 'serviceCategory', 'R', 3, 'R'                                   					--Leistungskategorien (serviceCategory) 
    UNION ALL SELECT 'serviceCategory', 'W', 3, 'W'                                   					--Leistungskategorien (serviceCategory) 
    UNION ALL SELECT 'serviceCategory', 'D', 3, 'D'                                   					--Leistungskategorien (serviceCategory) 
    UNION ALL SELECT 'serviceObjectType', 'R', 4, 'R'                                 					--Reinigungsobjekttypen (serviceObjectType) 
    UNION ALL SELECT 'serviceObjectType', 'W', 4, 'W'                                 					--Reinigungsobjekttypen (serviceObjectType) 
    UNION ALL SELECT 'serviceObjectType', 'D', 4, 'D'                                 					--Reinigungsobjekttypen (serviceObjectType) 
    UNION ALL SELECT 'serviceOrderStatus', 'R', 5, 'R'                                					--Ausführung-/Abrechnungsstatus (serviceOrderStatus) 
    UNION ALL SELECT 'serviceOrderStatus', 'W', 5, 'W'                               					--Ausführung-/Abrechnungsstatus (serviceOrderStatus) 
    UNION ALL SELECT 'serviceOrderStatus', 'D', 5, 'D'                                					--Ausführung-/Abrechnungsstatus (serviceOrderStatus) 
    UNION ALL SELECT 'serviceType', 'R', 6, 'R'                                      					--Leistungstypen (serviceType) 
    UNION ALL SELECT 'serviceType', 'W', 6, 'W'                                       					--Leistungstypen (serviceType) 
    UNION ALL SELECT 'serviceType', 'D', 6, 'D'                                       					--Leistungstypen (serviceType) 
    UNION ALL SELECT 'standard', 'R', 7, 'R'                                          					--Standards (standard) 
    UNION ALL SELECT 'standard', 'W', 7, 'W'                                          					--Standards (standard) 
    UNION ALL SELECT 'standard', 'D', 7, 'D'                                          					--Standards (standard) 
    UNION ALL SELECT 'turnus', 'R', 8, 'R'                                            					--Turnusse (turnus) 
    UNION ALL SELECT 'turnus', 'W', 8, 'W'                                            					--Turnusse (turnus) 
    UNION ALL SELECT 'turnus', 'D', 8, 'D'                                            					--Turnusse (turnus) 
    UNION ALL SELECT 'unit', 'R', 9, 'R'                                              					--Einheiten (unit) 
    UNION ALL SELECT 'unit', 'W', 9, 'W'                                              					--Einheiten (unit) 
    UNION ALL SELECT 'unit', 'D', 9, 'D'                                              					--Einheiten (unit) 
    UNION ALL SELECT 'wageGroup,wageCluster', 'R', 10, 'R'                             					--Lohncluster (wageGroup,wageCluster) 
    UNION ALL SELECT 'wageGroup,wageCluster', 'W', 10, 'W'                             					--Lohncluster (wageGroup,wageCluster) 
    UNION ALL SELECT 'wageGroup,wageCluster', 'D', 10, 'D'                             					--Lohncluster (wageGroup,wageCluster) 
    UNION ALL SELECT 'company', 'R', 11, 'R'                                           					--Gesellschaften (company) 
    UNION ALL SELECT 'company', 'W', 11, 'W'                                           					--Gesellschaften (company) 
    UNION ALL SELECT 'company', 'D', 11, 'D'                                           					--Gesellschaften (company) 
    UNION ALL SELECT 'supplier', 'R', 12, 'R'                                         					--Lieferanten (supplier) 
    UNION ALL SELECT 'supplier', 'W', 12, 'W'                                          					--Lieferanten (supplier) 
    UNION ALL SELECT 'supplier', 'D', 12, 'D'                                          					--Lieferanten (supplier) 
    UNION ALL SELECT 'standardDiscount', 'R', 13, 'R'                                  					--Standardwerte für Abzüge (standardDiscount) 
    UNION ALL SELECT 'standardDiscount', 'W', 13, 'W'                                  					--Standardwerte für Abzüge (standardDiscount) 
    UNION ALL SELECT 'standardDiscount', 'D', 13, 'D'                                  					--Standardwerte für Abzüge (standardDiscount) 
    UNION ALL SELECT 'calendar,calendarDay', 'R', 14, 'R'                              					--Kalender (calendar,calendarDay) 
    UNION ALL SELECT 'calendar,calendarDay', 'W', 14, 'W'                              					--Kalender (calendar,calendarDay) 
    UNION ALL SELECT 'calendar,calendarDay', 'D', 14, 'D'                              					--Kalender (calendar,calendarDay) 
    UNION ALL SELECT 'technicalCleaningObject', 'R', 15, 'R'                           					--Anlagen (technicalCleaningObject) 
    UNION ALL SELECT 'technicalCleaningObject', 'W', 15, 'W'                           					--Anlagen (technicalCleaningObject) 
    UNION ALL SELECT 'technicalCleaningObject', 'D', 15, 'D'                           					--Anlagen (technicalCleaningObject) 
    UNION ALL SELECT 'customCleaningObject', 'R', 16, 'R'                              					--Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) 
    UNION ALL SELECT 'customCleaningObject', 'W', 16, 'W'                              					--Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) 
    UNION ALL SELECT 'customCleaningObject', 'D', 16, 'D'                              					--Reinigungsobjekt (aka. Interne Flächen) (customCleaningObject) 
    UNION ALL SELECT 'serviceCatalog,servicePosition', 'R', 17, 'R'                    					--Leistungskataloge (serviceCatalog,servicePosition) 
    UNION ALL SELECT 'serviceCatalog,servicePosition', 'W', 17, 'W'                    					--Leistungskataloge (serviceCatalog,servicePosition) 
    UNION ALL SELECT 'serviceCatalog,servicePosition', 'D', 17, 'D'                    					--Leistungskataloge (serviceCatalog,servicePosition) 
    UNION ALL SELECT 'siteCatalog,siteCatalogPosition', 'R', 18, 'R'                   					--Standortkataloge (siteCatalog,siteCatalogPosition) 
    UNION ALL SELECT 'siteCatalog,siteCatalogPosition', 'W', 18, 'W'                   					--Standortkataloge (siteCatalog,siteCatalogPosition) 
    UNION ALL SELECT 'siteCatalog,siteCatalogPosition', 'D', 18, 'D'                   					--Standortkataloge (siteCatalog,siteCatalogPosition) 
    UNION ALL SELECT 'priceCatalog,priceCatalogPosition', 'R', 19, 'R'                 					--Preiskataloge (priceCatalog,priceCatalogPosition) 
    UNION ALL SELECT 'priceCatalog,priceCatalogPosition', 'W', 19, 'W'                 					--Preiskataloge (priceCatalog,priceCatalogPosition) 
    UNION ALL SELECT 'priceCatalog,priceCatalogPosition', 'D', 19, 'D'									--Preiskataloge (priceCatalog,priceCatalogPosition) 
	UNION ALL SELECT 'priceCatalogCalculation,priceCatalogCalculationPosition', 'R', 20, 'R'			--Ausschreibung (priceCatalogCalculation,priceCatalogCalculationPosition) 
    UNION ALL SELECT 'priceCatalogCalculation,priceCatalogCalculationPosition', 'W', 20, 'W'			--Ausschreibung (priceCatalogCalculation,priceCatalogCalculationPosition) 
    UNION ALL SELECT 'priceCatalogCalculation,priceCatalogCalculationPosition', 'D', 20, 'D'			--Ausschreibung (priceCatalogCalculation,priceCatalogCalculationPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'R', 21, 'R'									--Leistungsabruf (Regelleistung) (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'W', 21, 'W'									--Leistungsabruf (Regelleistung) (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'D', 21, 'D'									--Leistungsabruf (Regelleistung) (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'R', 22, 'R'									--Leistungsabruf (AdHoc Leistung) (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'W', 22, 'W'                 					--Leistungsabruf (AdHoc Leistung) (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'D', 22, 'D'                 					--Leistungsabruf (AdHoc Leistung) (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'R', 23, 'R'                 					--Leistungssteuerung (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'W', 23, 'W'                 					--Leistungssteuerung (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'D', 23, 'D'                 					--Leistungssteuerung (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'R', 24, 'R'                 					--Leistungsabnahme (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'W', 24, 'W'                 					--Leistungsabnahme (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'serviceOrder,serviceOrderPosition', 'D', 24, 'D'                 					--Leistungsabnahme (serviceOrder,serviceOrderPosition) 
    UNION ALL SELECT 'bill,billPositon', 'R', 25, 'R'                                  					--Abrechnung (bill,billPositon) 
    UNION ALL SELECT 'bill,billPositon', 'W', 25, 'W'                                  					--Abrechnung (bill,billPositon) 
    UNION ALL SELECT 'bill,billPositon', 'D', 25, 'D'                                  					--Abrechnung (bill,billPositon) 
    UNION ALL SELECT 'client', 'R', 28, 'R'                                            					--Benutzerverwaltung (client) 
    UNION ALL SELECT 'client', 'W', 28, 'W'                                            					--Benutzerverwaltung (client) 
    UNION ALL SELECT 'client', 'D', 28, 'D'                                            					--Benutzerverwaltung (client) 
    UNION ALL SELECT 'sapOrder', 'R', 30, 'R'                                          					--SAP-Bestellungen (sapOrder) 
    UNION ALL SELECT 'sapOrder.setActiveButton', 'locked', 30, 'R'                     					--SAP-Bestellungen (sapOrder) 
    UNION ALL SELECT 'sapOrder', 'W', 30, 'W'                                          					--SAP-Bestellungen (sapOrder) 
    UNION ALL SELECT 'sapOrder.setActiveButton', 'enabled', 30, 'W'                     				--SAP-Bestellungen (sapOrder) 
    UNION ALL SELECT 'sapOrder.deleteButton', 'locked', 30, 'W'                        					--SAP-Bestellungen (sapOrder) 
    UNION ALL SELECT 'sapOrder', 'D', 30, 'D'                                          					--SAP-Bestellungen (sapOrder) 
    UNION ALL SELECT 'sapOrder.setActiveButton', 'enabled', 30, 'D'                     				--SAP-Bestellungen (sapOrder) 
    UNION ALL SELECT 'sapOrder.deleteButton', 'enabled', 30, 'D'                       					--SAP-Bestellungen (sapOrder) 
    UNION ALL SELECT 'settlementType', 'R', 31, 'R'                                    					--Abrechungstypen (settlementType) 
    UNION ALL SELECT 'settlementType', 'W', 31, 'W'                                    					--Abrechungstypen (settlementType) 
    UNION ALL SELECT 'settlementType', 'D', 31, 'D'                                    					--Abrechungstypen (settlementType) 

    SET @msg = '    fill mapViewAppFunctionality done'

    PRINT @msg

END --mapViewAppFunctionality


GO
