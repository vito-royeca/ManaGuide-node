CREATE OR REPLACE FUNCTION createOrUpdateLayout(
    character varying,
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _description ALIAS FOR $3;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmlayout WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmlayout(
            name,
            name_section,
            description_)
        VALUES(
            _name,
            _name_section,
            _description);
    ELSE
        UPDATE cmlayout SET
            name = _name,
            name_section = _name_section,
            description_ = _description,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$$ LANGUAGE plpgsql;

