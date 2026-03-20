BEGIN --mainCodeUsageType

    PRINT '    fill mainCodeUsageType'

    INSERT INTO [dlm].[mapMainCodeUsageType]([mainCodeId],[usageTypeId])
    SELECT tmc.[dlm3Id],tut.[dlm3Id]
    FROM  [archiv].[dbo_MainCodeUsageType] mu
    INNER JOIN [mig].[mapMainCodeMainCode] tmc ON tmc.[dlm2Id] = mu.[MainCodeId]
    INNER JOIN [mig].[mapUsageTypeUsageType] tut ON tut.[dlm2Id] = mu.[UsageTypeId]


	INSERT INTO [dlm].[mapMainCodeUsagetype]([mainCodeId],[usageTypeId])
	SELECT mc3.[id],mcut.[usageTypeId] FROM 
	(SELECT * FROM [dlm].[maincode] WHERE isLegacy = 1) mc2
	INNER JOIN  (SELECT * FROM [dlm].[maincode] WHERE isLegacy = 0) mc3
		ON mc3.[code] = mc2.[code]
	INNER JOIN  [dlm].[mapMainCodeUsageType] mcut
		ON  mcut.[mainCodeId] = mc2.[id]

END --mainCodeUsageType


GO
