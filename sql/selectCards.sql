CREATE OR REPLACE FUNCTION selectCards(
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
        prices json[]
    )
AS
$$
DECLARE
    _cmset ALIAS FOR $1;
    _cmlanguage ALIAS FOR $2;
    command character varying;
BEGIN
    command := 'SELECT
                    id,
                    collector_number,
                    face_order,
                    loyalty,
                    mana_cost,
                    my_name_section,
                    my_number_order,
                    name,
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
                    ) AS prices
                FROM cmcard c';

    command := command || ' WHERE c.cmset = ''' || _cmset || ''' AND c.cmlanguage = ''' || _cmlanguage || ''' ORDER BY c.name ASC';

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

