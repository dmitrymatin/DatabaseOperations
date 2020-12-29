USE MedicalAppointments
GO

SELECT pt.IllnessCode, pt.MedicineCode FROM Illness AS i
JOIN PossibleTreatment AS pt on pt.IllnessCode = i.Code
WHERE pt.IllnessCode = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%ОРВИ%');

--SELECT * FROM Illness AS i
--JOIN PossibleTreatment AS pt on pt.IllnessCode = i.Code

USE MedicalAppointments SELECT pt.IllnessCode, pt.MedicineCode FROM MedicalAppointments.dbo.Illness AS i WITH (NOLOCK) JOIN PossibleTreatment AS pt on pt.IllnessCode = i.Code 
WHERE pt.IllnessCode = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%ОРВИ%')