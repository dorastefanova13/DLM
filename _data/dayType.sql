BEGIN --dayType

    PRINT '    fill dayType'

	MERGE INTO [std].[dayType] AS dayTypeTable
	USING (
		SELECT N'WORKDAY' AS [code] ,N'Arbeitstag' AS [name],N'normaler Arbeitstag' AS [description] ,'{"de":"Arbeitstag","en":"workday"}' AS [nameTranslated] ,'{"de":"normaler Arbeitstag","en":"workday"}' AS [descriptionTranslated] ,0 AS [hasSurcharge],0 AS [isDeleted]
		UNION ALL SELECT N'SATURDAY',N'Samstag',N'Samstag','{"de":"Samstag","en":"Saturday"}','{"de":"Samstag","en":"Saturday"}',1,0
		UNION ALL SELECT N'SUNDAY',N'Sonntag',N'Sonntag','{"de":"Sonntag","en":"Sunday"}','{"de":"Sonntag","en":"Sunday"}',1,0
		UNION ALL SELECT N'NATHOL',N'nationaler Feiertag',N'nationaler Feiertag','{"de":"nationaler Feiertag","en":"national holiday"}','{"de":"nationaler Feiertag","en":"national holiday"}',1,0
		UNION ALL SELECT N'REGHOL',N'regionaler Feiertag',N'regionaler Feiertag','{"de":"regionaler Feiertag","en":"regional holiday"}','{"de":"regionaler Feiertag","en":"regional holiday"}',1,0
		UNION ALL SELECT N'PLANTSHUTDOWN',N'Schließtag',N'Location geschlossen','{"de":"Schließtag","en":"closing day"}','{"de":"Location geschlossen","en":"location closed"}',0,0
	) AS source 
	ON dayTypeTable.[code] = source.[code]
	WHEN MATCHED THEN
		UPDATE SET 
			dayTypeTable.[name] = source.[name],
			dayTypeTable.[description] = source.[description],
			dayTypeTable.[nameTranslated] = NULL, --source.[nameTranslated],
			dayTypeTable.[descriptionTranslated] = NULL, --source.[descriptionTranslated],
			dayTypeTable.[hasSurcharge] = source.[hasSurcharge],
			dayTypeTable.[isDeleted] = source.[isDeleted],
			dayTypeTable.[updatedAt] = GETDATE(),
			dayTypeTable.[updatedBy] = 1
	WHEN NOT MATCHED THEN
		INSERT ([code], [name], [description],  [hasSurcharge],[insertedAt],[insertedBy])
		VALUES (source.[code], source.[name], source.[description], source.[hasSurcharge],GETDATE(),1);

END --dayType
GO



