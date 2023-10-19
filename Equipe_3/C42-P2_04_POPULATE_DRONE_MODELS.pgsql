-- section 4 partie 1 
CREATE OR REPLACE PROCEDURE add_drone_manufacturer(name_value VARCHAR(64), web_site_value VARCHAR(256))
LANGUAGE SQL
AS $$
	INSERT INTO manufacturing_company(name , web_site)VALUES (name_value, web_site_value);
$$;

CALL add_drone_manufacturer('M', 'metres');

-- SELECT * FROM  manufacturing_company


-- sectipon4 partie 3
CREATE OR REPLACE FUNCTION add_drone_specification(model_name VARCHAR(200), spec_name VARCHAR(200), spec_value VARCHAR(256), spec_comments VARCHAR(1024)) 
RETURNS VOID
LANGUAGE SQL
AS
$$
INSERT INTO drone_specification(drone_model, specification,value, comments) VALUES((SELECT id FROM drone_model WHERE name=model_name),(SELECT id FROM technical_specification WHERE name = spec_name), spec_value ,spec_comments);
$$;

SELECT add_drone_specification('Matrice 350 RTK','Autonomie d''opÃ©ration','55','La durÃ©e peut varier en fonction des conditions de vol.');

					
SELECT * FROM drone_specification

	
