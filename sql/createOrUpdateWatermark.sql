CREATE OR REPLACE FUNCTION createOrUpdateWatermark(
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmwatermark WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmwatermark(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmwatermark SET
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$$ LANGUAGE plpgsql;

