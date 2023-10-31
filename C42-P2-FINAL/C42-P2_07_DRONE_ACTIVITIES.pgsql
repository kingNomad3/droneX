/*

C42-P2_07_DRONE_ACTIVITIES.pgsql
420-C42-IN Langages d'exploitation des bases de données
Auteurs : Julien Coulombe-Morency, Benjamin Joinvil, Édouard Blain-Noël, François Maltais, Catherine Lavoie, Remi Chuet
Date de création : 2023-10-18 
Dernière modification : 2023-10-30

*/

DROP TRIGGER IF EXISTS prevent_delete_update_trig ON drone_state;
DROP TRIGGER IF EXISTS insert_into_state_note_trig ON drone_state;
DROP TRIGGER IF EXISTS validate_insert_drone_state_trig ON drone_state;	
DROP FUNCTION IF EXISTS insert_into_state_note;
DROP FUNCTION IF EXISTS get_previous_state(drone_param INTEGER);
DROP FUNCTION IF EXISTS validate_insert_drone_state;
DROP FUNCTION IF EXISTS prevent_delete_update;
DROP FUNCTION IF EXISTS get_last_state(p_drone_id INTEGER, is_before BOOLEAN);
DROP FUNCTION IF EXISTS get_note_from_state(drone_id_param INTEGER);
DROP FUNCTION IF EXISTS insert_note(drone_state INTEGER, note note_type, date_time TIMESTAMP, employee INTEGER, details VARCHAR(2048));
DROP PROCEDURE IF EXISTS simulation_transition_multiple_drone_random(nombre_insertion INTEGER);
DROP PROCEDURE IF EXISTS simulation_transition_multiple(drone_id INTEGER, date_commencement TIMESTAMP, date_fin TIMESTAMP);
DROP PROCEDURE IF EXISTS simulation_transition(drone_id INTEGER, date_insertion TIMESTAMP);


-- Une fonction de simulation simulant une transition pour un drone
CREATE OR REPLACE PROCEDURE simulation_transition(drone_id INTEGER, 
												  date_insertion TIMESTAMP)
LANGUAGE PLPGSQL
AS $$
DECLARE
	old_state state%ROWTYPE;
	
	probability BOOLEAN := (SELECT random_event(0.75));
	random_employe INTEGER := random_integer(1, (SELECT COUNT(*) FROM employee)::INTEGER);
BEGIN
	old_state := get_last_state(drone_id, TRUE);	
	
	IF probability = true THEN
		INSERT INTO drone_state(drone, state, employee, start_date_time, location) 
			VALUES (drone_id, old_state.next_accepted_state, random_employe, date_insertion, simulate_storage_localisation_tag());
	ELSE 
		INSERT INTO drone_state(drone, state, employee, start_date_time, location) 
			VALUES (drone_id, old_state.next_rejected_state, random_employe, date_insertion, simulate_storage_localisation_tag());
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
			CALL simulation_transition(drone_id, random_timestamp);
		END IF;
    END LOOP;
END$$; 


-- Une fonction de simulation simulant n transitions pour un drone généré aléatoirement
CREATE OR REPLACE PROCEDURE simulation_transition_multiple_drone_random(nombre_insertion INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
	random_drone_id INTEGER;												-- Changer la deuxieme valeur pour modifier le nb de transitions
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


--Récupérer la note du dernier state

CREATE OR REPLACE FUNCTION get_note_from_state(drone_id_param INTEGER)
RETURNS state_note.note%TYPE
LANGUAGE PLPGSQL
AS $$
DECLARE
	last_state_note state_note.note%TYPE;
BEGIN
	last_state_note := (SELECT note 
					  FROM state_note 
					 WHERE drone_state = (SELECT id FROM drone_state 
					                       WHERE drone = drone_id_param 
										ORDER BY start_date_time DESC LIMIT 1));
	RETURN last_state_note;
END$$; 


-- Fonction qui permet de retourner la Row au complet du dernier state
-- On passe TRUE pour son utilisation dans un trigger BEFORE
-- FALSE pour son utilisation dans un trigger AFTER

CREATE OR REPLACE FUNCTION get_last_state(p_drone_id INTEGER, is_before BOOLEAN) 
RETURNS state 
LANGUAGE plpgsql
AS $$
DECLARE
    last_state state;
BEGIN

    IF is_before THEN
        SELECT * INTO last_state
        FROM state
        WHERE symbol = (SELECT state FROM drone_state WHERE drone = p_drone_id
                                ORDER BY start_date_time DESC
                                    LIMIT 1); 
        
        RETURN last_state;
    ELSE
        SELECT * INTO last_state
        FROM state
        WHERE symbol = (SELECT state FROM drone_state WHERE drone = p_drone_id
                                ORDER BY start_date_time DESC
                                    LIMIT 1 OFFSET 1);
        RETURN last_state; 
    END IF;

    RAISE EXCEPTION 'Pas trouvé de state pour drone_id : %  et is_before : %', p_drone_id, is_before;
    
END$$ ;


-- Fonction du TRIGGER prevent update

CREATE OR REPLACE FUNCTION prevent_delete_update () 
RETURNS TRIGGER
LANGUAGE PLPGSQL AS $$
BEGIN
	RAISE EXCEPTION 'Opération % interdite dans table %', TG_OP, TG_TABLE_NAME;
END$$;

--Fonction du TRIGGER VALIDATE

CREATE OR REPLACE FUNCTION validate_insert_drone_state()
	RETURNS TRIGGER
LANGUAGE plpgsql 
AS $$
DECLARE
	old_state state%ROWTYPE;																			   	
	old_state_note note_type; 
	
	validate_r_a_state BOOLEAN := false;
	validate_note_old_state BOOLEAN := false;
	validate_horodatage BOOLEAN := false;
BEGIN
	
	old_state  := get_last_state(NEW.drone, TRUE);	
	old_state_note := get_note_from_state(NEW.drone); 
	
-- 1. Si le dernier state était final alors la prochaine tentative aura une valeur NULL, 
-- donc si la tentative est NULL on retourne NULL directement et ignore l'insertion

	IF NEW.state IS NULL THEN
		RETURN NULL;
	END IF;
	
-- 2. fonction qui verifie si le state est bon ou mauvais en fonct du na_state et nr_state
																				  
	IF NEW.state = old_state.next_accepted_state OR NEW.state = old_state.next_rejected_state THEN
 		validate_r_a_state := true;
	END IF;
	
-- 3. partie qui verifie si la note associe a l'ancien state est la bonne
 	
	IF NEW.state = old_state.next_accepted_state AND old_state.symbol = 'R' THEN -- i.e si NEW.state = i
		IF old_state_note = 'problematic_observation'::note_type 
		OR old_state_note = 'maintenance_performed'::note_type 
		OR old_state_note = 'repair_completed'::note_type THEN
			validate_note_old_state = true;	
		END IF;
	ELSIF NEW.state = old_state.next_accepted_state THEN
		validate_note_old_state = true;
	ELSIF NEW.state = old_state.next_rejected_state AND old_state_note = 'problematic_observation'::note_type THEN
		validate_note_old_state = true;
	END IF;
	
-- 4.  partie qui verifie si le temps en insertion est plus petit que le temps actuel
	
	IF NEW.start_date_time > (SELECT start_date_time FROM drone_state WHERE drone_state.drone = NEW.drone ORDER BY start_date_time DESC LIMIT 1) THEN
		validate_horodatage = true;
	END IF;
	
-- 5. partie de la fonction qui vérifie si toute les conditions d'insertion sont remplies puis insert le message concéquent

  	IF validate_r_a_state = true AND validate_note_old_state = true AND validate_horodatage = true THEN
    	RETURN NEW;
  	ELSE
    	RAISE EXCEPTION 'Insert validation failed: validate_r_a_state %  validate_note_old_state %  validate_horodatage %', validate_r_a_state, validate_note_old_state, validate_horodatage;
  	END IF;
END$$; 


-- Trigger after insert in drone_state that inserts state_notes:

CREATE OR REPLACE FUNCTION insert_into_state_note() 
	RETURNS TRIGGER
LANGUAGE PLPGSQL 
AS $$
DECLARE
	old_state state%ROWTYPE;																		   
BEGIN
	old_state  := get_last_state(NEW.drone, FALSE);	

	IF NEW.state = old_state.next_accepted_state AND old_state.symbol = 'R' THEN
		PERFORM insert_note(NEW.id, 'maintenance_performed', NEW.start_date_time, NEW.employee, concat('Maintenance done by : ', 
							(SELECT first_name FROM employee WHERE id = New.employee), ' ',(SELECT last_name FROM employee WHERE id = New.employee), ' on ',  NEW.start_date_time::DATE));
	ELSIF NEW.state = old_state.next_rejected_state THEN
		PERFORM insert_note(NEW.id, 'problematic_observation', NEW.start_date_time, NEW.employee, concat('Problematic observation made by : ', 
							(SELECT first_name FROM employee WHERE id = NEW.employee), ' ',(SELECT last_name FROM employee WHERE id = NEW.employee), ' on ',  NEW.start_date_time::DATE));
	ELSE
		PERFORM insert_note(NEW.id, 'general_observation', NEW.start_date_time, NEW.employee, concat('State transition approved by : ', 
							(SELECT first_name FROM employee WHERE id = NEW.employee), ' ',(SELECT last_name FROM employee WHERE id = NEW.employee), ' on ',  NEW.start_date_time::DATE));
	END IF;

	RETURN NULL;
END$$;
  
-- Trigger before insert into drone_state
CREATE TRIGGER validate_insert_drone_state_trig
BEFORE INSERT
ON drone_state
FOR EACH ROW
EXECUTE FUNCTION validate_insert_drone_state();

--Trigger after insert into drone_state
CREATE TRIGGER insert_into_state_note_trig
AFTER INSERT
ON drone_state
FOR EACH ROW
EXECUTE FUNCTION insert_into_state_note();

--Trigger before update or delete
CREATE TRIGGER prevent_delete_update_trig
BEFORE UPDATE OR DELETE
ON drone_state
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_update();


/*CALL DES FONCTION DE SIMULATION */

-- CALL simulation_transition_multiple_drone_random(50)	-- Changer le chiffre pour générer plus de transition

-- SELECT * FROM state_note WHERE drone_state = 130
-- SELECT * FROM drone
-- SELECT * FROM drone_state WHERE drone = 28











