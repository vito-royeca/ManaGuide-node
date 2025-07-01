CREATE OR REPLACE FUNCTION createOrUpdateRule(
    character varying,
    character varying,
    character varying,
    double precision,
    integer,
    integer) RETURNS void AS $$
DECLARE
    _term ALIAS FOR $1;
    _term_section ALIAS FOR $2;
    _definition ALIAS FOR $3;
    _order ALIAS FOR $4;
    _cmrule_parent ALIAS FOR $5;
    _id ALIAS FOR $6;

BEGIN
    IF lower(_term) = 'null' THEN
        _term := NULL;
    END IF;
    IF lower(_term_section) = 'null' THEN
        _term_section := NULL;
    END IF;
    IF lower(_definition) = 'null' THEN
        _definition := NULL;
    END IF;
    IF _cmrule_parent = -1 THEN
        _cmrule_parent := NULL;
    END IF;

    INSERT INTO cmrule(
        term,
        term_section,
        definition,
        "order",
        cmrule_parent,
        id)
    VALUES(
        _term,
        _term_section,
        _definition,
        _order,
        _cmrule_parent,
        _id)
    ON CONFLICT(
        term)
    DO UPDATE SET
        term_section = EXCLUDED.term_section,
        definition = EXCLUDED.definition,
        "order" = _order,
        cmrule_parent = EXCLUDED.cmrule_parent,
        id = _id,
        date_updated = now();

    RETURN;
END;
$$ LANGUAGE plpgsql;

