CREATE OR REPLACE FUNCTION createOrUpdateCardParts(
    character varying,
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcomponent ALIAS FOR $2;
    _cmcard_part ALIAS FOR $3;

    pkey character varying;
    cmcard_part_new_id character varying;
BEGIN
    SELECT new_id INTO cmcard_part_new_id FROM cmcard
    WHERE id = _cmcard_part;

    SELECT cmcard INTO pkey FROM cmcard_component_part
    WHERE cmcard = _cmcard
      AND cmcomponent = _cmcomponent
      AND cmcard_part = cmcard_part_new_id;

    IF NOT FOUND THEN
        INSERT INTO cmcard_component_part(
            cmcard,
            cmcomponent,
            cmcard_part)
        VALUES(
            _cmcard,
            _cmcomponent,
            cmcard_part_new_id);
    ELSE
        UPDATE cmcard_component_part SET
            cmcard = _cmcard,
            cmcomponent = _cmcomponent,
            cmcard_part = cmcard_part_new_id,
            date_updated = now()
        WHERE cmcard = _cmcard
          AND cmcomponent = _cmcomponent
          AND cmcard_part = cmcard_part_new_id;
    END IF;

    RETURN _cmcard;
END;
$$ LANGUAGE plpgsql;

