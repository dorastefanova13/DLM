BEGIN --enable all security policies

    PRINT 'enable all security policies'

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
            SELECT N'ALTER SECURITY POLICY ' + QUOTENAME(s.name) + N'.' + QUOTENAME(p.name) + N' WITH (STATE = ON);  ' AS [~]
            FROM sys.security_policies AS p
            INNER JOIN sys.schemas AS s 
                ON p.[schema_id] = s.[schema_id]

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

END --enable all security policies

GO
