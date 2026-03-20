BEGIN --reportConfig

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    reportConfig'

    PRINT @msg

    DECLARE @rowCount INT

    DELETE FROM [rep].[reportConfig]

    INSERT INTO [rep].[reportConfig]([report],[reportId])
    SELECT [report],[reportId] FROM [archiv].[stage_reportConfig]

    SET @rowCount = @@ROWCOUNT
    
    PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'
    
END
    
