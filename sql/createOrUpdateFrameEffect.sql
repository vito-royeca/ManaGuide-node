CREATE OR REPLACE FUNCTION createOrUpdateFrameEffect(
    character varying,
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _id ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
    _description ALIAS FOR $4;
BEGIN
    -- check for nulls
    IF lower(_id) = 'null' THEN
        _id := NULL;
    END IF;
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;
    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;
    IF lower(_description) = 'null' THEN
        _description := NULL;
    END IF;

    INSERT INTO cmframeeffect(
        id,
        name,
        name_section,
        description)
    VALUES(
        _id,
        _name,
        _name_section,
        _description)
    ON CONFLICT(id)
    DO UPDATE SET
        name = EXCLUDED.name,
        name_section = EXCLUDED.name_section,
        description = EXCLUDED.description,
        date_updated = now();
    
    RETURN;
END;
$$ LANGUAGE plpgsql;

