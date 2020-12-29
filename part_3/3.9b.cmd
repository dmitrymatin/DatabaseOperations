@ECHO OFF

chcp 65001
bcp "USE MedicalAppointments SELECT m.Code, m.[Name], m.[Action], m.Indications, m.Contraindications, m.SideEffects, m.Directions FROM MedicalAppointments.dbo.Illness AS i WITH (NOLOCK) JOIN PossibleTreatment AS pt ON pt.IllnessCode = i.Code JOIN Medicine AS m ON pt.MedicineCode = m.Code WHERE pt.IllnessCode = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%%ОРВИ%%')" ^
queryout "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Medicine.bcp" -n  -C 65001 -T

bcp " USE MedicalAppointments SELECT i.Code, i.[Name], i.Symptoms FROM MedicalAppointments.dbo.Illness AS i WITH (NOLOCK) JOIN PossibleTreatment AS pt ON pt.IllnessCode = i.Code JOIN Medicine AS m ON pt.MedicineCode = m.Code WHERE i.Code = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%%ОРВИ%%')" ^
queryout "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Illness.bcp" -n  -C 65001 -T