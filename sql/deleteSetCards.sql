CREATE OR REPLACE FUNCTION deleteSetCards(
    character varying) RETURNS integer AS $$
DECLARE
    _code ALIAS FOR $1;

    _new_id character varying;
    _card_count integer := 0;
BEGIN

    FOR _new_id IN SELECT new_id FROM cmcard where cmset = _code LOOP
        PERFORM deleteCard(_new_id);
        _card_count := _card_count + 1;
    END LOOP;

    RETURN _card_count;
END;
$$ LANGUAGE plpgsql;