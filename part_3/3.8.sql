USE MedicalAppointments
GO

BULK INSERT Medicine FROM 'C:\Users\dmitr\source\repos\DatabaseOps\part_3\import_data_for_bulk_insert.csv'
WITH (
	  CODEPAGE = '65001'
	, FORMAT = 'CSV'
	, FIELDQUOTE = '"'
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '\n'
);