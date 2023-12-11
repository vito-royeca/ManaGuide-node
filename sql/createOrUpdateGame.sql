CREATE OR REPLACE FUNCTION createOrUpdateGame(
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmgame%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmgame
        WHERE name = _name
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmgame(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
        
            UPDATE cmgame SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;
