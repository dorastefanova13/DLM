BEGIN --jobStatus

    PRINT '    fill jobStatus'

	DELETE FROM [etl].jobStatus

    INSERT INTO [etl].[jobStatus]([name],[isRunning],[isDeleted])
    SELECT 'started', 1, 0 UNION ALL
    SELECT 'started manually', 1, 0 UNION ALL
    SELECT 'finished', 0, 0 UNION ALL
    SELECT 'error',0,0

END --jobStatus
GO
