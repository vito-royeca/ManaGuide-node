CREATE OR REPLACE FUNCTION createOrUpdateCardType(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _cmcardtype_parent ALIAS FOR $3;
BEGIN
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;

    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;
    IF lower(_cmcardtype_parent) = 'null' THEN
        _cmcardtype_parent := NULL;
    END IF;

    IF _cmcardtype_parent IS NOT NULL THEN
        PERFORM createOrUpdateCardType(_cmcardtype_parent, LEFT(_cmcardtype_parent, 1), NULL);
    END IF;

    UPDATE cmcardtype SET
        name = _name,
        name_section = _name_section,
        cmcardtype_parent = _cmcardtype_parent,
        date_updated = now()
    WHERE name = _name;

    INSERT INTO cmcardtype(
        name,
        name_section,
        cmcardtype_parent)
    VALUES(
        _name,
        _name_section,
        _cmcardtype_parent)
    ON CONFLICT(name)
        DO UPDATE SET
            name_section = EXCLUDED.name_section,
            cmcardtype_parent = EXCLUDED.cmcardtype_parent,
            date_updated = now();

    RETURN;
END;
$$ LANGUAGE plpgsql;

