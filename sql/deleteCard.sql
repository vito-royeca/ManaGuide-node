CREATE OR REPLACE FUNCTION deleteCard(
    character varying) RETURNS boolean AS $$
DECLARE
    _new_id_or_id ALIAS FOR $1;

    pkey character varying;
    _new_id character varying;
BEGIN
    SELECT new_id INTO _new_id FROM cmcard c where c.new_id = _new_id_or_id;

    IF NOT FOUND THEN
        SELECT new_id INTO _new_id FROM cmcard c where c.id = _new_id_or_id;
    END IF;

    DELETE from cmcard_color WHERE cmcard = _new_id;
    DELETE from cmcard_coloridentity WHERE cmcard = _new_id;
	DELETE from cmcard_colorindicator WHERE cmcard = _new_id;
	DELETE from cmcard_component_part WHERE cmcard = _new_id;
    DELETE from cmcard_component_part WHERE cmcard_part = _new_id;
	DELETE from cmcard_face WHERE cmcard_face = _new_id;
	DELETE from cmcard_face WHERE cmcard = _new_id;
    DELETE from cmcard_format_legality WHERE cmcard = _new_id;
    DELETE from cmcard_frameeffect WHERE cmcard = _new_id;
	DELETE from cmcard_otherlanguage WHERE cmcard = _new_id;
    DELETE from cmcard_otherprinting WHERE cmcard = _new_id;
    DELETE from cmcard_subtype WHERE cmcard = _new_id;
    DELETE from cmcard_supertype WHERE cmcard = _new_id;
    DELETE from cmcardprice WHERE cmcard = _new_id;
	DELETE from cmcard_variation WHERE cmcard = _new_id;
    DELETE from cmcard_game WHERE cmcard = _new_id;
    DELETE from cmcard_artist WHERE cmcard = _new_id;
    DELETE from cmcard_keyword WHERE cmcard = _new_id;
    DELETE from cmcard WHERE new_id = _new_id;

    RETURN true;
END;
$$ LANGUAGE plpgsql;
