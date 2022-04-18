CREATE OR REPLACE FUNCTION createOrUpdateCardFaces(
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcard_face ALIAS FOR $2;

    row cmcard_face%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmcard_face
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
        IF row.cmcard IS DISTINCT FROM _cmcard OR
           row.cmcard_face IS DISTINCT FROM _cmcard_face THEN

            UPDATE cmcard_face SET
                cmcard = _cmcard,
                cmcard_face = _cmcard_face,
                date_updated = now()
            WHERE cmcard = _cmcard
                AND cmcard_face = _cmcard_face;
        END IF;        
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

