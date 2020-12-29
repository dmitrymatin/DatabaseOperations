@ECHO OFF

chcp 65001
bcp MedicalAppointments.dbo.Medicine IN "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Medicine.bcp" -T -n -C 65001
bcp MedicalAppointments.dbo.Illness IN "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Illness.bcp" -T -n -C 65001
bcp MedicalAppointments.dbo.PossibleTreatment IN "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\PossibleTreatment.bcp" -T -n -C 65001