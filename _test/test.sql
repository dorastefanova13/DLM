BEGIN --test

    PRINT 'test'

    SELECT * FROM $(srcdb)..[User]

END --test
GO
