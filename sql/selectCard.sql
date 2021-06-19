CREATE OR REPLACE FUNCTION selectCard(character varying)
    RETURNS TABLE (
        collector_number character varying,
        cmc double precision,
        face_order integer,
        flavor_text character varying,
        is_foil boolean,
        is_full_art boolean,
        is_highres_image boolean,
        is_nonfoil boolean,
        is_oversized boolean,
        is_reserved boolean,
        is_story_spotlight boolean,
        loyalty character varying,
        mana_cost character varying,
        my_name_section character varying,
        my_number_order double precision,
        name character varying,
        oracle_text character varying,
        power character varying,
        printed_name character varying,
        printed_text character varying,
        toughness character varying,
        arena_id integer,
        mtgo_id integer,
        tcgplayer_id integer,
        hand_modifier character varying,
        life_modifier character varying,
        is_booster boolean,
        is_digital boolean,
        is_promo boolean,
        released_at date,
        is_textless boolean,
        mtgo_foil_id integer,
        is_reprint boolean,
        new_id character varying,
        printed_type_line character varying,
        type_line character varying,
        multiverse_ids integer[],
        set json,
        rarity json,
        language json,
        layout json,
        watermark json,
        frame json,
        artist json,
        colors json[],
        color_identities json[],
        color_indicators json[],
        component_parts json[],
        faces json[],
        other_languages json[],
        other_printings json[],
        variations json[],
        format_legalities json[],
        frame_effects json[],
        subtypes json[],
        supertypes json[],
        prices json[],
		rulings json[]
    )
AS
$$
DECLARE
    _new_id ALIAS FOR $1;
    command character varying;
BEGIN
    command := 'SELECT
                    c.collector_number,
                    c.cmc,
                    c.face_order,
                    c.flavor_text,
                    c.is_foil,
                    c.is_full_art,
                    c.is_highres_image,
                    c.is_nonfoil,
                    c.is_oversized,
                    c.is_reserved,
                    c.is_story_spotlight,
                    c.loyalty,
                    c.mana_cost,
                    c.my_name_section,
                    c.my_number_order,
                    c.name,
                    c.oracle_text,
                    c.power,
                    c.printed_name,
                    c.printed_text,
                    c.toughness,
                    c.arena_id,
                    c.mtgo_id,
                    c.tcgplayer_id,
                    c.hand_modifier,
                    c.life_modifier,
                    c.is_booster,
                    c.is_digital,
                    c.is_promo,
                    c.released_at,
                    c.is_textless,
                    c.mtgo_foil_id,
                    c.is_reprint,
                    c.new_id,
                    c.printed_type_line,
                    c.type_line,
                    c.multiverse_ids,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.code, v.name, v.keyrune_class
                            FROM cmset v WHERE v.code = c.cmset
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.name_section
                            FROM cmrarity v
                            WHERE v.name = c.cmrarity
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.code, v.name
                            FROM cmlanguage v
                            WHERE v.code = c.cmlanguage
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.name_section, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                        ) x
                    ) AS layout,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.name_section
                            FROM cmwatermark v
                            WHERE v.name = c.cmwatermark
                        ) x
                    ) AS watermark,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.name_section, v.description
                            FROM cmframe v
                            WHERE v.name = c.cmframe
                        ) x
                    ) AS frame,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.first_name, v.last_name, v.name, v.name_section
                            FROM cmartist v
                            WHERE v.name = c.cmartist
                        ) x
                    ) AS artist,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name, w.name_section, w.symbol, w.is_mana_color
                            FROM cmcard_color v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS colors,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name, w.name_section, w.symbol, w.is_mana_color
                            FROM cmcard_coloridentity v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS color_identities,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name, w.name_section, w.symbol, w.is_mana_color
                            FROM cmcard_colorindicator v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS color_indicators ';

    -- Component Parts
	command := command ||
					', array(
                        SELECT row_to_json(x) FROM (
							SELECT
							(
								SELECT row_to_json(a) FROM (select w.name, w.name_section)
							a) AS component,
                            (
								SELECT row_to_json(b) FROM (
                                	select x.new_id,
                                	x.name,
                                	x.printed_name,
							    	(
                                    	SELECT row_to_json(x) FROM (
                                        	SELECT v.name
                                        	FROM cmrarity v
                                        	WHERE v.name = x.cmrarity
                                    	) x
                                	) AS rarity,
									(
                                    	SELECT row_to_json(x) FROM (
                                        	SELECT y.code, y.keyrune_class
                                        	FROM cmset y
                                        	WHERE y.code = x.cmset
                                    	) x
                                	) AS set,
									(
                                    	SELECT row_to_json(x) FROM (
                                        	SELECT z.code
                                        	FROM cmlanguage z
                                        	WHERE z.code = x.cmlanguage
                                    	) x
                                	) AS language
								)
							b) AS card
                            FROM cmcard_component_part v left join cmcomponent w on v.cmcomponent = w.name
							left join cmcard x on v.cmcard_part = x.new_id
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS component_parts ';
    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' || command ||
                            'FROM cmcard c left join cmcard_face w on w.cmcard_face = c.new_id
                            WHERE w.cmcard = ''' || _new_id || '''' ||
                        ') x
                    ) AS faces ';

    -- Other Languages
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT c.new_id,
                                c.name,
                                c.printed_name,
							    (
                                    SELECT row_to_json(x) FROM (
                                        SELECT v.name
                                        FROM cmrarity v
                                        WHERE v.name = c.cmrarity
                                    ) x
                                ) AS rarity,
								(
                                    SELECT row_to_json(x) FROM (
                                        SELECT y.code, y.keyrune_class
                                        FROM cmset y
                                        WHERE y.code = c.cmset
                                    ) x
                                ) AS set,
								(
                                    SELECT row_to_json(x) FROM (
                                        SELECT z.code
                                        FROM cmlanguage z
                                        WHERE z.code = c.cmlanguage
                                    ) x
                                ) AS language
                            FROM cmcard c left join cmlanguage w on w.code = cmlanguage
                            left join cmcard_otherlanguage x on x.cmcard_otherlanguage = c.new_id
                            left join cmset y on y.code = c.cmset
                            WHERE x.cmcard = ''' || _new_id || '''' ||
                            ' order by y.release_date desc
                        ) x
                    ) AS other_languages ';

    -- Other Printings
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
						    SELECT c.new_id,
                                c.name,
                                c.printed_name,
								(
                                    SELECT row_to_json(x) FROM (
                                        SELECT v.name
                                        FROM cmrarity v
                                        WHERE v.name = c.cmrarity
                                    ) x
                                ) AS rarity,
								(
                                    SELECT row_to_json(x) FROM (
                                        SELECT y.code, y.keyrune_class, y.name
                                        FROM cmset y
                                        WHERE y.code = c.cmset
                                    ) x
                                ) AS set,
								(
                                    SELECT row_to_json(x) FROM (
                                        SELECT z.code
                                        FROM cmlanguage z
                                        WHERE z.code = c.cmlanguage
                                    ) x
                                ) AS language,
                                array(
                                    SELECT row_to_json(x) FROM (
                                        SELECT v.market, v.is_foil
                                        FROM cmcardprice v
                                        WHERE v.cmcard = c.new_id
                                    ) x
                                ) AS prices
                            FROM cmcard c
                            left join cmcard_otherprinting w on w.cmcard_otherprinting = c.new_id
                            left join cmset y on y.code = c.cmset
                            WHERE w.cmcard = ''' || _new_id || '''' ||
                            ' order by y.release_date desc
                        ) x
                    ) AS other_printings ';

    -- Variations
    command := command ||
                ', array(
                    SELECT row_to_json(x) FROM (
						SELECT c.new_id,
                            c.name,
                            c.collector_number,
                            c.printed_name,
							(
                                SELECT row_to_json(x) FROM (
                                    SELECT v.name
                                    FROM cmrarity v
                                    WHERE v.name = c.cmrarity
                                ) x
                            ) AS rarity,
							(
                                SELECT row_to_json(x) FROM (
                                    SELECT y.code, y.keyrune_class
                                    FROM cmset y
                                    WHERE y.code = c.cmset
                                ) x
                            ) AS set,
							(
                                SELECT row_to_json(x) FROM (
                                    SELECT z.code
                                    FROM cmlanguage z
                                    WHERE z.code = c.cmlanguage
                                ) x
                            ) AS language
                        FROM cmcard c left join cmcard_variation w on w.cmcard_variation = c.new_id
                        left join cmset y on y.code = c.cmset
                        WHERE w.cmcard = ''' || _new_id || '''' ||
                        ' order by y.release_date desc
                    ) x
                ) AS variations ';

    -- Legalities
    command := command ||
                ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT (SELECT row_to_json(a) FROM (select w.name, w.name_section) a) AS format,
                            (SELECT row_to_json(b) FROM (select x.name, x.name_section) b) AS legality
                        FROM cmcard_format_legality v left join cmformat w on v.cmformat = w.name
                        left join cmlegality x on v.cmlegality = x.name
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS format_legalities ';

    -- Frame Effects
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.id, w.name, w.name_section, w.description
                        FROM cmcard_frameeffect v left join cmframeeffect w on v.cmframeeffect = w.id
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS frame_effects ';

    -- Subtypes
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.name, w.name_section, w.cmcardtype_parent AS parent
                        FROM cmcard_subtype v left join cmcardtype w on v.cmcardtype = w.name
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS subtypes ';

    -- Supertypes
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.name, w.name_section, w.cmcardtype_parent AS parent
                        FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS supertypes ';

    -- Prices
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_created
                        FROM cmcardprice v
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS prices ';

	-- Rulings
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT v.id, v.date_published, v.text
                        FROM cmruling v
                        WHERE v.oracle_id = c.oracle_id
                    ) x
                ) AS rulings ';

    command := command || 'FROM cmcard c WHERE c.new_id = ''' || _new_id || '''';

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

