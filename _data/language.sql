BEGIN --language

    PRINT '    fill language'

    MERGE INTO [std].[language] t
    USING
    (
        SELECT 'DE' AS [code],'german' AS [name],N'{"DE":"deutsch","EN":"german"}' AS [nameTranslated] ,0 AS [isDeleted]
        UNION ALL SELECT 'EN','english',N'{"DE":"englisch","EN":"english"}',0
        UNION ALL SELECT 'FR','french',N'{"DE":"französich","EN":"french","FR":"français"}',0
        UNION ALL SELECT 'HU','hungarian',N'{"DE":"ungarisch","EN":"hungarian","HU":"magyar"}',0
    ) s
    ON  t.[code] = s.[code]
    WHEN NOT MATCHED THEN
        INSERT([code],[name],[nameTranslated],[isDeleted],[insertedAt],[insertedBy])
        VALUES(s.[code],s.[name],s.[nameTranslated],s.[isDeleted],GETDATE(),1)
    WHEN MATCHED THEN 
        UPDATE SET
            t.[name] = s.[name]
			,t.[nameTranslated] = s.[nameTranslated]
            ,t.[isDeleted] = s.[isDeleted]
			,t.[updatedAt] = GETDATE()
			,t.[updatedBy] = 1
			;

END --language
GO
