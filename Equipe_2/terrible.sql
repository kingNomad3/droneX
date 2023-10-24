CREATE OR REPLACE FUNCTION getLastDroneState(p_drone_id INT)
RETURNS CHAR(1) LANGUAGE plpgsql AS $$
DECLARE
    v_last_state CHAR(1);
BEGIN
    -- Récupérer le dernier état pour le drone donné
    SELECT state_symbol INTO last_state
    FROM drone_state
    WHERE drone_id = p_drone_id
    ORDER BY start_date_time DESC
    LIMIT 1;
    
    RETURN v_last_state;
END;
$$ ;


DROP FUNCTION
CREATE OR REPLACE FUNCTION TESTESTEST() RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE rec state%ROWTYPE;
BEGIN

SELECT * INTO rec FROM state WHERE symbol = 'T';

RETURN 'P' IN (
	rec.next_accepted_state, rec.next_rejected_state
);

END
$$
SELECT TESTESTEST()


DROP TRIGGER IF EXISTS drone_state_trig ON drone_state;
DROP FUNCTION drone_state_ins;
CREATE FUNCTION drone_state_ins() RETURNS TRIGGER 
LANGUAGE PLPGSQL AS
$$
DECLARE 
	dernier_insert drone_state%ROWTYPE;
	
BEGIN

		SELECT * 
		  INTO dernier_insert
		  FROM drone_state 
		 WHERE drone = NEW.drone 
		 ORDER BY start_date_time DESC
		 LIMIT 1;
		 
	RAISE NOTICE 'dernier insert';
	
	
	
	
	
	IF NEW.state IN (
		SELECT next_accepted_state 
		  FROM state 
		 WHERE symbol = dernier_insert.state
 			   UNION
 		SELECT next_rejected_state
 		  FROM state
 		 WHERE symbol = dernier_insert.state
	) THEN RAISE NOTICE 'Ça marche';
	ELSE RAISE EXCEPTION 'Ça marche pas d`insérer % après %', NEW.state, dernier_insert.state;
	END IF;
	
	RETURN NEW;
END;
$$;
 CREATE OR REPLACE TRIGGER drone_state_trig 
  BEFORE INSERT ON drone_state
 	  FOR EACH ROW 
  EXECUTE FUNCTION drone_state_ins();
  
-- insert test dans drone
INSERT INTO drone (model, serial_number, drone_tag, acquisition_date) 
     VALUES (1, 'TESTESTESTEST', '12345678912345678912', NOW());

	 SELECT * FROM employee
INSERT INTO drone_state VALUES (DEFAULT, 1, 'T', 1, NOW(), 'BLABLA');
SELECT * FROM drone_state;

		SELECT 'T' IN ((SELECT next_accepted_state FROM state WHERE symbol = 'T'),(SELECT next_rejected_state
 		  FROM state
 		 WHERE symbol = 'T'
		))
		

