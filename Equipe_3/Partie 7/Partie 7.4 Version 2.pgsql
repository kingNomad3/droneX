
-- Le insert pour tester les fonctions (s'assurer que les fonctions et le trigger sont créés avant de rouler)
-- INSERT INTO drone_state(drone, state, employee, location) VALUES (1, 'D', 1,'dasda');
-- INSERT INTO drone_state(drone, state, employee, location) VALUES (1, 'L', 1,'dasda');
															  
-- SELECT * from drone_state;
SELECT * FROM drone;


-- SELECT * FROM state_note;
/**********************************************************************/


-- Partie 7 : Une fonction de simulation simulant une transition pour un drone

--DROP PROCEDURE IF EXISTS simulation_transition(drone_id INTEGER, date_insertion TIMESTAMP)
CREATE OR REPLACE PROCEDURE simulation_transition(drone_id INTEGER, date_insertion TIMESTAMP) 
AS $$
DECLARE
	old_state CHAR(1) := get_most_recent_insert_state(drone_id);
	old_state_n_r_state CHAR(1) := get_next_rejected_state(old_state);
	old_state_n_a_state CHAR(1) := get_next_accepted_state(old_state);
	probability BOOLEAN := (SELECT random_event(0.75));
	random_employe INTEGER := random_integer(1, (SELECT COUNT(*) FROM employee)::INTEGER);
BEGIN
	IF probability = true THEN
		INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (drone_id, old_state_n_a_state, random_employe, date_insertion, simulate_storage_localisation_tag());
	ELSE 
		INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (drone_id, old_state_n_r_state, random_employe, date_insertion, simulate_storage_localisation_tag());
	END IF;
END;
$$ LANGUAGE PLPGSQL;
-- Pour tester la fonction, executer la ligne suivante :

-- SELECT simulation_transition(1, to_timestamp('2023-10-10 01:00:00', 'YYYY-MM-DD HH:MI:SS')::TIMESTAMP)


-- Partie 7 : Une fonction de simulation simulant n transitions pour un drone
DROP PROCEDURE IF EXISTS simulation_transition_multiple(drone_id INTEGER, date_commencement TIMESTAMP, date_fin TIMESTAMP);
CREATE OR REPLACE PROCEDURE simulation_transition_multiple(drone_id INTEGER, date_commencement TIMESTAMP, date_fin TIMESTAMP) 
AS $$
DECLARE
	nombre_insertion INTEGER := random_integer(1, 3); -- changer la deuxieme valeur pour modifier le nb de transitions
	random_timestamp TIMESTAMP;
	i INTEGER;
	probability BOOLEAN := (SELECT random_event(0.75));
BEGIN
	FOR i IN 1..nombre_insertion LOOP
		random_timestamp := random_timestamp(date_commencement, date_fin);
        RAISE NOTICE '%', i;
		IF probability = true THEN
			PERFORM simulation_transition(drone_id, random_timestamp);
		END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Pour tester la fonction utiliser le code suivant :

--SELECT simulation_transition_multiple(1 , to_timestamp('2023-10-15 01:00:00', 'YYYY-MM-DD HH:MI:SS')::TIMESTAMP, NOW()::TIMESTAMP);
	

-- Partie 7 : Une fonction de simulation simulant n transitions pour un drone généré aléatoirement

DROP PROCEDURE IF EXISTS simulation_transition_multiple_drone_random();
CREATE OR REPLACE PROCEDURE simulation_transition_multiple_drone_random()
AS $$
DECLARE
	random_drone_id INTEGER;
	nombre_insertion INTEGER := 1; -- changer la deuxieme valeur pour modifier le nb de transitions
	random_timestamp TIMESTAMP;
	i INTEGER;
	probability BOOLEAN := (SELECT random_event(0.75));
	date_commencement TIMESTAMP;
BEGIN
	FOR i IN 1..nombre_insertion LOOP
		random_drone_id := (SELECT id FROM drone ORDER BY random() LIMIT 1);
		date_commencement := (SELECT start_date_time FROM drone_state ORDER BY start_date_time DESC LIMIT 1);
		random_timestamp := (date_commencement + '10 HOUR'::INTERVAL)::TIMESTAMP;
		probability := (SELECT random_event(0.75));

		IF probability = true THEN
			CALL simulation_transition(random_drone_id, random_timestamp);
		END IF;		
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Pour tester la fonction, utiliser le code suivant : 
--CALL simulation_transition_multiple_drone_random();
--SELECT * from drone_state;
-- SELECT * from state_note;

	
	






