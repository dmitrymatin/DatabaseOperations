USE MedicalAppointments
GO
-- MUST BE SUCCESSFUL (patients, doctors)
SELECT * FROM PossibleTreatment
SELECT * FROM PrescriptionTreatment
SELECT * FROM Diagnosis
SELECT * FROM Illness
SELECT * FROM Medicine
SELECT * FROM Appointment
SELECT * FROM Doctor
SELECT * FROM Patient

 -- MUST FAIL (patients), MUST SUCCEED (doctors)
 INSERT INTO PossibleTreatment (IllnessCode, MedicineCode) VALUES (1, 2);
 -- MUST FAIL (patients, doctors)
 INSERT INTO Doctor (FullName, PhoneNumber, Speciality) VALUES (N'Ив Ив Ив', N'123', N'несуществующий');

 -- MUST FAIL (patients), MUST SUCCEED (doctors)
 UPDATE Appointment SET Duration = 20 WHERE Code = 10;
 -- MUST FAIL (patients, doctors)
 UPDATE PossibleTreatment SET IllnessCode = 1 WHERE IllnessCode = 2 AND MedicineCode = 10;

 -- MUST FAIL (patients), MUST SUCCEED (doctors)
 DELETE FROM PrescriptionTreatment WHERE DiagnosisCode = 10 AND MedicineCode = 7;
 -- MUST FAIL (patients, doctors)
 DELETE FROM PossibleTreatment WHERE IllnessCode = 3 AND MedicineCode = 9;