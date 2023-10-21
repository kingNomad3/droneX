DROP FUNCTION IF EXISTS random_office_number();
DROP FUNCTION IF EXISTS random_office_type();
DROP FUNCTION IF EXISTS random_room_number();
DROP FUNCTION IF EXISTS random_floor_level();
DROP FUNCTION IF EXISTS random_color_tag();
DROP FUNCTION IF EXISTS random_building_code(range FLOAT);

CREATE OR REPLACE FUNCTION random_building_code(range FLOAT)
	RETURNS CHAR(2)
LANGUAGE PLPGSQL
DECLARE
    random_value FLOAT := random();
AS $$
BEGIN

    IF range < 0.85 THEN
        RETURN CASE
            WHEN random_value <= range THEN 'XB'
            ELSE 'GZ'
        END;
    ELSE
        RETURN CASE
            WHEN random_value <= range THEN 'GZ'
            ELSE 'XB'
        END;
    END IF;

END$$;

CREATE OR REPLACE FUNCTION random_color_tag()
	RETURNS CHAR(20)
LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN ;
END$$;

CREATE OR REPLACE FUNCTION random_floor_level()
	RETURNS CHAR(20)
LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN ;
END$$;

CREATE OR REPLACE FUNCTION random_room_number()
	RETURNS CHAR(20)
LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN ;
END$$;

CREATE OR REPLACE FUNCTION random_office_type()
	RETURNS CHAR(20)
LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN ;
END$$;

CREATE OR REPLACE FUNCTION random_office_number()
	RETURNS CHAR(20)
LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN ;
END$$;