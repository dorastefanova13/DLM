BEGIN

	DECLARE @msg NVARCHAR(MAX)
	DECLARE @rowcount INT

	SET @msg = 'Add positionspecific Maincodedescription to ServicePositionDescription'
	PRINT @msg

	UPDATE t1
	SET t1.[maincodedescription] = t1.[maincodedescription] + ' - ' + t2.[maincodename]
	FROM [dlm].[serviceposition] t1
	INNER JOIN
	(
	SELECT
		sp.[id] as [servicepositionid]
		,sp.[mainCodeDescription]
		,mcd.[maincodename]
	FROM [dlm].[servicePosition] sp
	INNER JOIN [mig].[mapSspItemServicePosition] msspisp 
		ON msspisp.[dlm3Id] = sp.[id]
	INNER JOIN [archiv].[dbo_sspitem] asspi 
		ON asspi.[id] = msspisp.[dlm2id]
	INNER JOIN [archiv].[dbo_SspEffectiveMainCodeDetail] mcd 
		ON mcd.[MainCodeId] = asspi.[MainCodeId] 
		AND mcd.[SspId] = asspi.[SspId]
	WHERE mcd.[lcid] = 1031
	AND sp.[mainCodeDescription] <> mcd.[maincodename] COLLATE SQL_Latin1_General_CP1_CI_AS
	) t2
	ON t2.[servicepositionid] = t1.[id]

	SET @rowcount = @@ROWCOUNT

	 PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'
END
GO