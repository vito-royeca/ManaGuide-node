CREATE OR REPLACE FUNCTION createOrUpdateColor(
    character varying,
    character varying,
    character varying,
    boolean) RETURNS varchar AS $$
DECLARE
    _symbol ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
    _is_mana_color ALIAS FOR $4;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmcolor WHERE name = _name;

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
        UPDATE cmcolor SET
            symbol = _symbol,
            name = _name,
            name_section = _name_section,
            is_mana_color = _is_mana_color,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$$ LANGUAGE plpgsql;

