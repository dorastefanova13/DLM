BEGIN --serviceOrderExecutionStatus

    PRINT '    fill serviceOrderExecutionStatus'

    --DELETE FROM [std].[serviceOrderExecutionStatus]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[serviceOrderExecutionStatus] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

	MERGE INTO [std].[serviceOrderExecutionStatus] AS t
	USING
	(
	    SELECT 0 AS [id],N'n/a' AS [code] ,N'keine Zuordnung' AS [name] ,N'keine Zuordnung' AS [description],0 AS [isDeleted]
		UNION ALL SELECT 1,N'PLANNED',N'geplant',N'Ausführung geplant',0
		UNION ALL SELECT 2,N'DONE',N'ausgeführt',N'Ausführung fertig',0
		UNION ALL SELECT 3,N'NOT DONE', N'keine Ausführung',N'keine Ausführung',0
	) AS s
	ON t.[code] = s.[code]
	WHEN NOT MATCHED THEN
		INSERT ([id],[code],[description],[name],[isDeleted]) 
		VALUES (s.[id],s.[code],s.[description],s.[name],s.[isDeleted]) 
	;

    SET IDENTITY_INSERT [std].[serviceOrderExecutionStatus] OFF 

END --serviceOrderExecutionStatus
GO
