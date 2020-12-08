USE master
GO

RESTORE DATABASE MedicalAppointments
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\MedicalAppointments.bak'
GO