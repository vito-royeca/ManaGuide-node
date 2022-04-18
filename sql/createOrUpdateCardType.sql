CREATE OR REPLACE FUNCTION createOrUpdateCardType(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _cmcardtype_parent ALIAS FOR $3;

    row cmcardtype%ROWTYPE;
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

    SELECT * INTO row FROM cmcardtype WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmcardtype(
            name,
            name_section,
            cmcardtype_parent)
        VALUES(
            _name,
            _name_section,
            _cmcardtype_parent);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.cmcardtype_parent IS DISTINCT FROM _cmcardtype_parent THEN

            UPDATE cmcardtype SET
                name = _name,
                name_section = _name_section,
                cmcardtype_parent = _cmcardtype_parent,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

