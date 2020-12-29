-- Общий запрос (common query)
USE MedicalAppointments 
SELECT * FROM MedicalAppointments.dbo.Illness AS i 
WITH (NOLOCK) 
JOIN PossibleTreatment AS pt ON pt.IllnessCode = i.Code
JOIN Medicine AS m ON pt.MedicineCode = m.Code
WHERE pt.IllnessCode = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%ОРВИ%')


 -- Лекарство (medicine)
USE MedicalAppointments 
SELECT m.Code, m.[Name], m.[Action], m.Indications, m.Contraindications, m.SideEffects, m.Directions FROM MedicalAppointments.dbo.Illness AS i 
WITH (NOLOCK) 
JOIN PossibleTreatment AS pt ON pt.IllnessCode = i.Code
JOIN Medicine AS m ON pt.MedicineCode = m.Code
WHERE pt.IllnessCode = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%ОРВИ%')

 -- Заболевание (illness)
 USE MedicalAppointments 
SELECT i.Code, i.[Name], i.Symptoms FROM MedicalAppointments.dbo.Illness AS i 
WITH (NOLOCK) 
JOIN PossibleTreatment AS pt ON pt.IllnessCode = i.Code
JOIN Medicine AS m ON pt.MedicineCode = m.Code
WHERE i.Code = (SELECT TOP(1) i.Code FROM Illness WHERE i.[Name] LIKE '%ОРВИ%')