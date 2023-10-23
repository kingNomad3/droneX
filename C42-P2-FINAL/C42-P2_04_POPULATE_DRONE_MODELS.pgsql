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
	C42-P2_04_POPULATE_DRONE_MODEL.pgsql
	V1.0	
*/


-- Procedure d'insertion:
-- Manufacturier

CREATE OR REPLACE PROCEDURE add_drone_manufacturer(name_value VARCHAR(64), web_site_value VARCHAR(256))
LANGUAGE SQL
AS $$
	INSERT INTO manufacturing_company(name , web_site)VALUES (name_value, web_site_value);
$$;

BEGIN;
	CALL add_drone_manufacturer($$DJI Enterprise$$, 'https://enterprise.dji.com/');
	CALL add_drone_manufacturer($$Parrot$$, 'https://www.parrot.com/us');
	CALL add_drone_manufacturer($$AgEagle$$, 'https://ageagle.com/');
	CALL add_drone_manufacturer($$Quantum Systems$$, 'https://quantum-systems.com/');
	CALL add_drone_manufacturer($$Lilium$$, 'https://lilium.com/');
	CALL add_drone_manufacturer($$Bell$$, 'https://www.bellflight.com/');
	CALL add_drone_manufacturer($$Clear Path Robotics$$, 'https://clearpathrobotics.com/');
	CALL add_drone_manufacturer($$Teledyne Flir$$, 'https://www.flir.ca/');
	CALL add_drone_manufacturer($$Boston Dynamics$$, 'https://bostondynamics.com/');
	CALL add_drone_manufacturer($$Oceanα$$, 'https://www.oceanalpha.com/');
	CALL add_drone_manufacturer($$Blueye$$, 'https://www.blueyerobotics.com/');
	CALL add_drone_manufacturer($$Deep Trekker$$, 'https://www.deeptrekker.com/');
COMMIT;

-- Drone model / Drone domain

CREATE OR REPLACE PROCEDURE add_drone_model(
	name_value VARCHAR(64),
	manufacturer_value VARCHAR(64),
	domains_value VARCHAR(256),
	description_value VARCHAR(2048),
	web_site_value VARCHAR(256)
)
LANGUAGE PLPGSQL
AS $$
DECLARE
	domains_array VARCHAR(64)[];
BEGIN
	INSERT INTO drone_model(name, manufacturer, description, web_site)
		VALUES (name_value, (SELECT id FROM manufacturing_company WHERE name = manufacturer_value),description_value, web_site_value);
	
	SELECT(string_to_array(domains_value, '&')) INTO domains_array;
	
	FOR i IN array_lower(domains_array, 1)..array_upper(domains_array, 1) LOOP
		INSERT INTO drone_domain(model, domain)
			VALUES ((SELECT id FROM drone_model WHERE name = name_value), (SELECT id FROM operational_domain WHERE name = domains_array[i]));
	END LOOP;
END$$;

BEGIN;
	CALL add_drone_model($$Matrice 350 RTK$$, $$DJI Enterprise$$, $$Vol à vue$$, $$Drone aérien pour la surveillance et l'inspection avec caméra thermique avancée.$$, 'https://enterprise.dji.com/matrice-350-rtk');
	CALL add_drone_model($$Anafi AI$$, $$Parrot$$, $$Vol à vue$$, $$Drone aérien léger avec capacités de zoom pour des opérations de reconnaissance.$$, 'https://www.parrot.com/us/drones/anafi-ai');
	CALL add_drone_model($$eBee X$$, $$AgEagle$$, $$Troposphérique$$, $$Drone aérien conçu pour surveiller et gérer les cultures agricoles.$$, 'https://ageagle.com/drones/ebee-x/');
	CALL add_drone_model($$Trinity F90+$$, $$Quantum Systems$$, $$Troposphérique$$, $$VTOL aérien pour la surveillance et la cartographie à longue portée. (VTOL = décollage et atterrissage verticaux)$$, 'https://quantum-systems.com/call trinity-f90/');
	CALL add_drone_model($$Lilium Jet$$, $$Lilium$$, $$Troposphérique$$, $$Aéronef électrique pour le transport urbain avec capacités VTOL (décollage et atterrissage verticaux).$$, 'https://lilium.com/jet');
	CALL add_drone_model($$Bell APT$$, $$Bell$$, $$Troposphérique$$, $$Drone aérien VTOL pour la logistique et la livraison, capable de transporter des charges importantes sur de courtes et moyennes distances. (VTOL = décollage et atterrissage call verticaux)$$, 'https://www.bellflight.com/products/bell-apt');
	CALL add_drone_model($$Husky$$, $$Clear Path Robotics$$, $$Roulant$$, $$Robot terrestre autonome pour la recherche et l'inspection.$$, 'https://clearpathrobotics.com/husky-unmanned-ground-vehicle-robot/');
	CALL add_drone_model($$Black Hornet PRS$$, $$Teledyne Flir$$, $$Vol à vue$$, $$Nano-drone aérien pour la reconnaissance militaire et la surveillance.$$, 'https://www.flir.com/products/black-hornet-prs/');
	CALL add_drone_model($$Spot$$, $$Boston Dynamics$$, $$Appendiculaire$$, $$Robot terrestre pour l'inspection et la cartographie de terrains difficiles.$$, 'https://bostondynamics.com/products/spot/');
	CALL add_drone_model($$Dolphin 1$$, $$Oceanα$$, $$De surface$$, $$Véhicule marin sans pilote pour la surveillance et le sauvetage.$$, 'https://www.oceanalpha.com/product-item/dolphin1/');
	CALL add_drone_model($$Blueye Pioneer$$, $$Blueye$$, $$Pélagique$$, $$Drone sous-marin pour les inspections et observations marines.$$, 'https://www.blueyerobotics.com/products/pioneer');
	CALL add_drone_model($$DTG3$$, $$Deep Trekker$$, $$Pélagique$$, $$ROV sous-marin pour les inspections sous-marines et la recherche.$$, 'https://www.deeptrekker.com/products/underwater-rov/dtg3-b');
	CALL add_drone_model($$Phantom 4 RTK$$, $$DJI Enterprise$$, $$Vol à vue$$, $$Drone aérien pour la cartographie et la photogrammétrie de précision.$$, 'https://enterprise.dji.com/phantom-4-rtk');
	CALL add_drone_model($$Vector$$, $$Quantum Systems$$, $$Troposphérique$$, $$VTOL aérien pour les opérations de surveillance discrètes.$$, 'https://quantum-systems.com/vector/');
	CALL add_drone_model($$Anafi Thermal$$, $$Parrot$$, $$Troposphérique$$, $$Drone aérien avec caméra thermique pour les opérations de recherche et de sauvetage.$$, 'https://www.parrot.com/en/drones/anafi-thermal');
	CALL add_drone_model($$PackBot 510$$, $$Teledyne Flir$$, $$Chenillé$$, $$Robot terrestre pour la reconnaissance, surveillance et interventions en zones dangereuses.$$, 'https://www.flir.com/products/packbot/');
COMMIT;

-- Drone spec

CREATE OR REPLACE PROCEDURE add_drone_specification(model_name VARCHAR(64), spec_name VARCHAR(64), spec_value VARCHAR(256), spec_comments VARCHAR(1024)) 
LANGUAGE PLPGSQL
AS $$
DECLARE
	model_name_temp INTEGER = (SELECT id FROM drone_model WHERE name=model_name);
	spec_name_temp INTEGER = (SELECT id FROM technical_specification WHERE name = spec_name);				 
BEGIN
	IF model_name_temp IS NOT NULL AND spec_name_temp IS NOT NULL THEN
		INSERT INTO drone_specification(drone_model, specification, value, comments) 
			VALUES(model_name_temp, spec_name_temp, spec_value ,spec_comments);
	END IF;
END$$;
						 
BEGIN;
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Autonomie d'opération$$, $$55$$, 'La durée peut varier en fonction des conditions de vol.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Précision de positionnement$$, $$1$$, 'Grâce à la technologie RTK.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Portée de communication$$, $$15$$, 'Dans des conditions optimales sans interférence.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Poids$$, $$4.5$$, 'Avec batteries et hélices.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Résistance au vent$$, $$15$$, 'Peut fonctionner dans des conditions venteuses.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Plage de température opérationnelle$$, $$-20 à 50$$, 'Résistant à une variété de conditions climatiques.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Vitesse maximum$$, $$23$$, 'Vitesse en vol horizontal.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Système anticollision$$, $$Oui$$, 'Capteurs multidirectionnels.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Nombre de capteurs$$, $$6$$, 'Incluant caméra, lidar, et autres.');
	CALL add_drone_specification($$Matrice 350 RTK$$, $$Zoom optique$$, $$6$$, 'Pour une meilleure reconnaissance visuelle.');
	CALL add_drone_specification($$Anafi AI$$, $$Résolution caméra$$, $$48$$, 'Offre une haute résolution pour la capture d''images.');
	CALL add_drone_specification($$Anafi AI$$, $$Autonomie d'opération$$, $$32$$, 'La durée peut varier en fonction des conditions de vol.');
	CALL add_drone_specification($$Anafi AI$$, $$Connectivité$$, $$4G$$, 'Permet une connexion sans interruption et des opérations au-delà de la ligne de vue.');
	CALL add_drone_specification($$Anafi AI$$, $$Poids$$, $$900$$, 'Facilité de transport et déploiement.');
	CALL add_drone_specification($$Anafi AI$$, $$Résistance au vent$$, $$14.5$$, 'Opérations stables même avec vent modéré.');
	CALL add_drone_specification($$Anafi AI$$, $$Vitesse maximum$$, $$19$$, 'Vitesse en mode sport.');
	CALL add_drone_specification($$Anafi AI$$, $$Portée de communication$$, $$8$$, 'Portée maximale en conditions optimales.');
	CALL add_drone_specification($$Anafi AI$$, $$Système anticollision$$, $$Oui$$, 'Capteurs à l''avant.');
	CALL add_drone_specification($$Anafi AI$$, $$Temps de charge$$, $$2$$, 'Avec un chargeur standard.');
	CALL add_drone_specification($$Anafi AI$$, $$Système d'exploitation$$, $$Parrot OS$$, 'Système d''exploitation dédié.');
	CALL add_drone_specification($$eBee X$$, $$Autonomie d'opération$$, $$25$$, 'Permet de couvrir de grandes étendues en un seul vol.');
	CALL add_drone_specification($$eBee X$$, $$Précision de positionnement$$, $$3$$, 'Lorsqu''il est équipé d''une caméra RTK/PPK.');
	CALL add_drone_specification($$eBee X$$, $$Poids$$, $$1.1$$, 'Léger et portable pour des déploiements faciles.');
	CALL add_drone_specification($$eBee X$$, $$Vitesse maximum$$, $$90 km/h$$, 'Adaptable selon les besoins du vol.');
	CALL add_drone_specification($$eBee X$$, $$Résistance au vent$$, $$12$$, 'Opérations fiables dans des conditions venteuses.');
	CALL add_drone_specification($$eBee X$$, $$Portée de communication$$, $$8$$, 'Communication stable avec la station au sol.');
	CALL add_drone_specification($$eBee X$$, $$Logiciel embarqué$$, $$eMotion$$, 'Logiciel dédié pour la planification de vol.');
	CALL add_drone_specification($$eBee X$$, $$Plage de température opérationnelle$$, $$-5 à 40$$, 'Pour une variété de conditions climatiques.');
	CALL add_drone_specification($$eBee X$$, $$Charge utile maximum$$, $$0.5$$, 'Pour diverses caméras et capteurs.');
	CALL add_drone_specification($$eBee X$$, $$Temps de charge$$, $$1$$, 'Pour une charge complète.');
	CALL add_drone_specification($$Trinity F90+$$, $$Autonomie d'opération$$, $$90$$, 'Couvre une grande zone en un seul vol.');
	CALL add_drone_specification($$Trinity F90+$$, $$Mode décollage-atterrissage$$, $$VTOL$$, 'Décollage et atterrissage verticaux.');
	CALL add_drone_specification($$Trinity F90+$$, $$Poids$$, $$4.5$$, 'Conception légère pour une portabilité optimale.');
	CALL add_drone_specification($$Trinity F90+$$, $$Résistance au vent$$, $$12$$, 'Opérations fiables dans des conditions venteuses.');
	CALL add_drone_specification($$Trinity F90+$$, $$Vitesse maximum$$, $$13.9$$, 'Idéal pour la cartographie et la surveillance.');
	CALL add_drone_specification($$Trinity F90+$$, $$Portée de communication$$, $$7.5$$, 'Communication stable avec la station au sol.');
	CALL add_drone_specification($$Trinity F90+$$, $$Système de navigation$$, $$RTK$$, 'Pour une précision de positionnement élevée.');
	CALL add_drone_specification($$Trinity F90+$$, $$Temps de charge$$, $$3$$, 'Avec un chargeur standard.');
	CALL add_drone_specification($$Trinity F90+$$, $$Système d'exploitation$$, $$QBase 3D$$, 'Logiciel dédié pour la planification et l''analyse.');
	CALL add_drone_specification($$Lilium Jet$$, $$Mode décollage-atterrissage$$, $$EVTOL$$, 'Aéronef électrique pour le transport urbain avec décollage et atterrissage verticaux.');
	CALL add_drone_specification($$Lilium Jet$$, $$Vitesse maximum$$, $$100 m/s$$, 'Vitesse élevée pour des déplacements rapides.');
	CALL add_drone_specification($$Lilium Jet$$, $$Nombre de passagers$$, $$5$$, 'Incluant le pilote, conçu pour le transport urbain.');
	CALL add_drone_specification($$Lilium Jet$$, $$Poids$$, $$1000$$, 'Y compris les batteries et l''équipement.');
	CALL add_drone_specification($$Lilium Jet$$, $$Temps de charge$$, $$1$$, 'Pour une charge complète avec un chargeur rapide.');
	CALL add_drone_specification($$Lilium Jet$$, $$Plage de température opérationnelle$$, $$-10 à 40$$, 'Pour diverses conditions climatiques.');
	CALL add_drone_specification($$Lilium Jet$$, $$Certification$$, $$EASA$$, 'Autorité de l''aviation civile européenne.');
	CALL add_drone_specification($$Lilium Jet$$, $$Altitude maximum$$, $$3000$$, 'Altitude de croisière.');
	CALL add_drone_specification($$Bell APT$$, $$Mode décollage-atterrissage$$, $$VTOL$$, 'Drone de livraison avec décollage et atterrissage verticaux.');
	CALL add_drone_specification($$Bell APT$$, $$Charge utile maximum$$, $$31.8$$, 'Capacité de livraison significative.');
	CALL add_drone_specification($$Bell APT$$, $$Vitesse maximum$$, $$24.1$$, 'Livraison rapide pour les besoins logistiques.');
	CALL add_drone_specification($$Bell APT$$, $$Temps de charge$$, $$1$$, 'Charge rapide pour des opérations continues.');
	CALL add_drone_specification($$Bell APT$$, $$Système d'exploitation$$, $$Propriétaire$$, 'Conçu pour une utilisation optimisée.');
	CALL add_drone_specification($$Bell APT$$, $$Système de navigation$$, $$GNSS avec RTK$$, 'Précision de positionnement élevée.');
	CALL add_drone_specification($$Bell APT$$, $$Résistance au vent$$, $$10$$, 'Opérations stables dans des conditions venteuses.');
	CALL add_drone_specification($$Husky$$, $$Poids$$, $$50$$, 'Avec équipement standard.');
	CALL add_drone_specification($$Husky$$, $$Vitesse maximum$$, $$1$$, 'Optimisé pour une navigation précise.');
	CALL add_drone_specification($$Husky$$, $$Autonomie d'opération$$, $$3$$, 'Fonctionnement continu sur une seule charge.');
	CALL add_drone_specification($$Husky$$, $$Système de navigation$$, $$GPS et IMU$$, 'Navigation précise en extérieur.');
	CALL add_drone_specification($$Husky$$, $$Charge utile maximum$$, $$75$$, 'Transport d''équipements supplémentaires.');
	CALL add_drone_specification($$Husky$$, $$Plage de température opérationnelle$$, $$-20 à 40$$, 'Pour diverses conditions climatiques.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Divers$$, $$Nano-drone aérien$$, 'Pour la reconnaissance militaire et la surveillance.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Autonomie d'opération$$, $$25$$, 'Opérations courtes de reconnaissance.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Poids$$, $$0.033$$, 'Extrêmement léger pour une discrétion maximale.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Vitesse maximum$$, $$5$$, 'Vitesse optimale pour des missions de reconnaissance.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Portée de communication$$, $$2$$, 'Communication stable avec la station de commande.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Divers$$, $$Caméra couleur et thermique$$, 'Double capteur pour des opérations diurnes et nocturnes.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Longueur$$, $$0.168$$, 'Taille compacte pour une portabilité maximale.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Largeur$$, $$0.084$$, 'Taille compacte pour une portabilité maximale.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Hauteur$$, $$0.003$$, 'Taille compacte pour une portabilité maximale.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Système d'exploitation$$, $$Propriétaire$$, 'Optimisé pour les besoins militaires.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Divers$$, $$Mode de vol semi-autonome$$, 'Peut être piloté manuellement ou suivre des waypoints.');
	CALL add_drone_specification($$Black Hornet PRS$$, $$Système de navigation$$, $$GPS$$, 'Intégré pour une navigation précise.');
	CALL add_drone_specification($$Spot$$, $$Divers$$, $$Robot terrestre$$, 'Pour l''inspection et la cartographie de terrains difficiles.');
	CALL add_drone_specification($$Spot$$, $$Autonomie d'opération$$, $$90$$, 'Batterie interchangeable pour une utilisation continue.');
	CALL add_drone_specification($$Spot$$, $$Vitesse maximum$$, $$1.6$$, 'Navigation précise dans divers environnements.');
	CALL add_drone_specification($$Spot$$, $$Poids$$, $$33$$, 'Conception robuste pour une durabilité maximale.');
	CALL add_drone_specification($$Spot$$, $$Plage de température opérationnelle$$, $$-20 à 45$$, 'Conçu pour fonctionner dans diverses conditions.');
	CALL add_drone_specification($$Spot$$, $$Divers$$, $$Système de navigation avec vision par ordinateur$$, 'Utilise des caméras pour éviter les obstacles.');
	CALL add_drone_specification($$Spot$$, $$Capacité de charge$$, $$14$$, 'Pour transporter différents équipements.');
	CALL add_drone_specification($$Spot$$, $$Longueur$$, $$1.0$$, 'Conception compacte pour une manœuvrabilité optimale.');
	CALL add_drone_specification($$Spot$$, $$Largeur$$, $$0.5$$, 'Conception compacte pour une manœuvrabilité optimale.');
	CALL add_drone_specification($$Spot$$, $$Hauteur$$, $$0.3$$, 'Conception compacte pour une manœuvrabilité optimale.');
	CALL add_drone_specification($$Spot$$, $$Connectivité$$, $$Wi-Fi et Bluetooth$$, 'Options flexibles pour le contrôle et la communication.');
	CALL add_drone_specification($$Spot$$, $$Divers$$, $$Mode d'opération autonome ou téléopéré$$, 'Peut être piloté à distance ou suivre des trajectoires programmées.');
	CALL add_drone_specification($$Dolphin 1$$, $$Divers$$, $$Véhicule marin sans pilote$$, 'Pour la surveillance et le sauvetage.');
	CALL add_drone_specification($$Dolphin 1$$, $$Autonomie d'opération$$, $$2$$, 'Opérations marines prolongées.');
	CALL add_drone_specification($$Dolphin 1$$, $$Vitesse maximum$$, $$3.6$$, 'Navigation rapide pour le sauvetage.');
	CALL add_drone_specification($$Dolphin 1$$, $$Poids$$, $$13$$, 'Conception équilibrée pour une stabilité maximale dans l''eau.');
	CALL add_drone_specification($$Dolphin 1$$, $$Divers$$, $$Système de propulsion à jet d'eau$$, 'Propulsion efficace et sûre.');
	CALL add_drone_specification($$Dolphin 1$$, $$Portée de communication$$, $$0.500$$, 'Distance sécurisée entre l''opérateur et le drone.');
	CALL add_drone_specification($$Dolphin 1$$, $$Charge utile maximum$$, $$Un humain$$, 'Peut être déployée en cas de nécessité pour le sauvetage à titre de boué de sauvetage.');
	CALL add_drone_specification($$Dolphin 1$$, $$Divers$$, $$Mode d'opération téléopéré$$, 'Piloté à distance par un opérateur.');
	CALL add_drone_specification($$Dolphin 1$$, $$Communication$$, $$Radiofréquence$$, 'Pour une communication fiable avec la station de commande.');
	CALL add_drone_specification($$Dolphin 1$$, $$Capteurs$$, $$Caméra frontale$$, 'Pour la reconnaissance et la surveillance.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Divers$$, $$Drone sous-marin$$, 'Conçu pour les inspections et observations marines.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Autonomie d'opération$$, $$2$$, 'Durée d''opération prolongée sous l''eau.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Profondeur maximum$$, $$150$$, 'Peut descendre à des profondeurs importantes pour des explorations sous-marines.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Vitesse maximum$$, $$2$$, 'Optimisé pour l''exploration sous-marine.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Poids$$, $$9$$, 'Conception compacte pour une portabilité facile.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Résolution caméra$$, $$Full HD$$, 'Capture des vidéos et des images de haute qualité sous l''eau.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Divers$$, $$Système d'éclairage à LEDs puissantes$$, 'Permet une visibilité claire dans des conditions sous-marines sombres.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Divers$$, $$Mode d'opération téléopéré$$, 'Commandé à distance via une application ou une station de commande.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Connectivité$$, $$Wi-Fi pour contrôle à surface$$, 'Permet une communication entre le drone et l''opérateur en surface.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Longueur$$, $$0.5$$, 'Taille optimisée pour une manœuvrabilité sous-marine.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Largeur$$, $$0.35$$, 'Taille optimisée pour une manœuvrabilité sous-marine.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Hauteur$$, $$0.25$$, 'Taille optimisée pour une manœuvrabilité sous-marine.');
	CALL add_drone_specification($$Blueye Pioneer$$, $$Divers$$, $$Structure robuste et résistante à la corrosion$$, 'Fabriqué pour résister aux conditions marines salines.');
	CALL add_drone_specification($$DTG3$$, $$Divers$$, $$ROV sous-marin$$, 'Conçu pour les inspections sous-marines et la recherche.');
	CALL add_drone_specification($$DTG3$$, $$Profondeur maximum$$, $$200$$, 'Conçu pour des explorations sous-marines profondes.');
	CALL add_drone_specification($$DTG3$$, $$Autonomie d'opération$$, $$8$$, 'Opérations prolongées sous l''eau.');
	CALL add_drone_specification($$DTG3$$, $$Vitesse maximum$$, $$2.5$$, 'Navigation optimisée pour l''exploration sous-marine.');
	CALL add_drone_specification($$DTG3$$, $$Poids$$, $$8.5$$, 'Facile à déployer et à transporter.');
	CALL add_drone_specification($$DTG3$$, $$Résolution caméra$$, $$Full HD avec zoom$$, 'Capture des images et vidéos claires sous l''eau.');
	CALL add_drone_specification($$DTG3$$, $$Divers$$, $$Système d'éclairage avec LEDs réglables$$, 'Éclairage pour une visibilité claire dans les environnements sombres.');
	CALL add_drone_specification($$DTG3$$, $$Divers$$, $$Propulsion à 4 propulseurs$$, 'Manœuvrabilité optimale dans toutes les directions.');
	CALL add_drone_specification($$DTG3$$, $$Divers$$, $$Mode d'opération téléopéré$$, 'Piloté à distance avec une station de commande.');
	CALL add_drone_specification($$DTG3$$, $$Connectivité$$, $$Tethered (câblé)$$, 'Utilise un câble pour la communication et l''alimentation.');
	CALL add_drone_specification($$DTG3$$, $$Divers$$, $$Matériaux : aluminium et acier inoxydable$$, 'Résistance à la corrosion pour les opérations marines.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Autonomie d'opération$$, $$30$$, 'Adapté pour la cartographie de grandes zones.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Précision de positionnement$$, $$1$$, 'Grâce à la technologie RTK intégrée.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Résolution caméra$$, $$20$$, 'Pour une capture d''image haute résolution.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Vitesse maximum$$, $$31$$, 'Vitesse en mode sport.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Poids$$, $$1.391$$, 'Incluant la batterie et les hélices.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Système anticollision$$, $$Oui$$, 'Capteurs sur 6 directions pour une sécurité accrue.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Portée de communication$$, $$7$$, 'Communication stable avec la station de commande.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Système de navigation$$, $$GPS + GLONASS$$, 'Pour une précision de positionnement maximale.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Divers$$, $$Plusiuers modes de vol dont Waypoint$$, 'Adapté pour diverses applications de cartographie.');
	CALL add_drone_specification($$Phantom 4 RTK$$, $$Capacité stockage$$, $$128$$, 'Capacité de stockage suffisante pour des sessions de cartographie prolongées.');
	CALL add_drone_specification($$Vector$$, $$Autonomie d'opération$$, $$40$$, 'Optimisé pour des opérations prolongées.');
	CALL add_drone_specification($$Vector$$, $$Précision de positionnement$$, $$1$$, 'Avec technologie RTK en option.');
	CALL add_drone_specification($$Vector$$, $$Capteurs$$, $$Types de caméra multiples$$, 'Options pour la thermographie, le zoom optique et d''autres capteurs spécifiques.');
	CALL add_drone_specification($$Vector$$, $$Vitesse maximum$$, $$25$$, 'Adapté pour une couverture rapide de grandes zones.');
	CALL add_drone_specification($$Vector$$, $$Poids$$, $$2$$, 'Selon la configuration et les équipements.');
	CALL add_drone_specification($$Vector$$, $$Système anticollision$$, $$Oui$$, 'Capteurs sur plusieurs directions pour une sécurité renforcée.');
	CALL add_drone_specification($$Vector$$, $$Portée de communication$$, $$10$$, 'Communication fiable avec la station de commande.');
	CALL add_drone_specification($$Vector$$, $$Système de navigation$$, $$GPS + GLONASS$$, 'Précision élevée pour des applications professionnelles.');
	CALL add_drone_specification($$Vector$$, $$Divers$$, $$Modes de vol multiples$$, 'Incluant le vol stationnaire, le waypoint et la reconnaissance automatique.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Autonomie d'opération$$, $$26$$, 'Optimisé pour des missions de surveillance et d''inspection.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Capteurs$$, $$Caméras : Double capteur 4K HDR et thermographie$$, 'Capture simultanée d''images visuelles et thermiques.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Divers$$, $$Plage de température détectable : -10°C à +400°C$$, 'Étendue pour la détection thermique dans diverses applications.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Poids$$, $$0.315$$, 'Conception légère pour une portabilité maximale.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Vitesse maximum$$, $$15$$, 'Adapté pour une couverture rapide de zones d''intérêt.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Système de navigation$$, $$GPS + GLONASS$$, 'Pour une précision de positionnement élevée.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Résistance au vent$$, $$14$$, 'Peut opérer dans des conditions venteuses.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Capacité stockage$$, $$16$$, 'Extensible jusqu''à 128 GB.');
	CALL add_drone_specification($$Anafi Thermal$$, $$Divers$$, $$Modes de vol ultiples$$, 'Incluant le vol stationnaire, le waypoint et la capture automatisée.');
	CALL add_drone_specification($$PackBot 510$$, $$Type$$, $$Robot terrestre$$, 'Conçu pour les opérations de reconnaissance, de surveillance et d''assistance en zones dangereuses.');
	CALL add_drone_specification($$PackBot 510$$, $$Vitesse maximale$$, $$9.3 km/h$$, 'Permet une réponse rapide sur le terrain.');
	CALL add_drone_specification($$PackBot 510$$, $$Poids$$, $$Environ 24 kg$$, 'Selon la configuration et les accessoires.');
	CALL add_drone_specification($$PackBot 510$$, $$Autonomie$$, $$Jusqu'à 4 heures$$, 'Batteries remplaçables pour des opérations prolongées.');
	CALL add_drone_specification($$PackBot 510$$, $$Capacité de charge$$, $$Jusqu'à 9 kg$$, 'Permet de transporter des équipements supplémentaires.');
	CALL add_drone_specification($$PackBot 510$$, $$Mode d'opération$$, $$Téléopéré$$, 'Piloté à distance à l''aide d''une console de commande.');
	CALL add_drone_specification($$PackBot 510$$, $$Système de vision$$, $$Caméras multiples$$, 'Incluant des caméras jour/nuit et des caméras thermiques pour divers scénarios.');
	CALL add_drone_specification($$PackBot 510$$, $$Bras manipulateur$$, $$Oui$$, 'Bras extensible pour la manipulation d''objets, l''inspection et d''autres tâches.');
	CALL add_drone_specification($$PackBot 510$$, $$Résistance à l'eau$$, $$Étanche$$, 'Peut opérer sous la pluie ou traverser des flaques d''eau.');
	CALL add_drone_specification($$PackBot 510$$, $$Système de navigation$$, $$GPS intégré$$, 'Pour le suivi et la planification des itinéraires.');
	CALL add_drone_specification($$PowerEgg X$$, $$Divers$$, $$Drone multifonctionnel$$, 'Mode main, caméra AI stationnaire et drone.');
	CALL add_drone_specification($$PowerEgg X$$, $$Résolution caméra$$, $$4K/60fps$$, 'Capture également des photos de 12MP.');
	CALL add_drone_specification($$PowerEgg X$$, $$Autonomie d'opération$$, $$30$$, 'Sur une seule charge.');
	CALL add_drone_specification($$PowerEgg X$$, $$Divers$$, $$Étanchéité avec kit d'accessoires$$, 'Permet des vols sous la pluie et des décollages/atterrissages sur l''eau.');
	CALL add_drone_specification($$PowerEgg X$$, $$Divers$$, $$Fonctionnalités AI et suivi automatique de sujet$$, 'Garde les sujets centrés dans le cadre.');
	CALL add_drone_specification($$PowerEgg X$$, $$Distance de transmission$$, $$6$$, 'Portée maximale de contrôle.');
	CALL add_drone_specification($$PowerEgg X$$, $$Divers$$, $$Design audacieuse en forme d'oeuf$$, 'Conception compacte et portable.');
	CALL add_drone_specification($$PowerEgg X$$, $$Résistance au vent$$, $$19.55$$, 'Assure la stabilité par temps venteux.');
	CALL add_drone_specification($$PowerEgg X$$, $$Divers$$, $$Synchronisation vocale$$, 'Synchronise n''importe quelle source sonore sans fil en temps réel.');

COMMIT;

select * from drone_specification



