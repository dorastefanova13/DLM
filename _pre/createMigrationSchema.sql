BEGIN

    PRINT 'clean temp schema [mig] if exists'

    DROP FUNCTION IF EXISTS  [mig].[fnGetIdFromFilename]

    DECLARE @sql VARCHAR(MAX)='';

    DECLARE cMig CURSOR FOR 
            SELECT N'DROP TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)  AS [~]
            FROM sys.tables AS t
            INNER JOIN sys.schemas AS s 
                ON t.[schema_id] = s.[schema_id]
            WHERE s.[name] IN ('mig')
            ORDER BY s.[name],t.[name]

    OPEN cMig
    FETCH NEXT FROM cMig INTO @sql
    WHILE @@FETCH_STATUS = 0
    BEGIN

        --PRINT @sql
        EXECUTE (@sql)
        FETCH NEXT FROM cMig INTO @sql
    END
    CLOSE cMig
    DEALLOCATE cMig

    DROP SCHEMA IF EXISTS mig;


END
PRINT 'create temp schema [mig]'
GO
CREATE SCHEMA mig AUTHORIZATION dbo;
GO
DROP FUNCTION IF EXISTS  [mig].[fnGetIdFromFilename]
GO
CREATE FUNCTION [mig].[fnGetIdFromFilename]
(
	@filename VARCHAR(255)
)
RETURNS NVARCHAR(250)
AS
BEGIN

	DECLARE @result NVARCHAR(250) = '' 
	DECLARE @startpos INT = 0

    IF @filename NOT LIKE '10000%'
    BEGIN

        IF @filename = 'n/a' 
        BEGIN

            SET @result = @filename

        END
        ELSE
        BEGIN
        
            WHILE PATINDEX('%[^0-9]%', @filename) > 0
            BEGIN
                SET @filename = STUFF( @filename, PATINDEX('%[^0-9]%',  @filename), 1, '')
            END

            SET @result = @filename

        END

    END
    ELSE
    BEGIN
	
	    SET @result = RIGHT(@filename,LEN(@filename) - CHARINDEX(':',@filename))
	    SET @result = RIGHT(@result,LEN(@result) - CHARINDEX('1000',@result) + 1)
	
        SET @result = LEFT(@result,CHARINDEX('-',REPLACE(@result,'_','-')) -1)

    END

	RETURN @result

END
GO


