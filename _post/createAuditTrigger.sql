BEGIN --set audit trigger

	PRINT 'set audit trigger'

	DECLARE @triggerStandardSql NVARCHAR(MAX) = '
	CREATE TRIGGER ##ts##.trg_Audit_##tn##
	ON ##tstn##
	AFTER INSERT, UPDATE
	AS
	BEGIN
    
		SET NOCOUNT ON;

		DECLARE @userId INT = (
			SELECT [id] 
			FROM [sec].[client] 
			WHERE [login] = CASE 
				WHEN ISNULL(CAST(SESSION_CONTEXT(N''userid'') AS NVARCHAR(100)),'''') = '''' THEN ''SYSTEM''
				ELSE CAST(SESSION_CONTEXT(N''userid'') AS NVARCHAR(100))
			END
		)
		DECLARE @logJobRunningId INT
		DECLARE @logText NVARCHAR(MAX)= (SELECT * FROM inserted FOR JSON AUTO)
        SET @logText = REPLACE(@logText,''}]'','',"login":"'' + ORIGINAL_LOGIN() + ''"}]'')
        SET @logText = REPLACE(@logText,''}]'','',"userid":"'' + ISNULL(CAST(SESSION_CONTEXT(N''userid'') AS NVARCHAR(100)),'''') + ''"}]'')
		DECLARE @logCaller NVARCHAR(100) = ''trg_Audit_##tn##''				
	
		SET @logJobRunningId = NEXT VALUE FOR [app].[seqLogId]

		--INSERT (inserted exists, delete not exists)

		IF EXISTS (SELECT 1 FROM inserted EXCEPT SELECT 1 FROM deleted)
		BEGIN
			UPDATE t
			SET [insertedAt] = GETDATE(),[insertedBy] =  @userId
			FROM ##tstn## t
			INNER JOIN inserted ON t.[id] = inserted.[id]
			WHERE t.[insertedAt] IS NULL;
		END

		--UPDATE (inserted.id = deleted.id)

		IF EXISTS (SELECT 1 FROM inserted INNER JOIN deleted ON inserted.id = deleted.id)
		BEGIN
			UPDATE t
			SET [updatedAt] = GETDATE(),[updatedBy] = @userId
			FROM ##tstn## t
			INNER JOIN inserted ON t.[id] = inserted.[id];
		END

		INSERT INTO [etl].[log] (
			[logJobRunningId]
			, [logCaller]
			, [logText]
			)
		SELECT @logJobRunningId
			, @logCaller
			, @logText
		WHERE EXISTS (SELECT 1 FROM [std].[parameter] WHERE [key] = ''log_active'' AND [value] = ''1'')

	END;
	'
	DECLARE @triggerMappingSql NVARCHAR(MAX) = '
	CREATE TRIGGER ##ts##.trg_Audit_##tn##
	ON ##tstn##
	AFTER INSERT, DELETE
	AS
	BEGIN
    
		SET NOCOUNT ON;

		DECLARE @userId INT = (
			SELECT [id] 
			FROM [sec].[client] 
			WHERE [login] = CASE 
				WHEN ISNULL(CAST(SESSION_CONTEXT(N''userid'') AS NVARCHAR(100)),'''') = '''' THEN ''SYSTEM''
				ELSE CAST(SESSION_CONTEXT(N''userid'') AS NVARCHAR(100))
			END
		)
		DECLARE @logJobRunningId INT
		DECLARE @logText NVARCHAR(MAX)= (SELECT * FROM inserted FOR JSON AUTO)
        SET @logText = REPLACE(@logText,''}]'','',"login":"'' + ORIGINAL_LOGIN() + ''"}]'')
        SET @logText = REPLACE(@logText,''}]'','',"userid":"'' + ISNULL(CAST(SESSION_CONTEXT(N''userid'') AS NVARCHAR(100)),'''') + ''"}]'')
		DECLARE @logCaller NVARCHAR(100) = ''trg_Audit_##tn##''				
	
		SET @logJobRunningId = NEXT VALUE FOR [app].[seqLogId]

		IF EXISTS (SELECT 1 FROM inserted)
		BEGIN

			UPDATE t
			SET [updatedAt] = GETDATE(),[updatedBy] = @userId
			FROM ##tstnmap1## t
			INNER JOIN inserted ON t.[id] = inserted.[##map1id##];

			UPDATE t
			SET [updatedAt] = GETDATE(),[updatedBy] = @userId
			FROM ##tstnmap2## t
			INNER JOIN inserted ON t.[id] = inserted.[##map2id##];

		END
		
		IF EXISTS (SELECT 1 FROM deleted)
		BEGIN

			UPDATE t
			SET [updatedAt] = GETDATE(),[updatedBy] = @userId
			FROM ##tstnmap1## t
			INNER JOIN deleted ON t.[id] = deleted.[##map1id##];

			UPDATE t
			SET [updatedAt] = GETDATE(),[updatedBy] = @userId
			FROM ##tstnmap2## t
			INNER JOIN deleted ON t.[id] = deleted.[##map2id##];

		END

		INSERT INTO [etl].[log] (
			[logJobRunningId]
			, [logCaller]
			, [logText]
			)
		SELECT @logJobRunningId
			, @logCaller
			, @logText
		WHERE EXISTS (SELECT 1 FROM [std].[parameter] WHERE [key] = ''log_active'' AND [value] = ''1'')

	END;
	'
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @ts NVARCHAR(100)
	DECLARE @tn NVARCHAR(100)
	DECLARE @cc INT
	DECLARE @tstnmap1 NVARCHAR(100)
	DECLARE @tstnmap2 NVARCHAR(100)
	DECLARE @map1id NVARCHAR(100)
	DECLARE @map2id NVARCHAR(100)

	DECLARE cMig CURSOR FOR
		SELECT 
			t.[TABLE_SCHEMA]
			,t.[TABLE_NAME]
			,c.[COLUMN_COUNT]
		FROM INFORMATION_SCHEMA.[Tables] t
		INNER JOIN (
			SELECT 
				[TABLE_SCHEMA]
				,[TABLE_NAME]
				,COUNT(1) AS [COLUMN_COUNT]
			FROM INFORMATION_SCHEMA.[COLUMNS]
			GROUP BY 
				[TABLE_SCHEMA]
				,[TABLE_NAME]
		) c
			ON t.[TABLE_NAME] = c.[TABLE_NAME]
			AND t.[TABLE_SCHEMA] = c.[TABLE_SCHEMA]
		WHERE t.[TABLE_TYPE] = N'BASE TABLE'
		AND (
            t.[TABLE_SCHEMA] IN ('dlm','sec','std')
            OR
            t.[TABLE_NAME] IN ('customCleaningObject','technicalCleaningObject')
            )
		ORDER BY 1,2

	OPEN cMig
	FETCH NEXT FROM cMig INTO @ts,@tn,@cc
	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF (SELECT COUNT(1) FROM [sys].[triggers] WHERE [name] = N'trg_Audit_' + @tn) > 0
		BEGIN

			SET @sql = N'    DROP TRIGGER [' + @ts + '].[trg_Audit_' + @tn + ']'
			PRINT @sql
			EXECUTE (@sql)

		END

		IF @cc > 2
		BEGIN

			SET @sql = REPLACE(REPLACE(REPLACE(@triggerStandardSql , '##tstn##',QUOTENAME(@ts) + '.' + QUOTENAME(@tn)),'##tn##',@tn),'##ts##',@ts)
			--PRINT @sql
			EXECUTE (@sql)

		END
		ELSE
		BEGIN

			SELECT 
				@tstnmap1 =  t_child_schema.name + '.' + t_child.name,
				@map1id = c_parent.name
			FROM sys.foreign_keys fk 
			INNER JOIN sys.foreign_key_columns fkc
				ON fkc.constraint_object_id = fk.object_id
			INNER JOIN sys.tables t_parent
				ON t_parent.object_id = fk.parent_object_id
			INNER JOIN sys.columns c_parent
				ON fkc.parent_column_id = c_parent.column_id  
				AND c_parent.object_id = t_parent.object_id 
			INNER JOIN sys.tables t_child
				ON t_child.object_id = fk.referenced_object_id
			INNER JOIN sys.schemas t_child_schema	
				ON t_child_schema.schema_id = t_child.schema_id
			INNER JOIN sys.columns c_child
				ON c_child.object_id = t_child.object_id
				AND fkc.referenced_column_id = c_child.column_id
            WHERE c_parent.name = @tn
			ORDER BY t_parent.name, c_parent.name
			OFFSET 0 ROW FETCH NEXT 1 ROW ONLY;

			SELECT 
				@tstnmap2 =  t_child_schema.name + '.' + t_child.name,
				@map2id = c_parent.name
			FROM sys.foreign_keys fk 
			INNER JOIN sys.foreign_key_columns fkc
				ON fkc.constraint_object_id = fk.object_id
			INNER JOIN sys.tables t_parent
				ON t_parent.object_id = fk.parent_object_id
			INNER JOIN sys.columns c_parent
				ON fkc.parent_column_id = c_parent.column_id  
				AND c_parent.object_id = t_parent.object_id 
			INNER JOIN sys.tables t_child
				ON t_child.object_id = fk.referenced_object_id
			INNER JOIN sys.schemas t_child_schema	
				ON t_child_schema.schema_id = t_child.schema_id
			INNER JOIN sys.columns c_child
				ON c_child.object_id = t_child.object_id
				AND fkc.referenced_column_id = c_child.column_id
            WHERE c_parent.name = @tn
			ORDER BY t_parent.name, c_parent.name
			OFFSET 1 ROW FETCH NEXT 1 ROW ONLY;

			SET @sql = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@triggerMappingSql , '##tstn##',QUOTENAME(@ts) + '.' + QUOTENAME(@tn)),'##tn##',@tn),'##tstnmap1##',@tstnmap1),'##tstnmap2##',@tstnmap2),'##map1id##',@map1id),'##map2id##',@map2id),'##ts##',@ts)
			--PRINT @sql
			EXECUTE (@sql)

		END

		FETCH NEXT FROM cMig INTO @ts,@tn,@cc

	END
	CLOSE cMig
	DEALLOCATE cMig

END            
