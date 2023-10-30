DROP TRIGGER IF EXISTS validate_insert_drone_state ON drone_state;	
DROP FUNCTION IF EXISTS validate_insert_drone_state();
DROP FUNCTION IF EXISTS get_most_recent_insert_id(drone_param INTEGER);
DROP FUNCTION IF EXISTS get_most_recent_insert_state(drone_param INTEGER);
DROP FUNCTION IF EXISTS get_next_rejected_state(symbol_param CHAR(1));	
DROP FUNCTION IF EXISTS get_next_accepted_state(symbol_param CHAR(1));	
DROP FUNCTION IF EXISTS get_note_from_state(drone_id_param INTEGER);
DROP FUNCTION IF EXISTS insert_note(drone_state INTEGER, note note_type, date_time TIMESTAMP, employee INTEGER, details VARCHAR(2048));

/****************************** Insert dans la table state_note *******************/

CREATE OR REPLACE FUNCTION insert_note(drone_state INTEGER, note note_type, date_time TIMESTAMP, employee INTEGER, details VARCHAR(2048))
RETURNS VOID
AS $$
BEGIN

INSERT INTO state_note(drone_state, note, date_time, employee, details) VALUES (drone_state, note, date_time, employee, details);

END;
$$ LANGUAGE PLPGSQL;
/*******************************************************************************/

/************************************ Récupérer la note du old state *************************/


CREATE OR REPLACE FUNCTION get_note_from_state(drone_id_param INTEGER)
RETURNS note_type
AS $$
DECLARE
	note_return note_type;
BEGIN
	
	note_return := (SELECT note FROM state_note WHERE drone_state = drone_id_param ORDER BY date_time DESC LIMIT 1);
	
	RAISE NOTICE '%', note_return;
	

RETURN note_return;

END;
$$ LANGUAGE PLPGSQL;
--SELECT get_note_from_state(1);


/****************************** Récupérer le prochain next_accepted_state *******************/
																			   
CREATE OR REPLACE FUNCTION get_next_accepted_state(symbol_param CHAR(1)) 
RETURNS CHAR(1)
AS $$
DECLARE 
	n_a_state CHAR(1);
BEGIN
	n_a_state := (SELECT next_accepted_state
			  	  FROM state
			      WHERE symbol = symbol_param);		  
	RETURN n_a_state;
END
$$ LANGUAGE PLPGSQL;

-- TEST :
-- SELECT get_next_accepted_state('D')
/**********************************************************************/

/****************************** Récupérer le prochain next_rejected_state *******************/
																			   
CREATE OR REPLACE FUNCTION get_next_rejected_state(symbol_param CHAR(1)) 
RETURNS CHAR(1)
AS $$
DECLARE 
	n_r_state CHAR(1);
BEGIN
	n_r_state := (SELECT next_rejected_state
			  	  FROM state
			      WHERE symbol = symbol_param);		  
	RETURN n_r_state;
END
$$ LANGUAGE PLPGSQL;

-- TEST :
-- SELECT get_next_rejected_state('D')
/**********************************************************************/


/****************************** Récupérer le state de l'insert le plus recent avec drone *******************/

CREATE OR REPLACE FUNCTION get_most_recent_insert_state(drone_param INTEGER) 
RETURNS CHAR(1)
AS $$
DECLARE 
	old_state CHAR(1);
BEGIN
	old_state := (SELECT state
			  	  FROM drone_state
			      WHERE drone = drone_param
				  ORDER BY start_date_time DESC
				  LIMIT 1);		  
	RETURN old_state;
END
$$ LANGUAGE PLPGSQL;
-- SELECT get_most_recent_insert_state(1)
/************************************************************/

/****************************** Récupérer l'id de l'insert le plus recent avec drone *******************/

CREATE OR REPLACE FUNCTION get_most_recent_insert_id(drone_param INTEGER) 
RETURNS INTEGER
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
END
$$ LANGUAGE PLPGSQL;
-- SELECT get_most_recent_insert_id()
/**********************************************************************/







/****************************** Fonction du TRIGGER *******************/


CREATE OR REPLACE FUNCTION validate_insert_drone_state()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
	
	drone INTEGER;
	state CHAR(1);
	employee INTEGER;
	location CHAR(20) DEFAULT 'XB 000.MAG-600.^IZ00';
	
	
	insert_correct BOOLEAN := false; -- variable qui valide si les conditions sont remplies;
	old_state CHAR(1);																			   
	old_state_next_accepted_state CHAR(1);
	old_state_next_rejected_state CHAR(1);
	
	old_state_note note_type;
	
	old_state_number_insertion INTEGER;
	
	validate_r_a_state BOOLEAN;
	validate_note_old_state BOOLEAN;
	validate_horodatage BOOLEAN;
	
BEGIN
	
-- 1. Assignation des variables

	drone := NEW.drone;
	state := NEW.state;
	employee := NEW.employee;
	
	IF NEW.location IS NOT NULL THEN
		location := NEW.location;
	END IF;
	
	IF state IS NULL THEN
		RETURN NULL;
	END IF;
	
	validate_r_a_state := false;
	validate_note_old_state := false;
	validate_horodatage := false;
	
	old_state_number_insertion = (SELECT COUNT(*) FROM drone_state WHERE drone_state.drone = NEW.drone);
	
 -- 3. fonction qui verifie si le state est bon ou mauvais en fonct du na_state et nr_state
																
	old_state := (SELECT get_most_recent_insert_state(drone));
	old_state_next_accepted_state := (SELECT get_next_accepted_state(old_state));
	old_state_next_rejected_state := (SELECT get_next_rejected_state(old_state));
	
	old_state_note := (SELECT get_note_from_state(drone)); 
																				  
	IF state = old_state_next_accepted_state OR state = old_state_next_rejected_state THEN
 		validate_r_a_state := true;
	ELSE 
		RAISE NOTICE 'MAUVAISE INSERTION LE STATE DOIT EGAL a % ou a %', old_state_next_accepted_state, old_state_next_rejected_state;
	END IF;
	
 -- 4. partie qui verifie si la note associe a l'ancien state est la bonne
 
 	
	IF state = old_state_next_accepted_state AND old_state = 'R' THEN -- i.e si NEW.state = i
		IF old_state_note = 'problematic_observation'::note_type 
		OR old_state_note = 'maintenance_performed'::note_type 
		OR old_state_note = 'repair_completed'::note_type THEN
			validate_note_old_state = true;	
		END IF;
	END IF;
	
	IF state = old_state_next_accepted_state OR state = old_state_next_rejected_state THEN
		validate_note_old_state = true;
	END IF;
		
	
	IF state = old_state_next_rejected_state AND old_state_note = 'problematic_observation'::note_type THEN
		validate_note_old_state = true;
	END IF;
	
	RAISE NOTICE 'state value % : old state : %', state, old_state_next_accepted_state;
	RAISE NOTICE 'old_state_note value %', validate_note_old_state;
	
	-- 4.  partie qui verifie si le temps en insertion est plus petit que le temps actuel
	
	IF NEW.start_date_time > (SELECT start_date_time FROM drone_state WHERE drone_state.drone = NEW.drone ORDER BY start_date_time DESC LIMIT 1) THEN
		validate_horodatage = true;
	END IF;
	
	RAISE NOTICE 'horodatage value %', validate_horodatage;
	
	IF validate_r_a_state = true AND validate_note_old_state = true AND validate_horodatage = true THEN
		insert_correct = true;
	END IF;
	
	
-- 5. partie de la fonction qui vérifie si toute les conditions d'insertion sont remplies
 

  	IF insert_correct THEN
  	-- Fonction insert dans state_note en fonction de NEW.state
		RAISE NOTICE 'Valid insert';
		IF state = old_state_next_accepted_state AND old_state = 'R' THEN
			PERFORM insert_note(NEW.drone, 'maintenance_performed', NEW.start_date_time, NEW.employee, concat('Maintenance done by : ', 
								(SELECT first_name FROM employee WHERE id = New.employee), ' ',(SELECT last_name FROM employee WHERE id = New.employee), ' on ',  NEW.start_date_time::DATE));
		
		ELSIF state = old_state_next_rejected_state THEN
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
/************************************************************/
  
  
/****************************** TRIGGER BEFORE INSERT  *****************************/
	

CREATE TRIGGER validate_insert_drone_state
BEFORE INSERT
ON drone_state
FOR EACH ROW
EXECUTE FUNCTION validate_insert_drone_state();
/**********************************************************************/


select * from state_note
