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
        number_order double precision,
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
        art_crop_url character varying,
        normal_url character varying,
        png_url character varying,
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
	_collector_number character varying;
    command character varying;	
BEGIN
	SELECT c.collector_number INTO _collector_number FROM cmcard c where c.new_id = _new_id;
	
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
                    c.number_order,
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
                    c.art_crop_url,
                    c.normal_url,
                    c.png_url,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.code, v.name, v.keyrune_class, v.keyrune_unicode
                            FROM cmset v WHERE v.code = c.cmset
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
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
                            SELECT v.name
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                        ) x
                    ) AS layout,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
                            FROM cmwatermark v
                            WHERE v.name = c.cmwatermark
                        ) x
                    ) AS watermark,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
                            FROM cmframe v
                            WHERE v.name = c.cmframe
                        ) x
                    ) AS frame,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
                            FROM cmartist v
                            WHERE v.name = c.cmartist
                        ) x
                    ) AS artist,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_color v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS colors,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_coloridentity v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS color_identities,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
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
								SELECT row_to_json(a) FROM (select w.name)
							a) AS component,
                            (
								SELECT row_to_json(b) FROM (
                                	select x.new_id,
                                    x.collector_number,
                                	x.name,
                                	x.printed_name,
                                    x.art_crop_url,
                                    x.normal_url,
                                    x.png_url,
                                    (
                                        SELECT row_to_json(x) FROM (
                                            SELECT v.code, v.name, v.keyrune_class, v.keyrune_unicode
                                            FROM cmset v WHERE v.code = x.cmset
                                        ) x
                                    ) AS set,
                                    (
                                        SELECT row_to_json(x) FROM (
                                            SELECT v.code, v.name
                                            FROM cmlanguage v
                                            WHERE v.code = x.cmlanguage
                                        ) x
                                    ) AS language
								)
							b) AS card
                            FROM cmcard_component_part v left join cmcomponent w on v.cmcomponent = w.name
							left join cmcard x on v.cmcard_part = x.new_id
                            WHERE v.cmcard = c.new_id AND v.cmcard_part != c.new_id
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
                            SELECT
                                x.cmcard_otherlanguage as new_id,
                                c.name,
                                c.printed_name,
                                c.collector_number,
                                c.art_crop_url,
                                c.normal_url,
                                c.png_url,
                                (
                                    SELECT row_to_json(x) FROM (
                                        SELECT v.name
                                        FROM cmrarity v
                                        WHERE v.name = c.cmrarity
                                    ) x
                                ) AS rarity,
                                (
                                    SELECT row_to_json(x) FROM (
                                        SELECT v.code, v.display_code, v.name
                                        FROM cmlanguage v
                                        WHERE v.code = w.code
                                    ) x
                                ) AS language,
                                (
                                    SELECT row_to_json(x) FROM (
                                        SELECT y.code, y.name, y.keyrune_class, y.keyrune_unicode
                                        FROM cmset y
                                        WHERE y.code = c.cmset
                                    ) x
                                ) AS set,
                                array(
                                    SELECT row_to_json(x) FROM (
                                        SELECT
                                            new_id,
                                            name,
                                            printed_name,
                                            art_crop_url,
                                            normal_url,
                                            png_url
                                        FROM cmcard c left join cmcard_face w on w.cmcard_face = c.new_id
                                        WHERE w.cmcard = x.cmcard_otherlanguage
                                    ) x
                                ) AS faces
                            FROM cmcard c left join cmlanguage w on w.code = cmlanguage
                            left join cmcard_otherlanguage x on x.cmcard_otherlanguage = c.new_id
                            WHERE x.cmcard = ''' || _new_id || '''' || ' and x.cmcard_otherlanguage LIKE ''%' || _collector_number || '''' ||
                            ' group by w.code, x.cmcard_otherlanguage, c.cmset, c.name, c.printed_name, c.cmrarity, c.collector_number,
                              c.art_crop_url, c.normal_url, c.png_url 
							 order by w.code
                        ) x
                    ) AS other_languages ';

    -- Other Printings
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
						    SELECT
                                c.new_id,
                                c.name,
                                c.printed_name,
                                c.collector_number,
                                c.art_crop_url,
                                c.normal_url,
                                c.png_url,
								(
                                    SELECT row_to_json(x) FROM (
                                        SELECT v.name
                                        FROM cmrarity v
                                        WHERE v.name = c.cmrarity
                                    ) x
                                ) AS rarity,
								(
                                    SELECT row_to_json(x) FROM (
                                        SELECT y.code, y.name, y.keyrune_class, y.keyrune_unicode
                                        FROM cmset y
                                        WHERE y.code = c.cmset
                                    ) x
                                ) AS set,
								array(
                                    SELECT row_to_json(x) FROM (
                                        SELECT new_id, art_crop_url, normal_url, png_url
                                        FROM cmcard c left join cmcard_face w on w.cmcard_face = c.new_id
                                        WHERE w.cmcard = x.cmcard_otherprinting
                                    ) x
                                ) AS faces,
                                array(
                                    SELECT row_to_json(x) FROM (
                                        SELECT id, v.market, v.is_foil
                                        FROM cmcardprice v
                                        WHERE v.cmcard = c.new_id
                                    ) x
                                ) AS prices,
                                (
                                    SELECT row_to_json(x) FROM (
                                        SELECT v.code, v.name
                                        FROM cmlanguage v
                                        WHERE v.code = c.cmlanguage
                                    ) x
                                ) AS language
                            FROM cmcard c
                            left join cmcard_otherprinting x on x.cmcard_otherprinting = c.new_id
                            left join cmset y on y.code = c.cmset
                            WHERE x.cmcard = ''' || _new_id || '''' ||
                            ' order by y.release_date desc, c.collector_number
                        ) x
                    ) AS other_printings ';

    -- Variations
    command := command ||
                ', array(
                    SELECT row_to_json(x) FROM (
						SELECT c.new_id,
                            c.collector_number,
                            c.name,
                            c.printed_name,
                            c.collector_number,
                            c.art_crop_url,
                            c.normal_url,
                            c.png_url,
                            (
                                SELECT row_to_json(x) FROM (
                                    SELECT v.name
                                    FROM cmrarity v
                                    WHERE v.name = c.cmrarity
                                ) x
                            ) AS rarity,
                            (
                                SELECT row_to_json(x) FROM (
                                    SELECT y.code, y.name, y.keyrune_class, y.keyrune_unicode
                                    FROM cmset y
                                    WHERE y.code = c.cmset
                                ) x
                            ) AS set,
                            (
                                SELECT row_to_json(x) FROM (
                                    SELECT v.code, v.name
                                    FROM cmlanguage v
                                    WHERE v.code = c.cmlanguage
                                ) x
                            ) AS language
                        FROM cmcard c left join cmcard_variation w on w.cmcard_variation = c.new_id
                        WHERE w.cmcard = ''' || _new_id || '''' ||
                        ' order by c.collector_number
                    ) x
                ) AS variations ';

    -- Legalities
    command := command ||
                ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT (SELECT row_to_json(a) FROM (select w.name) a) AS format,
                            (SELECT row_to_json(b) FROM (select x.name) b) AS legality
                        FROM cmcard_format_legality v left join cmformat w on v.cmformat = w.name
                        left join cmlegality x on v.cmlegality = x.name
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS format_legalities ';

    -- Frame Effects
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.description, w.id, w.name
                        FROM cmcard_frameeffect v left join cmframeeffect w on v.cmframeeffect = w.id
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS frame_effects ';

    -- Subtypes
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.name
                        FROM cmcard_subtype v left join cmcardtype w on v.cmcardtype = w.name
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS subtypes ';

    -- Supertypes
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.name
                        FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                        WHERE v.cmcard = c.new_id
                    ) x
                ) AS supertypes ';

    -- Prices
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
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

