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



