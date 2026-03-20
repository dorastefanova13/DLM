BEGIN --map serviceOrder SAPOrder

    SET NOCOUNT ON

	DECLARE @rowcount INT
    DECLARE @msg NVARCHAR(MAX)
    SET @msg = '    map serviceOrder SAPOrder'
    PRINT @msg

    DELETE FROM [dlm].[mapServiceOrderSAPOrder]

    SET @msg = '      map serviceOrder SAPOrder UHR'
    PRINT @msg

	INSERT INTO [dlm].[mapServiceOrderSapOrder]([serviceOrderId],[sapOrderId],[periodFrom],[periodUntil],[isActive],[insertedAt],[insertedBy])
	SELECT mSSPSO.[dlm3Id],mPOSO.[dlm3Id],COALESCE(ssp.[ValidFrom],ssp.[ChangeFrom],ssp.[Created]),ISNULL(ssp.[ChangeFrom],CONVERT(DATE,'21001231',12)),1,GETDATE(),1
	FROM [mig].[mapServiceSpecificationServiceOrder] mSSPSO
	INNER JOIN [archiv].[dbo_ServiceSpecification] ssp
		ON ssp.[id] = mSSPSO.[dlm2Id]
	INNER JOIN [mig].[mapPurchaseOrderSapOrder] mPOSO
		ON mPOSO.[dlm2Id] = ssp.[PoId]

	SET @rowcount = @@ROWCOUNT
	PRINT '         ' + CAST(@rowcount AS NVARCHAR) + ' records'


    SET @msg = '      map serviceOrder SAPOrder AdHoc'
    PRINT @msg

	INSERT INTO [dlm].[mapServiceOrderSapOrder]([serviceOrderId],[sapOrderId],[periodFrom],[periodUntil],[isActive],[insertedAt],[insertedBy])
	SELECT mWOSO.[dlm3Id],mPOSO.[dlm3Id],wo.[ContractingDate],wo.[ContractingDate],1,GETDATE(),1
	FROM  [mig].[mapWorkOrderServiceOrder] mWOSO
	INNER JOIN [archiv].[dbo_WorkOrder] wo
		ON wo.[id] = mWOSO.[dlm2Id]
	INNER JOIN [mig].[mapPurchaseOrderSapOrder] mPOSO
		ON mPOSO.[dlm2Id] = wo.[PoId]

	SET @rowcount = @@ROWCOUNT
	PRINT '         ' + CAST(@rowcount AS NVARCHAR) + ' records'

END
GO 