@ECHO OFF

chcp 65001
bcp "USE MedicalAppointments SELECT pt.IllnessCode, pt.MedicineCode FROM MedicalAppointments.dbo.Illness AS i WITH (NOLOCK) JOIN PossibleTreatment AS pt on pt.IllnessCode = i.Code WHERE pt.IllnessCode = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%%ОРВИ%%')" ^
queryout "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\PossibleTreatment.bcp" -n  -C 65001 -T