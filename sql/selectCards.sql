CREATE OR REPLACE FUNCTION selectCards(
    character varying,
    character varying)
    RETURNS TABLE (
        face_order integer,
        image_uris jsonb,
        loyalty character varying,
        mana_cost character varying,
        my_name_section character varying,
        my_number_order double precision,
        name character varying,
        power character varying,
        printed_name character varying,
        toughness character varying,
        id character varying,
        set json,
        rarity json,
        language json,
        printed_type_line character varying,
        type_line character varying,
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
                    face_order,
                    image_uris,
                    loyalty,
                    mana_cost,
                    my_name_section,
                    my_number_order,
                    name,
	                power,
                    printed_name,
                    toughness,
                    id,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code
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
                            SELECT l.code
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                        ) x
                    ) AS language,
                    printed_type_line,
                    type_line,
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

