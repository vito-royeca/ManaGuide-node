CREATE OR REPLACE FUNCTION createOrUpdateCardParts(
    character varying,
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcomponent ALIAS FOR $2;
    _cmcard_part ALIAS FOR $3;

    row cmcard_component_part%ROWTYPE;
    cmcard_part_new_id character varying;
BEGIN
    SELECT new_id INTO cmcard_part_new_id FROM cmcard
        WHERE id = _cmcard_part;

    SELECT * INTO row FROM cmcard_component_part
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
        IF row.cmcard IS DISTINCT FROM _cmcard OR
           row.cmcomponent IS DISTINCT FROM _cmcomponent OR
           row.cmcard_part IS DISTINCT FROM cmcard_part_new_id THEN

            UPDATE cmcard_component_part SET
                cmcard = _cmcard,
                cmcomponent = _cmcomponent,
                cmcard_part = cmcard_part_new_id,
                date_updated = now()
            WHERE cmcard = _cmcard
            AND cmcomponent = _cmcomponent
            AND cmcard_part = cmcard_part_new_id;
        END IF;    
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

