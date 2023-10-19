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


CALL add_drone_model('Matrice 350 RTK','DJI Enterprise','Vol à vue','Drone aérien pour la surveillance et l''inspection avec caméra thermique avancée.','https://enterprise.dji.com/matrice-350-rtk');

