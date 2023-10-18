ALTER TABLE state_note DROP CONSTRAINT IF EXISTS fk_not_emp;
ALTER TABLE state_note DROP CONSTRAINT IF EXISTS fk_not_dro;

DROP TABLE IF EXISTS state_note;
DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
	id 			SERIAL,
	ssn 		VARCHAR(32) 	NOT NULL,
	first_name 	VARCHAR(32) 	NOT NULL,
	last_name 	VARCHAR(32) 	NOT NULL,
	status		employee_status NOT NULL	DEFAULT employee_status::probation,
	office_room CHAR(18)		NOT NULL	DEFAULT 'GZ 000.WHI-100.A10',

	CONSTRAINT pk_emp	  PRIMARY KEY (id),
	CONSTRAINT uc_emp_ssn UNIQUE (ssn),
	CONSTRAINT cc_emp_ssn CHECK (LENGTH(ssn) >= 6)
	-- CONSTRAINT cc_emp_off CHECK()
	-- Pattern pour office_room à ajouter...
	-- FOREIGN KEY à ajouter
);

CREATE TABLE state_note (
	id			SERIAL,
	drone_state INTEGER 		NOT NULL,
	note    	note_type		NOT NULL,
	date_time	TIMESTAMP		NOT NULL,
	employe		INTEGER			NOT NULL,
	details		VARCHAR(2048)	NOT NULL,
	
	CONSTRAINT pk_not	  PRIMARY KEY (id),
	CONSTRAINT cc_not_det CHECK (LENGTH(details)>=15)
);

ALTER TABLE ADD CONSTRAINT fk_not_emp FOREIGN KEY (employee) REFERENCES employee(id);
ALTER TABLE ADD CONSTRAINT fk_not_dro FOREIGN KEY (drone_state) REFERENCES drone_state(id);


