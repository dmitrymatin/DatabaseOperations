@ECHO OFF

If "%~1" == "" ( 
	ECHO username parameter is empty
	osql -E -Q"USE MedicalAppointments BACKUP DATABASE MedicalAppointments TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\%2.bak'"
	ECHO ---saved backup to %2 ^(user: Windows Authentication ^)---
) ELSE ( 
	ECHO username parameter is not empty 
	osql -U %1 -Q"USE MedicalAppointments BACKUP DATABASE MedicalAppointments TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\%2.bak'"
	ECHO ---saved backup to %2 ^(user: %1 ^)---
)