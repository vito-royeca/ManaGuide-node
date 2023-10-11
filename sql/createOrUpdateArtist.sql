CREATE OR REPLACE FUNCTION createOrUpdateArtist(
    character varying,
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _first_name ALIAS FOR $2;
    _last_name ALIAS FOR $3;
    _name_section ALIAS FOR $4;

    row cmartist%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmartist
        WHERE name = _name
        LIMIT 1;

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
        IF row.name IS DISTINCT FROM _name OR
           row.first_name IS DISTINCT FROM _first_name OR
           row.last_name IS DISTINCT FROM _last_name OR
           row.name_section IS DISTINCT FROM _name_section THEN

            UPDATE cmartist SET
                name = _name,
                first_name = _first_name,
                last_name = _last_name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

