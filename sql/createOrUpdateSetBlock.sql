CREATE OR REPLACE FUNCTION createOrUpdateSetBlock(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _code ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
BEGIN
    INSERT INTO cmsetblock(
        code,
        name,
        name_section)
    VALUES(
        _code,
        _name,
        _name_section)
    ON CONFLICT(code)
        DO NOTHING;

    RETURN;
END;
$$ LANGUAGE plpgsql;

