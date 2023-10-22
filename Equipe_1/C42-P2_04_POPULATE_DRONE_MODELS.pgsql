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

CREATE OR REPLACE PROCEDURE add_drone_specification(model_name VARCHAR(200), spec_name VARCHAR(200), spec_value VARCHAR(256), spec_comments VARCHAR(1024)) 
LANGUAGE SQL
AS $$
	INSERT INTO drone_specification(drone_model, specification, value, comments) 
		VALUES((SELECT id FROM drone_model WHERE name=model_name),(SELECT id FROM technical_specification WHERE name = spec_name), spec_value ,spec_comments);
$$;

BEGIN;
	CALL add_drone_specification($$Poids$$, $$Masse totale du produit$$, 'kg');
	CALL add_drone_specification($$Longueur$$, $$Dimension la plus longue du produit$$, 'm');
	CALL add_drone_specification($$Largeur$$, $$Dimension la plus large du produit$$, 'm');
	CALL add_drone_specification($$Hauteur$$, $$Dimension verticale du produit$$, 'm');
	CALL add_drone_specification($$Volume$$, $$Espace total occupé par le produit$$, 'm³');
	CALL add_drone_specification($$Densité$$, $$Masse par unité de volume$$, 'kg/m³');
	CALL add_drone_specification($$Résistance$$, $$Capacité du matériau à résister à une force extérieure$$, 'N/mm²');
	CALL add_drone_specification($$Température opération maximum$$, $$Température maximale de fonctionnement du produit$$, '°C');
	CALL add_drone_specification($$Température opération minimum$$, $$Température minimale de fonctionnement du produit$$, '°C');
	CALL add_drone_specification($$Durée de vie$$, $$Durée estimée du bon fonctionnement du produit$$, 'h');
	CALL add_drone_specification($$Voltage$$, $$Tension électrique pour le fonctionnement$$, 'V');
	CALL add_drone_specification($$Courant$$, $$Courant électrique nominal$$, 'A');
	CALL add_drone_specification($$Puissance$$, $$Énergie consommée ou produite par heure$$, 'W');
	CALL add_drone_specification($$Fréquence$$, $$Fréquence d'opération pour les produits électroniques$$, 'Hz');
	CALL add_drone_specification($$Épaisseur$$, $$Mesure de la dimension la plus fine du produit, souvent pour des plaques ou feuilles$$, 'mm');
	CALL add_drone_specification($$Diamètre$$, $$Distance à travers le cercle, utile pour les objets cylindriques$$, 'mm');
	CALL add_drone_specification($$Tolérance$$, $$Écart maximum admissible par rapport à une valeur nominale$$, 'mm');
	CALL add_drone_specification($$RPM$$, $$Vitesse de rotation pour des pièces mécaniques, comme les moteurs$$, 'rpm');
	CALL add_drone_specification($$Isolation$$, $$Niveau de résistance à la conduction d'électricité ou de chaleur$$, 'Ω');
	CALL add_drone_specification($$Humidité d'opération$$, $$Plage d'humidité dans laquelle le produit fonctionne de manière optimale$$, '%');
	CALL add_drone_specification($$Pression d'opération$$, $$Plage de pression pour les produits fonctionnant sous certaines atmosphères$$, 'Pa');
	CALL add_drone_specification($$Conductivité$$, $$Capacité du matériau à conduire l'électricité$$, 'S/m');
	CALL add_drone_specification($$Rendement$$, $$Proportion de l'énergie d'entrée convertie en travail utile$$, '%');
	CALL add_drone_specification($$Cycle$$, $$Cycle de travail pour des machines fonctionnant en cycles intermittents$$, '%');
	CALL add_drone_specification($$Étanchéité$$, $$Capacité à empêcher la pénétration de liquides ou de gaz$$, NULL);
	CALL add_drone_specification($$Cycles de vie$$, $$Nombre de cycles d'opération avant une défaillance prévue$$, 'cycle');
	CALL add_drone_specification($$Bruit$$, $$Niveau sonore produit pendant le fonctionnement$$, 'dB');
	CALL add_drone_specification($$Charge maximum$$, $$Poids maximum que le produit peut soutenir ou transporter$$, 'kg');
	CALL add_drone_specification($$Portée$$, $$Distance maximale depuis la base jusqu'à l'extrémité du robot$$, 'mm');
	CALL add_drone_specification($$Répétabilité$$, $$Précision avec laquelle le robot peut retourner à une position spécifiée$$, 'mm');
	CALL add_drone_specification($$Vitesse axiale$$, $$Vitesse maximale d'un axe spécifique$$, 'deg/s');
	CALL add_drone_specification($$Accélération axiale$$, $$Accélération maximale d'un axe spécifique$$, 'deg/s²');
	CALL add_drone_specification($$Nombre d'axes$$, $$Nombre de degrés de liberté du robot$$, 'axes');
	CALL add_drone_specification($$Environnement$$, $$Conditions pour lesquelles le robot est conçu (standard, salle blanche, dangereux...)$$, NULL);
	CALL add_drone_specification($$Système de contrôle$$, $$Type de système de contrôle utilisé pour opérer le robot$$, NULL);
	CALL add_drone_specification($$Interface usager$$, $$Moyens par lesquels l'opérateur interagit avec le robot$$, NULL);
	CALL add_drone_specification($$Alimentation électrique$$, $$Énergie nécessaire pour le fonctionnement du robot$$, 'V');
	CALL add_drone_specification($$Source air comprimé$$, $$Besoin en air comprimé pour certaines fonctions$$, 'bar');
	CALL add_drone_specification($$Consommation$$, $$Énergie consommée pendant le fonctionnement$$, 'kWh');
	CALL add_drone_specification($$Espace installation$$, $$Dimension au sol requise pour l'installation$$, 'm²');
	CALL add_drone_specification($$Protocole de communication$$, $$Protocoles utilisés pour la communication avec d'autres équipements$$, NULL);
	CALL add_drone_specification($$Autonomie d'opération$$, $$Durée d'opération sur une seule charge de batterie$$, 'min');
	CALL add_drone_specification($$Vitesse maximum$$, $$Vitesse maximale que le drone peut atteindre$$, 'm/s');
	CALL add_drone_specification($$Altitude maximum$$, $$Altitude maximale à laquelle le drone peut opérer$$, 'm');
	CALL add_drone_specification($$Profondeur maximum$$, $$Profondeur Altitude maximale à laquelle le drone peut opérer$$, 'm');
	CALL add_drone_specification($$Portée de communication$$, $$Distance maximale du contrôleur à laquelle le drone peut fonctionner$$, 'km');
	CALL add_drone_specification($$Stabilisation image$$, $$Type de stabilisation utilisé pour la caméra (électronique, mécanique...)$$, NULL);
	CALL add_drone_specification($$Résolution caméra$$, $$Résolution de l'appareil photo du drone$$, 'MP');
	CALL add_drone_specification($$Résolution vidéo$$, $$Qualité de la vidéo que le drone peut enregistrer$$, 'MP');
	CALL add_drone_specification($$Capacité stockage$$, $$Espace disponible pour stocker des photos et vidéos$$, 'GB');
	CALL add_drone_specification($$Mode vol$$, $$Modes de vol automatiques disponibles (suivi, point d'intérêt...)$$, NULL);
	CALL add_drone_specification($$Nombre de capteurs$$, $$Indique le nombre de capteurs embarqués$$, NULL);
	CALL add_drone_specification($$Capteurs$$, $$Types de capteurs embarqués (thermique, sonar, LIDAR...)$$, NULL);
	CALL add_drone_specification($$Résistance au vent$$, $$Capacité à opérer malgré la force des vents$$, 'm/s');
	CALL add_drone_specification($$Résistance à l'eau$$, $$Capacité à opérer sous l'eau ou dans des conditions humides$$, NULL);
	CALL add_drone_specification($$Mode communication$$, $$Méthode de communication (Wi-Fi, radiofréquence, 4G...)$$, NULL);
	CALL add_drone_specification($$Charge utile maximum$$, $$Poids maximum d'équipement supplémentaire que le drone peut transporter$$, 'kg');
	CALL add_drone_specification($$Système de navigation$$, $$Comment le drone se repère (GPS, vision par ordinateur, sonar...)$$, NULL);
	CALL add_drone_specification($$Précision de positionnement$$, $$La précision à laquelle le drone se repère.$$, 'cm');
	CALL add_drone_specification($$Vitesse maximum terrestre$$, $$Vitesse maximale sur le sol$$, 'km/h');
	CALL add_drone_specification($$Profondeur opérationnelle$$, $$Profondeur maximale à laquelle le drone aquatique peut opérer$$, 'm');
	CALL add_drone_specification($$Flottabilité$$, $$Capacité du drone aquatique à rester à une profondeur spécifiée$$, NULL);
	CALL add_drone_specification($$Moteurs$$, $$Nombre et type de moteurs$$, NULL);
	CALL add_drone_specification($$Temps de charge$$, $$Temps nécessaire pour recharger la batterie$$, 'h');
	CALL add_drone_specification($$Système anticollision$$, $$Technologie utilisée pour éviter les obstacles en vol ou en mouvement$$, NULL);
	CALL add_drone_specification($$Mode retour$$, $$Fonctionnalité permettant au drone de revenir automatiquement à un point de départ$$, NULL);
	CALL add_drone_specification($$Plage de température opérationnelle$$, $$Plage de températures dans laquelle le drone peut fonctionner de manière optimale$$, '°C');
	CALL add_drone_specification($$Autonomie en veille$$, $$Durée pendant laquelle le drone peut rester allumé sans voler ou bouger$$, 'h');
	CALL add_drone_specification($$Type de propulsion$$, $$Mécanisme de propulsion (hélices, roues, jets d'eau...)$$, NULL);
	CALL add_drone_specification($$Connectivité$$, $$Types de connexions prises en charge (Bluetooth, Wi-Fi Direct, LTE...)$$, NULL);
	CALL add_drone_specification($$Support de carte mémoire$$, $$Type de carte mémoire externe supporté (SD, microSD...)$$, NULL);
	CALL add_drone_specification($$Champ vision caméra$$, $$Angle de vision de la caméra embarquée$$, 'FOV');
	CALL add_drone_specification($$Zoom optique$$, $$Capacités de zoom de la caméra, si disponible$$, 'x');
	CALL add_drone_specification($$Stabilisation gimbal$$, $$Axes de stabilisation pour le gimbal de la caméra$$, 'axes');
	CALL add_drone_specification($$Système d'exploitation$$, $$Système d'exploitation logicielle embarqué$$, NULL);
	CALL add_drone_specification($$Logiciel embarqué$$, $$Outil logiciel disponible embarqué sur le drone$$, NULL);
	CALL add_drone_specification($$Modes pilotage$$, $$Différents modes de contrôle (manuel, automatique, programmé...)$$, NULL);
	CALL add_drone_specification($$Nombre de passagers$$, $$Nombre de passagers de taille et poids standards$$, NULL);
	CALL add_drone_specification($$Certification$$, $$Certification autorisée par un organisme gouvernemental ou indépendant$$, NULL);
	CALL add_drone_specification($$Brouillage$$, $$Résistance aux interférences ou au brouillage électronique$$, NULL);
	CALL add_drone_specification($$Compatibilité logicielle$$, $$Logiciels ou applications avec lesquels le drone est compatible$$, NULL);
	CALL add_drone_specification($$Mode décollage-atterrissage$$, $$Modes de décollage et d'atterrissage (manuel, automatique)$$, NULL);
	CALL add_drone_specification($$Type batterie$$, $$Technologie de la batterie utilisée (LiPo, NiMH, Li-Ion...)$$, NULL);
	CALL add_drone_specification($$Divers$$, $$Autres caractéristiques notables du drone$$, NULL);
COMMIT;


