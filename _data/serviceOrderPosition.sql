BEGIN --serviceOrderPosition

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    fill serviceOrderPosition'

    PRINT @msg

    DELETE FROM [dlm].[serviceOrderPosition]
    
    DECLARE
		@dlm3Id INT
		,@sspiId INT
		,@ssciId INT
        ,@serviceOrderId INT
        ,@priceCatalogCalculationPositionId INT
        ,@servicePositionId INT
		,@serviceOrderPositionStatusId INT = (SELECT [id] FROM [std].[serviceOrderPositionStatus] WHERE [code] = N'OPEN')
        ,@serviceOrderPositionIsActive BIT
        ,@serviceOrderPositionExecution DATE


	DECLARE @insAt DATE
	DECLARE @updAt DATE
	DECLARE @insBy INT
	DECLARE @updBy INT
    DECLARE @serviceTypeId INT

    DECLARE
        @rowCount INT
        ,@mapCount INT


    BEGIN TRY

        DROP TABLE IF EXISTS [mig].[mapSspItemServiceOrderPosition]
        CREATE TABLE [mig].[mapSspItemServiceOrderPosition] (dlm2Id INT, dlm3Id INT)

        DROP TABLE IF EXISTS [mig].[mapWorkOrderItemServiceOrderPosition]
        CREATE TABLE [mig].[mapWorkOrderItemServiceOrderPosition] (dlm2Id INT, dlm3Id INT)

        BEGIN --fill serviceOrderPosition from SubLV

            SET @msg = '   fill serviceOrderPosition from SubLV ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg

            SET @rowCount = 0

			INSERT INTO [dlm].[serviceOrderPosition]([serviceOrderId],[priceCatalogCalculationPositionId],[serviceOrderPositionStatusId],[isLegacy],[isDeleted],[isActive],[updatedBy])
			OUTPUT inserted.[id],inserted.[updatedBy]
			INTO [mig].[mapSspItemServiceOrderPosition]([dlm3Id],[dlm2Id])
            SELECT 
				mSSSO.[dlm3Id] AS [serviceOrderId]	
				,pccp.[id] AS [priceCatalogCalculationPositionId]
                ,@serviceOrderPositionStatusId AS [serviceOrderPositionStatusId]
				,1 AS [isLegacy]
				,0 AS [isDeleted]
				,sspi.[IsActive]
				,sspi.[id] AS [updatedBy]
            FROM [dlm].[priceCatalogCalculationPosition] pccp
            INNER JOIN [dlm].[priceCatalogCalculation] pcc
                ON pcc.[id] = pccp.[priceCatalogCalculationId]
            INNER JOIN [dlm].[serviceOrder] so
                ON pcc.[id]  = so.[priceCatalogCalculationId]
            INNER JOIN [mig].[mapServiceSpecificationServiceOrder] mSSSO
                ON so.[id] = mSSSO.[dlm3id]
            INNER JOIN [dlm].[servicePosition] svp
                ON svp.[id] = pccp.[servicePositionId]
            INNER JOIN [mig].[mapMainCodeMainCode] mMCMC
                ON mMCMC.[dlm3Id] = svp.[mainCodeId]
            INNER JOIN [mig].[mapCycleTurnus] mCYTU
                ON mCYTU.[dlm3Id] = svp.[turnusId]
            INNER JOIN [archiv].[dbo_SspItem] sspi
                ON sspi.[SspId] = mSSSO.[dlm2Id]
                AND sspi.[MainCodeId] = mMCMC.[dlm2Id]
                AND sspi.[CycleCodeId] = MCYTU.[dlm2Id]
                AND sspi.[ItemNo] = svp.[servicePositionNo]
			WHERE pcc.[isReleased] = 1

            SET @rowCount = @@ROWCOUNT
        
            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

			PRINT '   fill audit columns ' + CONVERT(NVARCHAR,getdate(),120)

            UPDATE t1
                SET
                    t1.[insertedAt] = t2.[Created]
                    ,t1.[insertedBy] = t2.[CreatedBy]
                    ,t1.[updatedAt] = t2.[Modified]
                    ,t1.[updatedBy] = t2.[ModifiedBy]
            FROM [dlm].[serviceOrderPosition] t1
            INNER JOIN [mig].[mapSspItemServiceOrderPosition] m
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

        END--fill serviceOrderPosition from SubLV

        BEGIN --fill serviceOrderPosition  (LVs) <-> serviceObject (Area)

            SET @msg = '   fill serviceOrderPosition  (LVs) <-> serviceObject (Area) ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg
            
            SELECT @serviceTypeId = [id] FROM [std].[serviceType] WHERE [code] = N'UHR'

            INSERT INTO [dlm].[mapServiceOrderPositionServiceObject] ([serviceOrderPositionId],[serviceObjectId],[isActive],[insertedAt],[insertedBy])
            SELECT 
				sop.[id] AS [serviceOrderPosition]
				,soj.[id] AS [serviceObjectId]
				,CAST(m.[IsActive] AS INT) AS [isActive]
				,ISNULL(m.[Modified],m.[Created]) AS [Created]
				,ISNULL(mUC.[dlm3Id],1) AS [insertedBy]
            FROM [dlm].[serviceOrderPosition] sop
            INNER JOIN [dlm].[serviceOrder] so
                ON so.[id] = sop.[serviceOrderId]
            INNER JOIN [mig].[mapSspItemServiceOrderPosition] mSISOP
                ON mSISOP.[dlm3Id] = sop.[id]
            INNER JOIN [archiv].[dbo_Measurement] m
                ON m.[SspItemId] = mSISOP.[dlm2Id]
            INNER JOIN [mig].[mapAreaMeasurementStatus] mMAMS
                ON mMAMS.[dlm2MeasurementId] = m.[id]
            INNER JOIN [dlm].[serviceObject] soj
                ON soj.[areaId] = mMAMS.[dlm3AreaId]
            LEFT OUTER JOIN [mig].[mapUserClient] mUC
                ON mUC.[dlm2Id] = ISNULL(m.[ModifiedBy],m.[CreatedBy])
            WHERE soj.[areaId] IS NOT NULL
            AND so.[serviceTypeId] = @serviceTypeId

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END--fill serviceOrderPosition  (LVs) <-> serviceObject (Area)

        BEGIN --fill serviceOrderPosition  (LVs) <-> serviceObject (Manual)

            SET @msg = '   fill serviceOrderPosition  (LVs) <-> serviceObject (Manual) ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg

            INSERT INTO [dlm].[mapServiceOrderPositionServiceObject] ([serviceOrderPositionId],[serviceObjectId],[isActive],[insertedAt],[insertedBy])
            SELECT 
				mSSPISOP.[dlm3Id] AS [serviceOrderPosition]
				,so.[id] AS [serviceObjectId]
				,CAST(m.[IsActive] AS INT) AS [isActive]
				,m.[Created] AS [Created]
				,1 AS [insertedBy]
            FROM [dlm].[serviceObject] so
            INNER JOIN [mig].[mapCustomCleaningObjectMeasurementManual1] mCCOM
                ON so.[customCleaningObjectId] = mCCOM.[dlm3id]
            INNER JOIN [archiv].[dbo_Measurement] m
                ON m.[id] = mCCOM.[dlm2Id]
            INNER JOIN [mig].[mapSspItemServiceOrderPosition] mSSPISOP
                ON mSSPISOP.[dlm2Id] = m.[SspItemId]


            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --fill serviceOrderPosition  (LVs) <-> serviceObject (Manual)

        BEGIN--fill serviceOrderPosition from WorkOrder (EPKs)

            SET @msg = '   fill serviceOrderPosition from WorkOrder (EPKs) ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg

            SET @rowCount = 0

			INSERT INTO	[dlm].[serviceOrderPosition]([serviceOrderId],[priceCatalogCalculationPositionId],[serviceOrderPositionStatusId],[isLegacy],[isDeleted],[isActive],[updatedBy])
			OUTPUT inserted.[id],inserted.[updatedBy]
			INTO [mig].[mapWorkOrderItemServiceOrderPosition]([dlm3Id],[dlm2Id])
            SELECT 		 
				mWOSO.[dlm3Id] AS [ServiceOrderId]
				,pccp.[id] AS [priceCatalogCalculationPositionId]
				,@serviceOrderPositionStatusId
				,1 AS [isLegacy]
				,0 AS [isDeleted]
				,1 AS [isActive]
				,woi.[id] AS [updatedBy]
			FROM [archiv].[dbo_woItem] woi
			INNER JOIN [archiv].[dbo_WorkOrder] wo
				ON wo.[id] = woi.[WoId]
			INNER JOIN [archiv].[dbo_PurchaseOrder] po
				ON po.[id] = wo.[PoId]
			INNER JOIN [mig].[mapSupplierSupplier] mSUSU
				ON mSUSU.[dlm2Id] = po.[SupplierId]
			INNER JOIN  [mig].[mapSscItemPriceCatalogPosition] mSIPCP
				ON mSIPCP.[dlm2Id] = woi.[SscItemId]
			INNER JOIN [archiv].[dbo_SscItem] ssci
				ON ssci.[Id] =  woi.[SscItemId]
			INNER JOIN [archiv].[dbo_StandardServicesCatalog] ssc
				ON ssc.[Id] = ssci.[SscId]
			INNER JOIN [mig].[mapStandardServicesCatalogPriceCatalog] mSSCPC
				ON mSSCPC.[dlm2Id] = ssc.[Id]
			INNER JOIN [dlm].[priceCatalogCalculation] pcc
				ON pcc.[priceCatalogId] = mSSCPC.[dlm3Id]
				AND pcc.[supplierId] = mSUSU.[dlm3Id]
				AND pcc.[isReleased] = 1
			INNER JOIN [dlm].[priceCatalogCalculationPosition] pccp
				ON pccp.[priceCatalogCalculationId] = pcc.[id]
				AND pccp.[priceCatalogPositionId] = mSIPCP.[dlm3Id]
			INNER JOIN [mig].[mapWorkOrderServiceOrder] mWOSO
				ON mWOSO.[dlm2Id] = woi.[WoId]

            SET @rowCount = @@ROWCOUNT
            
            PRINT '      ' + CAST(@rowCount AS NVARCHAR) + ' records'

			PRINT '   fill audit columns ' + CONVERT(NVARCHAR,getdate(),120)

            UPDATE t1
                SET
                    t1.[insertedAt] = t2.[Created]
                    ,t1.[insertedBy] = t2.[CreatedBy]
                    ,t1.[updatedAt] = t2.[Modified]
                    ,t1.[updatedBy] = t2.[ModifiedBy]
            FROM [dlm].[serviceOrderPosition] t1
            INNER JOIN [mig].[mapWorkOrderItemServiceOrderPosition] m
                ON m.[dlm3Id] = t1.[id]
            INNER JOIN (
                SELECT i.[id],cr.[dlm3Id] AS [CreatedBy],mo.[dlm3Id] AS [ModifiedBy], i.[Created],i.[Modified]
                FROM [archiv].[dbo_woitem] i
            	LEFT OUTER JOIN [mig].[mapUserClient] cr
					ON cr.[dlm2Id] = i.[CreatedBy]
				LEFT OUTER JOIN [mig].[mapUserClient] mo
					ON mo.[dlm2Id] = i.[ModifiedBy]
                ) t2
                ON t2.[id] = m.[dlm2Id]

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --fill serviceOrderPosition from WorkOrder (EPKs)

        BEGIN --fill serviceOrderPosition <-> serviceObject (EPKs)

            SET @msg = '   fill serviceOrderPosition <-> serviceObject (EPKs) ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg

            INSERT INTO [dlm].[mapServiceOrderPositionServiceObject] ([serviceOrderPositionId],[serviceObjectId],[isActive],[insertedAt],[insertedBy])
            SELECT DISTINCT 
                mWOISOP.[dlm3Id]
                ,mAWI.[dlm3AreaId]
                ,1 AS [isActive]
                ,GETDATE() AS [insertedAt]
                ,1 [insertedBy]
            FROM [mig].[mapWorkOrderItemServiceOrderPosition] mWOISOP
            INNER JOIN [mig].[mapAreaWoItem] mAWI
                ON mAWI.[dlm2WoItemId] = mWOISOP.[dlm2Id]
            WHERE mAWI.[dlm3AreaId] IN (SELECT [id] FROM [dlm].[serviceObject])

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END--fill serviceOrderPosition <-> serviceObject (EPKs)

        BEGIN --fill serviceOrderPosition <-> customCleaningObject (EPKs Measurement Manual = 1)

            SET @msg = '   fill serviceOrderPosition <-> customCleaningObject (EPKs Measurement Manual = 1) ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg

            INSERT INTO [dlm].[mapServiceOrderPositionServiceObject] ([serviceOrderPositionId],[serviceObjectId],[isActive],[insertedAt],[insertedBy])
            SELECT DISTINCT
                mWOISOP.[dlm3Id]
                ,so.[id]
				,1 AS [isActive]
                ,GETDATE() AS [insertedAt]
                ,1 [insertedBy]
            FROM [mig].[mapWorkOrderItemServiceOrderPosition] mWOISOP
            INNER JOIN [mig].[mapCustomCleaningObjectWoItemManual1] mCCOWI
                ON mCCOWI.[dlm2Id] = mWOISOP.[dlm2Id]
			INNER JOIN [dlm].[serviceObject] so
				ON so.[customCleaningObjectId] = mCCOWI.[dlm3id]

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END--fill serviceOrderPosition <-> customCleaningObject (EPKs Measurement Manual = 1)

        BEGIN --fill serviceOrderPosition <-> customCleaningObject (EPKs InternalMeasurement)

            SET @msg = '   fill serviceOrderPosition <-> customCleaningObject (EPKs InternalMeasurement) ' + CONVERT(NVARCHAR,getdate(),120)
            PRINT @msg

            INSERT INTO [dlm].[mapServiceOrderPositionServiceObject] ([serviceOrderPositionId],[isActive],[serviceObjectId],[insertedAt],[insertedBy])
            SELECT DISTINCT 
                mWOISOP.[dlm3Id]
                ,so.[id]
				,1 AS [isActive]
                ,GETDATE() AS [insertedAt]
                ,1 [insertedBy]
            FROM [mig].[mapCustomCleaningObjectInternalMeasurement] mCCOIM
			INNER JOIN [dlm].[serviceObject] so
				ON so.[customCleaningObjectId] = mCCOIM.[dlm3Id]
			INNER JOIN [archiv].[dbo_WoItem] woi
				ON woi.[InternalMeasurementId] = mCCOIM.[dlm2Id]
			INNER JOIN [mig].[mapWorkOrderItemServiceOrderPosition] mWOISOP
				ON mWOISOP.[dlm2Id] = woi.[id]

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END--fill serviceOrderPosition <-> customCleaningObject (EPKs InternalMeasurement)

        BEGIN --fill serviceExecution for Workorder

            SET @msg = '   fill serviceExecution for Workorder'
            PRINT @msg

            INSERT INTO [dlm].[serviceExecution]
                       ([mapServiceOrderPositionServiceObjectId]
                       ,[serviceExecutionDay]
                       ,[planned]
                       ,[completed]
                       ,[deficient]
                       ,[isDeleted]
                       ,[insertedAt]
                       ,[insertedBy])
            SELECT
                sopso.[id] AS [mapServiceOrderPositionServiceObjectId]
                ,woi.[ExecutionDate] AS [serviceExecutionDay]
                ,1 AS [planned]
                ,CASE WHEN woi.[StateId] = 20 THEN 1 ELSE 0 END AS [completed]
                ,CASE WHEN woi.[StateId] = 30 THEN 1 ELSE 0 END AS [deficient]
                ,0 AS [isDeleted]
                ,ISNULL(woi.[Modified],GETDATE()) AS [insertedAt]
                ,ISNULL(muc.[dlm3Id],1) AS [insertedBy]
            FROM [archiv].[dbo_woitem] woi
            INNER JOIN [mig].[mapWorkOrderItemServiceOrderPosition] mWOISOP
                ON mWOISOP.[dlm2Id] = woi.[id]
            INNER JOIN [dlm].[mapServiceOrderPositionServiceObject] sopso
                ON sopso.[serviceOrderPositionId] = mWOISOP.[dlm3Id]
            LEFT OUTER JOIN [mig].[mapUserClient] muc
                ON muc.[dlm2Id] = woi.[ModifiedBy]

            SET @rowCount = @@ROWCOUNT

            PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'

        END --fill serviceExecution for Workorder

    END TRY
    BEGIN CATCH

		PRINT @msg + ' ERROR'

        SET @msg = ERROR_MESSAGE() + ' '  + @msg + ' serviceOrderPosition.sql'
        RAISERROR(@msg,1,16)

    END CATCH
END

GO
