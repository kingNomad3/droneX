-- fait la partie A du drone_tag
CREATE OR REPLACE FUNCTION drone_tag_a (manufacturer_name manufacturing_company.name%TYPE) 
RETURNS CHAR(3) LANGUAGE PLPGSQL 
AS $$
	BEGIN
		manufacturer_name := UPPER(REGEXP_REPLACE(manufacturer_name, '[^a-zA-Z]', '', 'g'));
		RETURN RPAD(SUBSTR(manufacturer_name, 1, 3), 3, 'x');
	END
$$;


-- fait la partie B du drone_tag
CREATE OR REPLACE FUNCTION drone_tag_b (model_name drone_model.name%TYPE) 
RETURNS CHAR(3) LANGUAGE PLPGSQL
AS 
$$
	DECLARE
			trimmed VARCHAR := UPPER(REPLACE(model_name, ' ', ''));
			len INT := LENGTH(trimmed);
			bias INT := (len % 2 = 1)::int;
			first CHAR := SUBSTR(trimmed, 1, 1);
			last CHAR := SUBSTR(trimmed, len, 1);

	BEGIN
		IF len=1 
			THEN RETURN CONCAT('x', trimmed, 'x');
		ELSIF len=2 
			THEN RETURN CONCAT(first, 'x', last);
		ELSE 
			RETURN CONCAT(first, SUBSTR(trimmed, len/2 + bias, 1), last);
		END IF;
	END
$$;


-- fait la partie C du drone_tag
CREATE OR REPLACE FUNCTION drone_tag_c (acquisition_date drone.acquisition_date%TYPE) 
RETURNS CHAR(6) LANGUAGE PLPGSQL
AS 
$$
	DECLARE date_reference DATE := '2000-01-01'::date;
	BEGIN
		RETURN LPAD((acquisition_date - date_reference)::VARCHAR, 6, '0');
	END
$$;

-- fait la partie D du drone_tag
CREATE OR REPLACE FUNCTION drone_tag_d () 
RETURNS CHAR(6) LANGUAGE PLPGSQL
AS 
$$
	DECLARE current_count INT := 1000 + (SELECT COUNT(*)-1 FROM drone) * 10;
	BEGIN
		RETURN TRANSLATE(LPAD(current_count::CHAR(6), 6, '0'), '0123456789', 'ZUDTQCSPHN');
	END
$$;


-- version finale (nécessite les fonctions ci-haut)
CREATE OR REPLACE FUNCTION generate_drone_tag (
		model_name drone_model.name%TYPE, 
		drone_acquisition drone.acquisition_date%TYPE
		) 
RETURNS drone.drone_tag%TYPE LANGUAGE PLPGSQL
AS 
$$
	DECLARE manufacturer_name manufacturing_company.name%TYPE;

	BEGIN

		IF $1 NOT IN (SELECT name FROM drone_model) 
		   THEN RAISE EXCEPTION 'Le modèle % n''existe pas', model_name;
		END IF;

		manufacturer_name := (
			SELECT name 
			  FROM manufacturing_company 
			 WHERE id = (SELECT manufacturer FROM drone_model WHERE name = $1)
		);

		RETURN drone_tag_a(manufacturer_name) || drone_tag_b($1) || '-' || drone_tag_c($2) || '-' || drone_tag_d();
	END
$$;






	
