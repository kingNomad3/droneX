/************************ Populate test **************************************/
BEGIN;

	INSERT INTO state (symbol, name, description, next_accepted_state, next_rejected_state)
		VALUES
			('I', 'Inspection', 'Évaluation visuelle ou technique d''un drone pour vérifier son état et sa conformité aux normes.', 'T', 'R'),
			('T', 'Test', 'Exécution de procédures spécifiques pour évaluer la performance et la fonctionnalité d''un drone.', 'P', 'R'),
			('P', 'Préparation', 'Mise en place et ajustement d''un drone avant son utilisation ou sa mise en service.', 'D', 'I'),
			('D', 'Disponibilité', 'Confirmation que le drone est opérationnel et prêt à être loué. Le drone est stocké.', 'L', 'I'),
			('L', 'Location', 'Le drone est loué à un client.', 'I', 'U'),
			('R', 'Réparation', 'Action de remettre en état de fonctionnement un drone qui est défectueux ou endommagé.', 'I', 'H'),
			('U', 'Perdu', 'État d''un drone qui n''a pas été retrouvé après une recherche ou qui n''est pas à son emplacement attendu.', NULL, NULL),
			('H', 'Hors-service', 'État d''un drone qui n''est plus en condition de fonctionnement ou qui a été mis hors service pour diverses raisons. Le drone peut tout de même ètre utilisé pour ses pièces.', NULL, NULL);
			
COMMIT;

INSERT INTO manufacturing_company(name , web_site)VALUES ('site 1', 'desc');
INSERT INTO drone_model(name, manufacturer, description, web_site) VALUES ('machine', 1, 'blab baffsfsfsfsfl', 'dad' );
INSERT INTO drone(model, serial_number, drone_tag, acquisition_date) VALUES (1, 'premier dans liste', 'tag premier', '1999-01-01');
INSERT INTO employee VALUES(1,'dddddd', 'dsdsds', 'rrrrr', 'probation', 'dasdasda');



INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (1, 'I', 1,'2000-05-01', 'dasda');
INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (1, 'T', 1,'2000-06-01', 'dasda');
INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (1, 'P', 1,'2000-07-01', 'dasda');

-- Le insert pour tester les fonctions (s'assurer que les fonctions et le trigger sont créés avant de rouler)
INSERT INTO drone_state(drone, state, employee, location) VALUES (1, 'I', 1,'dasda');
INSERT INTO drone_state(drone, state, employee, location) VALUES (1, 'R', 1,'dasda');

SELECT insert_note(1, 'problematic_observation', NOW()::TIMESTAMP, 1, 'qwewqeqeqeqewqewqewqeqeqweqweqweqwe');
SELECT insert_note(1, 'problematic_observation', NOW()::TIMESTAMP, 1, 'qwewqeqeqeqewqewqewqeqeqweqweqweqwe');
SELECT insert_note(1, 'problematic_observation', NOW()::TIMESTAMP, 1, 'qwewqeqeqeqewqewqewqeqeqweqweqweqwe');
																	  
SELECT * from drone_state;

SELECT * FROM state_note;
/**********************************************************************/

/****************************** Insert dans la table state_note *******************/
--DROP FUNCTION IF EXISTS insert_note(drone_state INTEGER, note note_type, date_time TIMESTAMP, employee INTEGER, details VARCHAR(2048));
CREATE OR REPLACE FUNCTION insert_note(drone_state INTEGER, note note_type, date_time TIMESTAMP, employee INTEGER, details VARCHAR(2048))
RETURNS VOID
AS $$
BEGIN

INSERT INTO state_note(drone_state, note, date_time, employee, details) VALUES (drone_state, note, date_time, employee, details);

END;
$$ LANGUAGE PLPGSQL;
/*******************************************************************************/

/************************************ Récupérer la note du old state *************************/
--DROP FUNCTION get_note_from_state(drone_id_param INTEGER);

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
--DROP FUNCTION IF EXISTS get_next_accepted_state(symbol_param CHAR(1));																				   
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
--DROP FUNCTION IF EXISTS get_next_rejected_state(symbol_param CHAR(1));																				   
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
--DROP FUNCTION IF EXISTS get_most_recent_insert_state(drone_param INTEGER);
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
-- DROP FUNCTION IF EXISTS get_most_recent_insert_id(drone_param INTEGER)
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
--DROP FUNCTION IF EXISTS validate_insert_drone_state();																				   
CREATE OR REPLACE FUNCTION validate_insert_drone_state()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
	insert_correct BOOLEAN := false; -- variable qui valide si les conditions sont remplies;
	drone INTEGER;
	state CHAR(1);
	employee INTEGER;
	location CHAR(19) DEFAULT 'XB 000.MAG-600.AZ00';
																				   
	old_state CHAR(1);																			   
	old_state_next_accepted_state CHAR(1);
	old_state_next_rejected_state CHAR(1);
	
	old_state_note note_type;
	
	-- AIDE MEMOIRE
	
	validate_r_a_state BOOLEAN;
	validate_note_old_state BOOLEAN;
	

BEGIN
	
-- 1. Assignation des variables

	drone := NEW.drone;
	state := NEW.state;
	employee := NEW.employee;
	
	IF NEW.location IS NOT NULL THEN
		location := NEW.location;
	END IF;
	
	validate_r_a_state := false;
	validate_note_old_state := false;
	
	
	
	
 -- 2. fonction qui verifie si le state est bon ou mauvais en fonct du na_state et nr_state
																
	old_state := (SELECT get_most_recent_insert_state(drone));
	old_state_next_accepted_state := (SELECT get_next_accepted_state(old_state));
	old_state_next_rejected_state := (SELECT get_next_rejected_state(old_state));
	
	old_state_note := (SELECT get_note_from_state(drone));
	
-- 					SELECT get_note_from_state(get_most_recent_insert_id(1)
																				  
	IF state = old_state_next_accepted_state OR state = old_state_next_rejected_state THEN
 		validate_r_a_state := true;
	ELSE 
		RAISE NOTICE 'MAUVAISE INSERTION LE STATE DOIT EGAL a % ou a %', old_state_next_accepted_state, old_state_next_rejected_state;
	END IF;
	
 -- 3. fonction qui verifie si la note associe a l'ancien state est la bonne
 	
	IF state = old_state_next_accepted_state THEN
		IF old_state_note = 'problematic_observation'::note_type 
		OR old_state_note = 'maintenance_performed'::note_type 
		OR old_state_note = 'repair_completed'::note_type THEN
			validate_note_old_state = true;	
			RAISE NOTICE 'test';
		END IF;
	END IF;
	
	IF state = old_state_next_rejected_state AND old_state_note = 'problematic_observation'::note_type THEN
		validate_note_old_state = true;	
	END IF;
 
 
 
 
 
	
	IF old_state_note = 'problematic_observation'::note_type THEN
		
	ELSE 
		RAISE NOTICE 'la note ne correspond pas';
	END IF;
			
	
	
	IF validate_r_a_state = true AND validate_note_old_state = true THEN
		insert_correct = true;
	END IF;
 

  	IF insert_correct THEN
  	-- Fonction insert dans state_note
  		NEW.start_date_time := NOW()::TIMESTAMP;
		RAISE NOTICE 'BONNE INSERTION DANS DRONE_STATE !!!';
			PERFORM insert_note(1, 'problematic_observation', NOW()::TIMESTAMP, 1, 'qwewqeqeqeqewqewqewqeqeqweqweqweqwe');
    	RETURN NEW;
  	ELSE
    	RAISE EXCEPTION 'Insert validation failed';
  	END IF;
END;
$$;
/************************************************************/
  

/****************************** TRIGGER BEFORE INSERT  *****************************/
--DROP TRIGGER IF EXISTS validate_insert_drone_state ON drone_state;																				 
CREATE TRIGGER validate_insert_drone_state
BEFORE INSERT
ON drone_state
FOR EACH ROW
EXECUTE FUNCTION validate_insert_drone_state();
/**********************************************************************/

