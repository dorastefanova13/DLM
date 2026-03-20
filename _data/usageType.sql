BEGIN --usageType

    PRINT '    fill usageType'

    DROP TABLE IF EXISTS [mig].[mapUsageTypeUsageType]
    CREATE TABLE [mig].[mapUsageTypeUsageType] (dlm2Id INT, dlm3Id INT)

    CREATE CLUSTERED INDEX [x_mapUsageTypeUsageType] ON [mig].[mapUsageTypeUsageType]
    (
        [dlm2Id] ASC
    )
    DELETE FROM [std].[usageType]

    BEGIN TRY

        SET IDENTITY_INSERT [std].[usageType] ON

    END TRY
    BEGIN CATCH

        PRINT '   IDENTITY_INSERT = ON'

    END CATCH

    INSERT INTO [std].[usageType]([id],[name],[ffg6],[isDeleted],[insertedAt],[insertedBy])
    SELECT 0,'keine Zuordnung','keine Zuordnung',0,GETDATE(),1

    INSERT [mig].[mapUsageTypeUsageType] (dlm2Id,dlm3Id)
    SELECT 0,0

    SET IDENTITY_INSERT [std].[usageType] OFF

    INSERT INTO [std].[usageType]([name],[ffg6],[isDeleted],[insertedAt],[insertedBy])
    SELECT [Code],[FFG_6_ID],0 ,[Created],1
	FROM [archiv].[faplis_UsageType]

    INSERT [mig].[mapUsageTypeUsageType] (dlm2Id,dlm3Id)
    SELECT dlm2.[Id] as dlm2id,dlm3.[id] as dlm3id
    FROM  [archiv].[faplis_UsageType] dlm2
    INNER JOIN [std].[usageType] dlm3
        ON dlm2.[Code] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[name]
		AND ISNULL(dlm2.[FFG_6_ID] COLLATE SQL_Latin1_General_CP1_CI_AI,' ') = ISNULL(dlm3.[ffg6],' ')

--    select code,count(1) from [FAPLISDlm].faplis.UsageType group by code order by 2 desc
--    select * from std.usageType
--    select * from ##mapUsageTypeUsageType

END --usageType
GO

