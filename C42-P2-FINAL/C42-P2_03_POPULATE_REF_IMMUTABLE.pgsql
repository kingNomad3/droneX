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


CREATE OR REPLACE PROCEDURE inserer_data_operational_domain(
	insert_name VARCHAR(32),
	insert_description VARCHAR(256),
	insert_depend VARCHAR(32)
)
LANGUAGE SQL
AS $$
	INSERT INTO operational_domain(name, description, depend)
		VALUES (insert_name, insert_description, (SELECT id FROM operational_domain WHERE name = insert_depend OR insert_depend = NULL));
$$;


BEGIN;

	CALL inserer_data_operational_domain('Domaine opérationnel', 'Environnement spécifique où un système ou appareil est déployé et fonctionne, définissant ses contraintes, capacités et applications adaptées.', NULL);
	CALL inserer_data_operational_domain('Aérien', 'Machines volantes, utilisent ailes ou hélices, naviguent dans l''atmosphère, dépendent de la portance.', 'Domaine opérationnel');
	CALL inserer_data_operational_domain('Terrestre', 'Véhicules roulants ou rampants, opèrent sur terrains variés, mécanismes de traction.', 'Domaine opérationnel');
	CALL inserer_data_operational_domain('Aquatique', 'Engins flottants ou submersibles, naviguent dans l''eau, propulsion adaptée à la résistance hydrodynamique.', 'Domaine opérationnel');
	CALL inserer_data_operational_domain('Vol à vue', 'élévation <= 500 m', 'Aérien');
	CALL inserer_data_operational_domain('Troposphérique', 'élévation <= 8 km', 'Aérien');
	CALL inserer_data_operational_domain('Stratosphérique', '8 km < élévation <= 50 km', 'Aérien');
	CALL inserer_data_operational_domain('Mésosphérique', '50 km < élévation <= 85 km', 'Aérien');
	CALL inserer_data_operational_domain('Roulant', 'avec roues, terrains relativement plats, haute vitesse', 'Terrestre');
	CALL inserer_data_operational_domain('Chenillé', 'avec chenilles, terrains relativement accidentés, moyenne vitesse', 'Terrestre');
	CALL inserer_data_operational_domain('Appendiculaire', 'avec pattes, terrains accidentés, faible vitesse', 'Terrestre');
	CALL inserer_data_operational_domain('De surface', 'ne peut être immergé, reste en surface', 'Aquatique');
	CALL inserer_data_operational_domain('Pélagique', 'profondeur <= 200 m', 'Aquatique');
	CALL inserer_data_operational_domain('Mésopélagique', '200 m < profondeur <= 1 km', 'Aquatique');
	CALL inserer_data_operational_domain('Bathypélagique', '1 km < profondeur <= 4 km', 'Aquatique');
	CALL inserer_data_operational_domain('Abyssopélagique', 'profondeur > 4 km', 'Aquatique');

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

DROP PROCEDURE inserer_data_operational_domain(insert_name VARCHAR(32), insert_description VARCHAR(256), insert_depend VARCHAR(32));

CREATE TRIGGER forbid_dml_operations_trig_state
	BEFORE INSERT OR UPDATE OR DELETE ON state
	FOR EACH ROW
	EXECUTE PROCEDURE forbid_dml_operations();

CREATE TRIGGER forbid_dml_operations_trig_od
	BEFORE INSERT OR UPDATE OR DELETE ON operational_domain
	FOR EACH ROW
	EXECUTE PROCEDURE forbid_dml_operations();



