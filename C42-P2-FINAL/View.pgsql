DROP VIEW IF EXISTS vue_drone_state_drone; 
DROP VIEW IF EXISTS vue_drone_state_state_note; 
DROP VIEW IF EXISTS vue_drone_disponible;

/*
UTILISATION
LIAISON :
	- drone_state.drone
	- drone.id
	
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




/*
UTILISATION
LIAISON :
	- drone_state.drone
	- state_note.id
	
On pourrait utilser la vue ici :
 - FICHIER 08
 		LIGNES 92 (fonction requete_dql_3)
 - FICHIER 06
 		LIGNES 158 (Avec le INSERT state_note)
*/
CREATE VIEW vue_drone_state_state_note AS
	SELECT drone_state.drone, state_note.id  
  	  FROM drone_state 
 	 INNER JOIN state_note
        ON drone_state.id = state_note.drone_state;
		
		
		
/*
UTILISATION
LIAISON :
	- drone_state
	- drone disponible

On pourrait utilser la vue ici :
		On pourrait utilser la vue dans le cadre de l'entreprise 
		afin de pouvoir donner au client rapidement une liste des
		drones disponibles.
		Elle serait souvent appele, car c'est dans le principe de
		l'entreprise d'offrir les drones disponibles
*/
CREATE VIEW vue_drone_disponible AS
	SELECT id AS id_drone_dispo
	  FROM drone_state
	 WHERE state = 'D'
     ORDER BY start_date_time DESC
     LIMIT 1; 
 
SELECT * FROM vue_drone_state_drone;
