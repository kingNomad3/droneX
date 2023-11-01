-- manque le nombre d'inspection, manque le operation domain

-- SELECT drone.model, drone.drone_tag, temp.max, drone_state.location FROM drone 
--   JOIN (SELECT drone, max(start_date_time) FROM drone_state GROUP BY drone ORDER BY drone) as "temp"
--     ON drone.id = temp.drone
--   JOIN drone_state
--     ON drone_state.start_date_time = temp.max 
-- WHERE drone_state.state = 'D'
-- ORDER BY drone.id

--  SELECT name
-- 		  FROM operational_domain, drone_domain 
-- 		  WHERE id = drone_domain.domain AND drone_domain.model = drone.model
		  
-- SELECT *
--   FROM drone_domain 
--   JOIN drone
--     ON drone_domain.model = drone.model
--   JOIN operational_domain
--     ON drone_domain.domain = operational_domain.id