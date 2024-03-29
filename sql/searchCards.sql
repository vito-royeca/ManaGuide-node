CREATE OR REPLACE FUNCTION searchCards(
    character varying,
    character varying,
    character varying)
    RETURNS TABLE (
        new_id character varying,
        collector_number character varying,
        face_order integer,
        loyalty character varying,
        mana_cost character varying,
        number_order double precision,
        name character varying,
        name_section character varying,
        printed_name character varying,
        printed_type_line character varying,
        type_line character varying,
        power character varying,
        toughness character varying,
        tcgplayer_id integer,
        released_at date,
        art_crop_url character varying,
        normal_url character varying,
        png_url character varying,
        set json,
        rarity json,
        language json,
		layout json,
        prices json[],
        faces  json[],
        supertypes json[]
    )
AS
$$
DECLARE
    _query ALIAS FOR $1;
    _sortedBy ALIAS FOR $2;
    _orderBy ALIAS FOR $3;
    command character varying;
BEGIN
    _query := lower(_query);
    IF lower(_sortedBy) = 'set_name' THEN
        _sortedBy = 's.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
	IF lower(_sortedBy) = 'set_release' THEN
        _sortedBy = 's.release_date ' || _orderBy || ', s.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'collector_number' THEN
        _sortedBy = 'c.number_order ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'name' THEN
        _sortedBy = 'regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'cmc' THEN
        _sortedBy = 'c.cmc ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'type' THEN
        _sortedBy = 'c.type_line ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'rarity' THEN
        _sortedBy = 'r.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;

    command := 'SELECT DISTINCT ON (regexp_replace(c.name, ''"'', '''', ''g''))
                    c.new_id,
                    c.collector_number,
                    c.face_order,
                    c.loyalty,
                    c.mana_cost,
                    c.number_order,
                    c.name,
                    c.name_section,
                    c.printed_name,
                    c.printed_type_line,
                    c.type_line,
	                c.power,
                    c.toughness,
                    c.tcgplayer_id,
                    c.released_at,
                    c.art_crop_url,
                    c.normal_url,
                    c.png_url,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class, s.keyrune_unicode
                            FROM cmset s WHERE s.code = c.cmset
                            LIMIT 1
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name
                            FROM cmrarity r WHERE r.name = c.cmrarity
                            LIMIT 1
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                            LIMIT 1
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                            LIMIT 1
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                            LIMIT 1
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT
                                new_id,
                                collector_number,
                                face_order,
                                loyalty,
                                mana_cost,
                                number_order,
                                name,
                                name_section,
                                printed_name,
                                printed_type_line,
                                type_line,
	                            power,
                                toughness,
                                art_crop_url,
                                normal_url,
                                png_url
                            FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                            ORDER BY face_order
                            LIMIT 10
                        ) x
                    ) AS faces ';

    -- Supertypes
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                            WHERE v.cmcard = c.new_id
                            LIMIT 50
                        ) x
                    ) AS supertypes ';               

    command := command || 'FROM cmcard c ';
    command := command || 'WHERE c.cmlanguage = ''en'' ';
    command := command || 'AND c.new_id NOT IN(select cmcard_face from cmcard_face) ';
    command := command || 'AND lower(c.name) LIKE ''%' || _query || '%'' ';
    command := command || 'ORDER BY ' || _sortedBy || '';

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

