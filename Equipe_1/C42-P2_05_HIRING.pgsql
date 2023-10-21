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

-- QUESTION
-- Confirmer validation d'intrant

*/
DROP FUNCTION IF EXISTS get_localisation_tag(building_code CHAR(2),
												floor_level INTEGER, color_tag CHAR(3),
												room_number INTEGER);
												
												
DROP FUNCTION IF EXISTS get_office_localisation_tag(building_code CHAR(2),
														floor_level INTEGER, color_tag CHAR(3),
														room_number INTEGER, office_type CHAR(1),
														office_number INTEGER);




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






