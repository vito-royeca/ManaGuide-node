CREATE OR REPLACE FUNCTION selectCard(character varying)
    RETURNS TABLE (
        collector_number character varying,
        cmc double precision,
        face_order integer,
        flavor_text character varying,
        image_uris jsonb,
        is_foil boolean,
        is_full_art boolean,
        is_highres_image boolean,
        is_nonfoil boolean,
        is_oversized boolean,
        is_reserved boolean,
        is_story_spotlight boolean,
        loyalty character varying,
        mana_cost character varying,
        multiverse_ids integer[],
        my_name_section character varying,
        my_number_order character varying,
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
        artist json,
        id character varying,
        card_back_id character varying,
        oracle_id character varying,
        illustration_id character varying,
        set json,
        rarity json,
        language json,
        layout json,
        watermark json,
        frame json,
        printed_type_line character varying,
        type_line character varying,
        -- start additions
        colors json[],
        color_identities json[],
        color_indicators json[]
        --component_parts json[]
        --faces json[],
        --format_legalities json[],
        --frame_effects json[],
        --other_languages json[],
        --other_printings json[],
        --subtypes json[],
        --supertypes json[],
        --variations json[]
    )
AS
$$
DECLARE
    _id ALIAS FOR $1;
    command character varying;
BEGIN
    command := 'SELECT
                    collector_number,
                    cmc,
                    face_order,
                    flavor_text,
                    image_uris,
                    is_foil,
                    is_full_art,
                    is_highres_image,
                    is_nonfoil,
                    is_oversized,
                    is_reserved,
                    is_story_spotlight,
                    loyalty,
                    mana_cost,
                    multiverse_ids,
                    my_name_section,
                    my_number_order,
                    name,
                    oracle_text,
                    power,
                    printed_name,
                    printed_text,
                    toughness,
                    arena_id,
                    mtgo_id,
                    tcgplayer_id,
                    hand_modifier,
                    life_modifier,
                    is_booster,
                    is_digital,
                    is_promo,
                    released_at,
                    is_textless,
                    mtgo_foil_id,
                    is_reprint,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.first_name, v.last_name, v.name, v.name_section
                            FROM cmartist v
                            WHERE v.name = c.cmartist
                        ) x
                    ) AS artist,
                    id,
                    card_back_id,
                    oracle_id,
                    illustration_id,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.code
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
                            SELECT v.code
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
                            SELECT v.name, v.name_section
                            FROM cmframe v
                            WHERE v.name = c.cmframe
                        ) x
                    ) AS frame,
                    printed_type_line,
                    type_line,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name, w.name_section, w.symbol, w.is_mana_color
                            FROM cmcard_color v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.id
                        ) x
                    ) AS colors,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name, w.name_section, w.symbol, w.is_mana_color
                            FROM cmcard_coloridentity v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.id
                        ) x
                    ) AS color_identities,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name, w.name_section, w.symbol, w.is_mana_color
                            FROM cmcard_colorindicator v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.id
                        ) x
                    ) AS color_indicators
                FROM cmcard c';

    command := command || ' WHERE c.id = ''' || _id || '''';

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

