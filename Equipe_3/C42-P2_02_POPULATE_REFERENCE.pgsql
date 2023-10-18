PREPARE ins_unit(VARCHAR(16),VARCHAR(64), VARCHAR(1024)) AS 
INSERT INTO unit VALUES ($1,$2,$3); 
EXECUTE ins_unit('M', 'metres', 'Unite de base de longeur');

DEALLOCATE ins_unit;

PREPARE ins_technical_specification(VARCHAR(64),VARCHAR(512),INTEGER) AS 
INSERT INTO technical_specification VALUES ($1,$2,(SELECT id FROM unit WHERE symbol = $3));
EXECUTE ins_technical_specification('Poids','Masse du produit','kg');

DEALLOCATE ins_technical_specification;


-- PREPARE ins_drone_specification(INTEGER,INTEGER,VARCHAR(256),VARCHAR(1024)) AS
-- INSERT INTO ins_drone_specification VALUES((SELECT id FROM drone_model WHERE name = $1),(SELECT id FROM drone_model WHERE name = $2),$3,$4);
-- EXECUTE ins_drone_specification('Matrice 350 RTK','Autonomie dopÃ©ration','55','La durÃ©e peut varier en fonction des conditions de vol');

-- DEALLOCATE ins_drone_specification


PREPARE ins_operational_domain(VARCHAR(32),VARCHAR(256),INTEGER) AS
INSERT INTO ins_operational_domain VALUES($1,$2,$3);
EXECUTE ins_operational_domain('Domaine operationel','Envit');

DEALLOCATE ins_drone_specification
