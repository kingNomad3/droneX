DROP FUNCTION IF EXISTS is_accepted_state;
DROP FUNCTION IF EXISTS requete_dql_3;
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
-- Évaluation : FONCTIONNE
-- 
--
-- Réalisé par : Edouard Blain-Noël, Catherine Lavoie
-- =======================================================

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
-- Évaluation : Fonctionne
-- 
--
-- Réalisé par : Edouard Blain-Noël, Catherine Lavoie
-- =======================================================
CREATE OR REPLACE FUNCTION requete_dql_3 (drone_id drone.id%TYPE) 
RETURNS TABLE (name TEXT, status TIMESTAMP, employee_full_name TEXT, activities_amount INT)
LANGUAGE SQL AS $$
SELECT DISTINCT state.name AS "Status", 
       sub.start_date_time AS "Start time of status", 
	   employee.first_name || ' ' || employee.last_name AS "Employee", 
	   etat.note_amount AS "Number of activities"
  FROM state_note
  JOIN
  (SELECT * FROM drone_state WHERE drone = drone_id) AS "sub"
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
$$;

-- Pour tester cette requête
SELECT name AS "Name", 
       status AS "Status", 
	   employee_full_name AS "Employee", 
	   activities_amount AS "Amount of activities" 
  FROM requete_dql_3(23);
  
  SELECT * FROM drone_state

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
-- Évaluation : Fonctionne
--
-- Réalisé par : Rémi Chuet, Julien Coulombe-Morency 
--
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
    IF state_value IN ('T', 'P', 'D', 'L') THEN
        RETURN TRUE;    
    -- Si l'état est 'I'
    ELSIF state_value = 'I' THEN
        -- Vérifier la transition précédente
        SELECT state INTO previous_state
        FROM drone_state
        WHERE drone = id_drone_value
            AND start_date_time < start_date_time_value
        ORDER BY start_date_time DESC
        LIMIT 1;
        
        RETURN previous_state = 'R';
    END IF;
    
    -- Par défaut, la transition est mauvaise
    RETURN FALSE;
END$$;

-- La requête:
SELECT
    emp.first_name AS "Prénom",
    emp.last_name AS "Nom de famille",
    SUM(CASE WHEN is_accepted_state(ds.state, ds.id, ds.start_date_time) THEN 1 ELSE 0 END)::INTEGER AS "Transitions acceptées",
    SUM(CASE WHEN is_accepted_state(ds.state, ds.id, ds.start_date_time) THEN 0 ELSE 1 END)::INTEGER AS "Transitions rejetées",
    (SUM(CASE WHEN is_accepted_state(ds.state, ds.id, ds.start_date_time) THEN 0 ELSE 1 END)::INTEGER + 
    SUM(CASE WHEN is_accepted_state(ds.state, ds.id, ds.start_date_time) THEN 1 ELSE 0 END)::INTEGER)/
    NULLIF(SUM(CASE WHEN is_accepted_state(ds.state, ds.id, ds.start_date_time) THEN 1 ELSE 0 END), 0)::DOUBLE PRECISION AS "Ratio de transitions rejetées"
FROM employee AS emp
JOIN drone_state AS ds ON emp.id = ds.employee
GROUP BY emp.first_name, emp.last_name
ORDER BY emp.last_name, emp.first_name;

-- =======================================================

-- =======================================================
-- Requête #6
--
-- Réalisée par le consultant
--
-- =======================================================
