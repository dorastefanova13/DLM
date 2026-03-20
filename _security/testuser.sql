BEGIN

    DECLARE @msg NVARCHAR(max)

    SET @msg = '    fill Testuser'

    PRINT @msg 

    DELETE FROM [sec].[mapClientClientPermission] WHERE [clientId] in (SELECT [id]  FROM [sec].[client] WHERE UPPER([login]) IN ( N'PIDBC9D',N'PIDBC9E', N'PIDBC9F', N'PIDBCA0',N'PIDBC9C',N'PIDBCA1',N'PIDBC9B' ))
    DELETE FROM [sec].[mapClientCompany] WHERE [clientId] in (SELECT [id]  FROM [sec].[client] WHERE UPPER([login]) IN ( N'PIDBC9D',N'PIDBC9E', N'PIDBC9F', N'PIDBCA0',N'PIDBC9C',N'PIDBCA1',N'PIDBC9B' ))
    DELETE FROM [sec].[mapClientPlant] WHERE [clientId] in (SELECT [id]  FROM [sec].[client] WHERE UPPER([login]) IN ( N'PIDBC9D',N'PIDBC9E', N'PIDBC9F', N'PIDBCA0',N'PIDBC9C',N'PIDBCA1',N'PIDBC9B' ))
    DELETE FROM [sec].[mapClientPermissionDefaultPlant] WHERE [permissionId] IN (SELECT [id] FROM [sec].[clientPermission] WHERE [name] LIKE N'PIDBC9D%' OR [name] LIKE N'PIDBC9E%' OR [name] LIKE N'PIDBC9F%' OR [name] LIKE N'PIDBCA0%' OR [name] LIKE N'PIDBC9C%' OR [name] LIKE N'PIDBCA1%' OR [name] LIKE N'PIDBC9B%' )
    DELETE FROM [sec].[clientPermission] WHERE [name] LIKE N'PIDBC9D%' OR [name] LIKE N'PIDBC9E%' OR [name] LIKE N'PIDBC9F%' OR [name] LIKE N'PIDBCA0%' OR [name] LIKE N'PIDBC9C%' OR [name] LIKE N'PIDBCA1%' OR [name] LIKE N'PIDBC9B%'
    DELETE FROM [sec].[client] WHERE UPPER([login]) IN ( N'PIDBC9D',N'PIDBC9E', N'PIDBC9F', N'PIDBCA0',N'PIDBC9C',N'PIDBCA1' ,N'PIDBC9B' )

    SET @msg = '   fill Testuser User'

    PRINT @msg 

    INSERT INTO [sec].[client]([login],[name],[firstname],[email],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9B','CleaningBoard','Tester','test@mercedes-benz.com',1,0,GETDATE(),1
    INSERT INTO [sec].[client]([login],[name],[firstname],[email],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9D','Werksadmin','Tester','test@mercedes-benz.com',1,0,GETDATE(),1
    INSERT INTO [sec].[client]([login],[name],[firstname],[email],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9E','Eink舫fer','Tester','test@mercedes-benz.com',1,0,GETDATE(),1
    INSERT INTO [sec].[client]([login],[name],[firstname],[email],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9F','Planer','Tester','test@mercedes-benz.com',1,0,GETDATE(),1
    INSERT INTO [sec].[client]([login],[name],[firstname],[email],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBCA0','Berater','Tester','test@mercedes-benz.com',1,0,GETDATE(),1
    INSERT INTO [sec].[client]([login],[name],[firstname],[email],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBCA1','Gast','Tester','test@mercedes-benz.com',1,0,GETDATE(),1
    INSERT INTO [sec].[client]([login],[name],[firstname],[email],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9C','DLM-Administrator','Tester','test@mercedes-benz.com',1,0,GETDATE(),1
	INSERT INTO [sec].[client]([login],[name],[firstname],[email],[isActive],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBCA2','Translator','Tester','test@mercedes-benz.com',1,0,GETDATE(),1

    SET @msg = '   fill Testuser Company'

    PRINT @msg 

    INSERT INTO [sec].[mapClientCompany] ([clientId],[companyId])
    SELECT c.[id],(SELECT TOP 1 [id] FROM [std].[company] WHERE [code] <> 'n/a')
    FROM [sec].[client] c
    WHERE c.[firstname] LIKE 'Test%'

    SET @msg = '   fill Testuser Plant'
    
    PRINT @msg 

    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9B'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9B'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000031'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9B'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000026'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9D'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9D'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000031'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9D'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000026'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9E'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9E'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000031'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9E'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000026'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9F'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9F'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000031'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9F'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000026'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBCA0'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBCA1'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016'))
    INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBC9C'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016'))
	INSERT INTO [sec].[mapClientPlant]([clientId],[plantId]) VALUES ((SELECT [id] FROM [sec].[client] WHERE [login] = 'PIDBCA2'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016'))

    SET @msg = '   fill Testuser Permission'

    PRINT @msg

    INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9B/CleaningBoard',(SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('CleaningBoard')),0,GETDATE(),1 WHERE NOT EXISTS (SELECT 1 FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9B/CleaningBoard') ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9B/CleaningBoard'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016')) ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9B/CleaningBoard'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000026')) ; 
    INSERT INTO [sec].[mapClientClientPermission]([clientId],[clientPermissionId]) VALUES ((SELECT[id] FROM [sec].[client] WHERE [login] = 'PIDBC9B'),(SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9B/CleaningBoard'))
    
    INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9D/PlantAdmin',(SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('PlantAdmin'))       ,0,GETDATE(),1 WHERE NOT EXISTS (SELECT 1 FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9D/PlantAdmin') ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9D/PlantAdmin'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016')) ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9D/PlantAdmin'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000026')) ; 
    INSERT INTO [sec].[mapClientClientPermission]([clientId],[clientPermissionId]) VALUES ((SELECT[id] FROM [sec].[client] WHERE [login] = 'PIDBC9D'),(SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9D/PlantAdmin'))
    
    INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9F/Planner',(SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Planner')),0,GETDATE(),1 WHERE NOT EXISTS (SELECT 1 FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9F/Planner') ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9F/Planner'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016')) ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9F/Planner'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000026')) ; 
    INSERT INTO [sec].[mapClientClientPermission]([clientId],[clientPermissionId]) VALUES ((SELECT[id] FROM [sec].[client] WHERE [login] = 'PIDBC9F'),(SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9F/Planner'))
    
    INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBCA0/Advisor',(SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Advisor'))          ,0,GETDATE(),1 WHERE NOT EXISTS (SELECT 1 FROM [sec].[clientPermission] WHERE [name] = 'PIDBCA0/Advisor') ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBCA0/Advisor'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016')) ; 
    INSERT INTO [sec].[mapClientClientPermission]([clientId],[clientPermissionId]) VALUES ((SELECT[id] FROM [sec].[client] WHERE [login] = 'PIDBCA0'),(SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBCA0/Advisor'))
    
    INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9E/Purchaser',(SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Purchaser'))        ,0,GETDATE(),1 WHERE NOT EXISTS (SELECT 1 FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9E/Purchaser') ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9E/Purchaser'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000026')) ; 
    INSERT INTO [sec].[mapClientClientPermission]([clientId],[clientPermissionId]) VALUES ((SELECT[id] FROM [sec].[client] WHERE [login] = 'PIDBC9E'),(SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9E/Purchaser'))
    
    INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBCA1/Guest',(SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Guest'))            ,0,GETDATE(),1 WHERE NOT EXISTS (SELECT 1 FROM [sec].[clientPermission] WHERE [name] = 'PIDBCA1/Guest') ; 
    INSERT INTO [sec].[mapClientPermissionDefaultPlant]([permissionId],[plantId]) VALUES ((SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBCA1/Guest'),(SELECT [id] FROM [loc].[plant] WHERE [functionalId] = '3000000000016')) ; 
    INSERT INTO [sec].[mapClientClientPermission]([clientId],[clientPermissionId]) VALUES ((SELECT[id] FROM [sec].[client] WHERE [login] = 'PIDBCA1'),(SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBCA1/Guest'))
    
    INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBC9C/DLMAdmin',(SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('DLMAdmin'))         ,0,GETDATE(),1 WHERE NOT EXISTS (SELECT 1 FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9C/DLMAdmin') ; 
    INSERT INTO [sec].[mapClientClientPermission]([clientId],[clientPermissionId]) VALUES ((SELECT[id] FROM [sec].[client] WHERE [login] = 'PIDBC9C'),(SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBC9C/DLMAdmin'))

    INSERT INTO [sec].[clientPermission]([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy]) SELECT 'PIDBCA2/Translator',(SELECT [id] FROM [sec].[clientRole] WHERE UPPER([name]) = UPPER('Translator'))         ,0,GETDATE(),1 WHERE NOT EXISTS (SELECT 1 FROM [sec].[clientPermission] WHERE [name] = 'PIDBCA2/Translator') ; 
    INSERT INTO [sec].[mapClientClientPermission]([clientId],[clientPermissionId]) VALUES ((SELECT[id] FROM [sec].[client] WHERE [login] = 'PIDBCA2'),(SELECT [id] FROM [sec].[clientPermission] WHERE [name] = 'PIDBCA2/Translator'))


    SET @msg = '   fill testuser DEV'

    PRINT @msg

    MERGE INTO [sec].[client] AS t
    USING
    (
		SELECT N'TKNEESC' AS [login],N'Kneesch' AS [name],N'Torben' AS [firstname],N'torben.kneesch@cgi.com' AS [email]
		UNION ALL SELECT N'KASHOFT' AS [login],N'Kashofer' AS [name],N'Thomas' AS [firstname],N'thomas.kashofer@cgi.com' AS [email]
		UNION ALL SELECT N'ALEXKEL' AS [login],N'Keller' AS [name],N'Alexandra' AS [firstname],N'alexandra.keller@mercedes-benz.de' AS [email]
		UNION ALL SELECT N'FROMMHL' AS [login],N'Frommhold' AS [name],N'Lutz' AS [firstname],N'lutz.frommhold@cgi.com' AS [email]
		UNION ALL SELECT N'HNOGARE' AS [login],N'Nogarede' AS [name],N'Hippolite' AS [firstname],N'nogarete.hippolite@cgi.com' AS [email]
		UNION ALL SELECT N'TKORTYK' AS [login],N'Kortyka' AS [name],N'Thomas' AS [firstname],N'thomas.kortyka@cgi.com' AS [email]
		UNION ALL SELECT N'NSCHIFF' AS [login],N'Schiffer' AS [name],N'Nico' AS [firstname],N'nils.gutsche@cgi.com' AS [email]
    )
    AS s
    ON s.[login] = t.[login]
    WHEN NOT MATCHED THEN
    INSERT ([login],[name],[firstname],[email],[language],[isDeleted],[insertedAt],[insertedBy])
    VALUES (s.[login],s.[name],s.[firstname],s.[email],N'de',0,GETDATE(),1)
    ;

    MERGE INTO [sec].[mapClientCompany] AS t
    USING
    (
        SELECT cl.[id] AS [clientId],co.[id] AS [companyId]
        FROM [sec].[client] cl
        CROSS JOIN (SELECT [id] FROM [std].[company] WHERE [code] IN ('DTAG','MBAG')) co
        WHERE UPPER([login]) IN ( N'TKNEESC',N'KASHOFT', N'ALEXKEL',N'FROMMHL',N'HNOGARE', N'TKORTYK' ,N'NSCHIFF' )
    )
    AS s
    ON s.[clientId] = t.[clientId]
    WHEN NOT MATCHED THEN
    INSERT ([clientId],[companyId])
    VALUES (s.[clientId],s.[companyId])
    ;

    MERGE INTO [sec].[clientPermission] AS t
    USING
    (
        SELECT 
            cl.[login]  + '/DLMAdmin' AS [name]
            ,3 AS [clientRoleId]
            ,0 AS [isDeleted]
        FROM [sec].[client] cl
        WHERE UPPER([login]) IN ( N'TKNEESC',N'KASHOFT', N'ALEXKEL',N'FROMMHL',N'HNOGARE', N'TKORTYK' ,N'NSCHIFF' ,N'SYSTEM' )
    )
    AS s
    ON s.[name] = t.[name]
    WHEN NOT MATCHED THEN
    INSERT([name],[clientRoleId],[isDeleted],[insertedAt],[insertedBy])
    VALUES(s.[name],s.[clientRoleId],s.[isDeleted],GETDATE(),1);


    MERGE INTO [sec].[mapClientClientPermission] AS t
    USING
    (
        SELECT 
            cp.[id] AS [clientPermissionId]
            ,cl.[id] AS [clientId]
        FROM [sec].[client] cl
        INNER JOIN [sec].[clientPermission] cp
            ON cp.[name] = cl.[login]  + '/DLMAdmin'
        WHERE UPPER([login]) IN (  N'TKNEESC',N'KASHOFT', N'ALEXKEL',N'FROMMHL',N'HNOGARE', N'TKORTYK' ,N'NSCHIFF' ,N'SYSTEM' )

    )
    AS s
    ON s.[clientId] = t.[clientId]
    AND s.[clientPermissionId] = t.[clientPermissionId]
    WHEN NOT MATCHED THEN
    INSERT([clientId],[clientPermissionId])
    VALUES(s.[clientId],s.[clientPermissionId])
    ;

    --UPDATE [sec].[client] SET [configuration] = '{  "id": 1,  "tableConfigurations": [ {"tableName": "serviceCatalog,servicePosition","columnOrder": [  "mrt-row-expand",  "id",  "name",  "description",  "company",  "servicePositions",  "isLegacy",  "actions"],"versionName": "serviceCatalogLegacy","sortOrders": [],"columnFilters": [{ "id": "isLegacy", "value": true  }],"isDefault": false }, {"tableName": "siteCatalog,siteCatalogPosition","columnOrder": [  "mrt-row-select",  "mrt-row-expand",  "id",  "name",  "description",  "nameTranslated",  "descriptionTranslated",  "serviceCatalog/name",  "currency/name",  "sites",  "plants",  "isSupplementFor/name",  "isReleased",  "releaseDate",  "siteCatalogPositions",  "isLegacy",  "actions"],"versionName": "siteCatalogLegacy","sortOrders": [],"columnFilters": [{ "id": "isLegacy", "value": true  }],"isDefault": false }, {"tableName": "serviceOrder,serviceOrderPosition","columnOrder": [  "mrt-row-select",  "mrt-row-expand",  "id",  "name",  "description",  "nameTranslated",  "descriptionTranslated",  "priceCatalogCalculation/priceCatalog/tenderName",  "systemOrderNo",  "serviceOrderStatus/name",  "supplier/name",  "sponsorInformation",  "costCenterB/name",  "costCenterC/name",  "sapOrder/sapOrderNo",  "coOrder",  "pmNo",  "pspElement",  "isGranular",  "serviceCategory/name",  "locations",  "periodFrom",  "periodUntil",  "serviceOrderPositions",  "isLegacy",  "actions"],"versionName": "serviceOrderLegacy","sortOrders": [],"columnFilters": [{ "id": "isLegacy", "value": true  }],"isDefault": false }, {"tableName": "bill,billPosition","columnOrder": [  "mrt-row-select",  "mrt-row-expand",  "id",  "systemBillNo",  "sapOrder/plant/code",  "serviceOrder/name",  "serviceOrder/serviceCategory/name",  "servicePeriod",  "serviceOrder/sapOrder/sapOrderNo",  "serviceOrder/supplier/code",  "sapOrder/settlementType/name",  "calculatedAmount",  "priceIncrease",  "priceReduction",  "dayReductionsSum",  "contractPenalty",  "discount",  "totalAmount/name",  "currentstatus/billStatus/name",  "openBillStatus/createdAt",  "openBillStatus/createdBy",  "releaseBillStatus/createdAt",  "releaseBillStatus/createdBy",  "fy235data",  "kb21data",  "report",  "serviceOrder/costCenterB/code",  "serviceOrder/costCenterC/code",  "serviceOrder/sponsorInformation",  "serviceOrder/coOrder",  "serviceOrder/pmNo",  "serviceOrder/pspElement",  "isLegacy",  "actions"],"versionName": "billLegacy","sortOrders": [],"columnFilters": [  { "id": "isLegacy", "value": "true"  }],"isDefault": false }]}'

    UPDATE [sec].[client] SET [language] = 'DE' ,[login] = UPPER([login])


    SET @msg = '    fill Testuser done'

    PRINT @msg 

END
GO