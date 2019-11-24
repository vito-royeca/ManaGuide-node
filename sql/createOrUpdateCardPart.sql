CREATE OR REPLACE FUNCTION createOrUpdateCardPart(
    character varying,
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcomponent ALIAS FOR $2;
    _cmcard_part ALIAS FOR $3;

    pkey character varying;
BEGIN
    SELECT cmcard INTO pkey FROM cmcard_part
    WHERE cmcard = _cmcard
        AND cmcomponent = _cmcomponent
        AND cmcard_part = _cmcard_part;

    IF NOT FOUND THEN
        INSERT INTO cmcard_part(
            cmcard,
            cmcomponent,
            cmcard_part)
        VALUES(
            _cmcard,
            _cmcomponent,
            _cmcard_part);
    ELSE
        UPDATE cmcard_part SET
            cmcard = _cmcard,
            cmcomponent = _cmcomponent,
            cmcard_part = _cmcard_part,
            date_updated = now()
        WHERE cmcard = _cmcard
            AND cmcomponent = _cmcomponent
            AND cmcard_part = _cmcard_part;
    END IF;

    RETURN _cmcard;
END;
$$ LANGUAGE plpgsql;

