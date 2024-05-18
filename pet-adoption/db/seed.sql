INSERT INTO orgs (public_id, name, email, address, cep, whatsapp, password)
VALUES 
(NEWID(), 'Org Lívia', 'contact@orgone.com', '123 Street A', '12345-678', '555-1234', 'password123'),
(NEWID(), 'Org Lucas', 'contact@orgtwo.com', '456 Street B', '87654-321', '555-5678', 'password456');

INSERT INTO pet_status (status)
VALUES ('Available'), ('Adopted');

INSERT INTO doctors (public_id, name, specialization, contact_info)
VALUES 
(NEWID(), 'Dr. Smith', 'Veterinary', '555-1111'),
(NEWID(), 'Dr. Jones', 'Veterinary', '555-2222'),
(NEWID(), 'Dr. Brown', 'Veterinary', '555-3333'),
(NEWID(), 'Dr. White', 'Veterinary', '555-4444'),
(NEWID(), 'Dr. Green', 'Veterinary', '555-5555'),
(NEWID(), 'Dr. Black', 'Veterinary', '555-6666');

INSERT INTO adopters (public_id, name, address, contact_info)
VALUES 
(NEWID(), 'John Doe', '789 Street C', '555-7777'),
(NEWID(), 'Jane Doe', '101 Street D', '555-8888'),
(NEWID(), 'Jim Beam', '102 Street E', '555-9999'),
(NEWID(), 'Jack Daniels', '103 Street F', '555-0000'),
(NEWID(), 'Josie Wells', '104 Street G', '555-1112'),
(NEWID(), 'Jake Blues', '105 Street H', '555-1313'),
(NEWID(), 'Elwood Blues', '106 Street I', '555-1414'),
(NEWID(), 'Ray Charles', '107 Street J', '555-1515'),
(NEWID(), 'Aretha Franklin', '108 Street K', '555-1616'),
(NEWID(), 'Otis Redding', '109 Street L', '555-1717');

INSERT INTO pets (public_id, name, breed, status_id, organization_id)
VALUES 
-- Org One Pets
(NEWID(), 'Buddy', 'Golden Retriever', 1, 1),
(NEWID(), 'Max', 'Bulldog', 1, 1),
(NEWID(), 'Bella', 'Poodle', 1, 1),
(NEWID(), 'Charlie', 'Beagle', 1, 1),
(NEWID(), 'Lucy', 'Shih Tzu', 1, 1),
(NEWID(), 'Daisy', 'Labrador', 1, 1),
(NEWID(), 'Bailey', 'Boxer', 1, 1),
(NEWID(), 'Lola', 'Dachshund', 1, 1),
(NEWID(), 'Sadie', 'Pug', 1, 1),
(NEWID(), 'Molly', 'Chihuahua', 1, 1),
(NEWID(), 'Sophie', 'Rottweiler', 1, 1),
(NEWID(), 'Duke', 'Cocker Spaniel', 1, 1),
(NEWID(), 'Rocky', 'Pitbull', 1, 1),
(NEWID(), 'Harley', 'Husky', 1, 1),
(NEWID(), 'Zoe', 'Corgi', 1, 1),
(NEWID(), 'Luna', 'Great Dane', 1, 1),
(NEWID(), 'Ruby', 'Doberman', 1, 1),
(NEWID(), 'Maggie', 'Basset Hound', 1, 1),
(NEWID(), 'Oscar', 'Akita', 1, 1),
(NEWID(), 'Toby', 'Maltese', 1, 1),
-- Org Two Pets
(NEWID(), 'Rex', 'German Shepherd', 1, 2),
(NEWID(), 'Bear', 'Saint Bernard', 1, 2),
(NEWID(), 'Sasha', 'Border Collie', 1, 2),
(NEWID(), 'Tucker', 'Brittany Spaniel', 1, 2),
(NEWID(), 'Jake', 'Jack Russell Terrier', 1, 2),
(NEWID(), 'Chloe', 'Shiba Inu', 1, 2),
(NEWID(), 'Buster', 'Cavalier King Charles Spaniel', 1, 2),
(NEWID(), 'Milo', 'Dalmatian', 1, 2),
(NEWID(), 'Penny', 'West Highland White Terrier', 1, 2),
(NEWID(), 'Ginger', 'Australian Shepherd', 1, 2),
(NEWID(), 'Ruby', 'Weimaraner', 1, 2),
(NEWID(), 'Hazel', 'Scottish Terrier', 1, 2),
(NEWID(), 'Finn', 'Whippet', 1, 2),
(NEWID(), 'Scout', 'Vizsla', 1, 2),
(NEWID(), 'Ziggy', 'Staffordshire Bull Terrier', 1, 2),
(NEWID(), 'Bruno', 'Schnauzer', 1, 2),
(NEWID(), 'Tank', 'Samoyed', 1, 2),
(NEWID(), 'Roxy', 'Saluki', 1, 2),
(NEWID(), 'Holly', 'Pomeranian', 1, 2),
(NEWID(), 'Hunter', 'Papillon', 1, 2),
(NEWID(), 'Emma', 'Newfoundland', 1, 2),
(NEWID(), 'Diesel', 'Mastiff', 1, 2),
(NEWID(), 'Ace', 'Lhasa Apso', 1, 2),
(NEWID(), 'Ranger', 'Italian Greyhound', 1, 2),
(NEWID(), 'Chief', 'Irish Setter', 1, 2),
(NEWID(), 'Winston', 'Fox Terrier', 1, 2),
(NEWID(), 'Stella', 'Finnish Spitz', 1, 2),
(NEWID(), 'Cooper', 'English Setter', 1, 2),
(NEWID(), 'Zeus', 'Doberman Pinscher', 1, 2);

DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN
    DECLARE @adoption_id BIGINT;
    DECLARE @adopter_id BIGINT = (SELECT TOP 1 id FROM adopters ORDER BY NEWID());
    DECLARE @pet_id BIGINT = (SELECT TOP 1 id FROM pets WHERE adoption_id IS NULL ORDER BY NEWID());

    INSERT INTO adoptions (adopter_id, adoption_date)
    VALUES (@adopter_id, DATEADD(DAY, -(@i * 10), GETDATE()));

    SET @adoption_id = SCOPE_IDENTITY();

    UPDATE pets
    SET adoption_id = @adoption_id, status_id = 2
    WHERE id = @pet_id;

    SET @i = @i + 1;
END;

DECLARE @doctor_id BIGINT;
DECLARE @_pet_id BIGINT;
SET @i = 1;
WHILE @i <= 50
BEGIN
    SET @doctor_id = (SELECT TOP 1 id FROM doctors ORDER BY NEWID());
    SET @_pet_id = (SELECT TOP 1 id FROM pets ORDER BY NEWID());

    INSERT INTO doctor_pet (doctor_id, pet_id)
    VALUES (@doctor_id, @_pet_id);

    SET @i = @i + 1;
END;