BEGIN

    DECLARE @msg NVARCHAR(max)

    SET @msg = '    fill Testuser'

    PRINT @msg 

    SET @msg = '   fill testuser DEV'

    PRINT @msg

    MERGE INTO [sec].[client] AS t
    USING
    (
		SELECT N'LUFROMM@tbdir.net' AS [login],N'Frommhold' AS [name],N'Lutz' AS [firstname],N'lutz.frommhold@cgi.com' AS [email]
		UNION ALL SELECT N'TKASHOF@tbdir.net' AS [login],N'Kashofer' AS [name],N'Thomas' AS [firstname],N'thomas.kashofer@cgi.com' AS [email]
        UNION ALL SELECT N'KORTYKT@tbdir.net' AS [login],N'Kortyk' AS [name],N'Thomas' AS [firstname],N'thomas.kortyk@cgi.com' AS [email]
		UNION ALL SELECT N'QUANBO@tbdir.net' AS [login],N'Quan' AS [name],N'Bo' AS [firstname],N'bo.quan@cgi.com' AS [email]
		UNION ALL SELECT N'SCLERSO@tbdir.net' AS [login],N'Test' AS [name],N'Test' AS [firstname],N'sclerso@tbdir.net' AS [email]
		UNION ALL SELECT N'TIMUNGE@tbdir.net' AS [login],N'Mungenast' AS [name],N'Timo' AS [firstname],N'timoge@tbdir.net' AS [email]
		UNION ALL SELECT N'DHGANES@tbdir.net' AS [login],N'Test' AS [name],N'Test' AS [firstname],N'dhganes@tbdir.net' AS [email]
		UNION ALL SELECT N'NIGUTSC@tbdir.net' AS [login],N'Gutsche' AS [name],N'Nils' AS [firstname],N'nils.gutsche@cgi.com' AS [email]
    )
    AS s
    ON s.[login] = t.[login]
    WHEN NOT MATCHED THEN
    INSERT ([login],[name],[firstname],[email],[language],[isDeleted])--,[insertedAt],[insertedBy])
    VALUES (s.[login],s.[name],s.[firstname],s.[email],N'de',0)--,GETDATE(),1)
    ;

    MERGE INTO [sec].[mapClientCompany] AS t
    USING
    (
        SELECT cl.[id] AS [clientId],co.[id] AS [companyId]
        FROM [sec].[client] cl
        CROSS JOIN (SELECT [id] FROM [std].[company] WHERE [code] = 'DTAG') co
        WHERE UPPER([login]) IN (N'LUFROMM@tbdir.net',N'TKASHOF@tbdir.net', N'QUANBO@tbdir.net', N'SCLERSO@tbdir.net',N'SCLERSO@tbdir.net',N'TIMUNGE@tbdir.net',N'DHGANES@tbdir.net', N'KORTYKT@tbdir.net', N'NIGUTSC@tbdir.net')
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
        WHERE UPPER([login]) IN (N'LUFROMM@tbdir.net',N'TKASHOF@tbdir.net', N'QUANBO@tbdir.net', N'SCLERSO@tbdir.net',N'SCLERSO@tbdir.net',N'TIMUNGE@tbdir.net',N'DHGANES@tbdir.net', N'KORTYKT@tbdir.net', N'NIGUTSC@tbdir.net')
    )
    AS s
    ON s.[name] = t.[name]
    WHEN NOT MATCHED THEN
    INSERT([name],[clientRoleId],[isDeleted])--,[insertedAt],[insertedBy])
    VALUES(s.[name],s.[clientRoleId],s.[isDeleted])--,GETDATE(),1);
	;

    MERGE INTO [sec].[mapClientClientPermission] AS t
    USING
    (
        SELECT 
            cp.[id] AS [clientPermissionId]
            ,cl.[id] AS [clientId]
        FROM [sec].[client] cl
        INNER JOIN [sec].[clientPermission] cp
            ON cp.[name] = cl.[login]  + '/DLMAdmin'
        WHERE UPPER([login]) IN (N'LUFROMM@tbdir.net',N'TKASHOF@tbdir.net', N'QUANBO@tbdir.net', N'SCLERSO@tbdir.net',N'SCLERSO@tbdir.net',N'TIMUNGE@tbdir.net',N'DHGANES@tbdir.net', N'KORTYKT@tbdir.net', N'NIGUTSC@tbdir.net',N'SYSTEM')
    )
    AS s
    ON s.[clientId] = t.[clientId]
    AND s.[clientPermissionId] = t.[clientPermissionId]
    WHEN NOT MATCHED THEN
    INSERT([clientId],[clientPermissionId])
    VALUES(s.[clientId],s.[clientPermissionId])
    ;

    UPDATE [sec].[client] SET [configuration] = '{  "id": 1,  "tableConfigurations": [ {"tableName": "serviceCatalog,servicePosition","columnOrder": [  "mrt-row-expand",  "id",  "name",  "description",  "company",  "servicePositions",  "isLegacy",  "actions"],"versionName": "serviceCatalogLegacy","sortOrders": [],"columnFilters": [{ "id": "isLegacy", "value": true  }],"isDefault": false }, {"tableName": "siteCatalog,siteCatalogPosition","columnOrder": [  "mrt-row-select",  "mrt-row-expand",  "id",  "name",  "description",  "nameTranslated",  "descriptionTranslated",  "serviceCatalog/name",  "currency/name",  "sites",  "plants",  "isSupplementFor/name",  "isReleased",  "releaseDate",  "siteCatalogPositions",  "isLegacy",  "actions"],"versionName": "siteCatalogLegacy","sortOrders": [],"columnFilters": [{ "id": "isLegacy", "value": true  }],"isDefault": false }, {"tableName": "serviceOrder,serviceOrderPosition","columnOrder": [  "mrt-row-select",  "mrt-row-expand",  "id",  "name",  "description",  "nameTranslated",  "descriptionTranslated",  "priceCatalogCalculation/priceCatalog/tenderName",  "systemOrderNo",  "serviceOrderStatus/name",  "supplier/name",  "sponsorInformation",  "costCenterB/name",  "costCenterC/name",  "sapOrder/sapOrderNo",  "coOrder",  "pmNo",  "pspElement",  "isGranular",  "serviceCategory/name",  "locations",  "periodFrom",  "periodUntil",  "serviceOrderPositions",  "isLegacy",  "actions"],"versionName": "serviceOrderLegacy","sortOrders": [],"columnFilters": [{ "id": "isLegacy", "value": true  }],"isDefault": false }, {"tableName": "bill,billPosition","columnOrder": [  "mrt-row-select",  "mrt-row-expand",  "id",  "systemBillNo",  "sapOrder/plant/code",  "serviceOrder/name",  "serviceOrder/serviceCategory/name",  "servicePeriod",  "serviceOrder/sapOrder/sapOrderNo",  "serviceOrder/supplier/code",  "sapOrder/settlementType/name",  "calculatedAmount",  "priceIncrease",  "priceReduction",  "dayReductionsSum",  "contractPenalty",  "discount",  "totalAmount/name",  "currentstatus/billStatus/name",  "openBillStatus/createdAt",  "openBillStatus/createdBy",  "releaseBillStatus/createdAt",  "releaseBillStatus/createdBy",  "fy235data",  "kb21data",  "report",  "serviceOrder/costCenterB/code",  "serviceOrder/costCenterC/code",  "serviceOrder/sponsorInformation",  "serviceOrder/coOrder",  "serviceOrder/pmNo",  "serviceOrder/pspElement",  "isLegacy",  "actions"],"versionName": "billLegacy","sortOrders": [],"columnFilters": [  { "id": "isLegacy", "value": "true"  }],"isDefault": false }]}'

    UPDATE [sec].[client] SET [language] = 'DE' 


    SET @msg = '    fill Testuser done'

    PRINT @msg 

END
GO