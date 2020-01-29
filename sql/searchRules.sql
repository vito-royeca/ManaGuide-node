CREATE OR REPLACE FUNCTION searchRules(
    character varying)
    RETURNS TABLE (
        id              integer,
        term            character varying,
        term_section    character varying,
        definition      character varying,
        "order"         double precision,
        parent          json,
        children        json[]
    )
AS
$$
DECLARE
    _query ALIAS FOR $1;
    command character varying;
BEGIN
    _query := lower(_query);

    command := 'SELECT id,
                    term,
                    term_section,
                    definition,
                    "order",
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT p.id, p.term, p.definition
                            FROM cmrule p WHERE p.id = s.cmrule_parent
                        ) x
                    ) AS parent';

    -- Children
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command || ', (SELECT children from selectRules(c.id))'
                            ' FROM cmrule c
                            WHERE c.cmrule_parent = s.id ORDER BY c.term'
                        ') x
                    ) AS children FROM cmrule s';

    command := command || ' WHERE lower(s.term) LIKE ''%' || _query || '%'' ';
    command := command || ' OR lower(s.definition) LIKE ''%' || _query || '%'' ';

    command := command || ' ORDER BY s.order ASC';

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

