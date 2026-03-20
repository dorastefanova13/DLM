BEGIN --serviceType

    PRINT '    fill serviceType'

    DELETE FROM [std].[serviceType]
    


    BEGIN TRY

        SET IDENTITY_INSERT [std].[serviceType] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH


    insert into std.serviceType([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) select 1,N'ADHOC',N'adHoc',N'adHoc-Beauftragung (EPK)',0,GETDATE(),1
	insert into std.serviceType([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) select 2,N'UHR',N'Unterhaltsreinigung',N'Unterhaltsreinigung',0,GETDATE(),1
	insert into std.serviceType([id],[code],[name],[description],[isDeleted],[insertedAt],[insertedBy]) select 3,N'TR',N'technische Reinigung',N'technische Reinigung',0,GETDATE(),1

    SET IDENTITY_INSERT [std].[serviceType] OFF

END --serviceType
GO
