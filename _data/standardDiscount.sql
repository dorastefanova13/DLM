BEGIN --standarddiscount

    PRINT '    fill standardDiscount'

    DELETE FROM [std].[standardDiscount]

    INSERT INTO [std].[standardDiscount]
               ([plantId]
               ,[value]
               ,[periodFrom]
               ,[periodUntil]
               ,[isDeleted]
			   ,[insertedAt]
			   ,[insertedBy])
    SELECT [id],5,CONVERT(DATETIME,'20240101',112),CONVERT(DATETIME,'20300101',112),0,GETDATE(),1 FROM [loc].[plant] WHERE [id] IN (SELECT [plantId] FROM [sec].[mapClientPlant])
    UNION ALL
    SELECT [id],10,CONVERT(DATETIME,'20240101',112),CONVERT(DATETIME,'20300101',112),0,GETDATE(),1 FROM [loc].[plant] WHERE [id] IN (SELECT [plantId] FROM [sec].[mapClientPlant])
    UNION ALL
    SELECT [id],15,CONVERT(DATETIME,'20240101',112),CONVERT(DATETIME,'20300101',112),0,GETDATE(),1 FROM [loc].[plant] WHERE [id] IN (SELECT [plantId] FROM [sec].[mapClientPlant])
    UNION ALL
    SELECT [id],20,CONVERT(DATETIME,'20240101',112),CONVERT(DATETIME,'20300101',112),0,GETDATE(),1 FROM [loc].[plant] WHERE [id] IN (SELECT [plantId] FROM [sec].[mapClientPlant])
    UNION ALL
    SELECT [id],25,CONVERT(DATETIME,'20240101',112),CONVERT(DATETIME,'20300101',112),0,GETDATE(),1 FROM [loc].[plant] WHERE [id] IN (SELECT [plantId] FROM [sec].[mapClientPlant])
    UNION ALL
    SELECT [id],30,CONVERT(DATETIME,'20240101',112),CONVERT(DATETIME,'20300101',112),0,GETDATE(),1 FROM [loc].[plant] WHERE [id] IN (SELECT [plantId] FROM [sec].[mapClientPlant])

END --standardDiscount
GO