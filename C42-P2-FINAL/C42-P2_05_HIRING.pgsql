/*
	Membres : 

	Julien Coulombe-Morency, 
	Remi Chuet, 
	Édouard Blain-Noël, 
	Catherine Lavoie, 
	Benjamin Jouinvil, 
	François Maltais
		
	Date de création : 2023-10-21
	Dernière modification : 2023-10-21
	C42-P2_05_HIRING.pgsql
	V1.0
*/
/*

SELECT get_office_localisation_tag('GZ', 12, 'WHI', 122, 'a', 12);
SELECT get_storage_localisation_tag('GZ', 12, 'WHI', 120, '<', 12, 0, 1);
CALL hire('1232131', 'Jilen', 'Test', FALSE, get_office_localisation_tag('GZ', 12, 'WHI', 122, 'a', 12));
CALL hire('123123', 'Remi', 'Test', TRUE);
SELECT simulate_storage_localisation_tag();
CALL simulate_hiring('Remi', 'Chuet', '121212121212');
CALL simulate_hiring('Julien', 'Bob', '12231212121212');CALL simulate_hiring('Remi', 'Chuet', '1212121212123453');
CALL simulate_hiring('Julien', 'Bob', '1212312121277');CALL simulate_hiring('Remi', 'Chuet', '1212121212113451');
CALL simulate_hiring('Julien', 'Bob', '1212132121266');CALL simulate_hiring('Remi', 'Chuet', '121212121213451111');
CALL simulate_hiring('Julien', 'Bob', '123145545562323');CALL simulate_hiring('Remi', 'Chuet', '12121234121222');
CALL simulate_hiring('Julien', 'Bob', '121212121245444');CALL simulate_hiring('Remi', 'Chuet', '121245121212333');
CALL simulate_hiring('Julien', 'Bob', '12121212451288');
SELECT * from employee 	


-- QUESTION
-- Confirmer validation d'intrant
-- 	RETURN 'GZ 000.WHI-100.A10'; ?
-- 	default table ? meme si procedure a un default


*/

DROP PROCEDURE IF EXISTS simulate_hiring(last_name_value employee.last_name%TYPE,first_name_value employee.first_name%TYPE,ssn_value employee.ssn%TYPE);
DROP FUNCTION IF EXISTS simulate_storage_localisation_tag();
DROP FUNCTION IF EXISTS simulate_office_localisation_tag();

DROP PROCEDURE IF EXISTS hire(ssn_value employee.ssn%TYPE,last_name_value employee.last_name%TYPE,first_name_value employee.first_name%TYPE,probation BOOLEAN,office_room_value employee.office_room%TYPE);

DROP FUNCTION IF EXISTS get_storage_localisation_tag();
DROP FUNCTION IF EXISTS get_storage_localisation_tag(building_code CHAR(2),floor_level INTEGER, color_tag CHAR(3),room_number INTEGER, office_type CHAR(1),storage_cabinet INTEGER,shelf_height INTEGER,storage_bin INTEGER);

DROP FUNCTION IF EXISTS get_office_localisation_tag();
DROP FUNCTION IF EXISTS get_office_localisation_tag(building_code CHAR(2),floor_level INTEGER, color_tag CHAR(3),room_number INTEGER, office_type CHAR(1),office_number INTEGER);
DROP FUNCTION IF EXISTS get_localisation_tag(building_code CHAR(2),floor_level INTEGER, color_tag CHAR(3),room_number INTEGER);

DROP FUNCTION IF EXISTS random_probation();
DROP FUNCTION IF EXISTS random_storage_bin();
DROP FUNCTION IF EXISTS random_storage_cabinet();
DROP FUNCTION IF EXISTS random_shelf_height();
DROP FUNCTION IF EXISTS random_office_number();
DROP FUNCTION IF EXISTS random_office_type(office_type VARCHAR(10));
DROP FUNCTION IF EXISTS random_room_number();
DROP FUNCTION IF EXISTS random_floor_level();
DROP FUNCTION IF EXISTS random_color_tag();
DROP FUNCTION IF EXISTS random_building_code(range FLOAT);


/*RANDOM FONCTION*/

-- Return un random building code
CREATE OR REPLACE FUNCTION random_building_code(range FLOAT)
	RETURNS CHAR(2)
LANGUAGE PLPGSQL
AS $$
DECLARE
    random_value FLOAT := random();
BEGIN

    IF range < 0.85 THEN
        RETURN CASE
            WHEN random_value <= range THEN 'XB'
            ELSE 'GZ'
        END;
    ELSE
        RETURN CASE
            WHEN random_value <= range THEN 'GZ'
            ELSE 'XB'
        END;
    END IF;

END$$;

-- Return un random color tag
CREATE OR REPLACE FUNCTION random_color_tag()
	RETURNS CHAR(3)
LANGUAGE PLPGSQL
AS $$
DECLARE
    colors CHAR(3)[] := ARRAY['RED', 'GRE',  'BLU', 'YEL', 'MAG', 'ORA', 'WHI', 'BLA'];
BEGIN
    RETURN colors[floor(random() * array_length(colors, 1))::INTEGER + 1]; 
END$$;

-- Return un floor level random entre -5 et 25
CREATE OR REPLACE FUNCTION random_floor_level()
	RETURNS INTEGER
LANGUAGE SQL
AS $$
    RETURN floor(random() * 31 - 5)::INTEGER; 
$$;

-- Return un room_number random entre 100 et 899
CREATE OR REPLACE FUNCTION random_room_number()
	RETURNS INTEGER
LANGUAGE SQL
AS $$
    RETURN floor(random() * 800 + 100)::INTEGER; 
$$;

-- Return un office_type random entre A et J
CREATE OR REPLACE FUNCTION random_office_type(office_type VARCHAR(10))
    RETURNS CHAR(1)
LANGUAGE PLPGSQL
AS $$
DECLARE
    space_type CHAR(1)[] := ARRAY['<', '>',  '^', 'v', 'x', '_'];
BEGIN

	if (office_type = 'office') THEN
    	RETURN CHR(floor(random() * 9 + 65)::INTEGER);
	ELSE 
		RETURN space_type[floor(random() * array_length(space_type, 1))::INTEGER + 1];
	END IF; 

END$$;

-- Return un office_number random entre 10 et 89
CREATE OR REPLACE FUNCTION random_office_number()
	RETURNS INTEGER
LANGUAGE SQL
AS $$
    RETURN floor(random() * 80 + 10)::INTEGER; 
$$;

-- Return un shelf_height random entre 0 et 25
CREATE OR REPLACE FUNCTION random_shelf_height()
	RETURNS INTEGER
LANGUAGE SQL
AS $$
    RETURN floor(random() * 26)::INTEGER; 
$$;

-- Return un office_type random entre A et T
CREATE OR REPLACE FUNCTION random_storage_cabinet()
	RETURNS INTEGER
LANGUAGE SQL
AS $$
    RETURN floor(random() * 20)::INTEGER; 
$$;

-- Return un shelf_height random entre 0 et 99
CREATE OR REPLACE FUNCTION random_storage_bin()
	RETURNS INTEGER
LANGUAGE SQL
AS $$
    RETURN floor(random() * 100)::INTEGER; 
$$;

-- Return vrai ou faux
CREATE OR REPLACE FUNCTION random_probation()
	RETURNS BOOLEAN
LANGUAGE SQL
AS $$
    RETURN random() < 0.75; 
$$;


/*FONCTION DE GENERATION*/

CREATE OR REPLACE FUNCTION get_localisation_tag(building_code CHAR(2),
												floor_level INTEGER, color_tag CHAR(3),
												room_number INTEGER)
	RETURNS CHAR(14)
LANGUAGE PLPGSQL
AS $$
DECLARE
	localisation_tag CHAR(14) := '';
	temp_string VARCHAR(10) := '';
BEGIN
	IF building_code != 'GZ' AND building_code != 'XB' THEN
		RAISE EXCEPTION 'Mauvaise building_code';
	END IF;
	localisation_tag := localisation_tag || building_code;
	
	
	IF floor_level < -99 OR floor_level > 999 THEN
		RAISE EXCEPTION 'Mauvaise floor_level';
	END IF;
	
	IF (floor_level >= 0) THEN
		localisation_tag := localisation_tag || ' ' || LPAD(floor_level::VARCHAR(3), 3, '0') || '.';
	END IF;
	
	IF (floor_level < 0) THEN
		temp_string := 'S';
		localisation_tag := localisation_tag || ' ' || temp_string || LPAD(abs(floor_level)::VARCHAR(3), 2, '0') || '.';
	END IF;
	
	localisation_tag := localisation_tag || color_tag || '-';
	
	IF room_number < 100 OR room_number > 899 THEN
		RAISE EXCEPTION 'Mauvais room_number';
	END IF;
	
	localisation_tag := localisation_tag || room_number;
	
	RETURN localisation_tag;
END$$;



CREATE OR REPLACE FUNCTION get_office_localisation_tag(building_code CHAR(2),
														floor_level INTEGER, color_tag CHAR(3),
														room_number INTEGER, office_type CHAR(1),
														office_number INTEGER)

	RETURNS CHAR(18)
LANGUAGE PLPGSQL
AS $$
DECLARE
	office_localisation_tag CHAR(18) := get_localisation_tag(building_code, floor_level, color_tag, room_number);
	office_type_temp CHAR(1) := UPPER(office_type);
BEGIN
	IF office_type_temp NOT BETWEEN 'A' AND 'J' THEN
		RAISE EXCEPTION 'Mauvais office_type';
	END IF;
	
	office_localisation_tag := office_localisation_tag || '.' || office_type_temp;
	
	IF office_number < 10 OR office_number > 89 THEN
		RAISE EXCEPTION 'Mauvais office_number';
	END IF;
	
		office_localisation_tag := office_localisation_tag || office_number;
	RETURN office_localisation_tag;
END$$;

CREATE OR REPLACE FUNCTION get_office_localisation_tag()
	RETURNS CHAR(18)
LANGUAGE SQL
AS $$
	RETURN 'GZ 000.WHI-100.A10';
$$;



CREATE OR REPLACE FUNCTION get_storage_localisation_tag(building_code CHAR(2),
														floor_level INTEGER, color_tag CHAR(3),
														room_number INTEGER, office_type CHAR(1),
														storage_cabinet INTEGER,
														shelf_height INTEGER,
														storage_bin INTEGER)
	RETURNS CHAR(20)
LANGUAGE PLPGSQL
AS $$
DECLARE
	storage_localisation_tag CHAR(20) := get_localisation_tag(building_code, floor_level, color_tag, room_number);
BEGIN
	IF office_type NOT IN ('^', '<', '>', 'v', 'x', '_') THEN
		RAISE EXCEPTION 'Mauvais office_type';
	END IF;
	
	storage_localisation_tag := storage_localisation_tag || '.' || office_type;
	
	IF storage_cabinet < 1 OR storage_cabinet > 20 THEN
		RAISE EXCEPTION 'Mauvais storage_cabinet';
	END IF;
	storage_localisation_tag := storage_localisation_tag || CHR(storage_cabinet + 64);
	
	
	IF shelf_height < 0 OR shelf_height > 25 THEN
		RAISE EXCEPTION 'Mauvais shelf_height';
	END IF;
	
	IF shelf_height = 0 THEN
		storage_localisation_tag := storage_localisation_tag || 'Z';
	ELSE
		storage_localisation_tag := storage_localisation_tag || CHR(shelf_height + 64);
	END IF;

	IF storage_bin < 0 OR storage_bin > 99 THEN
		RAISE EXCEPTION 'Mauvais storage_bin';
	END IF;
	
	IF storage_bin < 10 THEN
		storage_localisation_tag := storage_localisation_tag || LPAD(storage_bin::VARCHAR(2), 2, '0');
	ELSE
		storage_localisation_tag := storage_localisation_tag || storage_bin;
	END IF;
	
	
	RETURN storage_localisation_tag;
END$$;


CREATE OR REPLACE FUNCTION get_storage_localisation_tag()
	RETURNS CHAR(20)
LANGUAGE SQL
AS $$
	RETURN 'XB 000.MAG-600.^IZ00';
$$;



CREATE OR REPLACE PROCEDURE hire(ssn_value employee.ssn%TYPE,
								 last_name_value employee.last_name%TYPE,
								 first_name_value employee.first_name%TYPE,
								 probation BOOLEAN DEFAULT TRUE,
								 office_room_value employee.office_room%TYPE
								 DEFAULT get_office_localisation_tag())
LANGUAGE PLPGSQL
AS $$
DECLARE 
	probation_value employee_status;
BEGIN
	IF (probation) THEN
		probation_value := 'probation'::employee_status;
	ELSE 
		probation_value := 'regular'::employee_status;	
	END IF;
	
	INSERT INTO employee (ssn,		first_name, 		last_name, 			status, 			office_room)
		VALUES 			(ssn_value, first_name_value, 	last_name_value, 	probation_value, 	office_room_value);

END$$;



CREATE OR REPLACE FUNCTION simulate_office_localisation_tag()
	RETURNS CHAR(18)
LANGUAGE PLPGSQL
AS $$
DECLARE 
	randomValue FLOAT := random();
BEGIN
	
	IF (randomValue < 0.2) THEN
		RETURN get_office_localisation_tag();
	END IF;

	RETURN get_office_localisation_tag(random_building_code(0.85),
														random_floor_level(), random_color_tag(),
														random_room_number(), random_office_type('office'),
														random_office_number());
END$$;


CREATE OR REPLACE FUNCTION simulate_storage_localisation_tag()
	RETURNS CHAR(20)
LANGUAGE PLPGSQL
AS $$
DECLARE
	randomValue FLOAT := random();
BEGIN
	
	IF (randomValue < 0.4) THEN
		RETURN get_storage_localisation_tag();
	END IF;

	RETURN get_storage_localisation_tag(random_building_code(0.75),
														random_floor_level(), random_color_tag(),
														random_room_number(), random_office_type('storage'),
														random_storage_cabinet(),
														random_shelf_height(),
														random_storage_bin());
END$$;



CREATE OR REPLACE PROCEDURE simulate_hiring(last_name_value employee.last_name%TYPE,
											 first_name_value employee.first_name%TYPE,
											 ssn_value employee.ssn%TYPE DEFAULT NULL)
LANGUAGE PLPGSQL
AS $$
DECLARE
	random_ssn INTEGER := random() * 100000001 + 100000000 ;
BEGIN

	IF ssn_value IS NULL THEN
		CALL hire(random_ssn::VARCHAR(32), last_name_value, first_name_value, random_probation(), simulate_office_localisation_tag());
	ELSE
		CALL hire(ssn_value, last_name_value, first_name_value, random_probation(), simulate_office_localisation_tag());
	END IF;

END$$;

/*CALL */

CALL simulate_hiring('Rémi', 'Chuet', '111111111');
CALL simulate_hiring('Julien', 'Coulombe-Morency', '222222222');
CALL simulate_hiring('Édouard', 'Blain-Noël', '333333333');
CALL simulate_hiring('Catherine', 'Lavoie', '444444444');
CALL simulate_hiring('Benjamin', 'Joinvile', '555555555');
CALL simulate_hiring('François', 'Maltais', '666666666');

CALL simulate_hiring('Jean-Christophe', 'Demers');
CALL simulate_hiring('Frédéric', 'Thériault');
CALL simulate_hiring('Éric', 'Labonté');
CALL simulate_hiring('Jean-Marc', 'Deschamps');
CALL simulate_hiring('Francis', 'Beauchemin-Côté');
CALL simulate_hiring('Michelle', 'Girard');
