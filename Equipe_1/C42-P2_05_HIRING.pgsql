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
code : AA BBB.CCC-DDD[.xxxxx]

*/
DROP FUNCTION IF EXISTS get_localisation_tag(building_code CHAR(2),
												floor_level INTEGER, color_tag CHAR(3),
												room_number INTEGER);



CREATE OR REPLACE FUNCTION get_localisation_tag(building_code CHAR(2),
												floor_level INTEGER, color_tag CHAR(3),
												room_number INTEGER)
	RETURNS CHAR(14)
LANGUAGE PLPGSQL
AS $$
DECLARE
	localisation_tag CHAR(18) := '';
	temp_string VARCHAR(10) := '';
BEGIN
	IF building_code != 'GZ' AND building_code != 'XB' THEN
		RAISE EXCEPTION 'Mauvaise building_code';
	END IF;
	localisation_tag := localisation_tag || building_code;
	
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



