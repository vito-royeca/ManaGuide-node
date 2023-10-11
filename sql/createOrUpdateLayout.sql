CREATE OR REPLACE FUNCTION createOrUpdateLayout(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _description ALIAS FOR $3;

    row cmlayout%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmlayout
        WHERE name = _name
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmlayout(
            name,
            name_section,
            description)
        VALUES(
            _name,
            _name_section,
            _description);
    ELSE
        if row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.description IS DISTINCT FROM _description THEN
        
            UPDATE cmlayout SET
                name = _name,
                name_section = _name_section,
                description = _description,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

