BEGIN --serviceObjectType

    PRINT '    fill serviceObjectType'

    BEGIN TRY

        SET IDENTITY_INSERT [std].[serviceObjectType] ON

    END TRY
    BEGIN CATCH

        PRINT '  IDENTITY_INSERT ON'

    END CATCH

	insert into std.serviceObjectType([id],[code],[name],[isDeleted],[insertedAt],[insertedBy]) select 1,N'AREA',N'Fläche Unterhaltsreinigung',0,GETDATE(),1
	insert into std.serviceObjectType([id],[code],[name],[isDeleted],[insertedAt],[insertedBy]) select 2,N'TECH',N'Fläche techn. Reinigung',0,GETDATE(),1
	insert into std.serviceObjectType([id],[code],[name],[isDeleted],[insertedAt],[insertedBy]) select 3,N'CUST',N'Fläche für manuelles Aufmaß',0,GETDATE(),1

	SET IDENTITY_INSERT [std].[serviceObjectType] OFF

END --serviceObjectType
GO
