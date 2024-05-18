DROP DATABASE IF EXISTS db_find_a_friend;

CREATE DATABASE db_find_a_friend

CREATE TABLE orgs (
	id BIGINT PRIMARY KEY IDENTITY,
	public_id UNIQUEIDENTIFIER UNIQUE DEFAULT NEWID(),
	name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	address VARCHAR(100) NOT NULL,
	cep VARCHAR(15) NOT NULL,
	whatsapp VARCHAR(20),
	password VARCHAR(50),
	created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE pets (
	id BIGINT PRIMARY KEY IDENTITY,
	public_id UNIQUEIDENTIFIER UNIQUE DEFAULT NEWID(),
	name VARCHAR(50) NOT NULL,
	breed VARCHAR(50) NOT NULL,
	status_id TINYINT,
	adoption_id BIGINT,
	organization_id BIGINT
)

CREATE TABLE pet_status (
	id TINYINT PRIMARY KEY IDENTITY,
	status VARCHAR(25) NOT NULL
)

CREATE TABLE adopters (
	id BIGINT PRIMARY KEY IDENTITY,
	public_id UNIQUEIDENTIFIER UNIQUE DEFAULT NEWID(),
	name VARCHAR(50) NOT NULL,
	address VARCHAR(100),
	contact_info VARCHAR(50)
)

CREATE TABLE adoptions (
	id BIGINT PRIMARY KEY IDENTITY,
	adopter_id BIGINT,
	adoption_date DATETIME
)

CREATE TABLE doctors (
	id BIGINT PRIMARY KEY,
	public_id UNIQUEIDENTIFIER UNIQUE DEFAULT NEWID(),
	name VARCHAR(50) NOT NULL,
	specialization VARCHAR(50) NOT NULL,
	contact_info VARCHAR(50) NOT NULL,
	created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE doctor_pet (
	id BIGINT PRIMARY KEY IDENTITY,
	doctor_id BIGINT,
	pet_id BIGINT
)

ALTER TABLE pets ADD CONSTRAINT fk_status_id FOREIGN KEY (status_id) REFERENCES pet_status (id)

ALTER TABLE pets ADD CONSTRAINT fk_orgs_id FOREIGN KEY (organization_id) REFERENCES orgs (id)

ALTER TABLE pets ADD CONSTRAINT fk_adoption_id FOREIGN KEY (adoption_id) REFERENCES adoptions (id)

ALTER TABLE adoptions ADD CONSTRAINT fk_adopter_id FOREIGN KEY (adopter_id) REFERENCES adopters (id)

ALTER TABLE doctor_pet ADD CONSTRAINT fk_doctor_id FOREIGN KEY (doctor_id) REFERENCES doctors (id)

ALTER TABLE doctor_pet ADD CONSTRAINT fk_pet_id FOREIGN KEY (pet_id) REFERENCES pets (id)