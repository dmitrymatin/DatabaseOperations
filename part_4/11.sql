USE MedicalAppointments
GO

DECLARE people_cursor CURSOR
	FOR 
	SELECT FullName, 1 AS is_patient, 0 AS is_doctor FROM Patient
	UNION
	SELECT FullName, 0 AS is_patient, 1 AS is_doctor FROM Doctor
		
DECLARE @fullName NVARCHAR(max);
DECLARE @patientFlag BIT;
DECLARE @doctorFlag BIT;

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
		
		-- (3) create login
		--DECLARE @sqlCreateLoginQuery NVARCHAR(max) = N'CREATE LOGIN @abbreviation WITH PASSWORD ''pwd123'' + @abbreviation MUST_CHANGE';
		--DECLARE @createLoginParamDef NVARCHAR(max) = N'@abbreviation NVARCHAR(max)';
		--EXECUTE sp_executesql @sqlCreateLoginQuery, @createLoginParamDef, @abbreviation = @abbreviation;

		DECLARE @sqlCreateLoginQuery NVARCHAR(max) = N'CREATE LOGIN ' + @abbreviation + ' WITH PASSWORD=''pwd123'' MUST_CHANGE, CHECK_EXPIRATION=ON, CHECK_POLICY=ON;';
		EXEC (@sqlCreateLoginQuery);


		-- (4) create user
		--DECLARE @sqlCreateUserQuery NVARCHAR(max) = N'CREATE USER @abbreviation FOR LOGIN @abbreviation';
		--DECLARE @createUserParamDef NVARCHAR(max) = N'@abbreviation NVARCHAR(max)';
		--EXECUTE sp_executesql @sqlCreateUserQuery, @createUserParamDef, @abbreviation = @abbreviation;

		DECLARE @sqlCreateUserQuery NVARCHAR(max) = N'CREATE USER ' + @abbreviation + ' FOR LOGIN ' + @abbreviation;
		EXEC (@sqlCreateUserQuery);

		-- (5) add as role member
		IF @patientFlag = 1
		BEGIN
			--DECLARE @sqlAddUserToPatientsRoleQuery NVARCHAR(max) = N'ALTER ROLE patients ADD MEMBER @abbreviation';
			--DECLARE @addUserToPatientsRoleParamDef NVARCHAR(max) = N'@abbreviation NVARCHAR(max)';
			--EXECUTE sp_executesql @sqlAddUserToPatientsRoleQuery, @addUserToPatientsRoleParamDef, @abbreviation = @abbreviation;

			DECLARE  @sqlAddUserToPatientsRoleQuery NVARCHAR(max) = N'ALTER ROLE patients ADD MEMBER ' + @abbreviation;
			EXEC (@sqlAddUserToPatientsRoleQuery);
		END
		ELSE IF @doctorFlag = 1
		BEGIN
			--DECLARE @sqlAddUserToDoctorsRoleQuery NVARCHAR(max) = N'ALTER ROLE doctors ADD MEMBER @abbreviation';
			--DECLARE @addUserToDoctorsRoleParamDef NVARCHAR(max) = N'@abbreviation NVARCHAR(max)';
			--EXECUTE sp_executesql @sqlAddUserToDoctorsRoleQuery, @addUserToDoctorsRoleParamDef, @abbreviation = @abbreviation;

			DECLARE @sqlAddUserToDoctorsRoleQuery NVARCHAR(max) = N'ALTER ROLE doctors ADD MEMBER ' + @abbreviation;
			EXEC (@sqlAddUserToDoctorsRoleQuery);
		END

		FETCH NEXT FROM people_cursor INTO @fullName, @patientFlag, @doctorFlag;
	END;

CLOSE people_cursor;
DEALLOCATE people_cursor;