BEGIN --mainCode

    PRINT '    fill mainCode'

    DECLARE @serviceTypeId INT = (SELECT [id] FROM [std].[serviceType] WHERE [name] = 'Unterhaltsreinigung')

    DROP TABLE IF EXISTS [mig].[mapMainCodeMainCode]
    CREATE TABLE [mig].[mapMainCodeMainCode] (dlm2Id INT, dlm3Id INT, isSspSpecific BIT)

		--maincodes for DLM2.0-Legacy-Positions

    INSERT INTO [dlm].[mainCode]([code],[description],[isActive],[isLegacy],[isRewritable],[serviceTypeId],[isSiteCatalogSpecific],[isDeleted],[insertedAt],[insertedBy])
    SELECT RIGHT('00' + CAST(t1.[code] AS NVARCHAR),3),t.[DefaultText],1,1,0,@serviceTypeId,[isSspSpecific],0 ,t1.[Created],1
    FROM [archiv].[dbo_MainCode] t1
    INNER JOIN [archiv].[dbo_Text] t
        ON t.[id] = t1.[NameTextId]

    INSERT [mig].[mapMainCodeMainCode] (dlm2Id,dlm3Id,isSspSpecific)
    SELECT dlm2.[Id],dlm3.[id],dlm2.[IsSspSpecific]
    FROM  [archiv].[dbo_MainCode] dlm2
    INNER JOIN [dlm].[mainCode] dlm3
        ON dlm2.[Code] = dlm3.[code]

		--new maincodes for DLM3.0

    INSERT INTO [dlm].[mainCode]([code],[description],[isActive],[isLegacy],[isRewritable],[serviceTypeId],[isSiteCatalogSpecific],[isDeleted],[insertedAt],[insertedBy])
    SELECT RIGHT('00' + CAST(t1.[code] AS NVARCHAR),3),t.[DefaultText],1,0,0,@serviceTypeId,[isSspSpecific],0 ,t1.[Created],1
    FROM [archiv].[dbo_MainCode] t1
    INNER JOIN [archiv].[dbo_Text] t
        ON t.[id] = t1.[NameTextId]

END --mainCode
GO


