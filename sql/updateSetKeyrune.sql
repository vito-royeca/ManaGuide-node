CREATE OR REPLACE FUNCTION updateSetKeyrune(
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _code ALIAS FOR $1;
    _my_keyrune_code ALIAS FOR $2;
BEGIN

    UPDATE cmset SET
        my_keyrune_code = _my_keyrune_code,
        date_updated = now()
    WHERE code = _code OR cmset_parent = _code;

    RETURN _code;
END;
$$ LANGUAGE plpgsql;

