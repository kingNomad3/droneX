-- requete 1

SELECT
    dm.name AS model,
    d.drone_tag,
    d.serial_number,
    s.name AS etat,
    ds.start_date_time AS date_effectif
FROM drone AS d
INNER JOIN drone_model AS dm ON d.model = dm.id
INNER JOIN drone_state AS ds ON d.id = ds.drone
INNER JOIN state AS s ON ds.state = s.symbol
ORDER BY dm.name ASC, d.acquisition_date DESC, d.drone_tag ASC;


-- requete 5

-- Création d'une fonction qui facilitera le calcul des changements d'états.
DROP FUNCTION IF EXISTS is_accepted_state(state_value state.symbol%TYPE, id_drone_value drone.id%TYPE, start_date_time_value drone_state.start_date_time%TYPE);

CREATE OR REPLACE FUNCTION is_accepted_state(
    state_value state.symbol%TYPE,
    id_drone_value drone.id%TYPE,
    start_date_time_value drone_state.start_date_time%TYPE
)
RETURNS BOOLEAN
LANGUAGE PLPGSQL
AS $$
DECLARE 
    previous_state state.symbol%TYPE;
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
END;
$$;

-- La requête pour calculer les statistiques d'acceptation des transitions d'état par les employés :
SELECT
    emp.first_name AS prénom,
    emp.last_name AS nom_de_famille,
    COUNT(*) FILTER (WHERE is_accepted_state(ds.state, ds.id, ds.start_date_time) = TRUE) AS nbr_transitions_acceptées,
    COUNT(*) FILTER (WHERE is_accepted_state(ds.state, ds.id, ds.start_date_time) = FALSE) AS nbr_transitions_rejetées,
    COUNT(*) FILTER (WHERE is_accepted_state(ds.state, ds.id, ds.start_date_time) = FALSE)::NUMERIC /
    COUNT(*) FILTER (WHERE is_accepted_state(ds.state, ds.id, ds.start_date_time) = TRUE)::NUMERIC AS ratio_transitions_rejetées
FROM employee AS emp
JOIN drone_state AS ds ON emp.id = ds.employee
GROUP BY emp.id, emp.first_name, emp.last_name
ORDER BY emp.last_name, emp.first_name;


