
-- Le insert pour tester les fonctions (s'assurer que les fonctions et le trigger sont créés avant de rouler)
INSERT INTO drone_state(drone, state, employee, location) VALUES (1, 'D', 1,'dasda');
INSERT INTO drone_state(drone, state, employee, location) VALUES (1, 'L', 1,'dasda');
															  
SELECT * from drone_state;

SELECT * FROM state_note;
/**********************************************************************/


-- Partie 7 : Une fonction de simulation simulant une transition pour un drone

--DROP FUNCTION IF EXISTS simulation_transition(drone_id INTEGER, date_insertion TIMESTAMP)
CREATE OR REPLACE FUNCTION simulation_transition(drone_id INTEGER, date_insertion TIMESTAMP)
RETURNS VOID
AS $$
DECLARE

	old_state CHAR(1) := get_most_recent_insert_state(drone_id);
	old_state_n_r_state CHAR(1) := get_next_rejected_state(old_state);
	old_state_n_a_state CHAR(1) := get_next_accepted_state(old_state);
	probability BOOLEAN := (SELECT random_event(0.75));

BEGIN
	

	IF probability = true THEN
		INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (drone_id, old_state_n_r_state, 1, date_insertion, 'dasda');
	ELSE 
		INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (drone_id, old_state_n_r_state, 1, date_insertion, 'dasda');
	END IF;

END;
$$ LANGUAGE PLPGSQL;


-- Pour tester la fonction, executer la ligne suivante :

SELECT simulation_transition(1, to_timestamp('2023-10-10 01:00:00', 'YYYY-MM-DD HH:MI:SS')::TIMESTAMP)


-- Partie 7 : Une fonction de simulation simulant n transitions pour un drone
DROP FUNCTION IF EXISTS simulation_transition_multiple(drone_id INTEGER, date_commencement TIMESTAMP, date_fin TIMESTAMP)
CREATE OR REPLACE FUNCTION simulation_transition_multiple(drone_id INTEGER, date_commencement TIMESTAMP, date_fin TIMESTAMP)
RETURNS VOID
AS $$
DECLARE
	nombre_insertion INTEGER := random_integer(1, 3);
	random_timestamp TIMESTAMP;
	i INTEGER;
BEGIN
	FOR i IN 1..nombre_insertion LOOP
		random_timestamp := random_timestamp(date_commencement, date_fin);
        RAISE NOTICE '%', i;
		PERFORM simulation_transition(drone_id, random_timestamp);		
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- POur tester la fonction utiliser le code suivant :

SELECT simulation_transition_multiple(1 , to_timestamp('2023-10-15 01:00:00', 'YYYY-MM-DD HH:MI:SS')::TIMESTAMP, NOW()::TIMESTAMP);
	

	
	
	
	
	






