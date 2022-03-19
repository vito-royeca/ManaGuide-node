CREATE OR REPLACE FUNCTION selectRules(
    integer)
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
    _id ALIAS FOR $1;
    command character varying;
BEGIN
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
                    ) AS children ';
                    
    command := command ||                
                    'FROM cmrule s';

    IF _id IS NOT NULL THEN
        command := command || ' WHERE s.id = ' || _id || '';
    ELSE
	    command := command || ' WHERE s.cmrule_parent IS NULL';
    END IF;

    command := command || ' ORDER BY s.order ASC';

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

