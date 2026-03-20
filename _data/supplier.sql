BEGIN --supplier

    PRINT '    fill supplier'

    DROP TABLE IF EXISTS [mig].[mapSupplierSupplier]
    CREATE TABLE [mig].[mapSupplierSupplier] (dlm3Id INT,dlm2Id INT)

    DELETE FROM [dlm].[supplier]

    DECLARE cMig CURSOR FOR 
		SELECT su.[id],su.[Name],su.[Code],su.[IsActive],mCC.[dlm3Id] AS [CompanyId] 
		FROM [archiv].[dbo_Supplier] su
		INNER JOIN [mig].[mapCompanyCompany] mCC
			ON mCC.[dlm2Id] = su.[CompanyId]
		INNER JOIN [std].[company] co
			ON co.[id] = mCC.[dlm3Id]
		--WHERE [isActive] = 1

    DECLARE
        @S_id INT
        ,@S_Name NVARCHAR(200)
        ,@S_Code NVARCHAR(100)
        ,@S_IsActive BIT
        ,@S_CompanyId INT

    DECLARE @dlm3Id INT

    OPEN cMig
    FETCH NEXT FROM cMig INTO @S_id,@S_Name,@S_Code,@S_IsActive,@S_CompanyId
    WHILE @@FETCH_STATUS = 0
    BEGIN

        INSERT INTO [dlm].[supplier] ([name],[code],[isActive],[companyId],[isDeleted],[insertedAt],[insertedBy])
        SELECT @S_Name,@S_Code,@S_IsActive,@S_CompanyId,0,GETDATE(),1

        SET @dlm3Id = @@IDENTITY

        INSERT INTO [mig].[mapSupplierSupplier]([dlm2Id],[dlm3Id])
        SELECT @S_id,@dlm3Id

        FETCH NEXT FROM cMig INTO @S_id,@S_Name,@S_Code,@S_IsActive,@S_CompanyId

    END
    CLOSE cMig
    DEALLOCATE cMig

END --supplier

