CREATE OR REPLACE FUNCTION createOrUpdateRule(
    character varying,
    character varying,
    character varying,
    double precision,
    integer,
    integer) RETURNS varchar AS $$
DECLARE
    _term ALIAS FOR $1;
    _term_section ALIAS FOR $2;
    _definition ALIAS FOR $3;
    _order ALIAS FOR $4;
    _cmrule_parent ALIAS FOR $5;
    _id ALIAS FOR $6;

    pkey character varying;
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

    SELECT id INTO pkey FROM cmrule
        WHERE term = _term AND
        term_section = _term_section AND
        definition = _definition AND
        "order" = _order;

    IF NOT FOUND THEN
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
            _id);
    ELSE
        UPDATE cmrule SET
            term = _term,
            term_section = _term_section,
            definition = _definition,
            "order" = _order,
            cmrule_parent = _cmrule_parent,
            id = _id,
            date_updated = now()
        WHERE term = _term AND
            term_section = _term_section AND
            definition = _definition AND
            "order" = _order;
    END IF;

    RETURN pkey;
END;
$$ LANGUAGE plpgsql;

