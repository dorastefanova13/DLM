BEGIN --calendar

	PRINT '    fill calendar'

    DELETE FROM [dlm].[calendarDay]
    DELETE FROM [dlm].[calendar]

    DECLARE @parentId INT
    DECLARE @dayTypeId INT

	DECLARE @von DATE
	DECLARE @bis DATE

	DECLARE @workdayid INT = (SELECT [id] FROM [std].[dayType] WHERE [code] = 'WORKDAY')
	DECLARE @saturdayid INT = (SELECT [id] FROM [std].[dayType] WHERE [code] = 'SATURDAY')
	DECLARE @sundayid INT = (SELECT [id] FROM [std].[dayType] WHERE [code] = 'SUNDAY')
	DECLARE @natdayid INT = (SELECT [id] FROM [std].[dayType] WHERE [code] =  'NATHOL')
	DECLARE @regdayid INT = (SELECT [id] FROM [std].[dayType] WHERE [code] =  'REGHOL')

    --2023


    INSERT INTO [dlm].[calendar]([name],[locale],[year],[isDeleted],[isTemplate])
    SELECT 'Kalender Deutschland 2023','de-DE',2023,0,1

    SET @parentId = @@IDENTITY

	SET @von = CONVERT(DATETIME,'20230101',112)
	SET @bis = CONVERT(DATETIME,'20231231',112)



	WHILE @von <= @bis
	BEGIN

		INSERT INTO dlm.calendarDay([dayMonth],[name],[description],[dayTypeId],[calendarId],[isDeleted],[insertedAt],[insertedBy])
		SELECT 
			@von
			,CONVERT(NVARCHAR,@von,104)
			,CONVERT(NVARCHAR,@von,104)
			,CASE SUBSTRING(DATENAME(weekday, @von),1,2)
				WHEN 'SA' THEN @saturdayid
				WHEN 'SU' THEN @sundayid
				WHEN 'SO' THEN @sundayid
				ELSE @workdayid
			END
			,@parentId
			,0
			,GETDATE()
			,1

			SET @von = DATEADD(DAY,1,@von)

	END

	UPDATE dlm.calendarDay SET [description] = 'Neujahr',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20230101',112)
	UPDATE dlm.calendarDay SET [description] = 'Karfreitag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20230407')
	UPDATE dlm.calendarDay SET [description] = 'Ostermontag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20230410')
	UPDATE dlm.calendarDay SET [description] = 'Maifeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20230501')
	UPDATE dlm.calendarDay SET [description] = 'Himmelfahrt',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20230518')
	UPDATE dlm.calendarDay SET [description] = 'Pfingstmontag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20230529')
	UPDATE dlm.calendarDay SET [description] = 'Tag der Deutschen Einheit',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20231003')
	UPDATE dlm.calendarDay SET [description] = '1. Weihnachtsfeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20231225')
	UPDATE dlm.calendarDay SET [description] = '2. Weihnachtsfeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20231226')


    --2024

    INSERT INTO [dlm].[calendar]([name],[locale],[year],[isDeleted],[isTemplate],[insertedAt],[insertedBy])
    SELECT 'Kalender Deutschland 2024','de-DE',2024,0,1,GETDATE(),1

    SET @parentId = @@IDENTITY

	SET @von = CONVERT(DATETIME,'20240101',112)
	SET @bis = CONVERT(DATETIME,'20241231',112)



	WHILE @von <= @bis
	BEGIN

		INSERT INTO dlm.calendarDay([dayMonth],[name],[description],[dayTypeId],[calendarId],[isDeleted],[insertedAt],[insertedBy])
		SELECT 
			@von
			,CONVERT(NVARCHAR,@von,104)
			,CONVERT(NVARCHAR,@von,104)
			,CASE SUBSTRING(DATENAME(weekday, @von),1,2)
				WHEN 'SA' THEN @saturdayid
				WHEN 'SU' THEN @sundayid
				WHEN 'SO' THEN @sundayid
				ELSE @workdayid
			END
			,@parentId
			,0
			,GETDATE()
			,1

			SET @von = DATEADD(DAY,1,@von)

	END

	UPDATE dlm.calendarDay SET [description] = 'Neujahr',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20240101',112)
	UPDATE dlm.calendarDay SET [description] = 'Karfreitag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20240329')
	UPDATE dlm.calendarDay SET [description] = 'Ostermontag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20240401')
	UPDATE dlm.calendarDay SET [description] = 'Maifeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20240501')
	UPDATE dlm.calendarDay SET [description] = 'Himmelfahrt',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20240509')
	UPDATE dlm.calendarDay SET [description] = 'Pfingstmontag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20240520')
	UPDATE dlm.calendarDay SET [description] = 'Tag der Deutschen Einheit',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20241003')
	UPDATE dlm.calendarDay SET [description] = '1. Weihnachtsfeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20241225')
	UPDATE dlm.calendarDay SET [description] = '2. Weihnachtsfeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20241226')

    INSERT INTO [dlm].[calendar]([parentId],[name],[locale],[year],[isDeleted],[isTemplate],[insertedAt],[insertedBy])
    SELECT @parentId,'Kalender Bundesland Berlin 2024','de-DE',2023,0,0,GETDATE(),1

    SET @parentId = @@IDENTITY
    INSERT INTO [dlm].[calendarDay]([dayMonth],[name],[description],[dayTypeId],[calendarId],[isDeleted],[insertedAt],[insertedBy]) SELECT CONVERT(date,'20240308',112),'Frauentag','Frauentag',@regdayid,@parentId,0, GETDATE(),1

    --2025

    INSERT INTO [dlm].[calendar]([name],[locale],[year],[isDeleted],[isTemplate],[insertedAt],[insertedBy])
    SELECT 'Kalender Deutschland 2025','de-DE',2025,0,1,GETDATE(),1

    SET @parentId = @@IDENTITY

	SET @von = CONVERT(DATETIME,'20250101',112)
	SET @bis = CONVERT(DATETIME,'20251231',112)

	WHILE @von <= @bis
	BEGIN

		INSERT INTO dlm.calendarDay([dayMonth],[name],[description],[dayTypeId],[calendarId],[isDeleted],[insertedAt],[insertedBy])
		SELECT 
			@von
			,CONVERT(NVARCHAR,@von,104)
			,CONVERT(NVARCHAR,@von,104)
			,CASE SUBSTRING(DATENAME(weekday, @von),1,2)
				WHEN 'SA' THEN @saturdayid
				WHEN 'SU' THEN @sundayid
				WHEN 'SO' THEN @sundayid
				ELSE @workdayid
			END
			,@parentId
			,0
			,GETDATE()
			,1

			SET @von = DATEADD(DAY,1,@von)

	END

    UPDATE dlm.calendarDay SET [description] = 'Neujahr',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20250101',112)
	UPDATE dlm.calendarDay SET [description] = 'Karfreitag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20250418')
	UPDATE dlm.calendarDay SET [description] = 'Ostermontag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20250421')
	UPDATE dlm.calendarDay SET [description] = 'Maifeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20250501')
	UPDATE dlm.calendarDay SET [description] = 'Himmelfahrt',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20250529')
	UPDATE dlm.calendarDay SET [description] = 'Pfingstmontag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20250609')
	UPDATE dlm.calendarDay SET [description] = 'Tag der Deutschen Einheit',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20251003')
	UPDATE dlm.calendarDay SET [description] = '1. Weihnachtsfeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20251225')
	UPDATE dlm.calendarDay SET [description] = '2. Weihnachtsfeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20251226')


    INSERT INTO [dlm].[calendar]([parentId],[name],[locale],[year],[isDeleted],[isTemplate],[insertedAt],[insertedBy])
    SELECT @parentId,'Kalender Bundesland Berlin 2025','de-DE',2025,0,0,GETDATE(),1

    SET @parentId = @@IDENTITY
    INSERT INTO [dlm].[calendarDay]([dayMonth],[name],[description],[dayTypeId],[calendarId],[isDeleted],[insertedAt],[insertedBy]) SELECT CONVERT(date,'20250308',112),'Frauentag','Frauentag',@regdayid,@parentId,0,GETDATE(),1

    INSERT INTO [dlm].[calendarDay]([dayMonth],[name],[description],[dayTypeId],[calendarId],[isDeleted],[insertedAt],[insertedBy]) SELECT CONVERT(date,'20250508',112),'Tag der Befreiung','Tag der Befreiung',@regdayid,@parentId,0,GETDATE(),1

    --2026

    INSERT INTO [dlm].[calendar]([name],[locale],[year],[isDeleted],[isTemplate],[insertedAt],[insertedBy])
    SELECT 'Kalender Deutschland 2026','de-DE',2026,0,1,GETDATE(),1

    SET @parentId = @@IDENTITY

	SET @von = CONVERT(DATETIME,'20260101',112)
	SET @bis = CONVERT(DATETIME,'20261231',112)

	WHILE @von <= @bis
	BEGIN

		INSERT INTO dlm.calendarDay([dayMonth],[name],[description],[dayTypeId],[calendarId],[isDeleted],[insertedAt],[insertedBy])
		SELECT 
			@von
			,CONVERT(NVARCHAR,@von,104)
			,CONVERT(NVARCHAR,@von,104)
			,CASE SUBSTRING(DATENAME(weekday, @von),1,2)
				WHEN 'SA' THEN @saturdayid
				WHEN 'SU' THEN @sundayid
				WHEN 'SO' THEN @sundayid
				ELSE @workdayid
			END
			,@parentId
			,0
			,GETDATE()
			,1

			SET @von = DATEADD(DAY,1,@von)

	END

    UPDATE dlm.calendarDay SET [description] = 'Neujahr',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20260101',112)
	UPDATE dlm.calendarDay SET [description] = 'Karfreitag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20260403')
	UPDATE dlm.calendarDay SET [description] = 'Ostermontag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20260406')
	UPDATE dlm.calendarDay SET [description] = 'Maifeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20260501')
	UPDATE dlm.calendarDay SET [description] = 'Himmelfahrt',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20260514')
	UPDATE dlm.calendarDay SET [description] = 'Pfingstmontag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20260525')
	UPDATE dlm.calendarDay SET [description] = 'Tag der Deutschen Einheit',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20261003')
	UPDATE dlm.calendarDay SET [description] = '1. Weihnachtsfeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20261225')
	UPDATE dlm.calendarDay SET [description] = '2. Weihnachtsfeiertag',[dayTypeId] = @natdayid WHERE [dayMonth] = CONVERT(DATETIME,'20261226')


    INSERT INTO [dlm].[calendar]([parentId],[name],[locale],[year],[isDeleted],[isTemplate],[insertedAt],[insertedBy])
    SELECT @parentId,'Kalender Bundesland Berlin 2026','de-DE',2026,0,0,GETDATE(),1

    SET @parentId = @@IDENTITY
    INSERT INTO [dlm].[calendarDay]([dayMonth],[name],[description],[dayTypeId],[calendarId],[isDeleted],[insertedAt],[insertedBy]) SELECT CONVERT(date,'20260308',112),'Frauentag','Frauentag',@regdayid,@parentId,0,GETDATE(),1



END --calendar
GO
