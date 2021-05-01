CREATE OR REPLACE FUNCTION createOrUpdateFrameEffect(
    character varying,
    character varying,
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _id ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
    _description ALIAS FOR $4;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmframeeffect WHERE id = _id;

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
        UPDATE cmframeeffect SET
            id = _id,
            name = _name,
            name_section = _name_section,
            description = _description,
            date_updated = now()
        WHERE id = _id;
    END IF;

    RETURN _id;
END;
$$ LANGUAGE plpgsql;

