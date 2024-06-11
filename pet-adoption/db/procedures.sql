-- Procedure para atualizar o status do pet
CREATE OR ALTER PROCEDURE [dbo].[_sp_update_pet_status]
	@pet_id BIGINT,
	@status_id TINYINT
AS
BEGIN
    UPDATE pets
		SET status_id = @status_id
    WHERE id = @pet_id;
END;
GO

-- Procedure para adicionar um novo pet
CREATE OR ALTER PROCEDURE [dbo].[_sp_add_new_pet]
    @name VARCHAR(50),
    @breed VARCHAR(50),
    @status_id TINYINT,
    @organization_id BIGINT
AS
BEGIN
	INSERT INTO pets (
		name, 
		breed, 
		status_id, 
		organization_id
	)

	VALUES (
		@name, 
		@breed, 
		@status_id, 
		@organization_id
	)
END
GO

-- Procedure para registrar uma adoção
CREATE OR ALTER PROCEDURE [dbo].[_sp_register_adoption]
	@pet_id BIGINT,
	@adopter_id BIGINT,
	@adoption_date DATETIME = ''
AS
BEGIN
	IF (@adoption_date = '')
	BEGIN
		SET @adoption_date = GETDATE()
	END

	DECLARE @adoption_id BIGINT
	
	INSERT INTO adoptions (adopter_id, adoption_date)
	VALUES (@adopter_id, @adoption_date)

	SET @adoption_id = SCOPE_IDENTITY()

	UPDATE pets
		SET adoption_id = @adoption_id
	WHERE id = @pet_id
END
GO

-- Procedure para atualizar informações de um pet
CREATE OR ALTER PROCEDURE [dbo].[_sp_update_pet_info]
	@pet_id BIGINT,
    @name VARCHAR(50),
    @breed VARCHAR(50),
    @status_id TINYINT,
    @organization_id BIGINT
AS
BEGIN
	UPDATE pets
		SET name = @name,
			breed = @breed,
			status_id = @status_id,
			organization_id = @organization_id
    WHERE id = @pet_id;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[_sp_create_doctor]
	@doctor_public_id UNIQUEIDENTIFIER,
    @doctor_name VARCHAR(50),
    @specialization VARCHAR(50),
    @contact_info VARCHAR(50)
AS
BEGIN
	INSERT INTO doctors (
		public_id, 
		name, 
		specialization, 
		contact_info
	)
    
	VALUES (
		@doctor_public_id, 
		@doctor_name, 
		@specialization, 
		@contact_info
	);
END
GO

-- Procedure para adicionar um novo doutor e relacioná-lo a um pet
CREATE OR ALTER PROCEDURE [dbo].[_sp_book_appointment_pet]
    @doctor_id BIGINT,
	@pet_id BIGINT
AS
BEGIN
    INSERT INTO doctor_pet (doctor_id, pet_id)
    VALUES (@doctor_id, @pet_id);
END
GO

--  Procedure para listar pets e seus adotantes
CREATE OR ALTER PROCEDURE [dbo].[_sp_get_pets_adopters]
	@datetime DATETIME = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql NVARCHAR(MAX);

	SET @sql = '
		SELECT
			pets.id as pet_id,
			pets.name as pet_name,
			pets.breed as pet_breed,

			adopters.name as adopter_name,
			adopters.address as adopter_address,
			adopters.contact_info as adopter_contact_info,
		
			adoptions.adoption_date

		FROM pets pets
	
		INNER JOIN adoptions adoptions
			ON pets.adoption_id = adoptions.id

		INNER JOIN adopters adopters
			ON adoptions.adopter_id = adopters.id

		WHERE pets.status_id = 1' +
			CASE 
				WHEN @datetime IS NOT NULL THEN 'AND adoptions.adoption_date BETWEEN @datetime AND GETDATE()'
				ELSE ''
			END
		+ 'GROUP BY
			pets.id,
			pets.name,
			pets.breed,

			adopters.name,
			adopters.address,
			adopters.contact_info,
		
			adoptions.adoption_date
	'

	EXEC sp_executesql @sql, N'@datetime DATETIME', @datetime
END
GO

-- Criar a procedure para fazer o BULK INSERT dos dados de pets a partir de um arquivo .txt
CREATE OR ALTER PROCEDURE [dbo].[_sp_bulk_insert_pets]
    @filePath NVARCHAR(4000)
AS
BEGIN
	CREATE TABLE #_pets (
		name VARCHAR(200),
		breed VARCHAR(200),
		status_id TINYINT,
		organization_id INT
	)

    BEGIN TRY
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'BULK INSERT #_pets
                    FROM ''' + 'D:/w3sLeY/www/bin/fepi/pet-adoption/pets_data.txt' + '''
                    WITH (
                        FIELDTERMINATOR = '','', 
						ROWTERMINATOR = ''0x0a'', 
						CODEPAGE = ''ACP'',
                        FIRSTROW = 2
                    );';

        EXEC sp_executesql @sql;

		INSERT INTO pets (
			name, 
			breed, 
			status_id, 
			organization_id
		)

		SELECT 
			name, 
			breed, 
			status_id, 
			organization_id 
		
		FROM #_pets

		DROP TABLE #_pets

        PRINT 'Bulk insert realizado com sucesso.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

EXEC [dbo].[_sp_bulk_insert_pets] @filePath = 'D:/w3sLeY/www/bin/fepi/pet-adoption/pets_data.txt';