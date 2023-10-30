SELECT drone_model.name AS "Model", 
       drone.drone_tag AS "Tag", 
	   drone.serial_number AS "Serial number", 
	   state.name AS "Current state", 
	   drone_state.start_date_time AS "Effective start date"
  FROM drone  
  JOIN drone_state
    ON drone.id = drone_state.drone
  JOIN drone_model
    ON drone.model = drone_model.id
  JOIN state
    ON drone_state.state = state.symbol
ORDER BY "Model" ASC, "Effective start date" DESC, "Tag" ASC;

-- versus ça 
SELECT (SELECT name 
          FROM drone_model 
		 WHERE id = drone.model) AS model,

	   drone_tag, 

	   serial_number, 

	   (SELECT name 
		  FROM state 
		 WHERE symbol = (SELECT state 
		                   FROM drone_state 
						  WHERE drone = drone.id)) AS etat,

	   (SELECT start_date_time 
		  FROM drone_state 
		 WHERE drone = drone.id) AS date_effectif

  FROM drone
 ORDER BY model ASC, acquisition_date DESC, drone_tag ASC;
 
 -----------
 
 SELECT (SELECT STRING_AGG(name, ',' ORDER BY name)  
		  FROM operational_domain, drone_domain 
		  WHERE id = drone_domain.domain AND drone_domain.model = drone.model) AS domain_operationnel,
			
		  (SELECT name 
		  FROM drone_model 
		  WHERE id = drone.model) AS model,
			
		  drone_tag AS drone_tag, 

		  (SELECT start_date_time 
		  FROM drone_state 
	      WHERE drone = drone.id AND state = 'D') AS date_disponibilite,
			
		  (SELECT location 
		  FROM drone_state 
		  WHERE drone = drone.id AND state = 'D') AS localisation,
			
		  (SELECT count(*) 
		  FROM state_note, drone_state 
		  WHERE drone_state = drone_state.id AND drone_state.drone = drone.id ) AS nb_inspection

	 FROM drone
 ORDER BY domain_operationnel ASC, model ASC, date_disponibilite ASC;
 
-- requête #3
-- incomplète


INSERT INTO state_note VALUES (DEFAULT, 80, 'general_observation', now()::timestamp, 5, 'SEND TO REPARA AND DONT TALKA TOM E AGAIN');
INSERT INTO drone_state VALUES (DEFAULT, 2, 'R', 2, now()::timestamp, 'XB 000.MAG-600.^IZ00');

SELECT * FROM state_note
  JOIN (SELECT * FROM drone_state WHERE drone = 75) AS sub
    ON state_note


SELECT DISTINCT state.name AS "Status", 
       sub.start_date_time AS "Start time of status", 
	   employee.first_name || ' ' || employee.last_name AS "Employee", 
	   etat.note_amount AS "Number of activities"
  FROM state_note 
  JOIN
  (SELECT * FROM drone_state WHERE drone = 75) AS "sub"
  ON state_note.drone_state = sub.id
  JOIN state
    ON sub.state = state.symbol
  JOIN employee
    ON sub.employee = employee.id
  JOIN (SELECT drone_state, 
		       COUNT(*) AS "note_amount" 
		  FROM state_note 
		 GROUP BY drone_state) AS "etat"
    ON etat.drone_state = sub.id;

--SELECT drone, state, COUNT(*) FROM drone_state WHERE drone = 1 GROUP BY drone, state

--SELECT * FROM drone_state