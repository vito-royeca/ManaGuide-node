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

    INSERT INTO cmlanguage(
        code,
        display_code,
        name,
        name_section)
    VALUES(
        _code,
        _display_code,
        _name,
        _name_section)
    ON CONFLICT(code)
        DO UPDATE SET
            display_code = EXCLUDED.display_code,
            name = EXCLUDED.name,
            name_section = EXCLUDED.name_section,
            date_updated = now();

    RETURN;
END;
$$ LANGUAGE plpgsql;

