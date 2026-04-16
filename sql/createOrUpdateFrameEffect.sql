CREATE OR REPLACE FUNCTION createOrUpdateFrameEffect(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _id ALIAS FOR $1;
    _name ALIAS FOR $2;
    _description ALIAS FOR $3;
BEGIN
    -- check for nulls
    IF lower(_id) = 'null' THEN
        _id := NULL;
    END IF;
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;
    IF lower(_description) = 'null' THEN
        _description := NULL;
    END IF;

    INSERT INTO cmframeeffect(
        id,
        name,
        description)
    VALUES(
        _id,
        _name,
        _description)
    ON CONFLICT(id)
    DO UPDATE SET
        name = EXCLUDED.name,
        description = EXCLUDED.description,
        date_updated = now();
    
    RETURN;
END;
$$ LANGUAGE plpgsql;

