@ECHO OFF
chcp 65001

ECHO FIRST LOGIN:
sqlcmd -U ВВИ2 -d MedicalAppointments -Q "select CAST(GETDATE() AS time(0)) AS 'time'"

ECHO MUST SUCCEED:
sqlcmd -W -U ВВИ2 -d MedicalAppointments -Q "select * from PossibleTreatment; select * from PrescriptionTreatment; select * from Diagnosis; select * from Illness; select * from Medicine; select * from Appointment; select * from Doctor; select * from Patient; INSERT INTO PossibleTreatment (IllnessCode, MedicineCode) VALUES (1, 2); UPDATE Appointment SET Duration = 20 WHERE Code = 10; DELETE FROM PrescriptionTreatment WHERE DiagnosisCode = 10 AND MedicineCode = 7;"

ECHO MUST FAIL:
sqlcmd -W -U ВВИ2 -d MedicalAppointments -Q "INSERT INTO Doctor (FullName, PhoneNumber, Speciality) VALUES (N'Ив Ив Ив', N'123', N'несуществующий'); UPDATE PossibleTreatment SET IllnessCode = 1 WHERE IllnessCode = 2 AND MedicineCode = 10; DELETE FROM PossibleTreatment WHERE IllnessCode = 3 AND MedicineCode = 9;"