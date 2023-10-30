-- requête 1 Edouard (était dans mes notes)
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
