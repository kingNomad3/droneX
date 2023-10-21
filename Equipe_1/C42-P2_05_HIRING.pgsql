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

-- QUESTION
-- Confirmer validation d'intrant
-- 	RETURN 'GZ 000.WHI-100.A10'; ?
-- 	default table ? meme si procedure a un default


*/
DROP FUNCTION IF EXISTS get_localisation_tag(building_code CHAR(2),
												floor_level INTEGER, color_tag CHAR(3),
												room_number INTEGER);
												
												
DROP FUNCTION IF EXISTS get_office_localisation_tag(building_code CHAR(2),
														floor_level INTEGER, color_tag CHAR(3),
														room_number INTEGER, office_type CHAR(1),
														office_number INTEGER);

DROP FUNCTION IF EXISTS get_office_localisation_tag();


DROP FUNCTION IF EXISTS get_storage_localisation_tag(building_code CHAR(2),
														floor_level INTEGER, color_tag CHAR(3),
														room_number INTEGER, office_type CHAR(1),
														storage_cabinet INTEGER,
														shelf_height INTEGER,
														storage_bin INTEGER);
DROP FUNCTION IF EXISTS get_storage_localisation_tag();


DROP PROCEDURE hire(ssn_value employee.ssn%TYPE,
								 last_name_value employee.last_name%TYPE,
								 first_name_value employee.first_name%TYPE,
								 probation BOOLEAN DEFAULT  TRUE,
								 office_room_value employee.office_room%TYPE DEFAULT  get_office_localisation_tag());


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
LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN 'GZ 000.WHI-100.A10';
END$$;



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
LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN 'XB 000.MAG-600.^IZ00';
END$$;



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
	END IF	
	
	INSERT INTO employee
		VALUES 	(first_name, 		last_name, 			status, 			office_room)
				(first_name_value, 	last_name_value, 	probation_value, 	office_room_value);

END$$;


CALL hire('123123123', 'Rems', 'Test', TRUE);

