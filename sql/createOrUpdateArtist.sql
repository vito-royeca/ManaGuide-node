CREATE OR REPLACE FUNCTION createOrUpdateArtist(
    character varying,
    character varying,
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _name ALIAS FOR $1;
    _first_name ALIAS FOR $2;
    _last_name ALIAS FOR $3;
    _name_section ALIAS FOR $4;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmartist WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmartist(
            name,
            first_name,
            last_name,
            name_section)
        VALUES(
            _name,
            _first_name,
            _last_name,
            _name_section);
    ELSE
        UPDATE cmartist SET
            name = _name,
            first_name = _first_name,
            last_name = _last_name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$$ LANGUAGE plpgsql;

