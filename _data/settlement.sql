BEGIN --Settlement

    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    fill settlement'

    PRINT @msg

    DECLARE @rowCount INT

    DELETE FROM [dlm].[mapBillAttachedDocument]
    DELETE FROM [dlm].[attachedDocument] WHERE [type] IN ( N'FY235',N'KB21')

    DECLARE @settlementId INT
    DECLARE @settlementTypeId INT
    DECLARE @settlementPlantId INT
    DECLARE @fileId INT

    DECLARE @fy235StatusId INT = (SELECT [id] FROM [std].[billStatus] WHERE [code] = N'FY235')
    DECLARE @kb21StatusId INT = (SELECT [id] FROM [std].[billStatus] WHERE [code] = N'KB21')

    DECLARE cMig CURSOR FOR  
    SELECT [Id]
      ,[PlantId]
      ,[SettlementInterfaceId]
    FROM [archiv].[dbo_Settlement]
    WHERE ISNULL([File],'') <> ''

    BEGIN TRY

        SET IDENTITY_INSERT [dlm].[attachedDocument] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

    OPEN cMig
    FETCH NEXT FROM cMig INTO @settlementId,@settlementPlantId,@settlementTypeId
    WHILE @@FETCH_STATUS = 0
    BEGIN

        SELECT @fileId = 
            CASE 
                WHEN s.[FileNo] IS NULL THEN (
                    SELECT value AS ZweiterWert
                    FROM (
                        SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Position, value
                        FROM STRING_SPLIT(s.[File], '_')
                    ) AS Splitted
                    WHERE Position = 2
                )
                ELSE s.[FileNo]
            END               
        FROM [archiv].[dbo_Settlement] s
        WHERE s.[id] = @settlementId

        INSERT INTO [dlm].[attachedDocument]([id],[name],[originalFilename],[ref],[description],[timestamp],[type],[status],[fileNo],[insertedAt],[insertedBy])
        SELECT 
            @fileId
            ,s.[File]
            ,s.[File]
			,s.[File]
            ,SUBSTRING(LTRIM(RTRIM(ISNULL(s.[OperationStateMessage],' ') + ' ' + ISNULL(s.[FileContent],' '))),1,3800)
            ,s.[Completed]
            ,CASE WHEN s.[SettlementInterfaceId] = 1 THEN N'FY235' ELSE N'KB21' END
            ,N'STORED'
            ,@fileId
            ,s.[Created]
            ,ISNULL(mUC.[dlm3Id],1)
        FROM [archiv].[dbo_Settlement] s
        LEFT OUTER JOIN [mig].[mapUserClient] mUC
            ON mUC.[dlm2Id] = s.[CreatedBy]
        WHERE s.[File] IS NOT NULL
        AND s.[id] = @settlementId

        IF @settlementTypeId = 1 
        BEGIN 

            INSERT INTO [dlm].[mapBillAttachedDocument] ([attachedDocumentId],[billId])
            SELECT @fileId,mBB.[dlm3Id]
            FROM [mig].[mapBillBill] mBB
            WHERE mBB.[dlm2Id] IN (
                SELECT [id] 
                FROM [archiv].[dbo_Bill]
                WHERE [PrimarySettlementId] = @settlementId
                AND [PoId] IN (
                    SELECT [id] 
                    FROM [archiv].[dbo_PurchaseOrder]
                    WHERE [PlantId] = @settlementPlantId
                )
            )

        END

        IF @settlementTypeId = 2 
        BEGIN 

            INSERT INTO [dlm].[mapBillAttachedDocument] ([attachedDocumentId],[billId])
            SELECT @fileId,mBB.[dlm3Id]
            FROM [mig].[mapBillBill] mBB
            WHERE mBB.[dlm2Id] IN (
                SELECT [id] 
                FROM [archiv].[dbo_Bill]
                WHERE [SecondarySettlementId] = @settlementId
                AND [PoId] IN (
                    SELECT [id] 
                    FROM [archiv].[dbo_PurchaseOrder]
                    WHERE [PlantId] = @settlementPlantId
                )
            )

        END

        UPDATE T1
            SET T1.[fy235] = T2.[name]
        FROM [dlm].[bill] T1
        INNER JOIN [dlm].[mapBillAttachedDocument] mBAD
            ON mBAD.[billId] = T1.[id]
        INNER JOIN (
            SELECT [id],[name] FROM [dlm].[attachedDocument] WHERE [TYPE] = N'FY235'
        ) T2
            ON T2.[id] = mBAD.[attachedDocumentId]

        UPDATE T1
            SET T1.[kb21] = T2.[name]
        FROM [dlm].[bill] T1
        INNER JOIN [dlm].[mapBillAttachedDocument] mBAD
            ON mBAD.[billId] = T1.[id]
        INNER JOIN (
            SELECT [id],[name] FROM [dlm].[attachedDocument] WHERE [TYPE] = N'KB21'
        ) T2
            ON T2.[id] = mBAD.[attachedDocumentId]


        SET @rowCount = @rowCount + 1
    
        FETCH NEXT FROM cMig INTO @settlementId,@settlementPlantId,@settlementTypeId

    END
    CLOSE cMig
    DEALLOCATE cMig
        
    PRINT '      ' + CAST(@rowcount AS NVARCHAR) + ' records'
    
    INSERT INTO [dlm].[mapBillBillStatus] ([description],[createdAt],[createdBy],[billId],[billStatusId],[isCurrent],[isDeleted],[insertedAt],[insertedBy])
    SELECT N'übernommen aus DLM2.0',s.[Created],u.[login],mBAD.[billId],@fy235StatusId,0,0,GETDATE(),1
    FROM [archiv].[dbo_Settlement] s
    INNER JOIN [archiv].[dbo_User] u
        ON u.[Id] = s.[CreatedBy]
    INNER JOIN [dlm].[mapBillAttachedDocument] mBAD
        ON mBAD.[attachedDocumentId] = s.[id]
    WHERE s.[SettlementInterfaceId] = 1

    INSERT INTO [dlm].[mapBillBillStatus] ([description],[createdAt],[createdBy],[billId],[billStatusId],[isCurrent],[isDeleted],[insertedAt],[insertedBy])
    SELECT N'übernommen aus DLM2.0',s.[Created],u.[login],mBAD.[billId],@kb21StatusId,0,0,GETDATE(),1
    FROM [archiv].[dbo_Settlement] s
    INNER JOIN [archiv].[dbo_User] u
        ON u.[Id] = s.[CreatedBy]
    INNER JOIN [dlm].[mapBillAttachedDocument] mBAD
        ON mBAD.[attachedDocumentId] = s.[id]
    WHERE s.[SettlementInterfaceId] = 2

    SET IDENTITY_INSERT [dlm].[attachedDocument] OFF

END
GO