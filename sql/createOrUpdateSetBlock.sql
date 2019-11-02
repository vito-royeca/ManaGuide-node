CREATE OR REPLACE FUNCTION createOrUpdateSetBlock(
    character varying,
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _code ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;

    pkey character varying;
BEGIN
    SELECT code INTO pkey FROM cmsetblock WHERE code = _code;

    IF NOT FOUND THEN
        INSERT INTO cmsetblock(
            code,
            name,
            name_section)
        VALUES(
            _code,
            _name,
            _name_section);
    ELSE
        UPDATE cmsetblock SET
            code = _code,
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE code = _code;
    END IF;

    RETURN _code;
END;
$$ LANGUAGE plpgsql;

