CREATE OR REPLACE FUNCTION createOrUpdateLegality(
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmlegality WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmlegality(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmlegality SET
            name = _name,
            name_section = _name_section
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$$ LANGUAGE plpgsql;

