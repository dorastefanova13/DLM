BEGIN

    PRINT 'create detailViews'

    DECLARE @viewsql NVARCHAR(MAX)

    DROP VIEW IF EXISTS [app].[vDBVersion]

    SET @viewsql = '
    CREATE VIEW [app].[vDBVersion]
    AS
    SELECT 
		SERVERPROPERTY(N''ServerName'') AS [server_name],
        MAX([last_change]) AS [last_change]
    FROM (
        SELECT MAX([modify_date]) AS [last_change] FROM [sys].[objects]
        UNION ALL
        SELECT CONVERT(DATETIME,' + CHAR(39) + CONVERT(NVARCHAR,SYSDATETIME(),120) + CHAR(39) + ',120) AS [last_change]
    )q
    '

    EXEC(@viewsql)

    DROP VIEW IF EXISTS [app].[vUserPermissions]

    SET @viewsql = '
    CREATE VIEW [app].[vUserPermissions]
    AS
    SELECT 
	    c.[id] AS [clientId]
	    ,c.[login] AS [clientLogin]
	    ,c.[name] AS [clientName]
	    ,c.[firstname] AS [clientFirstName]
	    ,c.[email] AS [clientEmail]
	    ,co.[code] AS [clientCompany]
	    ,cpl.[code] + ''/'' + cpl.[name] AS [clientPlant]
	    ,p.[name] AS [permission]
	    ,ppl.[name] + ''/''+ ppl.[name] AS [permissionPlant]
	    ,r.[name] AS [permissionRole]
    FROM [sec].[client] c
    INNER JOIN [sec].[mapClientCompany] mcco
	    ON mcco.[clientId] = c.[id]
    INNER JOIN [std].[company] co
	    ON co.[id] = mcco.[companyId]
    INNER JOIN [sec].[mapClientPlant] mcp
	    ON mcp.[clientId] = c.[id]
    INNER JOIN [loc].[plant] cpl
	    ON cpl.[id] = mcp.[plantId]
    INNER JOIN [sec].[mapClientClientPermission] mccp
	    ON mccp.[clientId] = c.[id]
    INNER JOIN [sec].[clientPermission] p
	    ON p.[id] = mccp.[clientPermissionId]
    INNER JOIN [sec].[clientRole] r
	    ON r.[id] = p.[clientRoleId]
    LEFT OUTER JOIN [sec].[mapClientPermissionDefaultPlant] mcpdf
	    ON mcpdf.[permissionId] = p.[id]
    LEFT OUTER JOIN [loc].[plant] ppl
	    ON ppl.[id] = mcpdf.[plantId]    
    
    '

    EXEC(@viewsql)
    

    DROP VIEW IF EXISTS [app].[vServicePosition]

    SET @viewsql = '
    CREATE VIEW [app].[vServicePosition]
    AS
    SELECT 
    svp.[id] AS [servicePositionId]
    , mSCSP.[serviceCatalogId] AS [serviceCatalogId]
    , svp.[mainCodeId]
    , svp.[unitId]
    , svp.[serviceCategoryId]
    , svp.[companyId]
    , svp.[turnusId]
    , svp.[turnusServicePositionId]
    , svp.[serviceTypeId]
    , svp.[standardId]
    , CONCAT (
        mco.[code]
        , CHAR(46)
        , RIGHT(CHAR(48) + CHAR(48) + tur.[code], 2)
        , CHAR(46)
        , RIGHT(CHAR(48) + CHAR(48) + CHAR(48) + ISNULL(svp.[servicePositionOrderNo],CAST(svp.[servicePositionNo] AS NVARCHAR)), 3)
        ) AS [servicePositionCode]
    , svp.[name] AS [servicePositionName]
    , svp.[description] AS [servicePositiondescription]
    , svc.[name] AS [serviceCatalogName]
    , svc.[description] AS [serviceCatalogdescription]
    , mco.[code] AS [mainCode]
    , ISNULL(svp.[mainCodeDescription], mco.[description]) AS [mainCodeDescription]
    , svp.[servicePositionNo]
    , svp.[servicePositionOrderNo]
    , tur.[name] AS [turnusName]
    , tur.[code] AS [turnusCode]
    , tur.[factor] AS [turnusFactor]
    , tup.[name] AS [servicePositionTurnusName]
    , tup.[code] AS [servicePositionTurnusCode]
    , tup.[factor] AS [servicePositionTurnusFactor]
    , uni.[name] AS [unitName]
    , uni.[code] AS [unitCode]
    , cop.[code] AS [companyCode]
    , cop.[name] AS [companyName]
    , cop.[description] AS [companyDescription]
    , svt.[code] AS [serviceTypeCode]
    , svt.[name] AS [serviceTypeName]
    , svt.[description] AS [serviceTypeDescription]
    , svp.[isActive]
    , svp.[isSiteSpecific]
    , svp.[isLegacy]
    , svp.[isMainService]
    , svp.[calculatedRegularOutput]
    , sta.[code] AS [standardCode]
    , sta.[name] AS [standardName]
    , sta.[description] AS [standardDescription]
    , sca.[code] AS [serviceCategoryCode]
    , sca.[description] AS [serviceCategoryDescription]
    , ust.[name] AS [servicePositionUsageTypeName]
    FROM [dlm].[servicePosition] svp
    INNER JOIN [dlm].[mapServiceCatalogServicePosition] mSCSP
        ON svp.[id] = mSCSP.[servicePositionId]
    INNER JOIN [dlm].[serviceCatalog] svc
        ON svc.[id] = mSCSP.[serviceCatalogId]
    INNER JOIN [dlm].[mainCode] mco
        ON mco.[id] = svp.[mainCodeId]
    INNER JOIN [std].[turnus] tur
        ON tur.[id] = svp.[turnusId]
    INNER JOIN [std].[turnus] tup
        ON tup.[id] = svp.[turnusServicePositionId]
    INNER JOIN [dlm].[mapServicePositionUsageType] mSPUT
        ON svp.[id] = mSPUT.[servicePositionId]
    INNER JOIN [std].[usageType] ust
        ON ust.[id] = mSPUT.[usageTypeId]
    INNER JOIN [std].[serviceType] svt
        ON svt.[id] = svp.[serviceTypeId]
    INNER JOIN [std].[serviceCategory] sca
        ON sca.[id] = svp.[serviceCategoryId]
    INNER JOIN [std].[company] cop
        ON cop.[id] = svc.[companyId]
    INNER JOIN [std].[unit] uni
        ON uni.[id] = svp.[unitId]
    INNER JOIN [std].[standard] sta
        ON sta.[id] = svp.[standardId]
    '

    EXEC(@viewsql)
    
    DROP VIEW IF EXISTS [app].[vSiteCatalogPosition]
    
    SET @viewsql = '
    CREATE VIEW [app].[vSiteCatalogPosition]
    AS
    SELECT 
    scp.[id] AS [siteCatalogPositionId]
    , sic.[id] AS [siteCatalogId]
    , svp.[id] AS [servicePositionId]
    , mSCSP.[serviceCatalogId] AS [serviceCatalogId]
    , svp.[mainCodeId]
    , svp.[unitId]
    , svp.[serviceCategoryId]
    , svp.[companyId]
    , svp.[turnusId]
    , svp.[turnusServicePositionId]
    , svp.[serviceTypeId]
    , svp.[standardId]
    , CONCAT (
        mco.[code]
        , CHAR(46)
        , RIGHT(CHAR(48) + CHAR(48) + tur.[code], 2)
        , CHAR(46)
        , RIGHT(CHAR(48) + CHAR(48) + CHAR(48) + ISNULL(svp.[servicePositionOrderNo],CAST(svp.[servicePositionNo] AS NVARCHAR)), 3)
        ) AS [servicePositionCode]
    , scp.[unitsActive]
    , scp.[unitsNotActive]
    , svp.[name] AS [servicePositionName]
    , svp.[description] AS [servicePositiondescription]
    , svc.[name] AS [serviceCatalogName]
    , svc.[description] AS [serviceCatalogdescription]
    , sic.[name] AS [siteCatalogName]
    , sic.[description] AS [siteCatalogdescription]
    , sic.[isReleased]
    , sic.[releaseDate]
    , cur.[code] AS [currencyCode]
    , cur.[name] AS [currencyName]
    , mco.[code] AS [mainCode]
    , ISNULL(svp.[mainCodeDescription], mco.[description]) AS [mainCodeDescription]
    , svp.[servicePositionNo]
    , svp.[servicePositionOrderNo]
    , tur.[name] AS [turnusName]
    , tur.[code] AS [turnusCode]
    , tur.[factor] AS [turnusFactor]
    , tup.[name] AS [servicePositionTurnusName]
    , tup.[code] AS [servicePositionTurnusCode]
    , tup.[factor] AS [servicePositionTurnusFactor]
    , uni.[name] AS [unitName]
    , uni.[code] AS [unitCode]
    , cop.[code] AS [companyCode]
    , cop.[name] AS [companyName]
    , cop.[description] AS [companyDescription]
    , svt.[code] AS [serviceTypeCode]
    , svt.[name] AS [serviceTypeName]
    , svt.[description] AS [serviceTypeDescription]
    , svp.[isActive]
    , svp.[isSiteSpecific]
    , svp.[isLegacy]
    , svp.[isMainService]
    , svp.[calculatedRegularOutput]
    , sta.[code] AS [standardCode]
    , sta.[name] AS [standardName]
    , sta.[description] AS [standardDescription]
    , sca.[code] AS [serviceCategoryCode]
    , sca.[description] AS [serviceCategoryDescription]
    , ust.[name] AS [servicePositionUsageTypeName]
    FROM [dlm].[siteCatalogPosition] scp
    INNER JOIN [dlm].[servicePosition] svp
        ON svp.[id] = scp.[servicePositionId]
    INNER JOIN [dlm].[mapServiceCatalogServicePosition] mSCSP
        ON svp.[id] = mSCSP.[servicePositionId]
    INNER JOIN [dlm].[serviceCatalog] svc
        ON svc.[id] = mSCSP.[serviceCatalogId]
    INNER JOIN [dlm].[siteCatalog] sic
        ON sic.[id] = scp.[siteCatalogId]
        AND sic.[serviceCatalogId] = mSCSP.[serviceCatalogId]
    INNER JOIN [dlm].[mainCode] mco
        ON mco.[id] = svp.[mainCodeId]
    INNER JOIN [std].[turnus] tur
        ON tur.[id] = svp.[turnusId]
    INNER JOIN [std].[turnus] tup
        ON tup.[id] = svp.[turnusServicePositionId]
    INNER JOIN (
		SELECT m.[servicePositionId],STRING_AGG(u.[name],CHAR(44)) AS [name] 
		FROM [dlm].[mapServicePositionUsageType] m
		INNER JOIN [std].[usageType] u
			ON u.[id] = m.[usageTypeId]
		GROUP BY m.[servicePositionId]
	) ust		
        ON svp.[id] = ust.[servicePositionId]
    INNER JOIN [std].[serviceType] svt
        ON svt.[id] = svp.[serviceTypeId]
    INNER JOIN [std].[serviceCategory] sca
        ON sca.[id] = svp.[serviceCategoryId]
    INNER JOIN [std].[company] cop
        ON cop.[id] = svc.[companyId]
    INNER JOIN [std].[unit] uni
        ON uni.[id] = svp.[unitId]
    INNER JOIN [std].[standard] sta
        ON sta.[id] = svp.[standardId]
    INNER JOIN [std].[currency] cur
        ON cur.[id] = sic.[currencyId]
    LEFT OUTER JOIN (SELECT m.[siteCatalogId],STRING_AGG(si.[name],CHAR(46)) AS [sites] FROM [dlm].[mapSiteCatalogSite] m INNER JOIN [loc].[site] si ON si.[id] = m.[siteId] GROUP BY m.[siteCatalogId]) sites
        ON sites.[siteCatalogId] = sic.[id]
    LEFT OUTER JOIN (SELECT m.[siteCatalogId],STRING_AGG(pl.[code],CHAR(46)) AS [plants] FROM [dlm].[mapSiteCatalogPlant] m INNER JOIN [loc].[plant] pl ON pl.[id] = m.[plantId] GROUP BY m.[siteCatalogId]) plants
        ON plants.[siteCatalogId] = sic.[id]
    '

    EXEC(@viewsql)

    DROP VIEW IF EXISTS [app].[vServiceOrderPosition]
    
    SET @viewsql = '
    CREATE VIEW [app].[vServiceOrderPosition]
    AS
    SELECT 
    sop.[id] AS [serviceOrderPositionId]
    , sor.[id] AS [serviceOrderId]
    , pccp.[id] AS [priceCatalogCalculationPositionId]
    , pcp.[id] AS [priceCatalogPositionId]
    , scp.[id] AS [siteCatalogPositionId]
    , sic.[id] AS [siteCatalogId]
    , svp.[id] AS [servicePositionId]
    , sic.[serviceCatalogId] AS [serviceCatalogId]
    , svp.[mainCodeId]
    , svp.[unitId]
    , svp.[serviceCategoryId]
    , svp.[companyId]
    , svp.[turnusId]
    , svp.[turnusServicePositionId]
    , svp.[serviceTypeId]
    , svp.[standardId]
    , CONCAT (
        mco.[code]
        , CHAR(46)
        , RIGHT(CHAR(48) + CHAR(48) + tur.[code], 2)
        , CHAR(46)
        , RIGHT(CHAR(48) + CHAR(48) + CHAR(48) + ISNULL(svp.[servicePositionOrderNo],CAST(svp.[servicePositionNo] AS NVARCHAR)), 3)
        ) AS [servicePositionCode]
    , sop.[unitsActive]
    , sop.[unitsNotActive]
    , svp.[name] AS [servicePositionName]
    , svp.[description] AS [servicePositiondescription]
    , sor.[name] AS [serviceOrderName]
    , sor.[description] AS [serviceOrderdescription]
    , sor.[systemOrderNo]
    , sor.[sponsorInformation]
    , sos.[name] AS [serviceOrderStatus]
    , sic.[name] AS [siteCatalogName]
    , sic.[description] AS [siteCatalogdescription]
    , sic.[isReleased]
    , sic.[releaseDate]
    , cur.[code] AS [currencyCode]
    , cur.[name] AS [currencyName]
    , mco.[code] AS [mainCode]
    , ISNULL(svp.[mainCodeDescription], mco.[description]) AS [mainCodeDescription]
    , svp.[servicePositionNo]
    , svp.[servicePositionOrderNo]
    , tur.[name] AS [turnusName]
    , tur.[code] AS [turnusCode]
    , tur.[factor] AS [turnusFactor]
    , tup.[name] AS [servicePositionTurnusName]
    , tup.[code] AS [servicePositionTurnusCode]
    , tup.[factor] AS [servicePositionTurnusFactor]
    , uni.[name] AS [unitName]
    , uni.[code] AS [unitCode]
    , cop.[code] AS [companyCode]
    , cop.[name] AS [companyName]
    , cop.[description] AS [companyDescription]
    , svt.[code] AS [serviceTypeCode]
    , svt.[name] AS [serviceTypeName]
    , svt.[description] AS [serviceTypeDescription]
    , svp.[isActive]
    , svp.[isSiteSpecific]
    , svp.[isLegacy]
    , svp.[isMainService]
    , svp.[calculatedRegularOutput]
    , sta.[code] AS [standardCode]
    , sta.[name] AS [standardName]
    , sta.[description] AS [standardDescription]
    , sca.[code] AS [serviceCategoryCode]
    , sca.[description] AS [serviceCategoryDescription]
    , ust.[name] AS [servicePositionUsageTypeName]
    FROM [dlm].[serviceOrderPosition] sop
    INNER JOIN [dlm].[serviceOrder] sor
        ON sor.[id] = sop.[serviceOrderId]
    INNER JOIN [std].[serviceOrderStatus] sos
        ON sos.[id] = sor.[serviceOrderStatusId]
    INNER JOIN (
        SELECT m.[serviceOrderId],STRING_AGG(CONCAT(sap.[sapOrderNo],CHAR(47),sap.[sapOrderPosition]),CHAR(44)) AS [sapOrder] 
        FROM dlm.[mapServiceOrderSapOrder] m
        INNER JOIN [dlm].[sapOrder] sap
            ON sap.[id] = m.[sapOrderId]
        GROUP BY m.[serviceOrderId]
    ) sap
        ON sap.[serviceOrderId] = sor.[id]
    INNER JOIN [dlm].[priceCatalogCalculationPosition] pccp
        ON pccp.[id] = sop.[priceCatalogCalculationPositionId]
    INNER JOIN [dlm].[priceCatalogPosition] pcp
        ON pcp.[id] = pccp.[priceCatalogPositionId]
    INNER JOIN [dlm].[siteCatalogPosition] scp
        ON scp.[id] = pcp.[siteCatalogPositionId]
    INNER JOIN [dlm].[servicePosition] svp
        ON svp.[id] = pccp.[servicePositionId]
    INNER JOIN [dlm].[siteCatalog] sic
        ON sic.[id] = scp.[siteCatalogId]
    INNER JOIN [dlm].[mainCode] mco
        ON mco.[id] = svp.[mainCodeId]
    INNER JOIN [std].[turnus] tur
        ON tur.[id] = svp.[turnusId]
    INNER JOIN [std].[turnus] tup
        ON tup.[id] = svp.[turnusServicePositionId]
    LEFT OUTER JOIN (
		SELECT m.[servicePositionId],STRING_AGG(u.[name],CHAR(44)) AS [name] 
		FROM [dlm].[mapServicePositionUsageType] m
		INNER JOIN [std].[usageType] u
			ON u.[id] = m.[usageTypeId]
		GROUP BY m.[servicePositionId]
	) ust		
        ON svp.[id] = ust.[servicePositionId]
    INNER JOIN [std].[serviceType] svt
        ON svt.[id] = svp.[serviceTypeId]
    INNER JOIN [std].[serviceCategory] sca
        ON sca.[id] = svp.[serviceCategoryId]
    INNER JOIN [std].[company] cop
        ON cop.[id] = svp.[companyId]
    INNER JOIN [std].[unit] uni
        ON uni.[id] = svp.[unitId]
    INNER JOIN [std].[standard] sta
        ON sta.[id] = svp.[standardId]
    INNER JOIN [std].[currency] cur
        ON cur.[id] = sic.[currencyId]
    LEFT OUTER JOIN (SELECT m.[siteCatalogId],STRING_AGG(si.[name],CHAR(46)) AS [sites] FROM [dlm].[mapSiteCatalogSite] m INNER JOIN [loc].[site] si ON si.[id] = m.[siteId] GROUP BY m.[siteCatalogId]) sites
        ON sites.[siteCatalogId] = sic.[id]
    LEFT OUTER JOIN (SELECT m.[siteCatalogId],STRING_AGG(pl.[code],CHAR(46)) AS [plants] FROM [dlm].[mapSiteCatalogPlant] m INNER JOIN [loc].[plant] pl ON pl.[id] = m.[plantId] GROUP BY m.[siteCatalogId]) plants
        ON plants.[siteCatalogId] = sic.[id]
    '

    EXEC(@viewsql)




END
GO