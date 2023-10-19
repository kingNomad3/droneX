/*
	Membres : 
	
	Julien Coulombe-Morency, 
	Remi Chuet, 
	Édouard Blain-Noël, 
	Catherine Lavoie, 
	Benjamin Jouinvil, 
	François Maltais
		
	Date de création : 2023-10-19 
	Dernière modification : 2023-10-19
	C42-P2_03_POPULATE_REF_IMMUTABLE.pgsql
	V1.0	
*/


-- Transaction pour l'insertion dans la table operational_domain :

-- Fonction d'insertion:



BEGIN
	fonction_input_operationaltable()
COMMIT;

-- Transaction pour l'insertion dans la table state:

BEGIN;	
	INSERT INTO state (symbol, name, description, next_accepted_state, next_rejected_state)
		VALUES
			('I', 'Inspection', 'Évaluation visuelle ou technique d''un drone pour vérifier son état et sa conformité aux normes.', 'T', 'R'),
			('T', 'Test', 'Exécution de procédures spécifiques pour évaluer la performance et la fonctionnalité d''un drone.', 'P', 'R'),
			('P', 'Préparation', 'Mise en place et ajustement d''un drone avant son utilisation ou sa mise en service.', 'D', 'I'),
			('D', 'Disponibilité', 'Confirmation que le drone est opérationnel et prêt à être loué. Le drone est stocké.', 'L', 'I'),
			('L', 'Location', 'Le drone est loué à un client.', 'I', 'U'),
			('R', 'Réparation', 'Action de remettre en état de fonctionnement un drone qui est défectueux ou endommagé.', 'I', 'H'),
			('U', 'Perdu', 'État d''un drone qui n''a pas été retrouvé après une recherche ou qui n''est pas à son emplacement attendu.', NULL, NULL),
			('H', 'Hors-service', 'État d''un drone qui n''est plus en condition de fonctionnement ou qui a été mis hors service pour diverses raisons. Le drone peut tout de même ètre utilisé pour ses pièces.', NULL, NULL);
			
COMMIT;