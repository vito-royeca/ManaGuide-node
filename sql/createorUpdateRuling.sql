CREATE OR REPLACE FUNCTION createOrUpdateRuling(
    character varying,
    character varying,
    date) RETURNS varchar AS $$
DECLARE
    _oracle_id ALIAS FOR $1;
    _text ALIAS FOR $2;
    _date_published ALIAS FOR $3;

    pkey character varying;
BEGIN
        INSERT INTO cmruling(
            oracle_id,
            text,
            date_published)
        VALUES(
            _oracle_id,
            _text,
            _date_published);

    RETURN _oracle_id;
END;
$$ LANGUAGE plpgsql;

