CREATE OR REPLACE FUNCTION selectCards(
    character varying,
    character varying,
    character varying,
    character varying)
    RETURNS TABLE (
        id character varying,
        collector_number character varying,
        face_order integer,
        loyalty character varying,
        mana_cost character varying,
        my_name_section character varying,
        my_number_order double precision,
        name character varying,
        printed_name character varying,
        printed_type_line character varying,
        type_line character varying,
        power character varying,
        toughness character varying,
        image_uris jsonb,
        set json,
        rarity json,
        language json,
        prices json[],
        faces  json[]
    )
AS
$$
DECLARE
    _cmset ALIAS FOR $1;
    _cmlanguage ALIAS FOR $2;
    _sortedBy ALIAS FOR $3;
    _orderBy ALIAS FOR $4;
    command character varying;
BEGIN
    IF lower(_sortedBy) = 'set_name' THEN
        _sortedBy = 's.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
	IF lower(_sortedBy) = 'set_release' THEN
        _sortedBy = 's.release_date ' || _orderBy || ', s.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'collector_number' THEN
        _sortedBy = 'c.my_number_order ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'name' THEN
        _sortedBy = 'c.name';
    END IF;
    IF lower(_sortedBy) = 'cmc' THEN
        _sortedBy = 'c.cmc ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'type' THEN
        _sortedBy = 'c.type_line ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'rarity' THEN
        _sortedBy = 'r.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;

    command := 'SELECT
                    id,
                    collector_number,
                    face_order,
                    loyalty,
                    mana_cost,
                    c.my_name_section,
                    my_number_order,
                    c.name,
                    printed_name,
                    printed_type_line,
                    type_line,
	                power,
                    toughness,
                    image_uris,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name
                            FROM cmset s WHERE s.code = c.cmset
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name, r.name_section
                            FROM cmrarity r WHERE r.name = c.cmrarity
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                        ) x
                    ) AS language,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_created
                            FROM cmcardprice v
                            WHERE v.cmcard = c.id
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command ||
                            'FROM cmcard c left join cmcard_face w on w.cmcard_face = c.id
                            WHERE w.cmcard = c.id
                        ) x
                    ) AS faces ';

    command := command || 'FROM cmcard c LEFT JOIN cmset s ON c.cmset = s.code ';
	command := command || 'LEFT JOIN cmrarity r ON c.cmrarity = r.name ';
    command := command || 'WHERE c.cmset = ''' || _cmset || ''' ';
    command := command || 'AND c.cmlanguage = ''' || _cmlanguage || ''' ';
    command := command || 'ORDER BY ' || _sortedBy || '';

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

