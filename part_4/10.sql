USE MedicalAppointments
GO

CREATE ROLE doctors
GO
GO
GRANT INSERT, UPDATE, DELETE ON Patient TO doctors
GO
GRANT INSERT, UPDATE, DELETE ON Appointment TO doctors
GO
GRANT INSERT, UPDATE, DELETE ON Diagnosis TO doctors
GO
GRANT INSERT, UPDATE, DELETE ON PrescriptionTreatment TO doctors
GO
GRANT INSERT ON Medicine TO doctors
GO
GRANT INSERT ON PossibleTreatment TO doctors
GO
	  

CREATE ROLE patients
GO
GRANT SELECT ON PossibleTreatment TO doctors, patients
GRANT SELECT ON PrescriptionTreatment TO doctors, patients
GRANT SELECT ON Diagnosis TO doctors, patients
GRANT SELECT ON Illness TO doctors, patients
GRANT SELECT ON Medicine TO doctors, patients
GRANT SELECT ON Appointment TO doctors, patients
GRANT SELECT ON Doctor TO doctors, patients
GRANT SELECT ON Patient TO doctors, patients