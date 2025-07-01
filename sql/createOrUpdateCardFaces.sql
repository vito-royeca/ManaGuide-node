CREATE OR REPLACE FUNCTION createOrUpdateCardFaces(
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcard_face ALIAS FOR $2;
BEGIN
    INSERT INTO cmcard_face(
        cmcard,
        cmcard_face)
    VALUES(
        _cmcard,
        _cmcard_face)
    ON CONFLICT(
        cmcard,
        cmcard_face)
        DO NOTHING;

    RETURN;
END;
$$ LANGUAGE plpgsql;

