CREATE OR REPLACE FUNCTION createOrUpdateSetBlock(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _code ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;

    row cmsetblock%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmsetblock WHERE code = _code;

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
        IF row.code IS DISTINCT FROM _code OR
           row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
        
            UPDATE cmsetblock SET
                code = _code,
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE code = _code;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

