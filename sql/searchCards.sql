CREATE OR REPLACE FUNCTION searchCards(
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
    _query ALIAS FOR $1;
    command character varying;
BEGIN
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

    _query := lower(_query);
    command := command || 'FROM cmcard c LEFT JOIN cmset s ON c.cmset = s.code WHERE c.cmlanguage = ''en'' ';
    command := command || 'AND c.id NOT IN(select cmcard_face from cmcard_face) ';
    command := command || 'AND lower(c.name) LIKE ''%' || _query || '%'' ';
    command := command || 'GROUP BY c.id,
                    c.collector_number,
                    c.face_order,
                    c.loyalty,
                    c.mana_cost,
                    c.my_name_section,
                    c.my_number_order,
                    c.name,
                    c.printed_name,
                    c.printed_type_line,
                    c.type_line,
	                c.power,
                    c.toughness,
                    s.release_date ';
    command := command ||  'ORDER BY s.release_date DESC, c.name ASC ';

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

