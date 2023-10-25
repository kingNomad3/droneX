/* REQUETE 1
	DATE 21-10-2023
	QUESTION : 
 					Pour chacun des drones que possède l'entreprise, afficher :
						o nom du modèle															drone
						o drone_tag																drone
						o numéro de série														drone
						o son état (on désire le nom complet et pas seulement le symbole)		state	
						o la date à partir de laquelle cet état a été effectif					drone_state
						On désire le tout trié en ordre décroissant de :
						o le nom du modèle (croissant)
						o date d'acquisition des drones (décroissant)
						o drone_tag (croissant)
*/
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
 
 
/* REQUETE 2
DATE 21-10-2023
	QUESTION : 
					On désire connaître quels sont les drones disponibles pour la location. Cette requête doit présenter :
						o le domaine opérationnel (s'il y en a plusieurs, une chaîne de caractères où chacun est séparé par une virgule)			drone_domain
						o nom du modèle																												drone_modele
						o drone_tag																													drone
						o la date depuis quand il est disponible																					drone_state 'D'
						o sa localisation.																											drone_state
						On désire le résultat trié par :
						o le domaine opérationnel (croissant)
						o le nom du modèle (croissant)
						o la date depuis quand il est disponible (croissant) Donner le nombre d’inspections que
						chaque employé a fait.
*/


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


/* REQUETE 5
DATE 25-10-2023
	QUESTION : 
			Pour chaque employé, on désire connaitre le nombre de fois qu'il.elle a accepté.e positivement
			et négativement la transition d'un état à un autre (on considère toutes les transitions). On désire
			cette présentation :
			
					o prénom											employee
					o nom de famille									employee
					o le nombre de transitions acceptées				
					o le nombre de transitions rejetées                 
					o le ratio de transitions rejetées				    
					
					T, P, D, L, 	I (desfois) accepté
					R, U, H, 		I (desfois) refusé

					o le nombre de transitions acceptées				state_note COUNT(ok)
					o le nombre de transitions rejetées					state_note COUNT(BERK) AS berk
					o le ratio de transitions rejetées					state_note / berk
*/

DROP FUNCTION IF EXISTS is_accepted_state(state_value state.symbol%TYPE, id_drone_value drone.id%TYPE, start_date_time_value drone_state.start_date_time%TYPE);

CREATE OR REPLACE FUNCTION is_accepted_state(
    state_value state.symbol%TYPE,
    id_drone_value drone.id%TYPE,
    start_date_time_value drone_state.start_date_time%TYPE
)
RETURNS BOOLEAN
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- Vérifier si l'état est accepté
    IF state_value IN ('T','P','D','L') THEN
        RETURN TRUE;
		
	-- Si etat est I
    ELSIF state_value = 'I' THEN
        -- Vérifier la transition précédente
        DECLARE
            previous_state state.symbol%TYPE;
        BEGIN
            SELECT state INTO previous_state
            FROM drone_state
            WHERE id_drone = id_drone_value
                AND start_date_time < start_date_time_value
            ORDER BY start_date_time DESC
            LIMIT 1;	-- recuperer seulement 1
        
            -- Si la transition avant est 'R', 'U' ou 'H', elle est mauvaise
            IF previous_state IN ('R', 'U', 'H') THEN
                RETURN FALSE;
            ELSE
                RETURN TRUE; -- Sinon, elle est acceptée
            END IF;
        END;
    END IF;
    
    -- Par défaut, la transition est mauvaise (pcq il me faut un return de base)
    RETURN FALSE;
END;
$$;


-- FILTER permet de compter le nombre de fois que l'on retourne TRUE ou FALSE
SELECT
    emp.first_name AS prénom,		-- prenom
    emp.last_name AS nom_de_famille,		-- nom
    COUNT(*) FILTER (WHERE is_accepted_state(drone_state.state, drone_state.drone, drone_state.start_date_time) = TRUE) AS nbr_transitions_acceptées,
    COUNT(*) FILTER (WHERE is_accepted_state(drone_state.state, drone_state.drone, drone_state.start_date_time) = FALSE) AS nbr_transitions_rejetées,
COUNT(*) FILTER (WHERE is_accepted_state(drone_state.state, drone_state.drone, drone_state.start_date_time) = FALSE)::NUMERIC /
    COUNT(*) FILTER (WHERE is_accepted_state(drone_state.state, drone_state.drone, drone_state.start_date_time) = TRUE)::NUMERIC AS ratio_transitions_rejetées FROM employee emp
JOIN drone_state ON emp.id = drone_state.drone
GROUP BY emp.id, emp.first_name, emp.last_name
ORDER BY emp.last_name, emp.first_name;




