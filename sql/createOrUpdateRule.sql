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

    row cmrule%ROWTYPE;
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

    SELECT * INTO row FROM cmrule
        WHERE term = _term AND
        term_section = _term_section AND
        definition = _definition AND
        "order" = _order
        LIMIT 1;

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
        IF row.term IS DISTINCT FROM _term OR
           row.term_section IS DISTINCT FROM _term_section OR
           row.definition IS DISTINCT FROM _definition OR
           row."order" IS DISTINCT FROM _order OR
           row.cmrule_parent IS DISTINCT FROM _cmrule_parent OR
           row.id IS DISTINCT FROM _id THEN
            
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
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

