-- =======================================================
-- Requête #1
--
-- Objectif : 
-- Pour chacun des drones que possède l'entreprise, afficher :
-- Le nom du modèle, le drone_tag, le numéro de série, son état (on désire le nom complet et pas seulement le symbole), la date à partir de laquelle cet état a été effectif.																				
--
-- On désire le tout trié en ordre décroissant de :
-- Le nom du modèle (croissant), date d'acquisition des drones (décroissant), drone_tag (croissant)
--
-- Évaluation : 
-- 
--
-- Réalisé par : Julien Coulombe-Morency, Rémi Chuet
-- =======================================================

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

-- =======================================================

-- =======================================================
-- Requête #2
--
-- Objectif : 
-- On désire connaître quels sont les drones disponibles pour la location. Cette requête doit présenter :
-- Le domaine opérationnel (s'il y en a plusieurs, une chaîne de caractères où chacun est séparé par une virgule), le nom du modeèle,
-- le drone_tag, la date depuis quand il est disponible, sa localisation.																			
--
-- On désire le résultat trié par :
-- Le domaine opérationnel (croissant)), le nom du modèle (croissant), dla date depuis quand il est disponible (croissant)
--
-- Donner le nombre d’inspections que chaque employé a fait.
--
-- Évaluation : 
-- 
--
-- Réalisé par : Julien Coulombe-Morency, Rémi Chuet
-- =======================================================

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

-- =======================================================

-- =======================================================
-- Requête #3
--
-- Objectif : 
--  Pour un drone donné, montrer l'historique des activités liées. Pour chaque activité on désire :
-- L'état (avec le nom au complet), la date, le nom et prénom de l'employé lié (prénom + espace + nom), le nombre de notes disponibles																	
--
-- Évaluation : 
-- 
--
-- Réalisé par : Julien Coulombe-Morency, Rémi Chuet
-- =======================================================
   SELECT 


	 FROM 
-- =======================================================
--
-- =======================================================
-- Requête #4
--
-- Réalisée par le consultant
--
-- =======================================================

-- =======================================================
-- Requête #5
--
-- Objectif : 
-- Pour chaque employé, on désire connaitre le nombre de fois qu'il.elle a accepté.e positivement
-- et négativement la transition d'un état à un autre (on considère toutes les transitions). On désire
-- cette présentation :
--
-- Le prénom, le nom de famille, le nombre de transitions acceptées, le ratio de transitions rejetées																		
--
-- Évaluation : 
--
-- Réalisé par : Rémi Chuet
-- Aidé par : Julien Coulombe-Morency 
-- =======================================================

DROP FUNCTION IF EXISTS is_accepted_state(state_value state.symbol%TYPE, id_drone_value drone.id%TYPE, start_date_time_value drone_state.start_date_time%TYPE);

-- Création d'une fonction qui facilitera le calcul des changements d'états.
CREATE OR REPLACE FUNCTION is_accepted_state(
    state_value state.symbol%TYPE,
    id_drone_value drone.id%TYPE,
    start_date_time_value drone_state.start_date_time%TYPE
)
RETURNS BOOLEAN
LANGUAGE PLPGSQL
AS $$
DECLARE previous_state state.symbol%TYPE;
BEGIN
    -- Vérifier si l'état est accepté
    IF state_value IN ('T','P','D','L') THEN
        RETURN TRUE;    
    -- Si etat est I
    ELSIF state_value = 'I' THEN
        -- Vérifier la transition précédente
        
        previous_state := (SELECT state INTO 
        FROM drone_state
        WHERE id_drone = id_drone_value
            AND start_date_time < start_date_time_value
        ORDER BY start_date_time DESC
        LIMIT 1)    -- recuperer seulement 1
        
        RETURN previous_state = 'R'
    END IF;
    
    -- Par défaut, la transition est mauvaise
    RETURN FALSE;
END$$;

-- La requête:
SELECT
    emp.first_name AS prénom,		-- prenom
    emp.last_name AS nom_de_famille,		-- nom
    -- FILTER permet de compter le nombre de fois que l'on retourne TRUE ou FALSE
    COUNT(*) FILTER (WHERE is_accepted_state(drone_state.state, drone_state.drone, drone_state.start_date_time) = TRUE) AS nbr_transitions_acceptées,
    COUNT(*) FILTER (WHERE is_accepted_state(drone_state.state, drone_state.drone, drone_state.start_date_time) = FALSE) AS nbr_transitions_rejetées,

    COUNT(*) FILTER (WHERE is_accepted_state(drone_state.state, drone_state.drone, drone_state.start_date_time) = FALSE)::NUMERIC /
    COUNT(*) FILTER (WHERE is_accepted_state(drone_state.state, drone_state.drone, drone_state.start_date_time) = TRUE)::NUMERIC AS ratio_transitions_rejetées 
    
    FROM employee AS emp
    JOIN drone_state ON emp.id = drone_state.drone
GROUP BY emp.id, emp.first_name, emp.last_name
ORDER BY emp.last_name, emp.first_name;

-- =======================================================

-- =======================================================
-- Requête #6
--
-- Réalisée par le consultant
--
-- =======================================================
