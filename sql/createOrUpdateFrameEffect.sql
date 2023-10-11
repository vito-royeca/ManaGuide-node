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

    row cmframeeffect%ROWTYPE;
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

    SELECT * INTO row FROM cmframeeffect
        WHERE id = _id
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmframeeffect(
            id,
            name,
            name_section,
            description)
        VALUES(
            _id,
            _name,
            _name_section,
            _description);
    ELSE
        IF row.id IS DISTINCT FROM _id OR
           row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.description IS DISTINCT FROM _description THEN
            
            UPDATE cmframeeffect SET
                id = _id,
                name = _name,
                name_section = _name_section,
                description = _description,
                date_updated = now()
            WHERE id = _id;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

