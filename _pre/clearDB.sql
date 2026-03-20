BEGIN --uncheck constraints and empty database

    PRINT  CONVERT(NVARCHAR,getdate(),120) + ' - uncheck constraints'

    DECLARE @sql VARCHAR(MAX)='';

     IF (
	    SELECT cursor_status('global', 'cMig')
        ) >= - 1
     BEGIN
	    IF (
	        SELECT cursor_status('global', 'cMig')
	       ) > - 1
	    BEGIN
		    CLOSE cMig
	    END
    	DEALLOCATE cMig
     END

    DECLARE cMig CURSOR FOR 
            SELECT N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) + N' NOCHECK CONSTRAINT '+ QUOTENAME(c.name) + ';' AS [~]
            FROM sys.objects AS c
            INNER JOIN sys.tables AS t
                ON c.parent_object_id = t.[object_id]
            INNER JOIN sys.schemas AS s 
                ON t.[schema_id] = s.[schema_id]
            WHERE c.[type] IN ('F')
            --WHERE c.[type] IN ('D','C','F','PK','UQ')
            AND s.[name] IN ('dlm','sec','loc','std','log','app','mig','rep')
            ORDER BY c.[type]

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

    PRINT  CONVERT(NVARCHAR,getdate(),120) + ' - empty database'

    DECLARE cMig CURSOR FOR 
            SELECT N'DELETE FROM ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)  AS [~]
            --SELECT N'TRUNCATE TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)  AS [~]
            FROM sys.tables AS t
            INNER JOIN sys.schemas AS s 
                ON t.[schema_id] = s.[schema_id]
            WHERE s.[name] IN ('dlm','sec','loc','std','log','app','mig','rep')
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

    PRINT  CONVERT(NVARCHAR,getdate(),120) + ' - reset identity-columns'

    DECLARE cMig CURSOR FOR 
            SELECT QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)  AS [~]
            FROM sys.tables AS t
            INNER JOIN sys.schemas AS s 
                ON t.[schema_id] = s.[schema_id]
            WHERE s.[name] IN ('dlm','sec','loc','std','log','app','rep')
            ORDER BY s.[name],t.[name]

    OPEN cMig
    FETCH NEXT FROM cMig INTO @sql
    WHILE @@FETCH_STATUS = 0
    BEGIN

        BEGIN TRY

            DBCC CHECKIDENT(@sql, RESEED, 0) WITH NO_INFOMSGS 
            IF IDENT_CURRENT(@sql) = 0
            BEGIN
                DBCC CHECKIDENT(@sql, RESEED, 1) WITH NO_INFOMSGS 
            END

        END TRY
        BEGIN CATCH

            SET @sql = @sql --Dummybefehl

        END CATCH

        FETCH NEXT FROM cMig INTO @sql
    END
    CLOSE cMig
    DEALLOCATE cMig


END --uncheck constraints and empty database

GO
