CREATE OR REPLACE FUNCTION createOrUpdateFrame(
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _description ALIAS FOR $2;
BEGIN
    INSERT INTO cmframe(
        name,
        description)
    VALUES(
        _name,
        _description)
    ON CONFLICT(name)
    DO UPDATE SET
        description = EXCLUDED.description,
        date_updated = now();

    RETURN;
END;
$$ LANGUAGE plpgsql;

