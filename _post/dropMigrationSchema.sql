BEGIN --drop temp migration schema
    PRINT 'drop temp migration schema'

    IF $(dropmigschema) = '1'
    BEGIN

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

END --drop temp migration schema