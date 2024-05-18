-- Listar todos os pets disponíveis para adoção
CREATE VIEW vw_available_pets AS
SELECT DISTINCT 
    pets.id AS pet_id, 
    pets.public_id AS pet_public_id,
    pets.name AS pet_name, 
    pets.breed AS pet_breed, 
    orgs.name AS organization_name
FROM pets pets
INNER JOIN orgs orgs 
    ON pets.organization_id = orgs.id
WHERE pets.status_id = 1;

-- Listar todos os adotantes e os pets que adotaram
CREATE VIEW vw_adopters_and_pets AS
SELECT DISTINCT 
    adopters.id AS adopter_id, 
    adopters.public_id AS adopter_public_id,
    adopters.name AS adopter_name, 
    pets.name AS pet_name, 
    pets.breed AS pet_breed
FROM adopters adopters
INNER JOIN adoptions adoptions 
    ON adopters.id = adoptions.adopter_id
INNER JOIN pets pets 
    ON adoptions.id = pets.adoption_id;

-- Listar todos os pets e seus doutores atendentes
CREATE VIEW vw_pets_and_doctors AS
SELECT DISTINCT 
    pets.id AS pet_id, 
    pets.public_id AS pet_public_id,
    pets.name AS pet_name, 
    doctors.name AS doctor_name, 
    doctors.specialization
FROM pets pets
INNER JOIN doctor_pet doctor_pet 
    ON pets.id = doctor_pet.pet_id
INNER JOIN doctors doctors 
    ON doctor_pet.doctor_id = doctors.id;

-- Listar todas as adoções ocorridas no último mês
CREATE VIEW vw_adoptions_last_month AS
SELECT DISTINCT 
    adoptions.id AS adoption_id, 
    adopters.name AS adopter_name, 
    pets.name AS pet_name, 
    adoptions.adoption_date
FROM adoptions adoptions
INNER JOIN adopters adopters 
    ON adoptions.adopter_id = adopters.id
INNER JOIN pets pets 
    ON adoptions.id = pets.adoption_id
WHERE adoptions.adoption_date >= DATEADD(MONTH, -1, GETDATE());

-- Listar todas as organizações e o número de pets disponíveis para adoção em cada uma
CREATE VIEW vw_orgs_and_available_pets AS
SELECT DISTINCT 
    orgs.id AS organization_id, 
    orgs.name AS organization_name, 
    COUNT(pets.id) AS available_pets
FROM orgs orgs
INNER JOIN pets pets 
    ON orgs.id = pets.organization_id
WHERE pets.status_id = 1
GROUP BY orgs.id, orgs.name;

-- Listar todos os pets e seus adotantes, incluindo a data de adoção
CREATE VIEW vw_pets_and_adopters AS
SELECT DISTINCT 
    pets.id AS pet_id, 
    pets.public_id AS pet_public_id,
    pets.name AS pet_name, 
    adopters.name AS adopter_name, 
    adoptions.adoption_date
FROM pets pets
INNER JOIN adoptions adoptions 
    ON pets.adoption_id = adoptions.id
INNER JOIN adopters adopters 
    ON adoptions.adopter_id = adopters.id;

-- Listar todos os doutores e o número de pets que atendem
CREATE VIEW vw_doctors_and_pets_count AS
SELECT DISTINCT 
    doctors.id AS doctor_id, 
    doctors.public_id AS doctor_public_id,
    doctors.name AS doctor_name, 
    COUNT(doctor_pet.pet_id) AS pets_attended
FROM doctors doctors
INNER JOIN doctor_pet doctor_pet 
    ON doctors.id = doctor_pet.doctor_id
GROUP BY doctors.id, doctors.name;

-- Listar todos os pets adotados e suas organizações
CREATE VIEW vw_adopted_pets_and_orgs AS
SELECT DISTINCT 
    pets.id AS pet_id, 
    pets.public_id AS pet_public_id,
    pets.name AS pet_name, 
    orgs.name AS organization_name
FROM pets pets
INNER JOIN orgs orgs 
    ON pets.organization_id = orgs.id
WHERE pets.status_id = 2;

-- Listar todos os adotantes que adotaram mais de um pet
CREATE VIEW vw_adopters_with_multiple_pets AS
SELECT DISTINCT 
    adopters.id AS adopter_id, 
    adopters.public_id AS adopter_public_id,
    adopters.name AS adopter_name, 
    COUNT(pets.id) AS pets_adopted
FROM adopters adopters
INNER JOIN adoptions adoptions 
    ON adopters.id = adoptions.adopter_id
INNER JOIN pets pets 
    ON adoptions.id = pets.adoption_id
GROUP BY adopters.id, adopters.name
HAVING COUNT(pets.id) > 1;

-- Listar todos os pets e seus status atuais
CREATE VIEW vw_pets_and_status AS
SELECT DISTINCT 
    pets.id AS pet_id, 
    pets.public_id AS pet_public_id,
    pets.name AS pet_name, 
    pet_status.status AS pet_status
FROM pets pets
INNER JOIN pet_status pet_status 
    ON pets.status_id = pet_status.id;
