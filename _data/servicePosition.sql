BEGIN --servicePosition

    SET NOCOUNT ON

    PRINT '    fill servicePosition'

    DECLARE @msg NVARCHAR(MAX)

    DECLARE @dlm2Id INT
    DECLARE @dlm3Id INT
    DECLARE @companyId INT
    DECLARE @ServiceCategoryId INT
	DECLARE @ServiceCatalogId INT
    DECLARE @mappingUnitId INT
    DECLARE @mappingCompanyId INT
    DECLARE @mappingServiceCategoryId INT
    DECLARE @mappingServiceCatalogId INT
    DECLARE @mappingMainCodeId INT
    DECLARE @mappingCycleCodeId INT
    DECLARE @mappingCycleId INT

    DECLARE @StandardId INT = (SELECT [id] FROM [std].[standard] WHERE UPPER([name]) = UPPER('Standard'))
    DECLARE @ServiceTypeId INT = (SELECT [id] FROM [std].[serviceType] WHERE UPPER([name]) = UPPER('Unterhaltsreinigung'))

    DECLARE
        @sspId  INT,
        @sscId  INT,
        @sscIdOld  INT,
        @Code   NVARCHAR(200),
        @MainCode   NVARCHAR(200),
        @CodeOld   NVARCHAR(200),
        @Name   NVARCHAR(200),
        @Definition   NVARCHAR(200),
        @SspName   NVARCHAR(200),
        @Description    NVARCHAR(2000),
        @CycleCodeId    INT,
        @MainCodeId INT,
        @TurnusId INT,
        @SspMainCodeDescription NVARCHAR(200),
        @isSiteSpecific BIT,
        @ItemOrderNo NVARCHAR(100),
        @UnitId INT,
        @ItemNo INT,
        @IsActive BIT,
        @IsMajorItem BIT,
        @isWinterService BIT,
        @sspCategoryId INT,
        @CycleId INT,
        @sspItemNo INT,
        @isGlobal BIT,
        @rowCount INT,
        @mapCount INT,
        @mapCatalogCount INT,
        @dlm2MainCodeId INT,
        @dlm2CycleCodeId INT,
        @dlm2ItemNo INT,
        @dlm2SspId INT,
        @servicePositionId INT

	DECLARE @insAt DATE
	DECLARE @updAt DATE
	DECLARE @insBy INT
	DECLARE @updBy INT

    DECLARE @staNonStandardId INT = (SELECT  [id] FROM [std].[standard] WHERE UPPER([name]) = UPPER('non Standard'))
    DECLARE @staBestBenchId INT = (SELECT  [id] FROM [std].[standard] WHERE UPPER([name]) = UPPER('%BEST-BENCH%'))
    DECLARE @staEcoId INT = (SELECT  [id] FROM [std].[standard] WHERE UPPER([name]) = UPPER('Eco'))


    BEGIN TRY

        DELETE FROM [dlm].[servicePosition]
        DELETE FROM [dlm].[mapServiceCatalogServicePosition]
        DELETE FROM [dlm].[mapServicePositionUsageType]

        BEGIN --LV---------------------------------------------------------------------------------

            DROP TABLE IF EXISTS [mig].[mapSspItemServicePosition]

            CREATE TABLE [mig].[mapSspItemServicePosition] (dlm3Id INT ,dlm2Id INT,  dlm2MainCodeId INT, dlm2CycleCodeId INT, dlm2ItemNo INT, dlm2SspId INT, typ NVARCHAR(100))

            CREATE CLUSTERED INDEX [x_mapSspItemServicePosition] ON [mig].[mapSspItemServicePosition]
            (
    	        [dlm2Id],[dlm2MainCodeId],[dlm2CycleCodeId],[dlm2ItemNo],[dlm2SspId] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

            SELECT @ServiceTypeId = [id] FROM [std].[serviceType] WHERE UPPER([name]) = UPPER('Unterhaltsreinigung')

            BEGIN --   fill with SSPItem for global LV standard

                SET @msg =  '   fill with SSPItem for global LV standard'
                PRINT @msg

                SET @rowCount = 0

                INSERT INTO [dlm].[servicePosition] ([name],[description],[mainCodeDescription],[isSiteSpecific],[servicePositionNo]
                ,[servicePositionOrderNo],[isMainService],[mainCodeId],[unitId],[standardId],[serviceCategoryId],[turnusId],[turnusServicePositionId],[serviceTypeId],[companyId]
                ,[isActive],[isDeleted],[isLegacy],[insertedBy])
                OUTPUT inserted.[insertedBy],inserted.[id],N'LV global standard'
                INTO  [mig].[mapSspItemServicePosition]([dlm2Id],[dlm3Id],[typ])
                SELECT 	
                    i.[Name] AS [dlm2Name]
                    ,i.[Description] AS [dlm2Description]
                    ,t.[DefaultText] AS [sspMainCodeDescription]
                    ,ISNULL(mc.[IsSspSpecific],0) AS [isSiteSpecific]
                    ,i.[ItemNo]
                    ,RIGHT(N'000' + CAST(i.[ItemNo] AS NVARCHAR),3)
                    ,i.[IsMajorItem]
                    ,mMCMC.[dlm3Id] AS [mainCodeId]
                    ,mUU.[dlm3Id] AS [unitIt]
                    ,CASE
                        WHEN UPPER(i.[Name]) LIKE '%NON-STANDARD%' THEN @staNonStandardId
                        WHEN UPPER(i.[Name]) LIKE '%BEST-BENCH%' THEN @staBestBenchId
                        WHEN UPPER(i.[Name]) LIKE '%ECO%' THEN @staEcoId
                        ELSE 0
                    END AS [standardId]
                    ,mSCSC.[dlm3Id] AS [serviceCategoryId]
                    ,mCT.[dlm3Id] AS [turnusId]
                    ,mCTPosition.[dlm3Id] AS [tunrusServicePositi0nId]
                    ,@serviceTypeId 
                    ,mCOCO.[dlm3Id] AS [companyId]
                    ,i.[IsActive]
                    ,0 AS [deleted]
                    ,1 AS [isLegacy]
                    ,i.[id] AS [dlm2Id]
                FROM [archiv].[dbo_SspItem] i
                INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
                    ON ssp.[id] = i.[SspId]
                INNER JOIN [mig].[mapServiceSpecificationServiceCatalog] mSSSC 
                    ON mSSSC.[dlm2id] = i.[SspId]
                INNER JOIN [dlm].[serviceCatalog] svc
                    ON svc.[id] = mSSSC.[dlm3Id] 
                INNER JOIN [archiv].[dbo_SspCompany] sspco
                    ON sspco.[SspId] = ssp.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2id] = sspco.[CompanyId]
					AND mCOCO.[dlm3id] = svc.[companyId]
                INNER JOIN [mig].[mapUnitUnit] mUU
                    ON mUU.[dlm2Id] = ISNULL(i.[UnitId],0)
                INNER JOIN [mig].[mapSspCategoryServiceCategory] mSCSC
                    ON mSCSC.[dlm2Id] = ssp.[SspCategoryId]
                INNER JOIN [mig].[mapMainCodeMainCode] mMCMC
                    ON mMCMC.[dlm2Id] = i.[MainCodeId]
                INNER JOIN [mig].[mapCycleTurnus] mCT
                    ON mCT.[dlm2Id] = i.[CycleCodeId]
                INNER JOIN [mig].[mapCycleTurnus] mCTPosition
                    ON mCTPosition.[dlm2Id] = i.[CycleId]
                INNER JOIN [archiv].[dbo_MainCode] mc
                    ON mc.[id] = mMCMC.[dlm2Id]
                INNER JOIN [archiv].[dbo_Text] t
                    ON t.[Id] = mc.[NameTextId]
				INNER JOIN [std].[company] co
					ON co.[id] = svc.[companyId]
                WHERE ISNULL(ssp.[isGLobal],0) <> 0     -- nur SspItems aus globalen LVs
				AND ISNULL(ssp.[IsStandard],0) = 1  --nur SspItem for global LV is Standard
                AND mCOCO.[dlm3Id] = svc.[companyId]

                SET @rowCount = @@ROWCOUNT

                PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

            END

            BEGIN --   fill with SSPItem for global LV non standard

                SET @msg =  '   fill with SSPItem for global LV non standard'
                PRINT @msg

                SET @rowCount = 0

                INSERT INTO [dlm].[servicePosition] ([name],[description],[mainCodeDescription],[isSiteSpecific],[servicePositionNo]
                ,[servicePositionOrderNo],[isMainService],[mainCodeId],[unitId],[standardId],[serviceCategoryId],[turnusId],[turnusServicePositionId],[serviceTypeId],[companyId]
                ,[isActive],[isDeleted],[isLegacy],[insertedBy])
                OUTPUT inserted.[insertedBy],inserted.[id],N'LV global non standard'
                INTO  [mig].[mapSspItemServicePosition]([dlm2Id],[dlm3Id],[typ])
                SELECT 	
                    i.[Name] AS [dlm2Name]
                    ,i.[Description] AS [dlm2Description]
                    ,t.[DefaultText] AS [sspMainCodeDescription]
                    ,ISNULL(mc.[IsSspSpecific],0) AS [isSiteSpecific]
                    ,i.[ItemNo]
                    ,RIGHT(N'000' + CAST(i.[ItemNo] AS NVARCHAR),3)
                    ,i.[IsMajorItem]
                    ,mMCMC.[dlm3Id] AS [mainCodeId]
                    ,mUU.[dlm3Id] AS [unitIt]
                    ,CASE
                        WHEN UPPER(i.[Name]) LIKE '%NON-STANDARD%' THEN @staNonStandardId
                        WHEN UPPER(i.[Name]) LIKE '%BEST-BENCH%' THEN @staBestBenchId
                        WHEN UPPER(i.[Name]) LIKE '%ECO%' THEN @staEcoId
                        ELSE 0
                    END AS [standardId]
                    ,mSCSC.[dlm3Id] AS [serviceCategoryId]
                    ,mCT.[dlm3Id] AS [turnusId]
                    ,mCTPosition.[dlm3Id] AS [tunrusServicePositi0nId]
                    ,@serviceTypeId 
                    ,mCOCO.[dlm3Id] AS [companyId]
                    ,i.[IsActive]
                    ,0 AS [deleted]
                    ,1 AS [isLegacy]
                    ,i.[id] AS [dlm2Id]
                FROM [archiv].[dbo_SspItem] i
                INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
                    ON ssp.[id] = i.[SspId]
                INNER JOIN [mig].[mapServiceSpecificationServiceCatalog] mSSSC 
                    ON mSSSC.[dlm2id] = i.[SspId]
                INNER JOIN [dlm].[serviceCatalog] svc
                    ON svc.[id] = mSSSC.[dlm3Id] 
                INNER JOIN [archiv].[dbo_SspCompany] sspco
                    ON sspco.[SspId] = ssp.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2id] = sspco.[CompanyId]
					AND mCOCO.[dlm3id] = svc.[companyId]
                INNER JOIN [mig].[mapUnitUnit] mUU
                    ON mUU.[dlm2Id] = ISNULL(i.[UnitId],0)
                INNER JOIN [mig].[mapSspCategoryServiceCategory] mSCSC
                    ON mSCSC.[dlm2Id] = ssp.[SspCategoryId]
                INNER JOIN [mig].[mapMainCodeMainCode] mMCMC
                    ON mMCMC.[dlm2Id] = i.[MainCodeId]
                INNER JOIN [mig].[mapCycleTurnus] mCT
                    ON mCT.[dlm2Id] = i.[CycleCodeId]
                INNER JOIN [mig].[mapCycleTurnus] mCTPosition
                    ON mCTPosition.[dlm2Id] = i.[CycleId]
                INNER JOIN [archiv].[dbo_MainCode] mc
                    ON mc.[id] = mMCMC.[dlm2Id]
                INNER JOIN [archiv].[dbo_Text] t
                    ON t.[Id] = mc.[NameTextId]
				INNER JOIN [std].[company] co
					ON co.[id] = svc.[companyId]
                WHERE ISNULL(ssp.[isGLobal],0) <> 0     -- nur SspItems aus globalen LVs
				AND ISNULL(ssp.[IsStandard],0) = 0  --nur SspItem for global LV is non Standard
                AND mCOCO.[dlm3Id] = svc.[companyId]

                SET @rowCount = @@ROWCOUNT

                PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

            END
            
            BEGIN --   fill with SSPItem for not global LV

                SET @msg =  '   fill with SSPItem for not global LV  Ssp'
                PRINT @msg

                SET @rowCount = 0

                INSERT INTO [dlm].[servicePosition] ([name],[description],[mainCodeDescription],[isSiteSpecific],[servicePositionNo]
                ,[servicePositionOrderNo],[isMainService],[mainCodeId],[unitId],[standardId],[serviceCategoryId],[turnusId],[turnusServicePositionId],[serviceTypeId],[companyId]
                ,[isActive],[isDeleted],[isLegacy],[insertedBy])
                OUTPUT inserted.[insertedBy],inserted.[id],N'LV'
                INTO  [mig].[mapSspItemServicePosition]([dlm2Id],[dlm3Id],[typ])
                SELECT 	
                    i.[Name] AS [dlm2Name]
                    ,i.[Description] AS [dlm2Description]
                    ,t.[DefaultText] AS [sspMainCodeDescription]
                    ,ISNULL(ssp.[MainSspId],0) AS [isSiteSpecific]
                    ,i.[ItemNo]
                    ,RIGHT(N'000' + CAST(i.[ItemNo] AS NVARCHAR),3)
                    ,i.[IsMajorItem]
                    ,mMCMC.[dlm3Id] AS [mainCodeId]
                    ,mUU.[dlm3Id] AS [unitIt]
                    ,CASE
                        WHEN UPPER(i.[Name]) LIKE '%NON-STANDARD%' THEN @staNonStandardId
                        WHEN UPPER(i.[Name]) LIKE '%BEST-BENCH%' THEN @staBestBenchId
                        WHEN UPPER(i.[Name]) LIKE '%ECO%' THEN @staEcoId
                        ELSE 0
                    END AS [standardId]
                    ,mSCSC.[dlm3Id] AS [serviceCategoryId]
                    ,mCT.[dlm3Id] AS [turnusId]
                    ,mCTPosition.[dlm3Id] AS [tunrusServicePositi0nId]
                    ,@serviceTypeId 
                    ,mCOCO.[dlm3Id] AS [companyId]
                    ,i.[IsActive]
                    ,0 AS [deleted]
                    ,1 AS [isLegacy]
                    ,i.[id] AS [dlm2Id]
                FROM [archiv].[dbo_SspItem] i
                INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
                    ON ssp.[id] = i.[SspId]
                INNER JOIN [archiv].[dbo_SspCompany] sspco
                    ON sspco.[SspId] = ssp.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2id] = sspco.[CompanyId]
                INNER JOIN [mig].[mapUnitUnit] mUU
                    ON mUU.[dlm2Id] = ISNULL(i.[UnitId],0)
                INNER JOIN [mig].[mapSspCategoryServiceCategory] mSCSC
                    ON mSCSC.[dlm2Id] = ssp.[SspCategoryId]
                INNER JOIN [mig].[mapMainCodeMainCode] mMCMC
                    ON mMCMC.[dlm2Id] = i.[MainCodeId]
                INNER JOIN [mig].[mapCycleTurnus] mCT
                    ON mCT.[dlm2Id] = i.[CycleCodeId]
                INNER JOIN [mig].[mapCycleTurnus] mCTPosition
                    ON mCTPosition.[dlm2Id] = i.[CycleId]
                INNER JOIN [archiv].[dbo_MainCode] mc
                    ON mc.[id] = mMCMC.[dlm2Id]
                INNER JOIN [archiv].[dbo_Text] t
                    ON t.[Id] = mc.[NameTextId]
				INNER JOIN [std].[company] co
					ON co.[id] = mCOCO.[dlm3Id]
                WHERE 1=1--i.[id] NOT IN (SELECT [dlm2Id] FROM [mig].[mapSspItemServicePosition])
				--AND ISNULL(mc.[IsSspSpecific],0) = 0  -- nur SspItems nicht site-specific
                AND ISNULL(ssp.[isGLobal],0) = 0        -- nur SspItems aus nicht globalen LVs

                SET @rowCount = @@ROWCOUNT

                PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

            END

			PRINT '   fill audit columns'

            UPDATE t1
                SET
                    t1.[insertedAt] = t2.[Created]
                    ,t1.[insertedBy] = t2.[CreatedBy]
                    ,t1.[updatedAt] = t2.[Modified]
                    ,t1.[updatedBy] = t2.[ModifiedBy]
            FROM [dlm].[servicePosition] t1
            INNER JOIN [mig].[mapSspItemServicePosition] m
                ON m.[dlm3Id] = t1.[id]
            INNER JOIN (
                SELECT i.[id],cr.[dlm3Id] AS [CreatedBy],mo.[dlm3Id] AS [ModifiedBy], i.[Created],i.[Modified]
                FROM [archiv].[dbo_sspitem] i
            	LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = i.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = i.[ModifiedBy]
                ) t2
                ON t2.[id] = m.[dlm2Id]

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

			PRINT '   fill mapping DLM2.0 <-> DLM3.0'

            UPDATE t1
                SET
                    t1.[dlm2MainCodeId] = t2.[MainCodeId]
                    ,t1.[dlm2CycleCodeId] = t2.[CycleCodeId]
                    ,t1.[dlm2ItemNo] = t2.[ItemNo]
                    ,t1.[dlm2SspId] = t2.[SspId]
            FROM [mig].[mapSspItemServicePosition] t1
            INNER JOIN [archiv].[dbo_SspItem] t2
                ON t2.[id] = t1.[dlm2Id]

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END


        BEGIN --EPK--------------------------------------------------------------------------------

            DROP TABLE IF EXISTS [mig].[mapSscItemServicePosition]
            CREATE TABLE [mig].[mapSscItemServicePosition] (dlm2Id INT, dlm3Id INT,typ NVARCHAR(100))

            CREATE CLUSTERED INDEX [x_mapSscItemServicePosition] ON [mig].[mapSscItemServicePosition]
            (
    	        [dlm2Id] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

            SELECT @ServiceTypeId = [id] FROM [std].[serviceType] WHERE UPPER([name]) = UPPER('adHoc')

            BEGIN --   fill mainCodes from SSCItem 

                SET @msg =  '   fill mainCodes from SSCItem'
                PRINT @msg

				INSERT INTO [dlm].[mainCode] ([code],[description],[isActive],[isLegacy],[isRewritable],[serviceTypeId],[isDeleted],[insertedAt],[insertedBy])
				SELECT DISTINCT 
                    i.[Code] + N' EPK ' + CAST(i.[SscId] AS NVARCHAR)
                    ,N'Maincode EPK ' + i.[Code]
                    ,1
					,1
                    ,1
                    ,@ServiceTypeId
                    ,0
					,@insAt
					,@insBy
				FROM  [archiv].[dbo_SscItem] i
                
				SET @rowCount = @@ROWCOUNT

				 PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

			END --   fill mainCodes from SSCItem 

            BEGIN --   fill with SSCItem from global EPK

                SET @msg =  '   fill with SSCItem from global EPK'
                PRINT @msg

                SET @sscIdOld = 0
                SET @CodeOld = ''
                SET @rowCount = 0
                SET @mapCount = 0
                SET @mapCatalogCount = 0

                DECLARE cMig CURSOR FOR 
                    SELECT 
						i.[id]
						,i.[sscId]
						,i.[Code] + N' EPK ' + CAST(i.[SscId] AS NVARCHAR)
						,i.[Definition]
						,i.[Description]
						,ISNULL(s.[IsGlobal],0) AS [isGlobal]
						,i.[Code] + N' EPK ' + CAST(i.[SscId] AS NVARCHAR) AS [mainCode] 
						,mc.[id] AS [mainCodeId]
						,muu.[dlm3Id] AS [unitId]
						,REPLACE(i.[Code],SUBSTRING(i.[Code],0,CHARINDEX('.',i.[Code])) + '.','') AS [ItemOrderNo]
						,ISNULL(mCOCO.[dlm3Id],0) AS [companyId]
						,mSSCSC.[dlm3Id] AS [serviceCatalogId]
						,ISNULL(cat.[CategoryId],0) AS [serviceCategoryId]
						,i.[Created]
						,cr.[dlm3Id]
						,i.[Modified]
						,mo.[dlm3Id]
                    FROM [archiv].[dbo_SscItem] i
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = i.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = i.[ModifiedBy]
                    INNER JOIN  [archiv].[dbo_StandardServicesCatalog] s
                        ON s.[id] = i.[sscId]
					INNER JOIN [mig].[mapStandardServicesCatalogServiceCatalog] mSSCSC
						ON mSSCSC.[dlm2Id] = i.[sscId]
					INNER JOIN [archiv].[dbo_SscCompany] sscc
						ON sscc.[SscId] = i.[sscId]
					INNER JOIN [mig].[mapCompanyCompany] mCOCO
						ON mCOCO.[dlm2Id] = sscc.[CompanyId]
                    INNER JOIN [dlm].[serviceCatalog] svc
                        ON svc.[id] = mSSCSC.[dlm3Id]
					INNER JOIN [std].[company] co
						ON co.[id] = svc.[companyId]
					LEFT OUTER JOIN (
						SELECT po.[SscId],MIN(mSCSC.[dlm3Id]) AS [CategoryId]
						FROM [archiv].[dbo_PurchaseOrder] po
						INNER JOIN [archiv].[dbo_WorkOrder] wo
							ON wo.[PoId] = po.[id]
						INNER JOIN [mig].[mapSspCategoryServiceCategory] mSCSC
							ON mSCSC.[dlm2Id] = wo.[WoCategoryId]
						GROUP BY po.[SscId]
					) cat
					ON cat.[SscId] = i.[SscId]
					LEFT OUTER JOIN [dlm].[mainCode] mc
						ON mc.[code] = i.[Code] COLLATE SQL_Latin1_General_CP1_CI_AI
						AND mc.[isLegacy] = 1
						AND mc.[serviceTypeId] = @ServiceTypeId
					LEFT OUTER JOIN [mig].[mapUnitUnit] muu
						ON muu.[dlm2Id] = i.[UnitId]
                    WHERE ISNULL([IsGlobal],0) <> 0 
                    AND svc.[companyId] = mCOCO.[dlm3Id]
                    ORDER BY i.[sscId],i.[Code]

                OPEN cMig
                FETCH NEXT FROM cMig INTO @dlm2id,@sscId,@Code,@Definition, @Description,@isGlobal,@MainCode,@MainCodeId,@UnitId,@ItemOrderNo,@CompanyId,@ServiceCatalogId,@ServiceCategoryId,@insAt,@insBy,@updAt,@updBy
                WHILE @@FETCH_STATUS = 0
                BEGIN

                    --get MainCode - first Segment from Code splitted by dot 
                    --if not exists - insert new

					IF @MainCodeId IS NULL
					BEGIN

						INSERT INTO [dlm].[mainCode] ([code],[description],[isActive],[isLegacy],[isRewritable],[serviceTypeId],[isDeleted],[insertedAt],[insertedBy])
						SELECT @mainCode,'Maincode EPK ' + @mainCode,1,1,1,@ServiceTypeId,0,@insAt,@insBy

						SET @MainCodeId = @@IDENTITY
					END

                    --groupswitch for generate running number for itemno

                    IF @sscId <> @sscIdOld AND @Code <> @CodeOld
                    BEGIN

                        SET @sscIdOld = @sscId
                        SET @CodeOld = @Code
                        SET @ItemNo = 0

                    END

                    SET @ItemNo = @ItemNo + 1

                    --insert serviceposition

                    INSERT INTO [dlm].[servicePosition] ([name],[description],[servicePositionNo],[servicePositionOrderNo],[isMainService],[mainCodeId],[unitId],[standardId],[serviceCategoryId],[turnusId],[turnusServicePositionId],[serviceTypeId],[companyId],[isActive],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
                    SELECT
                        SUBSTRING(@Code + ' - ' + @Definition,1,200),
                        ISNULL(@Description,'ServicePosition ') + ' ('  + @Code + ')',
                        @ItemNo,
                        @ItemOrderNo,
                        1,
                        @MainCodeId,
                        @UnitId,
                        0,
                        ISNULL(@ServiceCategoryId,0),
                        0,
                        0,
                        @ServiceTypeId,
                        ISNULL(@CompanyId,0),
                        0,
                        0,
                        1,
						@insAt,
						@insBy,
						@updAt,
						@updBy

                    SET @rowCount = @rowCount + @@ROWCOUNT

                    SET @dlm3Id = @@IDENTITY

                    INSERT INTO [dlm].[mapServiceCatalogServicePosition]([serviceCatalogId],[servicePositionId])
                    SELECT @ServiceCatalogId,@dlm3Id

                    SET @mapCatalogCount = @mapCatalogCount + @@ROWCOUNT

                    INSERT INTO [mig].[mapSscItemServicePosition]([dlm2Id],[dlm3Id],[typ])
                    SELECT @dlm2Id,@dlm3Id, 'EPK global'

                    SET @mapCount = @mapCount + @@ROWCOUNT

                    FETCH NEXT FROM cMig INTO @dlm2id,@sscId,@Code,@Definition, @Description,@isGlobal,@MainCode,@MainCodeId,@UnitId,@ItemOrderNo,@CompanyId,@ServiceCatalogId,@ServiceCategoryId,@insAt,@insBy,@updAt,@updBy
                END
                CLOSE cMig
                DEALLOCATE cMig

                PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings - ' + CAST(@mapCatalogCount AS NVARCHAR) + ' catalog mappings'

            END --   fill with SSCItem from global EPK

            BEGIN --   fill with SSCItem from not global EPK

                SET @msg =  '   fill with SSCItem from not global EPK'
                PRINT @msg

                SET @sscIdOld = 0
                SET @CodeOld = ''
                SET @rowCount = 0
                SET @mapCount = 0
                SET @mapCatalogCount = 0

                DECLARE cMig CURSOR FOR 
                    SELECT 
					    i.[id]
						,i.[sscId]
						,i.[Code] + N' EPK ' + CAST(i.[SscId] AS NVARCHAR)
						,i.[Definition]
						,i.[Description]
						,ISNULL(s.[IsGlobal],0) AS [isGlobal]
						,i.[Code] + N' EPK ' + CAST(i.[SscId] AS NVARCHAR) AS [mainCode] 
						,mc.[id] AS [mainCodeId]
						,muu.[dlm3Id] AS [unitId]
						,REPLACE(i.[Code],SUBSTRING(i.[Code],0,CHARINDEX('.',i.[Code])) + '.','') AS [ItemOrderNo]
						,ISNULL(mCOCO.[dlm3Id],0) AS [companyId]
						,mSSCSC.[dlm3Id] AS [serviceCatalogId]
						,ISNULL(cat.[CategoryId],0) AS [serviceCategoryId]
						,i.[Created]
						,cr.[dlm3Id]
						,i.[Modified]
						,mo.[dlm3Id]
                    FROM [archiv].[dbo_SscItem] i
					LEFT OUTER JOIN [mig].[mapUserClient] cr
						ON cr.[dlm2Id] = i.[CreatedBy]
					LEFT OUTER JOIN [mig].[mapUserClient] mo
						ON mo.[dlm2Id] = i.[ModifiedBy]
                    INNER JOIN [archiv].[dbo_StandardServicesCatalog] s
                        ON s.[id] = i.[sscId]
					INNER JOIN [mig].[mapStandardServicesCatalogServiceCatalog] mSSCSC
						ON mSSCSC.[dlm2Id] = i.[sscId]
					INNER JOIN [archiv].[dbo_SscCompany] sscc
						ON sscc.[SscId] = i.[sscId]
					INNER JOIN [mig].[mapCompanyCompany] mCOCO
						ON mCOCO.[dlm2Id] = sscc.[CompanyId]
					INNER JOIN [std].[company] co
						ON co.[id] = mCOCO.[dlm3Id]
					LEFT OUTER JOIN (
						SELECT po.[SscId],MIN(mSCSC.[dlm3Id]) AS [CategoryId]
						FROM [archiv].[dbo_PurchaseOrder] po
						INNER JOIN [archiv].[dbo_WorkOrder] wo
							ON wo.[PoId] = po.[id]
						INNER JOIN [mig].[mapSspCategoryServiceCategory] mSCSC
							ON mSCSC.[dlm2Id] = wo.[WoCategoryId]
						GROUP BY po.[SscId]
					) cat
					ON cat.[SscId] = i.[SscId]
					LEFT OUTER JOIN [dlm].[mainCode] mc
						ON mc.[code] = i.[Code] COLLATE SQL_Latin1_General_CP1_CI_AI
						AND mc.[isLegacy] = 1
						AND mc.[serviceTypeId] = @ServiceTypeId
					LEFT OUTER JOIN [mig].[mapUnitUnit] muu
						ON muu.[dlm2Id] = i.[UnitId]
                    WHERE ISNULL([IsGlobal],0) = 0 
                    ORDER BY i.[sscId],i.[Code]
					
                OPEN cMig
                FETCH NEXT FROM cMig INTO @dlm2id,@sscId,@Code,@Definition, @Description,@isGlobal,@MainCode,@MainCodeId,@UnitId,@ItemOrderNo,@CompanyId,@ServiceCatalogId,@ServiceCategoryId,@insAt,@insBy,@updAt,@updBy
                WHILE @@FETCH_STATUS = 0
                BEGIN

                    --get MainCode - first Segment from Code splitted by dot 
                    --if not exists - insert new

					IF @MainCodeId IS NULL
					BEGIN

						INSERT INTO [dlm].[mainCode] ([code],[description],[isActive],[isLegacy],[isRewritable],[serviceTypeId],[isDeleted],[insertedAt],[insertedBy])
						SELECT @mainCode,'Maincode EPK ' + @mainCode,1,1,1,@ServiceTypeId,0,@insAt,@insBy

						SET @MainCodeId = @@IDENTITY
					END

                    --groupswitch for running number for itemno

                    IF @sscId <> @sscIdOld AND @Code <> @CodeOld
                    BEGIN

                        SET @sscIdOld = @sscId
                        SET @CodeOld = @Code
                        SET @ItemNo = 0

                    END

                    SET @ItemNo = @ItemNo + 1

                    --insert serviceposition

                    INSERT INTO [dlm].[servicePosition] ([name],[description],[servicePositionNo],[servicePositionOrderNo],[isMainService],[mainCodeId],[unitId],[standardId],[serviceCategoryId],[turnusId],[turnusServicePositionId],[serviceTypeId],[companyId],[isActive],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
                    SELECT
                        SUBSTRING(@Code + ' - ' + @Definition,1,200),
                        ISNULL(@Description,'ServicePosition ') + ' ('  + @Code + ')',
                        @ItemNo,
                        @ItemOrderNo,
                        1,
                        @MainCodeId,
                        @UnitId,
                        0,
                        @ServiceCategoryId,
                        0,
                        0,
                        @ServiceTypeId,
                        @CompanyId,
                        0,
                        0,
                        1,
						@insAt,
						@insBy,
						@updAt,
						@updBy

                    SET @rowCount = @rowCount + @@ROWCOUNT

                    SET @dlm3Id = @@IDENTITY

                    INSERT INTO [dlm].[mapServiceCatalogServicePosition]([serviceCatalogId],[servicePositionId])
                    SELECT @ServiceCatalogId,@dlm3Id

                    SET @mapCatalogCount = @mapCatalogCount + @@ROWCOUNT

                    INSERT INTO [mig].[mapSscItemServicePosition]([dlm2Id],[dlm3Id],[typ])
                    SELECT @dlm2Id,@dlm3Id, 'EPK not global'

                    SET @mapCount = @mapCount + @@ROWCOUNT

                    FETCH NEXT FROM cMig INTO @dlm2id,@sscId,@Code,@Definition, @Description,@isGlobal,@MainCode,@MainCodeId,@UnitId,@ItemOrderNo,@CompanyId,@ServiceCatalogId,@ServiceCategoryId,@insAt,@insBy,@updAt,@updBy

                END
                CLOSE cMig
                DEALLOCATE cMig

                PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings - ' + CAST(@mapCatalogCount AS NVARCHAR) + ' catalog mappings'

            END --   fill with SSCItem from not global EPK

        END

    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' servicePosition.sql'
        RAISERROR(@msg,1,16)

    END CATCH

END --servicePosition
GO
