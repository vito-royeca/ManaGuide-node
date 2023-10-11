CREATE OR REPLACE FUNCTION createOrUpdateColor(
    character varying,
    character varying,
    character varying,
    boolean) RETURNS void AS $$
DECLARE
    _symbol ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
    _is_mana_color ALIAS FOR $4;

    row cmcolor%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmcolor WHERE name = _name
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmcolor(
            symbol,
            name,
            name_section,
            is_mana_color)
        VALUES(
            _symbol,
            _name,
            _name_section,
            _is_mana_color);
    ELSE
        IF row.symbol IS DISTINCT FROM _symbol OR
           row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.is_mana_color IS DISTINCT FROM _is_mana_color THEN

            UPDATE cmcolor SET
                symbol = _symbol,
                name = _name,
                name_section = _name_section,
                is_mana_color = _is_mana_color,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

