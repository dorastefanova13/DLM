BEGIN --mapSupplierPlant

    PRINT '    fill mapSupplierPlant'

    DELETE FROM [dlm].[mapSupplierPlant]

    INSERT INTO [dlm].[mapSupplierPlant]([plantId],[supplierId])
    SELECT mPP.[dlm3Id],mSS.[dlm3id]
    FROM [archiv].[dbo_PlantSupplier] pl
	INNER JOIN [archiv].[dbo_supplier] s
		ON s.[id] = pl.[SupplierId]
	INNER JOIN [mig].[mapCompanyCompany] mcc
		ON mcc.[dlm2Id] = s.[CompanyId]
    INNER JOIN [mig].[mapSupplierSupplier] mSS ON mSS.[dlm2Id] = pl.[SupplierId]
    INNER JOIN [mig].[mapPlantPlant] mPP ON mPP.[dlm2Id] = pl.[PlantId]

END --mapSupplierPlant
