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
BEGIN
    INSERT INTO cmcolor(
        symbol,
        name,
        name_section,
        is_mana_color)
    VALUES(
        _symbol,
        _name,
        _name_section,
        _is_mana_color)
    ON CONFLICT(symbol)
        DO UPDATE SET
            symbol = EXCLUDED.symbol,
            name = EXCLUDED.name,
            name_section = EXCLUDED.name_section,
            is_mana_color = EXCLUDED.is_mana_color,
            date_updated = now();

    RETURN;
END;
$$ LANGUAGE plpgsql;

