CREATE OR REPLACE FUNCTION createOrUpdateArtist(
    character varying,
    character varying,
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _first_name ALIAS FOR $2;
    _last_name ALIAS FOR $3;
    _name_section ALIAS FOR $4;
    _info ALIAS FOR $5;

    row cmartist%ROWTYPE;
    _new_info character varying;

BEGIN
    -- check for nulls
    IF lower(_first_name) = 'null' THEN
        _first_name := NULL;
    END IF;
    IF lower(_last_name) = 'null' THEN
        _last_name := NULL;
    END IF;
    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;
    IF lower(_info) = 'null' THEN
        _info := NULL;
    END IF;

    SELECT * INTO row FROM cmartist
        WHERE name = _name
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmartist(
            name,
            first_name,
            last_name,
            name_section,
            info)
        VALUES(
            _name,
            _first_name,
            _last_name,
            _name_section,
            _info);
    ELSE
        IF row.first_name IS DISTINCT FROM _first_name OR
           row.last_name IS DISTINCT FROM _last_name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.info IS DISTINCT FROM _info THEN
            IF row.info IS NULL THEN
                _new_info := _info;
            ELSE
                IF _info IS NULL THEN
                    _new_info := NULL;
                ELSE
                    IF right(row.info, char_length(_info)) <> _info THEN
                        _new_info := row.info || '; ' || _info;
                    END IF;
                END IF;
            END IF;

            UPDATE cmartist SET
                name = _name,
                first_name = _first_name,
                last_name = _last_name,
                name_section = _name_section,
                info = _new_info,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

