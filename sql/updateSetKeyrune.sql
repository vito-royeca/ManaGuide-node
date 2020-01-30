CREATE OR REPLACE FUNCTION updateSetKeyrune(
    character varying,
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _code ALIAS FOR $1;
    _keyrune_unicode ALIAS FOR $2;
    _keyrune_class ALIAS FOR $3;
BEGIN

    UPDATE cmset SET
        keyrune_unicode = _keyrune_unicode,
        keyrune_class = _keyrune_class,
        date_updated = now()
    WHERE code = _code OR cmset_parent = _code;

    RETURN _code;
END;
$$ LANGUAGE plpgsql;

