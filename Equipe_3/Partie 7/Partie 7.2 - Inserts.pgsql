/************************ Populate test **************************************/
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

INSERT INTO manufacturing_company(name , web_site)VALUES ('site 1', 'desc');
INSERT INTO drone_model(name, manufacturer, description, web_site) VALUES ('machine', 1, 'blab baffsfsfsfsfl', 'dad' );
INSERT INTO drone(model, serial_number, drone_tag, acquisition_date) VALUES (1, 'premier dans liste', 'tag premier', '1999-01-01');
INSERT INTO employee VALUES(1,'dddddd', 'dsdsds', 'rrrrr', 'probation', 'dasdasda');



INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (1, 'I', 1,'2000-05-01', 'dasda');
INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (1, 'T', 1,'2000-06-01', 'dasda');
INSERT INTO drone_state(drone, state, employee, start_date_time, location) VALUES (1, 'P', 1,'2000-07-01', 'dasda');

INSERT INTO state_note(drone_state, note, date_time, employee, details) VALUES(1, 'problematic_observation', NOW()::TIMESTAMP, 1, 'qwewqeqeqeqewqewqewqeqeqweqweqweqwe');
INSERT INTO state_note(drone_state, note, date_time, employee, details) VALUES(1, 'problematic_observation', NOW()::TIMESTAMP, 1, 'qwewqeqeqeqewqewqewqeqeqweqweqweqwe');
INSERT INTO state_note(drone_state, note, date_time, employee, details) VALUES(1, 'repair_completed', NOW()::TIMESTAMP, 1, 'qwewqeqeqeqewqewqewqeqeqweqweqweqwe');