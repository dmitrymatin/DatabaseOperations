		declare @abbreviation nvarchar(max) = 'abcd';
		DECLARE @sqlCreateLoginQuery NVARCHAR(max) = N'CREATE LOGIN ' + @abbreviation + ' WITH PASSWORD=''pwd123'' MUST_CHANGE, CHECK_EXPIRATION=ON, CHECK_POLICY=ON;';
		EXEC (@sqlCreateLoginQuery)