/*
	Membres : 
		Julien Coulombe-Morency, 
		Remi Chuet, 
		Édouard Blain-Noël, 
		Catherine Lavoie, 
		Benjamin Jouinvil, 
		François Maltais
		
	Date de création : 2023-10-18 
	Dernière modification : 2023-10-18
	C42-P2_01_CREATE_INFRA.pgsql
	V1.0
	
*/
ALTER TABLE state DROP CONSTRAINT IF EXISTS fk_state_rejected;
ALTER TABLE state DROP CONSTRAINT IF EXISTS fk_state_accepted;
ALTER TABLE technical_specification DROP CONSTRAINT IF EXISTS fk_ts_unit;
ALTER TABLE drone_specification DROP CONSTRAINT IF EXISTS fk_ds_specification;
ALTER TABLE drone_specification DROP CONSTRAINT IF EXISTS fk_ds_drone_model;
ALTER TABLE drone_state DROP CONSTRAINT IF EXISTS fk_ds_employee;
ALTER TABLE drone_state DROP CONSTRAINT IF EXISTS fk_ds_state;
ALTER TABLE drone_state DROP CONSTRAINT IF EXISTS fk_ds_drone;
ALTER TABLE state_note DROP CONSTRAINT IF EXISTS fk_sn_employee;
ALTER TABLE state_note DROP CONSTRAINT IF EXISTS fk_sn_drone_state;
ALTER TABLE fk_od_depend DROP CONSTRAINT IF EXISTS fk_od_depend;
ALTER TABLE drone_domain DROP CONSTRAINT IF EXISTS fk_dm_domain;
ALTER TABLE drone_domain DROP CONSTRAINT IF EXISTS fk_dm_model;
ALTER TABLE drone_model DROP CONSTRAINT IF EXISTS fk_drone_model_manufacturer;
ALTER TABLE drone DROP CONSTRAINT IF EXISTS fk_drone_model;

DROP TABLE IF EXISTS state ;
DROP TABLE IF EXISTS unit ;
DROP TABLE IF EXISTS technical_specification;
DROP TABLE IF EXISTS drone_specification;
DROP TABLE IF EXISTS manufacturing_compagny;
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
	general_observation, 
	problematic_observation, 
	maintenance_performed, 
	repair_completed, 
	equipment_replaced
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

CREATE TABLE employee (
	id 						SERIAL,
	ssn 					VARCHAR(32) 			NOT NULL,
	first_name 				VARCHAR(32) 			NOT NULL,
	last_name 				VARCHAR(32) 			NOT NULL,
	status					employee_status 		NOT NULL	DEFAULT employee_status::probation,
	office_room 			CHAR(18)				NOT NULL	DEFAULT 'GZ 000.WHI-100.A10',

	CONSTRAINT pk_employee PRIMARY KEY (id),
	CONSTRAINT uc_employee_ssn UNIQUE (ssn),
	CONSTRAINT cc_employee_ssn CHECK (LENGTH(ssn) >= 6)
	-- CONSTRAINT cc_emp_off CHECK()
	-- Pattern pour office_room à ajouter...
	-- FOREIGN KEY à ajouter
);

CREATE TABLE state_note (
	id						SERIAL,
	drone_state				INTEGER 				NOT NULL,
	note    				note_type				NOT NULL,
	date_time				TIMESTAMP				NOT NULL,
	employe					INTEGER					NOT NULL,
	details					VARCHAR(2048)			NOT NULL,
	
	CONSTRAINT pk_state_note PRIMARY KEY (id),
	CONSTRAINT cc_sn_details CHECK (LENGTH(details)>=15)
);

CREATE TABLE drone_state ( 
	id    			SERIAL, 
	drone INTEGER   NOT NULL, 
	state CHAR(1)   NOT NULL,
	employe INTEGER NOT NULL,
	start_date_time TIMESTAMP NOT NULL,

	CONSTRAINT pk_drone_state PRIMARY KEY (id)
	CONSTRAINT uc_sta_dro_dro_start_date UNIQUE(drone, start_date_time)
	-- CONTRAINT cc_dro_sta_loc CHECK(??? regx, fonction)
	--location CHAR(19) DEFAULT 'GZ 01' 
);

CREATE TABLE manufacturing_compagny (
	id SERIAL, 
	name  NOT NULL, 
	web_site VARCHAR(256) NOT NULL 

	CONSTRAINT PRIMARY KEY pk_manufacturing_compagny (id)
);

CREATE TABLE drone_specification(
	id 				SERIAL,
	drone_model		INTEGER        NOT NULL,
	specfication    INTEGER        NOT NULL,
	value 			VARCHAR(256)   NOT NULL,  
	comments        VARCHAR(1024), 
	
	
	CONSTRAINT pk_ds PRIMARY KEY(id),
	CONSTRAINT cc_ds_value CHECK (LENGTH(value) > 0)
);

CREATE TABLE technical_specification(
	id 				SERIAL,
	name 			VARCHAR(64)    NOT NULL,
	description 	VARCHAR(512)   NOT NULL,
	unit 			INTEGER,
	
	
	CONSTRAINT pk_ts PRIMARY KEY(id),
	CONSTRAINT uc_ts_name UNIQUE (name),
	CONSTRAINT cc_ts_name CHECK (LENGTH(name) > 2),
	CONSTRAINT cc_ts_description CHECK (LENGTH(description) > 10)
);

CREATE TABLE unit(
	id 				SERIAL,
	symbol 			VARCHAR(16) 	NOT NULL,
	name 			VARCHAR(64) 	NOT NULL,
	description 	VARCHAR(1024),
	
	CONSTRAINT pk_unit PRIMARY KEY(id),
	CONSTRAINT uc_unit_name UNIQUE (name),
	CONSTRAINT uc_unit_symbol UNIQUE (symbol),
	CONSTRAINT cc_unit_name  CHECK (LENGTH(name) > 0),
	CONSTRAINT cc_unit_symbol CHECK (LENGTH(symbol) > 0),
	CONSTRAINT cc_unit_description CHECK (LENGTH(description) >= 10 OR description = NULL)
);

CREATE TABLE state(
	symbol 	CHAR(1),
	name	VARCHAR(32) 	NOT NULL,
	description VARCHAR(2048) NOT NULL,
	next_accepted_state CHAR(1) DEFAULT NULL,
	next_rejected_state CHAR(1) DEFAULT NULL,
	
	
	CONSTRAINT pk_state PRIMARY KEY(symbol),
	CONSTRAINT uc_state_name UNIQUE (name),
	CONSTRAINT uc_state_description UNIQUE (description),
	
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
		FOREIGN KEY (next_accepted_state) REFERENCES state(symbol),
	ADD CONSTRAINT fk_state_rejected
		FOREIGN KEY (next_rejected_state) REFERENCES state(symbol);

	
		





