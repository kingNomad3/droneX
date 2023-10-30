/*

C42-P2_07_DRONE_ACTIVITIES.pgsql
420-C42-IN Langages d'exploitation des bases de données
Auteurs : Julien Coulombe-Morency, Benjamin Joinvil, Édouard Blain-Noël, François Maltais, Catherine Lavoie, Remi Chuet
Date de création : 2023-10-18 
Dernière modification : 2023-10-30

*/

DROP TRIGGER IF EXISTS prevent_delete_update_trig ON drone_state;
DROP TRIGGER IF EXISTS validate_insert_drone_state_trig ON drone_state;	
DROP FUNCTION IF EXISTS prevent_delete_update;
DROP FUNCTION IF EXISTS validate_insert_drone_state;
DROP FUNCTION IF EXISTS get_most_recent_insert_id(drone_param INTEGER);
DROP FUNCTION IF EXISTS get_most_recent_insert_state(drone_param INTEGER);
DROP FUNCTION IF EXISTS get_next_rejected_state(symbol_param CHAR(1));	
DROP FUNCTION IF EXISTS get_next_accepted_state(symbol_param CHAR(1));	
DROP FUNCTION IF EXISTS get_note_from_state(drone_id_param INTEGER);
DROP FUNCTION IF EXISTS insert_note(drone_state INTEGER, note note_type, date_time TIMESTAMP, employee INTEGER, details VARCHAR(2048));
DROP PROCEDURE IF EXISTS simulation_transition_multiple_drone_random();
DROP PROCEDURE IF EXISTS simulation_transition_multiple(drone_id INTEGER, date_commencement TIMESTAMP, date_fin TIMESTAMP);
DROP PROCEDURE IF EXISTS simulation_transition(drone_id INTEGER, date_insertion TIMESTAMP);


-- Une fonction de simulation simulant une transition pour un drone
CREATE OR REPLACE PROCEDURE simulation_transition(drone_id INTEGER, 
												  date_insertion TIMESTAMP)
LANGUAGE PLPGSQL
AS $$
DECLARE
	old_state CHAR(1) := get_most_recent_insert_state(drone_id);
	old_state_n_r_state CHAR(1) := get_next_rejected_state(old_state);
	old_state_n_a_state CHAR(1) := get_next_accepted_state(old_state);
	probability BOOLEAN := (SELECT random_event(0.75));
	random_employe INTEGER := random_integer(1, (SELECT COUNT(*) FROM employee)::INTEGER);
BEGIN
	IF probability = true THEN
		INSERT INTO drone_state(drone, state, employee, start_date_time, location) 
			VALUES (drone_id, old_state_n_a_state, random_employe, date_insertion, simulate_storage_localisation_tag());
	ELSE 
		INSERT INTO drone_state(drone, state, employee, start_date_time, location) 
			VALUES (drone_id, old_state_n_r_state, random_employe, date_insertion, simulate_storage_localisation_tag());
	END IF;
END$$;


-- Une fonction de simulation simulant n transitions pour un drone
CREATE OR REPLACE PROCEDURE simulation_transition_multiple(drone_id INTEGER, 
														   date_commencement TIMESTAMP, 
														   date_fin TIMESTAMP)
LANGUAGE plpgsql
AS $$
DECLARE
	nombre_insertion INTEGER := random_integer(1, 3); 								-- changer la deuxieme valeur pour modifier le nb de transitions
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
END$$; 


-- Une fonction de simulation simulant n transitions pour un drone généré aléatoirement
CREATE OR REPLACE PROCEDURE simulation_transition_multiple_drone_random()
LANGUAGE plpgsql
AS $$
DECLARE
	random_drone_id INTEGER;
	nombre_insertion INTEGER := 100; 												-- Changer la deuxieme valeur pour modifier le nb de transitions
	random_timestamp TIMESTAMP;
	i INTEGER;
	probability BOOLEAN := (SELECT random_event(0.75));
	date_commencement TIMESTAMP;
BEGIN
	FOR i IN 1..nombre_insertion LOOP
		random_drone_id := (SELECT id 
							  FROM drone 
						  ORDER BY random() LIMIT 1);						  
		date_commencement := (SELECT start_date_time 								-- Va chercher le start_date du dernier state insérer 
							    FROM drone_state
							   WHERE drone = random_drone_id 
							ORDER BY start_date_time DESC LIMIT 1);
		random_timestamp := (date_commencement + '10 HOUR'::INTERVAL)::TIMESTAMP;	-- Ajoute 10h au dernier changement de state
		probability := (SELECT random_event(0.75));
		
		IF probability = true THEN
			CALL simulation_transition(random_drone_id, random_timestamp);
		END IF;		
		
    END LOOP;
END$$; 

-- Insert dans la table state_note
-- Fonction qui retourne VOID, nous injectons des SELECT dans les paramêtre donc une procédure ne fonctionnerait pas.
CREATE OR REPLACE FUNCTION insert_note(drone_state INTEGER, 
									   note note_type, 
									   date_time TIMESTAMP, 
									   employee INTEGER, 
									   details VARCHAR(2048))
RETURNS VOID
LANGUAGE PLPGSQL
AS $$
BEGIN
	INSERT INTO state_note(drone_state, note, date_time, employee, details) 
		VALUES (drone_state, note, date_time, employee, details);
END$$;


--Récupérer la note du old state
CREATE OR REPLACE FUNCTION get_note_from_state(drone_id_param INTEGER)
RETURNS state_note.note%TYPE
LANGUAGE PLPGSQL
AS $$
DECLARE
	note_return state_note.note%TYPE;
BEGIN
	note_return := (SELECT note 
					  FROM state_note 
					 WHERE drone_state = drone_id_param 
				  ORDER BY date_time DESC LIMIT 1);
	RETURN note_return;
END$$; 


--Récupérer le prochain next_accepted_state																	   
CREATE OR REPLACE FUNCTION get_next_accepted_state(symbol_param CHAR(1)) 
RETURNS CHAR(1)
LANGUAGE PLPGSQL
AS $$
DECLARE 
	n_a_state CHAR(1);
BEGIN
	n_a_state := (SELECT next_accepted_state
			  	    FROM state
			       WHERE symbol = symbol_param);		  
	RETURN n_a_state;
END$$;


--Récupérer le prochain next_rejected_state																	   
CREATE OR REPLACE FUNCTION get_next_rejected_state(symbol_param CHAR(1)) 
RETURNS CHAR(1)
LANGUAGE PLPGSQL
AS $$
DECLARE 
	n_r_state CHAR(1);
BEGIN
	n_r_state := (SELECT next_rejected_state
			  	    FROM state
			       WHERE symbol = symbol_param);		  
	RETURN n_r_state;
END$$; 


--Récupérer le state de l'insert le plus recent avec drone
CREATE OR REPLACE FUNCTION get_most_recent_insert_state(drone_param INTEGER) 
RETURNS CHAR(1)
LANGUAGE PLPGSQL
AS $$
DECLARE 
	old_state CHAR(1);
BEGIN
	old_state := (SELECT state
			  	    FROM drone_state
			       WHERE drone = drone_param
			    ORDER BY start_date_time DESC LIMIT 1);		  
	RETURN old_state;
END$$;


--Récupérer l'id de l'insert le plus recent avec drone
CREATE OR REPLACE FUNCTION get_most_recent_insert_id(drone_param INTEGER) 
RETURNS INTEGER
LANGUAGE PLPGSQL
AS $$
DECLARE 
	old_id INTEGER;
BEGIN
	old_id := (SELECT id
			  	  FROM drone_state
			      WHERE drone = drone_param
				  ORDER BY start_date_time DESC
				  LIMIT 1);		  
	RETURN old_id;
END$$;

-- Fonction du TRIGGER prevent update
CREATE OR REPLACE FUNCTION prevent_delete_update () 
RETURNS TRIGGER
LANGUAGE PLPGSQL AS $$
BEGIN
	RAISE EXCEPTION 'Opération interdite [_OPERATION_NAME_] sur la table _TABLE_NAME_.';
END$$;

--Fonction du TRIGGER VALIDATE
CREATE OR REPLACE FUNCTION validate_insert_drone_state()
RETURNS TRIGGER
LANGUAGE plpgsql 
AS $$
DECLARE
	old_state CHAR(1);																			   
	old_state_next_accepted_state CHAR(1);
	old_state_next_rejected_state CHAR(1);
	
	old_state_note note_type;
	old_state_number_insertion INTEGER := (SELECT COUNT(*) FROM drone_state WHERE drone_state.drone = NEW.drone);
	
	validate_r_a_state BOOLEAN := false;
	validate_note_old_state BOOLEAN := false;
	validate_horodatage BOOLEAN := false;
BEGIN
-- 1. Si le dernier state était final alors la prochaine tentative aura une valeur NULL, 
-- donc si la tentative est NULL on retourne NULL directement et ignore l'insertion

	IF NEW.state IS NULL THEN
		RETURN NULL;
	END IF;
	
-- 2. fonction qui verifie si le state est bon ou mauvais en fonct du na_state et nr_state
																
	old_state := get_most_recent_insert_state(New.drone);
	old_state_next_accepted_state := get_next_accepted_state(old_state);
	old_state_next_rejected_state := get_next_rejected_state(old_state);
	
	old_state_note := get_note_from_state(New.drone); 
																				  
	IF NEW.state = old_state_next_accepted_state OR NEW.state = old_state_next_rejected_state THEN
 		validate_r_a_state := true;
	ELSE 
		RAISE NOTICE 'MAUVAISE INSERTION LE STATE DOIT EGAL a % ou a %', old_state_next_accepted_state, old_state_next_rejected_state;
	END IF;
	
-- 3. partie qui verifie si la note associe a l'ancien state est la bonne
 	
	IF New.state = old_state_next_accepted_state AND old_state = 'R' THEN -- i.e si NEW.state = i
		IF old_state_note = 'problematic_observation'::note_type OR old_state_note = 'maintenance_performed'::note_type OR old_state_note = 'repair_completed'::note_type THEN
			validate_note_old_state = true;	
		END IF;
	ELSIF New.state = old_state_next_accepted_state OR NEW.state = old_state_next_rejected_state THEN
		validate_note_old_state = true;
	ELSIF New.state = old_state_next_rejected_state AND old_state_note = 'problematic_observation'::note_type THEN
		validate_note_old_state = true;
	END IF;
	
-- 4.  partie qui verifie si le temps en insertion est plus petit que le temps actuel
	
	IF NEW.start_date_time > (SELECT start_date_time FROM drone_state WHERE drone_state.drone = NEW.drone ORDER BY start_date_time DESC LIMIT 1) THEN
		validate_horodatage = true;
	END IF;
	
-- 5. partie de la fonction qui vérifie si toute les conditions d'insertion sont remplies puis insert le message concéquent

  	IF validate_r_a_state = true AND validate_note_old_state = true AND validate_horodatage = true THEN
		RAISE NOTICE 'Valid insert';
		IF New.state = old_state_next_accepted_state AND old_state = 'R' THEN
			PERFORM insert_note(NEW.drone, 'maintenance_performed', NEW.start_date_time, NEW.employee, concat('Maintenance done by : ', 
								(SELECT first_name FROM employee WHERE id = New.employee), ' ',(SELECT last_name FROM employee WHERE id = New.employee), ' on ',  NEW.start_date_time::DATE));
		ELSIF New.state = old_state_next_rejected_state THEN
			PERFORM insert_note(NEW.drone, 'problematic_observation', NEW.start_date_time, NEW.employee, concat('Problematic observation made by : ', 
								(SELECT first_name FROM employee WHERE id = NEW.employee), ' ',(SELECT last_name FROM employee WHERE id = NEW.employee), ' on ',  NEW.start_date_time::DATE));
		ELSE
			PERFORM insert_note(NEW.drone, 'general_observation', NEW.start_date_time, NEW.employee, concat('State transition approved by : ', 
								(SELECT first_name FROM employee WHERE id = NEW.employee), ' ',(SELECT last_name FROM employee WHERE id = NEW.employee), ' on ',  NEW.start_date_time::DATE));
		END IF;
		
    	RETURN NEW;
  	ELSE
    	RAISE EXCEPTION 'Insert validation failed';
  	END IF;
END$$; 
  
-- Trigger before insert
CREATE TRIGGER validate_insert_drone_state_trig
BEFORE INSERT
ON drone_state
FOR EACH ROW
EXECUTE FUNCTION validate_insert_drone_state();


--Trigger before update or delete
CREATE TRIGGER prevent_delete_update_trig
BEFORE UPDATE OR DELETE
ON drone_state
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_update();


