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

CREATE OR REPLACE FUNCTION get_localisation_tag(building_code CHAR(2),
												floor_level INTEGER, color_tag CHAR(3),
												room_number INTEGER)
	RETURNS CHAR(14)
LANGUAGE PLPGSQL
AS $$
DECLARE
	localisation_tag DOUBLE PRECISION := 0.0;
BEGIN
	IF max_i <= 0 THEN
		max_i := 1000;
	END IF;
	FOR i IN 1..max_i LOOP
		pi_value := pi_value + 1.0 / i^2;
	END LOOP;
	RETURN sqrt(6.0 * pi_value);
END$$;


