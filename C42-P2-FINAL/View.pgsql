DROP VIEW IF EXISTS vue_drone_state_drone; 


/*
UTILISATION
On pourrait utilser la vue ici :

 - FICHIER 07
 			fonction :  
			Ligne 237 (old_state_number_insertion compare drone.id et drone_state.drone)
			Ligne 278 (on compare drone.id et drone_state.drone)
 - FICHIER 08
			LIGNE 28 (on compare drone.id et drone_state.drone)
			LIGNE 32 (on compare drone.id et drone_state.drone)
			LIGNE 70 (on compare drone.id et drone_state.drone AS date_disponibilite)
			LIGNE 74 (on compare drone.id et drone_state.drone AS localisation)
			LIGNE 78 (on compare drone.id et drone_state.drone AS nb_inspection)
			LIGNE 173 (on compare drone.id et drone_state.drone AS INNER JOIN)

*/

CREATE VIEW vue_drone_state_drone AS
SELECT drone_state.drone, drone.id  
  FROM drone_state 
 INNER JOIN drone 
       ON drone_state.drone = drone.id;
