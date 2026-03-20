BEGIN --additionalShift

    PRINT '    fill additionalShift'

    DELETE FROM [std].[additionalShift]

    INSERT INTO [std].[additionalShift]([code],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT N'SA',N'Samstag mit Aufschlag',0,GETDATE(),1
    INSERT INTO [std].[additionalShift]([code],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT N'SO',N'Sonntag mit Aufschlag',0,GETDATE(),1
    INSERT INTO [std].[additionalShift]([code],[name],[isDeleted],[insertedAt],[insertedBy]) SELECT N'HOL',N'Feiertag mit Aufschlag',0,GETDATE(),1

END --additionalShift
GO

