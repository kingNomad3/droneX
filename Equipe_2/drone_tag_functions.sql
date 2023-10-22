-- fait la partie A du drone_tag
CREATE OR REPLACE FUNCTION drone_tag_a (manufacturer_name VARCHAR) RETURNS CHAR(3)
LANGUAGE PLPGSQL 
AS $$
	BEGIN
		manufacturer_name := UPPER(REGEXP_REPLACE(manufacturer_name, '[^a-zA-Z]', '', 'g'));
		RETURN RPAD(SUBSTR(manufacturer_name, 1, 3), 3, 'x');
	END
$$;


-- fait la partie B du drone_tag
CREATE OR REPLACE FUNCTION drone_tag_b (model_name VARCHAR) RETURNS CHAR(3)
LANGUAGE PLPGSQL
AS $$
DECLARE
		trimmed VARCHAR := UPPER(REPLACE(model_name, ' ', ''));
		len INT := LENGTH(trimmed);
		bias INT := (len % 2 = 1)::int;
		first CHAR := SUBSTR(trimmed, 1, 1);
		last CHAR := SUBSTR(trimmed, len, 1);
		
BEGIN
	IF len=1 
		THEN RETURN CONCAT('x', trimmed, 'x');
	ELSIF len=2 
		THEN RETURN CONCAT(first, 'x', last);
	ELSE 
		RETURN CONCAT(first, SUBSTR(trimmed, len/2 + bias, 1), last);
	END IF;
END$$;


-- fait la partie C du drone_tag
CREATE OR REPLACE FUNCTION drone_tag_c (acquisition_date DATE) RETURNS CHAR(6)
LANGUAGE PLPGSQL
AS $$
DECLARE date_reference DATE := '2000-01-01'::date;
BEGIN
	RETURN LPAD((acquisition_date - date_reference)::VARCHAR, 6, '0');
END$$;


