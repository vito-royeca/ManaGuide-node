CREATE OR REPLACE FUNCTION createOrUpdateLayout(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _code ALIAS FOR $1;
    _name ALIAS FOR $2;
    _description ALIAS FOR $3;
BEGIN
    INSERT INTO cmlayout(
        code,
        name,
        description)
    VALUES(
        _code,
        _name,
        _description)
    ON CONFLICT(code)
        DO UPDATE SET
            name = EXCLUDED.name,
            description = EXCLUDED.description,
            date_updated = now();

    RETURN;
END;
$$ LANGUAGE plpgsql;

