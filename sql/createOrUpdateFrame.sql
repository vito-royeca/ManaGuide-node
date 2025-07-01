CREATE OR REPLACE FUNCTION createOrUpdateFrame(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _description ALIAS FOR $3;
BEGIN
    INSERT INTO cmframe(
        name,
        name_section,
        description)
    VALUES(
        _name,
        _name_section,
        _description)
    ON CONFLICT(name)
    DO UPDATE SET
        name_section = EXCLUDED.name_section,
        description = EXCLUDED.description,
        date_updated = now();

    RETURN;
END;
$$ LANGUAGE plpgsql;

