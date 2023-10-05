-- add foreign keys 
-- add state constraint 
DROP TABLE IF EXISTS unit ;
DROP TABLE IF EXISTS technical_specification;
DROP TABLE IF EXISTS drone_specification;

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



