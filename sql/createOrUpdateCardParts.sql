CREATE OR REPLACE FUNCTION createOrUpdateCardParts(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcomponent ALIAS FOR $2;
    _cmcard_part ALIAS FOR $3;

    cmcard_part_new_id character varying;
BEGIN
    SELECT new_id INTO cmcard_part_new_id FROM cmcard
        WHERE id = _cmcard_part
        LIMIT 1;

    INSERT INTO cmcard_component_part(
        cmcard,
        cmcomponent,
        cmcard_part)
    VALUES(
        _cmcard,
        _cmcomponent,
        cmcard_part_new_id)
    ON CONFLICT(cmcard, cmcomponent, cmcard_part)
        DO NOTHING;

    RETURN;
END;
$$ LANGUAGE plpgsql;

