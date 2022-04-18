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
    SELECT * INTO row FROM cmruling WHERE oracle_id = _oracle_id;

    IF NOT FOUND THEN
        INSERT INTO cmruling(
            oracle_id,
            text,
            date_published)
        VALUES(
            _oracle_id,
            _text,
            _date_published);
    ELSE
        IF row.oracle_id IS DISTINCT FROM _oracle_id OR
           row.text IS DISTINCT FROM _text OR
           row.date_published IS DISTINCT FROM _date_published THEN

            UPDATE cmruling SET
                oracle_id = _oracle_id,
                text = _text,
                date_published = _date_published,
                date_updated = now()
            WHERE oracle_id = _oracle_id;
        END IF;  
    END IF;        

    RETURN;
END;
$$ LANGUAGE plpgsql;

