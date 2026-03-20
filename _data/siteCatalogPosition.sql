BEGIN --fill siteCatalogPosition

    DECLARE @rowCount INT = 0
    DECLARE @mapCount INT = 0
    DECLARE @msg NVARCHAR(MAX)

    SET @msg = '    fill siteCatalogPositions LV' 
    PRINT @msg

    DECLARE
        @servicePositionId INT
		,@siteCatalogPositionId INT
        ,@siteCatalogId INT
		,@serviceCatalogId INT
        ,@siteCatalogPositionNo INT
		,@serviceTypeId INT
        ,@turnusId INT
        ,@dlm2Id INT
        ,@dlm3Id INT

	DECLARE @insAt DATE
	DECLARE @updAt DATE
	DECLARE @insBy INT
	DECLARE @updBy INT

	DECLARE @staNonStandardId INT = (SELECT  [id] FROM [std].[standard] WHERE UPPER([name]) = UPPER('non Standard'))
    DECLARE @staBestBenchId INT = (SELECT  [id] FROM [std].[standard] WHERE UPPER([name]) = UPPER('%BEST-BENCH%'))
    DECLARE @staEcoId INT = (SELECT  [id] FROM [std].[standard] WHERE UPPER([name]) = UPPER('Eco'))


    BEGIN TRY

        DELETE FROM [dlm].[siteCatalogPosition]

        DROP TABLE IF EXISTS [mig].[mapSspItemSiteCatalogPosition]
        CREATE TABLE [mig].[mapSspItemSiteCatalogPosition] (dlm2Id INT, dlm3Id INT)

        BEGIN --fill siteCatalogPosition from LV-Position from LV with global LV Standard

            SET @msg = '   fill siteCatalogPosition from LV-Position from LV with global LV Standard' 

            PRINT @msg
			
			INSERT INTO [dlm].[siteCatalogPosition]([servicePositionId],[siteCatalogId],[siteCatalogPositionNo],[turnusId],[isActive],[isDeleted],[isLegacy],[updatedBy])
			OUTPUT inserted.[id],inserted.[updatedBy] INTO [mig].[mapSspItemSiteCatalogPosition]([dlm3Id],[dlm2Id])
            SELECT DISTINCT
                mSISP.[dlm3id] AS [servicePositionId]
                ,mSSSC.[dlm3Id] AS [siteCatalogId]
                ,sspi.[ItemNo] AS [siteCatalogPositionNo]
                ,mCT.[dlm3Id] AS [turnusId]
                ,1 AS [isActive]
                ,0 AS [isDeleted]
                ,1 AS [isLegacy]
				,sspi.[id] AS [updatedBy]
            FROM [archiv].[dbo_SspItem] sspi
			LEFT OUTER JOIN [mig].[mapUserClient] cr
				ON cr.[dlm2Id] = sspi.[CreatedBy]
			LEFT OUTER JOIN [mig].[mapUserClient] mo
				ON mo.[dlm2Id] = sspi.[ModifiedBy]
            INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
                ON ssp.[id] = sspi.[SspId]
			INNER JOIN [archiv].[dbo_ServiceSpecification] sspGlobal
				ON sspGlobal.[id] = ssp.[GlobalSspId]
            INNER JOIN [mig].[mapSspItemServicePosition] mSISP
                ON mSISP.[dlm2MainCodeId] = sspi.[MainCodeId]
                AND mSISP.[dlm2CycleCodeId] = sspi.[CycleCodeId]
                AND mSISP.[dlm2ItemNo] = sspi.[ItemNo]
                AND mSISP.[dlm2SspId] = ssp.[GlobalSspId]
            INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC
                ON mSSSC.[dlm2id] = sspi.[sspId]
            INNER JOIN [dlm].[siteCatalog] sic
                ON sic.[id] = mSSSC.[dlm3id]
            INNER JOIN [dlm].[serviceCatalog] svc
                ON svc.[id] = sic.[serviceCatalogId]
            INNER JOIN [dlm].[servicePosition] svp
                ON svp.[id] = mSISP.[dlm3Id]
            INNER JOIN [mig].[mapCycleTurnus] mCT
                ON mCT.[dlm2id] = sspi.[cycleId]
			INNER JOIN [std].[company] co
				ON co.[id] = svc.[companyId]
            WHERE svp.[companyId] = svc.[companyId]
            AND ISNULL(ssp.[IsGlobal],0) = 0             -- nur aus nicht globalen LVs
            AND ISNULL(ssp.[GlobalSspId],0) <> 0         -- nur aus LV mit globalem LV
            AND ISNULL(ssp.[MainSspId],0) = 0            -- keine SubLVs (Beauftragungen)
			AND ISNULL(sspGlobal.[IsStandard],0) = 1     -- nur SspItem for LV mit globalem LV is Standard

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'


        END --fill siteCatalogPosition from LV-Position from LV with global LV Standard

        BEGIN --fill siteCatalogPosition from LV-Position from LV with global LV non Standard

            SET @msg = '   fill siteCatalogPosition from LV-Position from LV with global LV non Standard' 

            PRINT @msg

			--create dummy servicepositions

            INSERT INTO [dlm].[servicePosition] ([name],[description],[mainCodeDescription],[isSiteSpecific],[servicePositionNo]
            ,[servicePositionOrderNo],[isMainService],[mainCodeId],[unitId],[standardId],[serviceCategoryId],[turnusId],[turnusServicePositionId],[serviceTypeId],[companyId]
            ,[isActive],[isDeleted],[isLegacy],[updatedBy])
            OUTPUT inserted.[updatedBy],inserted.[id],N'LV global non standard'
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
			INNER JOIN [archiv].[dbo_ServiceSpecification] sspGlobal
				ON sspGlobal.[id] = ssp.[GlobalSspId]
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
            WHERE ISNULL(ssp.[isGLobal],0) <> 0       -- nur SspItems aus nicht globalen LVs
			AND ISNULL(ssp.[GlobalSspId],0) <> 0	  -- nur SspItem aus LVs mit globalem LV
			AND ISNULL(ssp.[MainSspId],0) = 0         -- keine SubLVs (Beauftragungen)
			AND ISNULL(sspGlobal.[IsStandard],0) = 0  -- nur SspItem aus LVs mit globalem LV is non Standard

			--fill dlm2id for dummy positions in mig-mapping table for positions

			UPDATE t1
                SET
                    t1.[dlm2MainCodeId] = t2.[MainCodeId]
                    ,t1.[dlm2CycleCodeId] = t2.[CycleCodeId]
                    ,t1.[dlm2ItemNo] = t2.[ItemNo]
                    ,t1.[dlm2SspId] = t2.[SspId]
            FROM [mig].[mapSspItemServicePosition] t1
            INNER JOIN [archiv].[dbo_SspItem] t2
                ON t2.[id] = t1.[dlm2Id]
			WHERE t1.[dlm2SspId] IS NULL

			--map ServicePositions with ServiceCatalogs

			MERGE INTO [dlm].[mapServiceCatalogServicePosition] AS t
			USING (
				SELECT 
					mSISP.[dlm3Id] AS [servicePositionId]
					,mSSSC.[dlm3Id] AS [serviceCatalogId]
				FROM [mig].[mapSspItemServicePosition] mSISP
				INNER JOIN [archiv].[dbo_SspItem] i
					ON i.[id] = mSISP.[dlm2Id] 
				INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
					ON ssp.[id] = i.[SspId]
				INNER JOIN [archiv].[dbo_ServiceSpecification] sspGlobal
					ON sspGlobal.[id] = ssp.[GlobalSspId]
				INNER JOIN [mig].[mapServiceSpecificationServiceCatalog] mSSSC 
					ON mSSSC.[dlm2id] = i.[SspId]
	            WHERE ISNULL(ssp.[isGLobal],0) <> 0       -- nur SspItems aus globalen LVs
				AND ISNULL(ssp.[GlobalSspId],0) <> 0	  -- nur SspItem aus LVs mit globalem LV
				AND ISNULL(ssp.[MainSspId],0) = 0         -- keine SubLVs (Beauftragungen)
				AND ISNULL(sspGlobal.[IsStandard],0) = 0  -- nur SspItem for LV mit global LV is non Standard
			) AS s
			ON s.[servicePositionId] = t.[servicePositionId]
			AND s.[serviceCatalogId] = t.[ServiceCatalogId]
			WHEN NOT MATCHED THEN 
				INSERT ([servicePositionId],[serviceCatalogId])
				VALUES (s.[servicePositionId],s.[serviceCatalogId]);

			--fill siteCatalogPositions

			INSERT INTO [dlm].[siteCatalogPosition]([servicePositionId],[siteCatalogId],[siteCatalogPositionNo],[turnusId],[isActive],[isDeleted],[isLegacy],[updatedBy])
			OUTPUT inserted.[id],inserted.[updatedBy] INTO [mig].[mapSspItemSiteCatalogPosition]([dlm3Id],[dlm2Id])
            SELECT DISTINCT
                mSISP.[dlm3id] AS [servicePositionId]
                ,mSSSC.[dlm3Id] AS [siteCatalogId]
                ,sspi.[ItemNo] AS [siteCatalogPositionNo]
                ,mCT.[dlm3Id] AS [turnusId]
                ,1 AS [isActive]
                ,0 AS [isDeleted]
                ,1 AS [isLegacy]
				,sspi.[id] AS [updatedBy]
            FROM [archiv].[dbo_SspItem] sspi
			LEFT OUTER JOIN [mig].[mapUserClient] cr
				ON cr.[dlm2Id] = sspi.[CreatedBy]
			LEFT OUTER JOIN [mig].[mapUserClient] mo
				ON mo.[dlm2Id] = sspi.[ModifiedBy]
            INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
                ON ssp.[id] = sspi.[SspId]
			INNER JOIN [archiv].[dbo_ServiceSpecification] sspGlobal
				ON sspGlobal.[id] = ssp.[GlobalSspId]
            INNER JOIN [mig].[mapSspItemServicePosition] mSISP
                ON mSISP.[dlm2MainCodeId] = sspi.[MainCodeId]
                AND mSISP.[dlm2CycleCodeId] = sspi.[CycleCodeId]
                AND mSISP.[dlm2ItemNo] = sspi.[ItemNo]
                AND mSISP.[dlm2SspId] = ssp.[Id]
            INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC
                ON mSSSC.[dlm2id] = sspi.[sspId]
            INNER JOIN [dlm].[siteCatalog] sic
                ON sic.[id] = mSSSC.[dlm3id]
            INNER JOIN [dlm].[serviceCatalog] svc
                ON svc.[id] = sic.[serviceCatalogId]
            INNER JOIN [dlm].[servicePosition] svp
                ON svp.[id] = mSISP.[dlm3Id]
            INNER JOIN [mig].[mapCycleTurnus] mCT
                ON mCT.[dlm2id] = sspi.[cycleId]
			INNER JOIN [std].[company] co
				ON co.[id] = svc.[companyId]
            WHERE svp.[companyId] = svc.[companyId]
            AND ISNULL(ssp.[IsGlobal],0) = 0             -- nur aus nicht globalen LVs
            AND ISNULL(ssp.[GlobalSspId],0) <> 0         -- nur aus LV mit globalem LV
            AND ISNULL(ssp.[MainSspId],0) = 0            -- keine SubLVs (Beauftragungen)
			AND ISNULL(sspGlobal.[IsStandard],0) = 0     -- nur SspItem for LV mit globalem LV is non Standard

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --fill siteCatalogPosition from LV-Position from LV with global LV non Standard

        BEGIN --fill siteCatalogPosition from LV-Position from LV without global LV

            SET @msg = '   fill siteCatalogPosition from LV-Position from LV without global LV' 

            PRINT @msg

            SET @rowCount = 0

			INSERT INTO [dlm].[siteCatalogPosition]([servicePositionId],[siteCatalogId],[siteCatalogPositionNo],[turnusId],[isActive],[isDeleted],[isLegacy],[updatedBy])
			OUTPUT inserted.[id],inserted.[updatedBy] INTO [mig].[mapSspItemSiteCatalogPosition]([dlm3Id],[dlm2Id])
            SELECT DISTINCT
                mSISP.[dlm3id] AS [servicePositionId]
                ,mSSSC.[dlm3Id] AS [siteCatalogId]
                ,sspi.[ItemNo] AS [siteCatalogPositionNo]
                ,mCT.[dlm3Id] AS [turnusId]
				,sspi.[IsActive]
				,0 AS [isDeleted]
				,1 AS [isLegacy]
				,sspi.[id] AS [updatedBy]
			FROM [archiv].[dbo_SspItem] sspi
			LEFT OUTER JOIN [mig].[mapUserClient] cr
				ON cr.[dlm2Id] = sspi.[CreatedBy]
			LEFT OUTER JOIN [mig].[mapUserClient] mo
				ON mo.[dlm2Id] = sspi.[ModifiedBy]
            INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
                ON ssp.[id] = sspi.[SspId]
            INNER JOIN [mig].[mapSspItemServicePosition] mSISP
                ON mSISP.[dlm2Id] = sspi.[id]
            INNER JOIN [mig].[mapServiceSpecificationSiteCatalog] mSSSC
                ON mSSSC.[dlm2id] = sspi.[sspId]
            INNER JOIN [dlm].[siteCatalog] sic
                ON sic.[id] = mSSSC.[dlm3id]
            INNER JOIN [dlm].[serviceCatalog] svc
                ON svc.[id] = sic.[serviceCatalogId]
            INNER JOIN [dlm].[servicePosition] svp
                ON svp.[id] = mSISP.[dlm3Id]
            INNER JOIN [mig].[mapCycleTurnus] mCT
                ON mCT.[dlm2id] = sspi.[cycleId]
			INNER JOIN [std].[company] co
				ON co.[id] = svc.[companyId]
            WHERE svp.[companyId] = svc.[companyId]
            AND ssp.[IsGlobal] = 0                -- nur aus nicht globalen LVs
            AND ISNULL(ssp.[GlobalSspId],0) = 0   -- nur aus nicht globalen LVs ohne globalem LV
            AND ISNULL(ssp.[MainSspId],0) = 0     -- keine SubLVs (Beauftragungen)

			SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --fill siteCatalogPosition from LV-Position from LV without global LV

		BEGIN --update audit columns

			PRINT '   set audit columns'

			UPDATE t1
				SET 
					t1.[insertedAt] = ISNULL(t2.[insertedAt],GETDATE())
					,t1.[updatedAt] = t2.[updatedAt]
					,t1.[insertedBy] = ISNULL(t2.[insertedBy],1)
					,t1.[updatedBy] = t2.[insertedBy]
			FROM [dlm].[siteCatalogPosition] t1
			INNER JOIN (
				SELECT 
					mSICP.[dlm3Id]
					,ssp.[Created] AS [insertedAt]
					,ssp.[Modified] AS [updatedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,mo.[dlm3Id] AS [updatedBy]
				FROM [mig].[mapSspItemSiteCatalogPosition] mSICP
				INNER JOIN [archiv].[dbo_SspItem] ssp
					ON ssp.[id] = mSICP.[dlm2Id]
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = ssp.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = ssp.[ModifiedBy]
			) t2
			ON t2.[dlm3Id] = t1.[id]

			SET @rowCount = @@ROWCOUNT

			PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

		END --update audit columns

        BEGIN --fill siteCatalogPosition EPK

            SET @msg = '   fill siteCatalogPositions EPK'

            PRINT @msg

            SET @rowCount = 0
            SET @mapCount = 0

            DROP TABLE IF EXISTS [mig].[mapSscItemSiteCatalogPosition]
            CREATE TABLE [mig].[mapSscItemSiteCatalogPosition] (dlm2Id INT,dlm3Id INT)


            MERGE INTO [dlm].[siteCatalogPosition] AS t
            USING
            (
                SELECT  DISTINCT
                    ssci.[id] AS [dlm2Id]
                    ,mSISP.[dlm3Id] AS [servicePositionId]
                    ,mSSCSC.[dlm3Id] AS [siteCatalogId]
                    ,svp.[ServicePositionNo] AS [siteCatalogPositionNo]
                    ,0 AS [turnusId]
                    ,1 AS [isActive]
                    ,0 AS [isDeleted]
                    ,1 AS [isLegacy]
					,ssci.[Created] AS [insertedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,ssci.[Modified] AS [updatedAt]
					,mo.[dlm3Id] AS [updatedBy]
                FROM [archiv].[dbo_SscItem] ssci
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = ssci.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = ssci.[ModifiedBy]
                INNER JOIN [archiv].[dbo_StandardServicesCatalog] ssc
                    ON ssc.[id] = ssci.[sscid]
                INNER JOIN [mig].[mapStandardServicesCatalogSiteCatalog] mSSCSC
                    ON mSSCSC.[dlm2Id] = ssci.[sscId]
                INNER JOIN [dlm].[siteCatalog] sic
                    ON sic.[id] = mSSCSC.[dlm3Id]
                INNER JOIN [dlm].[ServiceCatalog] svc
                    ON svc.[id] = sic.[serviceCatalogId]
                INNER JOIN [mig].[mapSscItemServicePosition] mSISP
                    ON mSISP.[dlm2Id] = ssci.[Id]
                INNER JOIN [dlm].[servicePosition] svp
                    ON svp.[id] = mSISP.[dlm3Id]
				INNER JOIN [std].[company] co
					ON co.[id] = svc.[companyId]
                WHERE svp.[companyId] = svc.[companyId]
            ) AS s
            ON t.[servicePositionId] = s.[servicePositionId]
            AND t.[siteCatalogId] = s.[siteCatalogId]
            WHEN NOT MATCHED THEN
            INSERT([servicePositionId],[siteCatalogId],[siteCatalogPositionNo],[turnusId],[isActive],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
            VALUES(s.[servicePositionId],s.[siteCatalogId],s.[siteCatalogPositionNo],s.[turnusId],s.[isActive],s.[isDeleted],s.[isLegacy],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
            OUTPUT s.[dlm2id],inserted.[id]
            INTO [mig].[mapSscItemSiteCatalogPosition]([dlm2Id],[dlm3Id]);

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'
        
        END --fill siteCatalogPosition EPK

		BEGIN --fill siteCatalogPosition (LVs) <-> serviceObject (Area)

            SET @msg = '   fill siteCatalogPosition  (LVs) <-> serviceObject (Area)'
            PRINT @msg
            
            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [code] = N'UHR'

            INSERT INTO [dlm].[mapsiteCatalogPositionServiceObject] ([siteCatalogPositionId],[serviceObjectId],[isActive],[insertedAt],[insertedBy])
            SELECT 
				sip.[id] AS [siteCatalogId]
				,soj.[id] AS [serviceObjectId]
				,CAST(m.[IsActive] AS INT) AS [isActive]
				,ISNULL(m.[Modified],m.[Created]) AS [Created]
				,ISNULL(mUC.[dlm3Id],1) AS [insertedBy]
            FROM [dlm].[siteCatalogPosition] sip
			INNER JOIN [mig].[mapSspItemSiteCatalogPosition] mSISCP
				ON sip.[id] = mSISCP.[dlm3Id]
            INNER JOIN [archiv].[dbo_Measurement] m
                ON m.[SspItemId] = mSISCP.[dlm2Id]
            INNER JOIN [mig].[mapAreaMeasurementStatus] mMAMS
                ON mMAMS.[dlm2MeasurementId] = m.[id]
            INNER JOIN [dlm].[serviceObject] soj
                ON soj.[areaId] = mMAMS.[dlm3AreaId]
            LEFT OUTER JOIN [mig].[mapUserClient] mUC
                ON mUC.[dlm2Id] = ISNULL(m.[ModifiedBy],m.[CreatedBy])
            WHERE soj.[areaId] IS NOT NULL	   
            AND sip.[siteCatalogId] IN (
				SELECT [id] 
				FROM [dlm].[siteCatalog]
				WHERE [serviceCatalogId] IN (
					SELECT [id]
					FROM [dlm].[serviceCatalog]
					WHERE [serviceTypeId] = @serviceTypeId
				)
			)

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END--fill siteCatalogPosition (LVs) <-> serviceObject (Area)


		BEGIN -- '    fill siteCatalogPosition (LVs) <-> serviceObject (CustonClecningObjects)'

			SET @msg = '    fill siteCatalogPosition (LVs) <-> serviceObject (CustonClecningObjects)'

			PRINT @msg

			INSERT INTO [dlm].[mapSiteCatalogPositionServiceObject]([siteCatalogPositionId],[serviceObjectId],[isActive],[insertedAt],[insertedBy])
			SELECT 
				mSISCP.dlm3Id AS [siteCatalogId]
				,so.[id] AS [serviceObjectId]
				,CAST(m.[IsActive] AS INT) AS [isActive]
				,m.[Created] AS [Created]
				,ISNULL(mUC.[dlm3Id],1) AS [insertedBy]
			FROM [loc].[customCleaningObject] cco
			INNER JOIN [dlm].[serviceObject] so
				ON so.[customCleaningObjectId] = cco.[id]
			INNER JOIN mig.[mapCustomCleaningObjectMeasurementManual1] mCCOMM1
				ON mCCOMM1.[dlm3Id] = cco.[id]
			INNER JOIN [archiv].[dbo_Measurement] m
				ON m.[id] = mCCOMM1.[dlm2Id]
			INNER JOIN mig.[mapSspItemSiteCatalogPosition] mSISCP
				ON mSISCP.[dlm2Id] = m.[SspItemId]
			INNER JOIN [dlm].[siteCatalogPosition] sip
				ON sip.[id] = mSISCP.[dlm3Id]
            LEFT OUTER JOIN [mig].[mapUserClient] mUC
                ON mUC.[dlm2Id] = ISNULL(m.[ModifiedBy],m.[CreatedBy])
            AND sip.[siteCatalogId] IN (
				SELECT [id] 
				FROM [dlm].[siteCatalog]
				WHERE [serviceCatalogId] IN (
					SELECT [id]
					FROM [dlm].[serviceCatalog]
					WHERE [serviceTypeId] = @serviceTypeId
				)
			)
			--GROUP BY mSISCP.dlm3Id,so.[id]



			SET @rowcount = @@ROWCOUNT

			PRINT '        ' + CAST(@rowcount AS NVARCHAR) + ' records'

		END --'    fill siteCatalogPosition (LVs) <-> serviceObject (CustonClecningObjects)'

		BEGIN --fill Mapping Positions with Temp-ServiceCatalog

            SET @msg =  '   fill Mapping Positions with Temp-ServiceCatalog'
            PRINT @msg

            DECLARE @out TABLE
	        (
	            [servicePositionId] INT
	        );

            MERGE INTO [dlm].[mapservicecatalogserviceposition] AS t
            USING (
                SELECT DISTINCT sp.[id] AS [servicePositionId], msssc.[dlm3id] AS [serviceCatalogId]
                FROM [dlm].[servicePosition]  sp
                INNER JOIN  [mig].[mapSspItemServicePosition] msspisp
                    ON msspisp.[dlm3Id] = sp.[id]
                INNER JOIN [archiv].[dbo_sspitem] asspi
                    ON asspi.[id] = msspisp.[dlm2Id]
                INNER JOIN [mig].[mapServiceSpecificationServiceCatalog] msssc
                    ON msssc.[dlm2id] = asspi.[SspId]
                WHERE sp.[id] NOT IN (
                    SELECT [servicePositionId]
                    FROM [dlm].[mapServiceCatalogServicePosition]
                )
            ) s
            ON s.[servicePositionId] = t.[servicePositionId]
            AND s.[serviceCatalogId] = t.[serviceCatalogId]
            WHEN NOT MATCHED THEN
                INSERT([servicePositionId],[serviceCatalogId])
                VALUES(s.[servicePositionId],s.[serviceCatalogId])
            OUTPUT inserted.servicePositionId INTO @out;

            SELECT @rowcount = COUNT(1) FROM @out

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'
        END

    END TRY
    BEGIN CATCH

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' siteCatalogPosition.sql'
        RAISERROR(@msg,1,16)

    END CATCH

END --fill siteCatalogPosition

GO
