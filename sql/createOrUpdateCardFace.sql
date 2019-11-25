CREATE OR REPLACE FUNCTION createOrUpdateCardFace(
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcard_face ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT cmcard INTO pkey FROM cmcard_face
    WHERE cmcard = _cmcard
        AND cmcard_face = _cmcard_face;

    IF NOT FOUND THEN
        INSERT INTO cmcard_face(
            cmcard,
            cmcard_face)
        VALUES(
            _cmcard,
            _cmcard_face);
    ELSE
        UPDATE cmcard_face SET
            cmcard = _cmcard,
            cmcard_face = _cmcard_face,
            date_updated = now()
        WHERE cmcard = _cmcard
            AND cmcard_face = _cmcard_face;
    END IF;

    RETURN _cmcard;
END;
$$ LANGUAGE plpgsql;

