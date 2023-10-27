
-- Le insert pour tester les fonctions (s'assurer que les fonctions et le trigger sont créés avant de rouler)
INSERT INTO drone_state(drone, state, employee, location) VALUES (1, 'D', 1,'dasda');
INSERT INTO drone_state(drone, state, employee, location) VALUES (1, 'L', 1,'dasda');
															  
SELECT * from drone_state;

SELECT * FROM state_note;
/**********************************************************************/



