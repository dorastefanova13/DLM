BEGIN --restore constraints

    PRINT 'restore constraints'

    DECLARE @sql VARCHAR(MAX)='';

    DECLARE cFK CURSOR FOR 
            SELECT N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) + N' WITH CHECK CHECK CONSTRAINT '+ QUOTENAME(c.name) + ';' AS [~]
            FROM sys.objects AS c
            INNER JOIN sys.tables AS t
                ON c.parent_object_id = t.[object_id]
            INNER JOIN sys.schemas AS s 
                ON t.[schema_id] = s.[schema_id]
            WHERE c.[type] IN ('F')
            AND s.[name] IN ('dlm','sec','loc','std','log','app','etl','mig')
            ORDER BY c.[type]

    OPEN cFK
    FETCH NEXT FROM cFK INTO @sql
    WHILE @@FETCH_STATUS = 0
    BEGIN

		BEGIN TRY

			EXECUTE (@sql)

		END TRY
		BEGIN CATCH

			PRINT @sql
			PRINT ERROR_MESSAGE()

		END CATCH

        FETCH NEXT FROM cFK INTO @sql
    END
    CLOSE cFK
    DEALLOCATE cFK

END --restore constraints
GO
