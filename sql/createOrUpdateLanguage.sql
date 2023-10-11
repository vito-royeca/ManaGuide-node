CREATE OR REPLACE FUNCTION createOrUpdateLanguage(
    character varying,
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _code ALIAS FOR $1;
    _display_code ALIAS FOR $2;
    _name ALIAS FOR $3;
    _name_section ALIAS FOR $4;

    row cmlanguage%ROWTYPE;
BEGIN
    -- check for nulls
    IF lower(_display_code) = 'null' THEN
        _display_code := NULL;
    END IF;
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;
    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;

    SELECT * INTO row FROM cmlanguage
        WHERE code = _code
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmlanguage(
            code,
            display_code,
            name,
            name_section)
        VALUES(
            _code,
            _display_code,
            _name,
            _name_section);
    ELSE
        IF row.code IS DISTINCT FROM _code OR
           row.display_code IS DISTINCT FROM _display_code OR
           row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
            
            UPDATE cmlanguage SET
                code = _code,
                display_code = _display_code,
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE code = _code;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

