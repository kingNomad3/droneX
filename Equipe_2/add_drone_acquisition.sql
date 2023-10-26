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
	DECLARE current_count INT := 1000 + (SELECT COUNT(*) FROM drone) * 10;
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

		IF model_name NOT IN (SELECT name FROM drone_model) 
		   THEN RAISE EXCEPTION 'Le modèle % n''existe pas', model_name;
		END IF;

		manufacturer_name := (
			SELECT name 
			  FROM manufacturing_company 
			 WHERE id = (SELECT manufacturer FROM drone_model WHERE name = model_name)
		);

		RETURN drone_tag_a(manufacturer_name) || drone_tag_b(model_name) || '-' || drone_tag_c(drone_acquisition) || '-' || drone_tag_d();
	END
$$;



SELECT * FROM drone;
-- * FROM drone_state;
-- * FROM state_note;
CALL add_drone_acquisition(
	'Matrice 350 RTK', 'kfj06546ww3', '222222222', NOW()::TIMESTAMP, '111111111', NOW()::date, '333333333');
---------------------------
CREATE OR REPLACE PROCEDURE add_drone_acquisition(
    model_name              drone_model.name%TYPE,
    serial_drone            drone.serial_number%TYPE,
    registering_employee    employee.ssn%TYPE, 
    registering_timestamp   drone_state.start_date_time%TYPE, 
    receiving_employee      employee.ssn%TYPE, 
    receiving_date          drone.acquisition_date%TYPE, 
    unpacking_employee      employee.ssn%TYPE)
LANGUAGE PLPGSQL 
AS 
$$
DECLARE drone_initial_state CHAR(1) := 'I';
		note_type_initial note_type := 'general_observation'::note_type;
        drone_id drone.id%TYPE := null;
		
BEGIN


--1er partie fonctionnelle, mais non-testée
	INSERT INTO drone (model, serial_number, drone_tag, acquisition_date) 
		VALUES (
            (SELECT id FROM drone_model WHERE name = model_name), 
            serial_drone, 
            generate_drone_tag(model_name, receiving_date), 
            receiving_date);

	SELECT id INTO drone_id FROM drone WHERE serial_number = serial_drone;

--2 partie
	INSERT INTO drone_state (drone, state, employee, start_date_time, location)
		VALUES (
            drone_id, 
            drone_initial_state, 
            (SELECT id FROM employee WHERE ssn = registering_employee), 
            registering_timestamp, 
            simulate_storage_localisation_tag()); -- à disctuer en équipe ce qu'on fait par rapport au state en fonction des triggers de drone_state

--3e partie
	INSERT INTO state_note (drone_state, note, date_time, employee, details)
		VALUES (
			(SELECT id FROM drone_state WHERE drone = drone_id), 
			note_type_initial,
			registering_timestamp, 
			(SELECT id FROM employee WHERE ssn = receiving_employee),
			'Received by : ' || concat_name(receiving_employee) || ' on ' || receiving_date || 
			E'\nUnpacked by : ' || concat_name(unpacking_employee));

END
$$;

CREATE OR REPLACE FUNCTION concat_name(ssn_employe employee.ssn%TYPE) RETURNS VARCHAR LANGUAGE SQL AS $$
    SELECT first_name || ' ' || last_name FROM employee WHERE ssn = ssn_employe;
$$
