CREATE OR REPLACE FUNCTION createOrUpdateRuling(
    character varying,
    character varying,
    date) RETURNS void AS $$
DECLARE
    _oracle_id ALIAS FOR $1;
    _text ALIAS FOR $2;
    _date_published ALIAS FOR $3;

    row cmruling%ROWTYPE;
BEGIN
    INSERT INTO cmruling(
        oracle_id,
        text,
        date_published)
    VALUES(
        _oracle_id,
        _text,
        _date_published);

    RETURN;
END;
$$ LANGUAGE plpgsql;

