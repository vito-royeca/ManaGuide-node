CREATE OR REPLACE FUNCTION createOrUpdateComponent(
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
BEGIN
    INSERT INTO cmcomponent(
        name,
        name_section)
    VALUES(
        _name,
        _name_section)
    ON CONFLICT(name)
        DO NOTHING;

    RETURN;
END;
$$ LANGUAGE plpgsql;

