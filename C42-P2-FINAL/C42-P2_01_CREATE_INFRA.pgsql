/*

C42-P2_01_CREATE_INFRA.pgsql
420-C42-IN Langages d'exploitation des bases de données
Auteurs : Julien Coulombe-Morency, Benjamin Joinvil, Édouard Blain-Noël, François Maltais, Catherine Lavoie, Remi Chuet
Date de création : 2023-10-18 
Dernière modification : 2023-10-30

*/
DROP VIEW IF EXISTS vue_drone_state_drone; 
DROP VIEW IF EXISTS vue_drone_state_state_note; 
DROP VIEW IF EXISTS vue_drone_disponible;

DROP INDEX IF EXISTS idx_employee_name; 
DROP INDEX IF EXISTS idx_state_next; 
DROP INDEX IF EXISTS idx_drone_acquisition;
DROP INDEX IF EXISTS idx_drone_state_date;

ALTER TABLE IF EXISTS state DROP CONSTRAINT IF EXISTS fk_state_rejected;
ALTER TABLE IF EXISTS state DROP CONSTRAINT IF EXISTS fk_state_accepted;
ALTER TABLE IF EXISTS technical_specification DROP CONSTRAINT IF EXISTS fk_ts_unit;
ALTER TABLE IF EXISTS drone_specification DROP CONSTRAINT IF EXISTS fk_ds_specification;
ALTER TABLE IF EXISTS drone_specification DROP CONSTRAINT IF EXISTS fk_ds_drone_model;
ALTER TABLE IF EXISTS drone_state DROP CONSTRAINT IF EXISTS fk_ds_employee;
ALTER TABLE IF EXISTS drone_state DROP CONSTRAINT IF EXISTS fk_ds_state;
ALTER TABLE IF EXISTS drone_state DROP CONSTRAINT IF EXISTS fk_ds_drone;
ALTER TABLE IF EXISTS state_note DROP CONSTRAINT IF EXISTS fk_sn_employee;
ALTER TABLE IF EXISTS state_note DROP CONSTRAINT IF EXISTS fk_sn_drone_state;
ALTER TABLE IF EXISTS operational_domain DROP CONSTRAINT IF EXISTS fk_od_depend;
ALTER TABLE IF EXISTS drone_domain DROP CONSTRAINT IF EXISTS fk_dm_domain;
ALTER TABLE IF EXISTS drone_domain DROP CONSTRAINT IF EXISTS fk_dm_model;
ALTER TABLE IF EXISTS drone_model DROP CONSTRAINT IF EXISTS fk_drone_model_manufacturer;
ALTER TABLE IF EXISTS drone DROP CONSTRAINT IF EXISTS fk_drone_model;

DROP TABLE IF EXISTS state ;
DROP TABLE IF EXISTS unit ;
DROP TABLE IF EXISTS technical_specification;
DROP TABLE IF EXISTS drone_specification;
DROP TABLE IF EXISTS manufacturing_company;
DROP TABLE IF EXISTS drone_state;
DROP TABLE IF EXISTS state_note;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS operational_domain;
DROP TABLE IF EXISTS drone_domain;
DROP TABLE IF EXISTS drone_model;
DROP TABLE IF EXISTS drone;

DROP TYPE IF EXISTS employee_status;
DROP TYPE IF EXISTS note_type;




CREATE TYPE note_type AS ENUM (
	'general_observation', 
	'problematic_observation', 
	'maintenance_performed', 
	'repair_completed', 
	'equipment_replaced'
);

CREATE TYPE employee_status AS ENUM ( 
    'probation',
    'regular',
    'retired',
    'deceased',
    'resigned',
    'on_leave',
    'fired',
    'laid_off',
    'suspended'
);

CREATE TABLE drone (
	model					INTEGER 				NOT NULL,
	id						SERIAL,
	serial_number			VARCHAR(64)				NOT NULL,
	drone_tag				CHAR(20)				NOT NULL,
	acquisition_date		DATE					NOT NULL DEFAULT(current_date),
	
	CONSTRAINT pk_drone	PRIMARY KEY (id),
	CONSTRAINT uc_drone_serial_number UNIQUE (serial_number),
	CONSTRAINT uc_drone_tag UNIQUE (drone_tag),
	CONSTRAINT cc_drone_serial_number CHECK (LENGTH(serial_number) >= 1)

);

CREATE TABLE drone_model(
	id 						SERIAL,
	manufacturer 			INTEGER 				NOT NULL,
	name 					VARCHAR(64) 			NOT NULL, 
	description 			VARCHAR(2048) 			NOT NULL,
	web_site 				VARCHAR(256),
	
	CONSTRAINT pk_drone_model PRIMARY KEY (id),
	CONSTRAINT uc_drone_model_name UNIQUE (name),
	CONSTRAINT uc_drone_model_web_site UNIQUE (web_site),
	CONSTRAINT cc_drone_model_name CHECK (LENGTH(name) > 0),
	CONSTRAINT cc_drone_model_description CHECK (LENGTH(description) >= 12)
	
);

CREATE TABLE drone_domain(
	model 					INTEGER,
	domain					INTEGER,
	
	CONSTRAINT pk_drone_domain PRIMARY KEY (model, domain)
);

CREATE TABLE operational_domain(
	id						SERIAL,
	name					VARCHAR(32)				NOT NULL,
	description				VARCHAR(256),
	depend					INTEGER,
	
	CONSTRAINT pk_operational_domain PRIMARY KEY (id),
	CONSTRAINT uc_od_name UNIQUE (name),
	CONSTRAINT cc_od_name CHECK (LENGTH(name) > 3)
	
);

CREATE TABLE employee (
	id 						SERIAL,
	ssn 					VARCHAR(32) 			NOT NULL,
	first_name 				VARCHAR(64) 			NOT NULL,
	last_name 				VARCHAR(64) 			NOT NULL,
	status					employee_status 		NOT NULL	DEFAULT 'probation'::employee_status,
	office_room 			CHAR(18)				NOT NULL	DEFAULT 'GZ 000.WHI-100.A10',

	CONSTRAINT pk_employee PRIMARY KEY (id),
	CONSTRAINT uc_employee_ssn UNIQUE (ssn),
	CONSTRAINT cc_employee_ssn CHECK (LENGTH(ssn) >= 6)
);

CREATE TABLE state_note (
	id						SERIAL,
	drone_state				INTEGER 				NOT NULL,
	note    				note_type				NOT NULL,
	date_time				TIMESTAMP				NOT NULL,
	employee				INTEGER					NOT NULL,
	details					VARCHAR(2048)			NOT NULL,
	
	CONSTRAINT pk_state_note PRIMARY KEY (id),
	CONSTRAINT cc_sn_details CHECK (LENGTH(details)>=15)
);

CREATE TABLE drone_state ( 
	id    					SERIAL, 
	drone 					INTEGER   				NOT NULL, 
	state 					CHAR(1)   				NOT NULL,
	employee 				INTEGER 				NOT NULL,
	start_date_time 		TIMESTAMP 				NOT NULL,
	location 				CHAR(20) 				DEFAULT 'XB 000.MAG-600.^IZ00',

	CONSTRAINT pk_drone_state PRIMARY KEY (id),
	CONSTRAINT uc_sta_dro_dro_start_date UNIQUE(drone, start_date_time)
);

CREATE TABLE manufacturing_company (
	id 						SERIAL, 
	name  					VARCHAR(64)				NOT NULL, 
	web_site 				VARCHAR(256) 			NOT NULL, 

	CONSTRAINT pk_manufacturing_company PRIMARY KEY(id),
	CONSTRAINT uc_mc_name UNIQUE (name),
	CONSTRAINT uc_mc_web_site UNIQUE (web_site)
	
);

CREATE TABLE drone_specification(
	id 						SERIAL,
	drone_model				INTEGER        			NOT NULL,
	specification   		INTEGER        			NOT NULL,
	value 					VARCHAR(256)   			NOT NULL,  
	comments        		VARCHAR(1024), 
	
	
	CONSTRAINT pk_ds PRIMARY KEY(id),
	CONSTRAINT cc_ds_value CHECK (LENGTH(value) > 0)
);

CREATE TABLE technical_specification (
	id 						SERIAL,
	name 					VARCHAR(64)    			NOT NULL,
	description 			VARCHAR(512)   			NOT NULL,
	unit 					INTEGER,
	
	CONSTRAINT pk_ts PRIMARY KEY(id),
	CONSTRAINT uc_ts_name UNIQUE (name),
	CONSTRAINT cc_ts_name CHECK (LENGTH(name) > 2),
	CONSTRAINT cc_ts_description CHECK (LENGTH(description) > 10)
);

CREATE TABLE unit(
	id 						SERIAL,
	symbol 					VARCHAR(16) 			NOT NULL,
	name 					VARCHAR(64) 			NOT NULL,
	description 			VARCHAR(1024),
	
	CONSTRAINT pk_unit PRIMARY KEY(id),
	CONSTRAINT uc_unit_name UNIQUE (name),
	CONSTRAINT uc_unit_symbol UNIQUE (symbol),
	CONSTRAINT cc_unit_name  CHECK (LENGTH(name) > 0),
	CONSTRAINT cc_unit_symbol CHECK (LENGTH(symbol) > 0),
	CONSTRAINT cc_unit_description CHECK (LENGTH(description) >= 10 OR description = NULL)
);

CREATE TABLE state(
	symbol 					CHAR(1),
	name					VARCHAR(32) 			NOT NULL,
	description 			VARCHAR(2048) 			NOT NULL,
	next_accepted_state 	CHAR(1) 				DEFAULT NULL,
	next_rejected_state 	CHAR(1) 				DEFAULT NULL,
	
	
	CONSTRAINT pk_state PRIMARY KEY(symbol),
	CONSTRAINT uc_state_name UNIQUE (name),
	CONSTRAINT uc_state_description UNIQUE (description)
	
	--trigger	
);

ALTER TABLE drone
	ADD CONSTRAINT fk_drone_model
		FOREIGN KEY (model) REFERENCES drone_model(id);

ALTER TABLE drone_model
	ADD CONSTRAINT fk_drone_model_manufacturer
		FOREIGN KEY (manufacturer) REFERENCES manufacturing_company(id);
		
ALTER TABLE drone_domain
	ADD CONSTRAINT fk_dm_model
		FOREIGN KEY (model) REFERENCES drone_model(id),
	ADD CONSTRAINT fk_dm_domain
		FOREIGN KEY (domain) REFERENCES operational_domain(id);
		
ALTER TABLE operational_domain
	ADD CONSTRAINT fk_od_depend
		FOREIGN KEY (depend) REFERENCES operational_domain(id);

ALTER TABLE state_note
	ADD CONSTRAINT fk_sn_employee 
		FOREIGN KEY (employee) REFERENCES employee(id),
	ADD CONSTRAINT fk_sn_drone_state 
		FOREIGN KEY (drone_state) REFERENCES drone_state(id);
		
ALTER TABLE drone_state
	ADD CONSTRAINT fk_ds_drone
		FOREIGN KEY (drone) REFERENCES drone(id),
	ADD CONSTRAINT fk_ds_state
		FOREIGN KEY (state) REFERENCES state(symbol),
	ADD CONSTRAINT fk_ds_employee
		FOREIGN KEY (employee) REFERENCES employee(id);
		
ALTER TABLE drone_specification
	ADD CONSTRAINT fk_ds_drone_model
		FOREIGN KEY (drone_model) REFERENCES drone_model(id);

ALTER TABLE drone_specification
	ADD CONSTRAINT fk_ds_specification
		FOREIGN KEY (specification) REFERENCES technical_specification(id);

ALTER TABLE technical_specification
	ADD CONSTRAINT fk_ts_unit
		FOREIGN KEY (unit) REFERENCES unit(id);

ALTER TABLE state 
	ADD CONSTRAINT fk_state_accepted
		FOREIGN KEY (next_accepted_state) REFERENCES state(symbol) DEFERRABLE,
	ADD CONSTRAINT fk_state_rejected
		FOREIGN KEY (next_rejected_state) REFERENCES state(symbol) DEFERRABLE;


CREATE INDEX idx_employee_name
    ON employee (first_name, last_name);
	
CREATE INDEX idx_state_next
    ON state (next_accepted_state, next_rejected_state);
	
CREATE INDEX idx_drone_acquisition
    ON drone(acquisition_date);

CREATE INDEX idx_drone_state_date
    ON drone_state(start_date_time);
	

	
-- UTILISATION
-- LIAISON :
-- 	- drone_state.drone
-- 	- drone.id
	
-- On pourrait utilser la vue ici :

--  - FICHIER 07
--  			fonction :  
-- 			Ligne 237 (old_state_number_insertion compare drone.id et drone_state.drone)
-- 			Ligne 278 (on compare drone.id et drone_state.drone)
--  - FICHIER 08
-- 			LIGNE 28 (on compare drone.id et drone_state.drone)
-- 			LIGNE 32 (on compare drone.id et drone_state.drone)
-- 			LIGNE 70 (on compare drone.id et drone_state.drone AS date_disponibilite)
-- 			LIGNE 74 (on compare drone.id et drone_state.drone AS localisation)
-- 			LIGNE 78 (on compare drone.id et drone_state.drone AS nb_inspection)
-- 			LIGNE 173 (on compare drone.id et drone_state.drone AS INNER JOIN)


CREATE VIEW vue_drone_state_drone AS
	SELECT drone_state.drone, drone.id
      FROM drone_state 
 	 INNER JOIN drone 
        ON drone_state.drone = drone.id;


-- UTILISATION
-- LIAISON :
-- 	- drone_state.drone
-- 	- state_note.id
	
-- On pourrait utilser la vue ici :
--  - FICHIER 08
--  		LIGNES 92 (fonction requete_dql_3)
--  - FICHIER 06
--  		LIGNES 158 (Avec le INSERT state_note)

CREATE VIEW vue_drone_state_state_note AS
	SELECT drone_state.drone, state_note.id  
  	  FROM drone_state 
 	 INNER JOIN state_note
        ON drone_state.id = state_note.drone_state;	
		

-- UTILISATION
-- LIAISON :
-- 	- drone_state
-- 	- drone disponible

-- On pourrait utilser la vue ici :
-- 		On pourrait utilser la vue dans le cadre de l'entreprise 
-- 		afin de pouvoir donner au client rapidement une liste des
-- 		drones disponibles.

CREATE VIEW vue_drone_disponible AS
	SELECT DISTINCT id AS id_drone_dispo
	  FROM drone_state
	 WHERE state = 'D'
