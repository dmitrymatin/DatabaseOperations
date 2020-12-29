--SELECT * FROM Patient
--SELECT * FROM Doctor

--SELECT FullName, 1 AS is_patient, 0 AS is_doctor FROM Patient
--UNION 
--SELECT FullName, 0 AS is_patient, 1 AS is_doctor FROM Doctor


DECLARE people_cursor CURSOR
	FOR 
	SELECT FullName, 1 AS is_patient, 0 AS is_doctor FROM Patient
	UNION
	SELECT FullName, 0 AS is_patient, 1 AS is_doctor FROM Doctor
		
DECLARE @fullName NVARCHAR(max);
DECLARE @patientFlag INT;
DECLARE @doctorFlag INT;

OPEN people_cursor
FETCH NEXT FROM people_cursor INTO @fullName, @patientFlag, @doctorFlag;

WHILE @@FETCH_STATUS = 0
	BEGIN
		-- (1) получаем аббревиатуру ФИО [STRING_SPLIT() как альтернатива]
		DECLARE @abbreviation NVARCHAR(max);

		SET @fullName = RTRIM(LTRIM(@fullName));
		SET @abbreviation = LEFT(@fullName, 1);

		WHILE CHARINDEX(' ', @fullName, 1) > 0 
		BEGIN
			SET @fullName = LTRIM(RIGHT(@fullName, LEN(@fullName) - CHARINDEX(' ', @fullName, 1)));
			SET @abbreviation += LEFT(@fullName, 1);
		END

		-- (2) 
		--select * from sys.sql_logins -- [или select * from sys.server_principals] [syslogins - old]

		IF EXISTS (SELECT 1 FROM sys.sql_logins WHERE [name] = @abbreviation)
		BEGIN
			DECLARE @index INT = 1
			WHILE EXISTS (SELECT 1 FROM sys.sql_logins WHERE [name] = @abbreviation + CAST(@index AS nvarchar(max)))
			BEGIN
				SET @index += 1;
			END
			SET @abbreviation = @abbreviation + CAST(@index AS nvarchar(max))
		END
		ELSE
		
		-- (3) create login
		DECLARE @sqlCreateLoginQuery NVARCHAR(max) = N'CREATE LOGIN @abbreviation WITH PASSWORD ''pwd123'' + @abbreviation MUST_CHANGE';
		EXECUTE sp_executesql @sqlCreateLoginQuery, @abbreviation;

		-- (4) create user
		DECLARE @sqlCreateUserQuery NVARCHAR(max) = N'CREATE USER @abbreviation FOR LOGIN @abbreviation';
		EXECUTE sp_executesql @sqlCreateUserQuery, @abbreviation;

		-- (5) add as role member
		IF @patientFlag = 1
		BEGIN
			DECLARE @sqlAddUserToPatientsRoleQuery NVARCHAR(max) = N'ALTER ROLE patients ADD MEMBER @abbreviation';
			EXECUTE sp_executesql @sqlAddUserToPatientsRoleQuery, @abbreviation;
		END
		ELSE IF @doctorFlag = 1
		BEGIN
			DECLARE @sqlAddUserToDoctorsRoleQuery NVARCHAR(max) = N'ALTER ROLE patients ADD MEMBER @abbreviation';
			EXECUTE sp_executesql @sqlAddUserToDoctorsRoleQuery, @abbreviation;
		END

		FETCH NEXT FROM people_cursor INTO @fullName;
	END;

CLOSE people_cursor;
DEALLOCATE people_cursor;


