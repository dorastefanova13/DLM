BEGIN --serviceCatalog

    --Tabelle initialisieren und Arbeitsvariablen deklarieren bzw. ermitteln

    DELETE FROM [dlm].[serviceCatalog]

    DECLARE @dlm2Id INT
    DECLARE @dlm3Id INT
    DECLARE @serviceCatalogName NVARCHAR(200)
    DECLARE @tmpEPKNo INT
    DECLARE @companyId INT = (SELECT TOP 1 [id] FROM [std].[company] WHERE [code] <> 'n/a')
    DECLARE @companyCode NVARCHAR(100) = (SELECT TOP 1 [code] FROM [std].[company] WHERE [code] <> 'n/a')
    --TODO other companies
    DECLARE @msg NVARCHAR(MAX)
    DECLARE @rowCount INT
    DECLARE @mapCount INT
    DECLARE @serviceTypeId INT

	DECLARE @insAt DATE
	DECLARE @updAt DATE
	DECLARE @insBy INT
	DECLARE @updBy INT

    SET @msg = '    fill serviceCatalog'
    PRINT @msg

    BEGIN TRY
    
        BEGIN --LVs-----------------------------------------------------------------------

			BEGIN --   fill serviceCatalog with global LVs

				SET @msg = '   fill serviceCatalog with global LVs'
				PRINT @msg

				DROP TABLE IF EXISTS [mig].[mapServiceSpecificationServiceCatalog]
				CREATE TABLE [mig].[mapServiceSpecificationServiceCatalog] (dlm2Id INT, dlm3Id INT,typ NVARCHAR(100))

				CREATE CLUSTERED INDEX [x_mapServiceSpecificationServiceCatalogTyp] ON [mig].[mapServiceSpecificationServiceCatalog]([typ] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

				SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [code] = N'UHR'

				SET @rowCount = 0

				--alle globalen LVs uebertragen 

				INSERT INTO [dlm].[serviceCatalog] ([name],[description],[companyId],[serviceTypeId],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
				SELECT 
					SUBSTRING('LV ' + CAST([SspNo] AS NVARCHAR) + ' - ' + ssp.[Name]  + N' ' + c.[code],1,200)
					,SUBSTRING('LV ' + CAST([SspNo] AS NVARCHAR) + ' - ' + ssp.[Name]  + N' ' + c.[code] + N'- erstellt bei Migration aus DLM2.0',1,200)
					,c.[id]
					,@serviceTypeId
					,0 
					,1
					,ssp.[Created]
					,ISNULL(cr.[dlm3Id],1)
					,ssp.[Modified]
					,ISNULL(mo.[dlm3Id],1)
				FROM [archiv].[dbo_ServiceSpecification] ssp
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = ssp.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = ssp.[ModifiedBy]
				INNER JOIN [archiv].[dbo_SspCompany] sc
					ON sc.[SspId] = ssp.[id]
				INNER JOIN [archiv].[dbo_Company] c
					ON c.[id] = sc.[CompanyId]
				INNER JOIN [mig].[mapCompanyCompany] mcc
					ON c.[id] = mcc.[dlm2Id]
				INNER JOIN [std].[company] co
					ON co.[id] = mcc.[dlm3Id]
				WHERE ssp.[IsGlobal] = 1
				--AND ssp.[IsStandard] = 1
				--AND ssp.[IsActive] = 1

				SET @rowCount = @@ROWCOUNT

				--mappingTable alteId<->neueId fuellen

				INSERT INTO [mig].[mapServiceSpecificationServiceCatalog]([dlm2Id],[dlm3Id],[typ])
				SELECT dlm2.[id],dlm3.[id],N'LV global ' + CASE WHEN dlm2.[IsStandard] = 1 THEN 'standard' ELSE 'non standard' END
				FROM 
				(
					SELECT ssp.[id] , SUBSTRING('LV ' + CAST(ssp.[SspNo] AS NVARCHAR) + ' - ' + ssp.[Name]  + N' ' + c.[code],1,200) AS [name],ssp.[SspNo],ssp.[IsStandard]
					FROM [archiv].[dbo_ServiceSpecification] ssp
					INNER JOIN [archiv].[dbo_SspCompany] sc
						ON sc.[SspId] = ssp.[id]
					INNER JOIN [archiv].[dbo_Company] c
						ON c.[id] = sc.[CompanyId]
					INNER JOIN [mig].[mapCompanyCompany] mcc
						ON c.[id] = mcc.[dlm2Id]
					INNER JOIN [std].[company] co
						ON co.[id] = mcc.[dlm3Id]
					WHERE ssp.[IsGlobal] = 1
				) dlm2
				INNER JOIN [dlm].[serviceCatalog] dlm3
					ON dlm2.[name] COLLATE SQL_Latin1_General_CP1_CI_AI = dlm3.[name]

				SET @mapCount = @@ROWCOUNT

				PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

			END --   fill serviceCatalog with global LVs

			BEGIN --   fill serviceCatalog with Dummys for assignment from LVs without global LV

				SET @msg = '   fill serviceCatalog with Dummys for assignment from LVs without global LV'
				PRINT @msg

				DROP TABLE IF EXISTS [mig].[mapTempServiceCatalogCompany]
				CREATE TABLE [mig].[mapTempServiceCatalogCompany] ([dlm3Id] INT,[companyId] INT)

				INSERT INTO [dlm].[serviceCatalog] ([name],[description],[companyId],[serviceTypeId],[isDeleted],[isLegacy],[insertedAt],[insertedBy])
				SELECT 
					SUBSTRING(N'Container ServiceCatalog für LVs ohne globalen LV ' + c.[code],1,200) AS [name]
					,N'Container ServiceCatalog für LVs ohne globalen LV - erstellt bei Migration aus DLM2.0 -> Zuordnung von SspItems von nicht globalen LVs '  + c.[code] AS [description]
					,c.[id] AS [companyId]
					,@serviceTypeId AS [serviceTypeId]
					,0 AS [isDeleted]
					,1 AS [isLegacy]
					,GETDATE()
					,1
				FROM [std].[company] c
				INNER JOIN [mig].[mapCompanyCompany] mcc
					ON mcc.[dlm3Id] = c.[id]
				WHERE c.[id] > 0
            
				SET @rowCount = @@ROWCOUNT

				INSERT INTO  [mig].[mapTempServiceCatalogCompany]([dlm3Id],[companyId])
				SELECT [id],[companyId] 
				FROM [dlm].[serviceCatalog] 
				WHERE [name] LIKE N'Container ServiceCatalog für LVs ohne globalen LV %'

				SET @mapCount = @@ROWCOUNT

				PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

			END --   fill serviceCatalog with Dummys for assignment from LVs without global LV

        END

        BEGIN --EPKs------------------------------------------------------------------------------------------

            SET @msg = '   fill serviceCatalog with global EPKs'
            PRINT @msg

            DROP TABLE IF EXISTS [mig].[mapStandardServicesCatalogServiceCatalog]
            CREATE TABLE [mig].[mapStandardServicesCatalogServiceCatalog] (dlm2Id INT, dlm3Id INT, typ NVARCHAR(100))

            SET @rowCount = 0
            SET @mapCount = 0

            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [code] = N'ADHOC'

            --alle globalen aktiven EPKs uebertragen 

            MERGE INTO [dlm].[serviceCatalog] AS t
            USING (
                SELECT 
                    N'EPK '+ CAST([SscNo] AS NVARCHAR) + ' - ' + ISNULL(ssc.[Description] COLLATE SQL_Latin1_General_CP1_CI_AS,' ') + ' ' + co.[code] AS [name]
                    ,N'EPK '+ CAST([SscNo] AS NVARCHAR) + ' - ' + ISNULL(ssc.[Description] COLLATE SQL_Latin1_General_CP1_CI_AS,' ') + ' ' + co.[code] + N' - erstellt bei Migration aus DLM2.0' AS [description]
                    ,@serviceTypeId AS [serviceTypeId]
                    ,mCOCO.[dlm3Id] AS [companyId]
                    ,0 AS [isDeleted]
                    ,1 AS [isLegacy]
                    ,ssc.[Id] AS [dlm2SscId]
					,ssc.[Created] AS [insertedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,ssc.[Modified] AS [updatedAt]
					,mo.[dlm3Id] AS [updatedBy]
                FROM [archiv].[dbo_StandardServicesCatalog] ssc
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = ssc.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = ssc.[ModifiedBy]
                INNER JOIN [archiv].[dbo_SscCompany] sscco
                    ON sscco.[SscId] = ssc.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2Id] = sscco.[CompanyId]
                INNER JOIN [std].[company] co
                    ON co.[id] = mCOCO.[dlm3Id]
                WHERE [IsGlobal] = 1 
                --AND [IsActive] = 1
            ) AS s
            ON t.[name] COLLATE SQL_Latin1_General_CP1_CI_AS = s.[name]
            WHEN NOT MATCHED THEN
                INSERT([name],[description],[serviceTypeId],[companyId],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
                VALUES(s.[name],s.[description],s.[serviceTypeId],s.[companyId],s.[isDeleted],s.[isLegacy],s.[insertedAt],s.[insertedBy],s.[updatedAt],s.[updatedBy])
            OUTPUT s.[dlm2SscId],inserted.[id],N'serviceCatalog with global EPKs'
            INTO [mig].[mapStandardServicesCatalogServiceCatalog]([dlm2Id],[dlm3Id],[typ]);
            ;

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

            SET @msg = '   fill serviceCatalog with not global EPKs for assignment from siteCatalogs'

            PRINT @msg

            SET @rowCount = 0
            SET @mapCount = 0

            --alle nichtglobalen aktiven EPKs uebertragen fuer spaetere Zuordnung von Servicepositionen, die nicht zu einem globalen EPK gehoeren

            DECLARE cMig CURSOR FOR
                SELECT 
					ssc.[id]
					,ssc.[description]
					,ssc.[SscNo]
					,co.[id]
					,co.[code]
					,ssc.[Created] AS [insertedAt]
					,cr.[dlm3Id] AS [insertedBy]
					,ssc.[Modified] AS [updatedAt]
					,mo.[dlm3Id] AS [updatedBy]
                FROM [archiv].[dbo_StandardServicesCatalog] ssc
				LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = ssc.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = ssc.[ModifiedBy]
                LEFT OUTER JOIN (
					SELECT DISTINCT q.[sscId],q.[CompanyId]
					FROM (
						SELECT [sscId],[CompanyId] FROM [archiv].[dbo_PurchaseOrder] UNION ALL
						SELECT [sscId],[CompanyId] FROM [archiv].[dbo_SscCompany]
					) q WHERE q.[CompanyId] IS NOT NULL
				) sscco
                    ON sscco.[SscId] = ssc.[id]
                INNER JOIN [mig].[mapCompanyCompany] mCOCO
                    ON mCOCO.[dlm2Id] = sscco.[CompanyId]
                INNER JOIN [std].[company] co
                    ON co.[id] = mCOCO.[dlm3Id]
                WHERE [isGlobal] = 0

            OPEN cMig
            FETCH NEXT FROM cMig INTO @dlm2Id,@serviceCatalogName,@tmpEPKNo,@companyId,@companyCode,@insAt,@insBy,@updAt,@updBy
            WHILE @@FETCH_STATUS = 0
            BEGIN

                INSERT INTO [dlm].[serviceCatalog] ([name],[description],[companyId],[serviceTypeId],[isDeleted],[isLegacy],[insertedAt],[insertedBy],[updatedAt],[updatedBy])
                SELECT 
                    SUBSTRING(N'EPK '+ CAST(@tmpEPKNo AS NVARCHAR) + ' - ' + @serviceCatalogName,1,200) + ' ' + @companyCode
                    ,SUBSTRING(N'Container ServiceCatalog für ' + N'EPK '+ CAST(@tmpEPKNo AS NVARCHAR) + ' - ' + @serviceCatalogName + ' ' + @companyCode + N' - aus DLM2.0 für Zuordnung von SscItems von nicht globalen EPKs',1,3999) 
                    ,@companyId
                    ,@serviceTypeId
                    ,0 
                    ,1
					,@insAt
					,@insBy
					,@updAt
					,@updBy

                SET @rowCount = @rowCount + @@ROWCOUNT

                SET @dlm3Id = @@IDENTITY

                INSERT INTO [mig].[mapStandardServicesCatalogServiceCatalog]([dlm2Id],[dlm3Id],[typ])
                SELECT @dlm2Id,@dlm3Id,'EPK not global'

                SET @mapCount = @mapCount + @@ROWCOUNT

                FETCH NEXT FROM cMig INTO @dlm2Id,@serviceCatalogName,@tmpEPKNo,@companyId,@companyCode,@insAt,@insBy,@updAt,@updBy
            END
            CLOSE cMig
            DEALLOCATE cMig

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records - ' + CAST(@mapCount AS NVARCHAR) + ' mappings'

        END

    END TRY
    BEGIN CATCH

            Set @msg = ERROR_MESSAGE() + ' ' + @msg + ' serviceCatalog'
            RAISERROR(@msg,16,1)

    END CATCH
END --serviceCatalog
GO
