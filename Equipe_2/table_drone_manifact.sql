CREATE TYPE note_type AS ENUM (
'general_observation', 
'problematic_observation', 
'maintenance_performed', 
'repair_completed', 
'equipment_replaced'
);

CREATE TYPE note_type AS ENUM ( 
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

CREATE TABLE drone_state ( 
	id    SERIAL, 
	drone INTEGER   NOT NULL, 
	state CHAR(1)   NOT NULL,
	employe INTEGER NOT NULL,
	start_date_time TIMESTAMP NOT NULL,
	--location CHAR(19) DEFAULT 'GZ 01' 
	PRIMARY KEY pk_dro_sta (id)
	CONSTRAINT uc_sta_dro_dro_start_date UNIQUE(drone, start_date_time)
	-- CONTRAINT cc_dro_sta_loc CHECK(??? regx, fonction)
)

CREATE TABLE manufacturing_compagny (
id SERIAL, 
name  NOT NULL, 
web_site VARCHAR(256) NOT NULL 

PRIMARY KEY pk_manu (id)
)
