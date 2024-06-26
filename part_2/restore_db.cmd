@ECHO OFF

If "%~1" == "" ( 
	ECHO username parameter is empty
	osql -E -Q"USE master RESTORE DATABASE MedicalAppointments FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\%2.bak'"
	ECHO ---restored backup from %2 ^(user: Windows Authentication ^)---
) ELSE ( 
	ECHO username parameter is not empty 
	osql -U %1 -Q"USE master RESTORE DATABASE MedicalAppointments FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\%2.bak'"
	ECHO ---restored backup from %2 ^(user: %1 ^)---
)