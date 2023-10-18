DROP TABLE IF EXISTS operational_domain
DROP TABLE IF EXISTS drone_domain
DROP TABLE IF EXISTS drone_model
DROP TABLE IF EXISTS drone

CREATE TABLE drone (

	model					INTEGER 				NOT NULL,
	id						SERIAL,
	serial_number			VARCHAR(64)				NOT NULL,
	drone_tag				CHAR(20)				NOT NULL,
	acquisition_date		DATE					NOT NULL,
	
	CONSTRAINT pk_drone	PRIMARY KEY (id),

);

CREATE TABLE drone_model(

	id 						SERIAL,
	manufacturer 			INTEGER 				NOT NULL,
	name 					VARCHAR(64) 			NOT NULL, 
	description 			VARCHAR(2048) 			NOT NULL,
	web_site 				VARCHAR(256),
	
	CONSTRAINT pk_drone_model PRIMARY KEY (id),

);

CREATE TABLE drone_domain(
	
	model 					INTEGER,
	domain					INTEGER,
	
	CONSTRAINT pk_drone_domain PRIMARY KEY (model, domain),

);

CREATE TABLE operational_domain(

	id						SERIAL,
	name					VARCHAR(32)				NOT NULL,
	description				VARCHAR(256),
	depend					INTEGER,
	
	CONSTRAINT pk_operational_domain PRIMARY KEY (id),

);

ALTER TABLE drone
	ADD CONSTRAINT fk_drone_model
		FOREIGN KEY (model) REFERENCES drone_model(id);

ALTER TABLE drone_model
	ADD CONSTRAINT fk_drone_model_manufacturer
		FOREIGN KEY (manufacturer) REFERENCES manufacturing_company(id);
		
ALTER TABLE drone_domain
	ADD CONSTRAINT fk_dm_model
		FOREIGN KEY (model) REFERENCES drone_model(id)
	ADD CONSTRAINT fk_dm_domain
		FOREIGN KEY (domain) REFERENCES operational_domain(id);
		
ALTER TABLE operational_domain
	ADD CONSTRAINT fk_od_depend
		FOREIGN KEY (depend) REFERENCES operational_domain(id);

