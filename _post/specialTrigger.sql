    SET NOCOUNT ON

    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    changeSettlementHandling'

    PRINT @msg

    DECLARE @seqStart INT
    DECLARE @altersql NVARCHAR(MAX)

    SELECT @seqStart = MAX([id]) + 1 FROM [dlm].[attachedDocument]
    SET @altersql = N'ALTER SEQUENCE [app].[seqSettlementNo] RESTART WITH ' + CAST(@seqStart AS NVARCHAR)
    EXEC sp_executesql @altersql

    GO
    DROP TRIGGER IF EXISTS [dlm].[trg_Audit_attachedDocument]
    GO

    CREATE TRIGGER [dlm].[trg_Audit_attachedDocument]
	ON [dlm].[attachedDocument]
	AFTER INSERT, UPDATE
	AS
	BEGIN
    
		SET NOCOUNT ON;

		DECLARE @userId INT = (
			SELECT [id] 
			FROM [sec].[client] 
			WHERE [login] = CASE 
				WHEN ISNULL(CAST(SESSION_CONTEXT(N'userid') AS NVARCHAR(100)),'') = '' THEN 'SYSTEM'
				ELSE CAST(SESSION_CONTEXT(N'userid') AS NVARCHAR(100))
			END
		)
		DECLARE @logJobRunningId INT
		DECLARE @logText NVARCHAR(MAX)= (SELECT * FROM inserted FOR JSON AUTO)
        SET @logText = REPLACE(@logText,'}]',',"login":"' + ORIGINAL_LOGIN() + '"}]')
        SET @logText = REPLACE(@logText,'}]',',"userid":"' + ISNULL(CAST(SESSION_CONTEXT(N'userid') AS NVARCHAR(100)),'') + '"}]')
		DECLARE @logCaller NVARCHAR(100) = 'trg_Audit_attachedDocument'				

        DECLARE @nextSettlementNo INT
        DECLARE @fileType NVARCHAR(100)
	
		SET @logJobRunningId = NEXT VALUE FOR [app].[seqLogId]

		--INSERT (inserted exists, delete not exists)

		IF EXISTS (SELECT 1 FROM inserted EXCEPT SELECT 1 FROM deleted)
		BEGIN

            SELECT @fileType = [type] FROM inserted
            IF @fileType IN (N'FY235',N'KB21')
            BEGIN
            
                SELECT @nextSettlementNo = NEXT VALUE FOR [app].[seqSettlementNo]

            END
            ELSE
            BEGIN

                SET @nextSettlementNo = NULL

            END

			UPDATE t
			SET [insertedAt] = GETDATE(),[insertedBy] =  @userId,[fileNo] = @nextSettlementNo
			FROM [dlm].[attachedDocument] t
			INNER JOIN inserted ON t.[id] = inserted.[id]
			WHERE t.[insertedAt] IS NULL;
		END

		--UPDATE (inserted.id = deleted.id)

		IF EXISTS (SELECT 1 FROM inserted INNER JOIN deleted ON inserted.id = deleted.id)
		BEGIN
			UPDATE t
			SET [updatedAt] = GETDATE(),[updatedBy] = @userId
			FROM [dlm].[attachedDocument] t
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
		WHERE EXISTS (SELECT 1 FROM [std].[parameter] WHERE [key] = 'log_active' AND [value] = '1')

	END;

	DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    cancelServiceOrder'

    PRINT @msg

    GO
    DROP TRIGGER IF EXISTS [dlm].[trg_Audit_serviceOrder]
    GO

    CREATE TRIGGER [dlm].[trg_Audit_serviceOrder]
	ON [dlm].[serviceOrder]
	AFTER INSERT, UPDATE
	AS
	BEGIN

		SET NOCOUNT ON;

		DECLARE @userId INT = (
			SELECT [id] 
			FROM [sec].[client] 
			WHERE [login] = CASE 
				WHEN ISNULL(CAST(SESSION_CONTEXT(N'userid') AS NVARCHAR(100)),'') = '' THEN 'SYSTEM'
				ELSE CAST(SESSION_CONTEXT(N'userid') AS NVARCHAR(100))
			END
		)
		DECLARE @logJobRunningId INT
		DECLARE @logText NVARCHAR(MAX)= (SELECT * FROM inserted FOR JSON AUTO)
        SET @logText = REPLACE(@logText,'}]',',"login":"' + ORIGINAL_LOGIN() + '"}]')
        SET @logText = REPLACE(@logText,'}]',',"userid":"' + ISNULL(CAST(SESSION_CONTEXT(N'userid') AS NVARCHAR(100)),'') + '"}]')
		DECLARE @logCaller NVARCHAR(100) = 'trg_Audit_serviceOrder'				
	
		SET @logJobRunningId = NEXT VALUE FOR [app].[seqLogId]

		--INSERT (inserted exists, delete not exists)

		IF EXISTS (SELECT 1 FROM inserted EXCEPT SELECT 1 FROM deleted)
		BEGIN
			UPDATE t
			SET [insertedAt] = GETDATE(),[insertedBy] =  @userId
			FROM [dlm].[serviceOrder] t
			INNER JOIN inserted ON t.[id] = inserted.[id]
			WHERE t.[insertedAt] IS NULL;
		END

		--UPDATE (inserted.id = deleted.id)

		IF EXISTS (SELECT 1 FROM inserted INNER JOIN deleted ON inserted.id = deleted.id)
		BEGIN

			--special Case
			--check if serviceOrderStatus is changed to "canceled


			IF EXISTS (
				SELECT 1 
				FROM inserted 
				INNER JOIN deleted ON inserted.id = deleted.id 
				WHERE inserted.[serviceOrderStatusId] <> deleted.[serviceOrderStatusId]
				AND EXISTS (
					SELECT 1 
					FROM [std].[serviceOrderStatus] 
					WHERE [id] =  inserted.[serviceOrderStatusId] 
					AND [code] = N'CANCELLED'
					)
				)
			BEGIN

				--check if serviceOrderStatus is changed from "billed"

				IF EXISTS (
					SELECT 1 
					FROM deleted
					INNER JOIN [std].[serviceOrderStatus] sos
						ON sos.[id] = deleted.[serviceOrderStatusId] 
					WHERE sos.[code] = N'BILLED'
				)
				BEGIN

					--check if user <> DLMAdmin

					IF NOT EXISTS (
						SELECT 1
						FROM [sec].[client] c
						INNER JOIN [sec].[mapClientClientPermission] mccp
							ON mccp.[clientId] = c.[id]
						INNER JOIN [sec].[clientPermission] cp
							ON cp.[id] = mccp.[clientPermissionId]
						INNER JOIN [sec].[clientRole] cr
							ON cr.[id] = cp.[clientRoleId]
						WHERE c.[login] = CAST(SESSION_CONTEXT(N'userid') AS NVARCHAR(100))
							AND cr.[name] = N'DLMAdmin'
					)
					BEGIN

						-- rollback and error
						RAISERROR ('could not changed serviceOrder from billed to canceled', 16, 1);
						ROLLBACK TRANSACTION;

					END
					ELSE
					BEGIN

						IF EXISTS (
							SELECT 1
							FROM inserted
							INNER JOIN [dlm].[bill] b
								ON b.[serviceOrderId] = inserted.[id]
							INNER JOIN [dlm].[mapBillBillStatus] mBBS
								ON mBBS.[billId] = b.[id]
							INNER JOIN [std].[billStatus] bs
								ON bs.[id] = mBBS.[billStatusId]
							WHERE bs.[code] IN (N'FY235',N'KB21')
						)

						BEGIN

							-- rollback and error
							RAISERROR ('could not changed serviceOrder to canceled if FY235 or KB21 exists', 16, 1);
							ROLLBACK TRANSACTION;

						END

					END

				END

			END

			UPDATE t
			SET [updatedAt] = GETDATE(),[updatedBy] = @userId
			FROM [dlm].[serviceOrder] t
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
		WHERE EXISTS (SELECT 1 FROM [std].[parameter] WHERE [key] = 'log_active' AND [value] = '1')


	END


    GO
