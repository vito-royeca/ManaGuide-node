CREATE OR REPLACE FUNCTION deleteCard(
    character varying) RETURNS boolean AS $$
DECLARE
    _new_id ALIAS FOR $1;

    pkey character varying;
BEGIN
    DELETE from cmcard_color WHERE cmcard = _new_id;
    DELETE from cmcard_coloridentity WHERE cmcard = _new_id;
    DELETE from cmcard_format_legality WHERE cmcard = _new_id;
    DELETE from cmcard_frameeffect WHERE cmcard = _new_id;
    DELETE from cmcard_otherprinting WHERE cmcard = _new_id;
    DELETE from cmcard_subtype WHERE cmcard = _new_id;
    DELETE from cmcard_supertype WHERE cmcard = _new_id;
    DELETE from cmcardprice WHERE cmcard = _new_id;
    DELETE from cmcard_face WHERE cmcard = _new_id;
    DELETE from cmcard WHERE new_id = _new_id;

    RETURN true;
END;
$$ LANGUAGE plpgsql;
