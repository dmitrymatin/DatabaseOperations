DECLARE completeBackupCursor CURSOR
	FOR 
	SELECT [name] FROM sys.databases
		WHERE [name] NOT IN ('master', 'model', 'msdb', 'tempdb');

DECLARE @path NVARCHAR(max);
DECLARE @filename NVARCHAR(max);
DECLARE @db_name NVARCHAR(max);
OPEN completeBackupCursor;

FETCH NEXT FROM completeBackupCursor INTO @db_name;
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @filename = @db_name + FORMAT(GETDATE(), '-yyyy-MM-dd');
		SET @path = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\' + @filename + '.bak';
		BACKUP DATABASE @db_name TO DISK = @path
		PRINT 'backed up database ' + @db_name + ' to ' + @path;

		FETCH NEXT FROM completeBackupCursor INTO @db_name;
	END;

CLOSE completeBackupCursor;
DEALLOCATE completeBackupCursor;