-- CHECK IF DB DOES NOT EXIST
IF DB_ID('MedicalAppointments') IS NULL
BEGIN
	USE master
	CREATE DATABASE MedicalAppointments
	PRINT('CREATING DB...');
END
GO

-- SWITCH TO DATABASE CONTEXT
USE MedicalAppointments

------------------------------------------------------- CREATING TABLES (1)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'PossibleTreatment')
BEGIN
	DROP TABLE PossibleTreatment
END
CREATE TABLE
	MedicalAppointments.dbo.PossibleTreatment(
		IllnessCode INT NOT NULL,
		MedicineCode INT NOT NULL

		CONSTRAINT PK_PossibleTreatment PRIMARY KEY (IllnessCode ASC, MedicineCode ASC)
	);
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'PrescriptionTreatment')
BEGIN
	DROP TABLE PrescriptionTreatment
END
CREATE TABLE
	MedicalAppointments.dbo.PrescriptionTreatment(
		DiagnosisCode INT NOT NULL,
		MedicineCode INT NOT NULL

		CONSTRAINT PK_PrescriptionTreatment PRIMARY KEY (DiagnosisCode ASC, MedicineCode ASC)
	);
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Diagnosis')
BEGIN
	DROP TABLE Diagnosis
END
CREATE TABLE
	MedicalAppointments.dbo.Diagnosis(
		Code INT PRIMARY KEY NOT NULL IDENTITY,
		AppointmentCode INT NOT NULL,
		IllnessCode INT NOT NULL,
		Remarks NVARCHAR(255) NULL
	);
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Illness')
BEGIN
	DROP TABLE Illness
END
CREATE TABLE
	MedicalAppointments.dbo.Illness(
		Code INT PRIMARY KEY NOT NULL IDENTITY,
		[Name] NVARCHAR(255) NOT NULL,
		Symptoms NVARCHAR(2048) NOT NULL,
	);
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Medicine')
BEGIN
	DROP TABLE Medicine
END
CREATE TABLE
	MedicalAppointments.dbo.Medicine(
		Code INT PRIMARY KEY NOT NULL IDENTITY,
		[Name] NVARCHAR(255) NOT NULL,
		[Action] NVARCHAR(2048) NOT NULL,
		Indications NVARCHAR(2048) NOT NULL,
		Contraindications NVARCHAR(2048) NOT NULL,
		SideEffects NVARCHAR(2048) NOT NULL,
		Directions NVARCHAR(2048) NOT NULL
	);
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Appointment')
BEGIN
	DROP TABLE Appointment
END
CREATE TABLE
	MedicalAppointments.dbo.Appointment(
		Code INT PRIMARY KEY NOT NULL IDENTITY,
		DoctorCode INT NOT NULL,
		PatientCode INT NOT NULL,
		[Date] DATETIME2(7) NOT NULL,
		Duration INT NOT NULL,		--in minutes
	);
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Doctor')
BEGIN
	DROP TABLE Doctor
END
CREATE TABLE MedicalAppointments.dbo.Doctor(
		Code INT PRIMARY KEY NOT NULL IDENTITY,
		FullName NVARCHAR(255) NOT NULL,
		Speciality NVARCHAR(255) NOT NULL,
		PhoneNumber NVARCHAR(255) NULL
	);
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Patient')
BEGIN
	DROP TABLE Patient
END
CREATE TABLE
	MedicalAppointments.dbo.Patient(
		Code INT PRIMARY KEY NOT NULL IDENTITY,
		FullName NVARCHAR(255) NOT NULL,
		BirthDate DATE NOT NULL,
		[Address] NVARCHAR(2048) NOT NULL,
		PhoneNumber NVARCHAR(255) NULL
	);
GO

------------------------------------------------------- ADDING FOREIGN KEYS (2)
ALTER TABLE MedicalAppointments.dbo.Appointment
	ADD CONSTRAINT FK_Appointment_Doctor FOREIGN KEY (DoctorCode)
			REFERENCES Doctor (Code) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT FK_Appointment_Patient FOREIGN KEY (PatientCode)
			REFERENCES Patient (Code) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE MedicalAppointments.dbo.Diagnosis
	ADD	CONSTRAINT FK_Diagnosis_Appointment FOREIGN KEY (AppointmentCode)
			REFERENCES Appointment (Code) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT FK_Diagnosis_Illness FOREIGN KEY (IllnessCode)
			REFERENCES Illness (Code) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE MedicalAppointments.dbo.PossibleTreatment
	ADD	CONSTRAINT FK_PossibleTreatment_Illness FOREIGN KEY (IllnessCode)
			REFERENCES Illness (Code) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT FK_PossibleTreatment_Medicine FOREIGN KEY (MedicineCode)
			REFERENCES Medicine (Code) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE MedicalAppointments.dbo.PrescriptionTreatment
	ADD	CONSTRAINT FK_PrescriptionTreatment_Diagnosis FOREIGN KEY (DiagnosisCode)
			REFERENCES Diagnosis (Code) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT FK_PrescriptionTreatment_Medicine FOREIGN KEY (MedicineCode)
			REFERENCES Medicine (Code) ON DELETE CASCADE ON UPDATE CASCADE
GO