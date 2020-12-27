USE MedicalAppointments
GO

SELECT pt.IllnessCode, pt.MedicineCode FROM Illness AS i
JOIN PossibleTreatment AS pt on pt.IllnessCode = i.Code
WHERE pt.IllnessCode = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%ÎÐÂÈ%');

--SELECT * FROM Illness AS i
--JOIN PossibleTreatment AS pt on pt.IllnessCode = i.Code