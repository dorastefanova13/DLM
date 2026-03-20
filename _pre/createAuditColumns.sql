BEGIN --set audit columns

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
			WHERE [COLUMN_NAME] NOT IN (N'insertedAt',N'insertedBy',N'updatedAt',N'updatedBy')
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

		--PRINT ''
		--PRINT N'Columns for ' + @tn

		IF (SELECT COUNT(1) FROM [sys].[triggers] WHERE [name] = N'trg_Audit_' + @tn) > 0
		BEGIN

			SET @sql = N'    DROP TRIGGER [' + @ts + '].[trg_Audit_' + @tn + ']'
			--PRINT @sql
			EXECUTE (@sql)

		END

		IF EXISTS (
			SELECT 1
			FROM   INFORMATION_SCHEMA.COLUMNS
			WHERE  [TABLE_SCHEMA] = @ts
			AND [TABLE_NAME] = @tn
			AND COLUMN_NAME = N'insertedAt')
		BEGIN
			SET @sql = N'    ALTER TABLE ' + QUOTENAME(@ts) + '.'+ QUOTENAME(@tn) + ' DROP COLUMN [insertedAt]'
			--PRINT @sql
			EXECUTE (@sql)
		END

		IF EXISTS (
			SELECT 1
			FROM   INFORMATION_SCHEMA.COLUMNS
			WHERE  [TABLE_SCHEMA] = @ts
			AND [TABLE_NAME] = @tn
			AND COLUMN_NAME = N'insertedBy')
		BEGIN
			SET @sql = N'    ALTER TABLE ' + QUOTENAME(@ts) + '.'+ QUOTENAME(@tn) + ' DROP COLUMN [insertedBy]'
			--PRINT @sql
			EXECUTE (@sql)
		END

		IF EXISTS (
			SELECT 1
			FROM   INFORMATION_SCHEMA.COLUMNS
			WHERE  [TABLE_SCHEMA] = @ts
			AND [TABLE_NAME] = @tn
			AND COLUMN_NAME = N'updatedAt')
		BEGIN
			SET @sql = N'    ALTER TABLE ' + QUOTENAME(@ts) + '.'+ QUOTENAME(@tn) + ' DROP COLUMN [updatedAt]'
			--PRINT @sql
			EXECUTE (@sql)
		END

		IF EXISTS (
			SELECT 1
			FROM   INFORMATION_SCHEMA.COLUMNS
			WHERE  [TABLE_SCHEMA] = @ts
			AND [TABLE_NAME] = @tn
			AND COLUMN_NAME = N'updatedBy')
		BEGIN
			SET @sql = N'    ALTER TABLE ' + QUOTENAME(@ts) + '.'+ QUOTENAME(@tn) + ' DROP COLUMN [updatedBy]'
			--PRINT @sql
			EXECUTE (@sql)
		END

		IF @cc <> 2
		BEGIN

			SET @sql = N'    ALTER TABLE ' + QUOTENAME(@ts) + '.'+ QUOTENAME(@tn) + ' ADD [insertedAt] DATETIME NULL '
			--PRINT @sql
			EXECUTE (@sql)
			SET @sql = N'    ALTER TABLE ' + QUOTENAME(@ts) + '.'+ QUOTENAME(@tn) + ' ADD [insertedBy] INT NULL '
			--PRINT @sql
			EXECUTE (@sql)
			SET @sql = N'    ALTER TABLE ' + QUOTENAME(@ts) + '.'+ QUOTENAME(@tn) + ' ADD [updatedAt] DATETIME NULL  '
			--PRINT @sql
			EXECUTE (@sql)
			SET @sql = N'    ALTER TABLE ' + QUOTENAME(@ts) + '.'+ QUOTENAME(@tn) + ' ADD [updatedBy] INT NULL '
			--PRINT @sql
			EXECUTE (@sql)

		END

		FETCH NEXT FROM cMig INTO @ts,@tn,@cc

	END
	CLOSE cMig
	DEALLOCATE cMig

END            




