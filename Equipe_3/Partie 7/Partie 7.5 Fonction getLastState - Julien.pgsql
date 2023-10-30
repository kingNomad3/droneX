-- Fonction qui allègerais le code de la fonction trigger. Permet de retourner la row au complet du dernier state

CREATE OR REPLACE FUNCTION getLastDroneState(p_drone_id INT) 
RETURNS state 
LANGUAGE plpgsql
AS $$
DECLARE
    v_last_state state;
BEGIN
    SELECT * INTO v_last_state
    FROM state
    WHERE symbol = (SELECT state FROM drone_state WHERE drone = p_drone_id
                             ORDER BY start_date_time DESC
                                LIMIT 1); 
    RETURN v_last_state;
END;
$$ ;

-- Ensuite tu peux accéder au variable du rowtype comme un objet : last_state.next_accepted_state, etc. 
-- A la place de te faire 10 variables / fonctions.

CREATE OR REPLACE PROCEDURE verifLastState(p_drone_id INT) 
LANGUAGE plpgsql
AS $$
DECLARE
    last_state state%ROWTYPE := getLastDroneState(p_drone_id);
BEGIN
    RAISE NOTICE 'last_state : %          dernier accepted : %        dernier rejected : %', last_state.symbol, last_state.next_accepted_state, last_state.next_rejected_state;
END;
$$ ;


CALL verifLastState(34);
CALL verifLastState(67);
CALL verifLastState(49);
CALL verifLastState(99);