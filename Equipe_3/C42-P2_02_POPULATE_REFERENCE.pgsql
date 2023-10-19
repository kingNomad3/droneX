DEALLOCATE ins_unit;

PREPARE ins_unit(VARCHAR(16),VARCHAR(64), VARCHAR(1024)) AS 
INSERT INTO unit(symbol, name , description)VALUES ($1,$2,$3);

BEGIN;
	EXECUTE ins_unit('M', 'metres', 'Unite de base de longeur');
COMMIT;

-- SELECT * FROM unit

DEALLOCATE ins_technical_specification;

PREPARE ins_technical_specification(VARCHAR(64),VARCHAR(512),VARCHAR(16)) AS 
INSERT INTO technical_specification(name, description, unit) VALUES ($1,$2,(SELECT id FROM unit WHERE symbol = $3));

BEGIN;
	EXECUTE ins_technical_specification('Poids','Masse du produit','M');
COMMIT;

-- SELECT * FROM technical_specification



CREATE OR REPLACE FUNCTION forbid_dml_operations() RETURNS TRIGGER
LANGUAGE PLPGSQL AS $$
BEGIN
RAISE EXCEPTION 'Vous ne possedez pas les permissions pour modifier cette table';
END$$;

CREATE TRIGGER forbid_dml_operations_trig_unit
	BEFORE INSERT OR UPDATE OR DELETE ON unit
	FOR EACH ROW
	EXECUTE PROCEDURE forbid_dml_operations();

CREATE TRIGGER forbid_dml_operations_trig_ts
	BEFORE INSERT OR UPDATE OR DELETE ON technical_specification;
	FOR EACH ROW
	EXECUTE PROCEDURE forbid_dml_operations();
	
	
CREATE OR REPLACE PROCEDURE insertAAA(insert_1 VARCHAR(14), insert_2 VARCHAR(64), insert_3 VARCHAR(1024))
LANGUAGE SQL
AS $$
	INSERT INTO unit(symbol, name , description)VALUES (insert_1, insert_2, insert_3);
$$;


CALL insertAAA('M', 'metres', 'Unite de base de longeur');






	
