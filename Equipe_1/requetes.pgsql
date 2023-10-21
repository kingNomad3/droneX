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

