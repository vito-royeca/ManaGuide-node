CREATE OR REPLACE FUNCTION createOrUpdateCard(
    character varying,
    double precision,
    character varying,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
    boolean,
    character varying,
    character varying,
    integer[],
    character varying,
    double precision,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    boolean,
    boolean,
    boolean,
    character varying,
    boolean,
    character varying,
    boolean,
    character varying[],
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying[],
    character varying[],
    character varying[],
    character varying[],
    jsonb,
    character varying,
    character varying,
    character varying[],
    character varying[],
    integer,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying[],
    character varying[]) RETURNS void AS $$
DECLARE
    _collector_number ALIAS FOR $1;
    _cmc ALIAS FOR $2;
    _flavor_text ALIAS FOR $3;
    _is_foil ALIAS FOR $4;
    _is_full_art ALIAS FOR $5;
    _is_highres_image ALIAS FOR $6;
    _is_nonfoil ALIAS FOR $7;
    _is_oversized ALIAS FOR $8;
    _is_reserved ALIAS FOR $9;
    _is_story_spotlight ALIAS FOR $10;
    _loyalty ALIAS FOR $11;
    _mana_cost ALIAS FOR $12;
    _multiverse_ids ALIAS FOR $13;
    _name_section ALIAS FOR $14;
    _number_order ALIAS FOR $15;
    _name ALIAS FOR $16;
    _oracle_text ALIAS FOR $17;
    _power ALIAS FOR $18;
    _printed_name ALIAS FOR $19;
    _printed_text ALIAS FOR $20;
    _toughness ALIAS FOR $21;
    _arena_id ALIAS FOR $22;
    _mtgo_id ALIAS FOR $23;
    _tcgplayer_id ALIAS FOR $24;
    _hand_modifier ALIAS FOR $25;
    _life_modifier ALIAS FOR $26;
    _is_booster ALIAS FOR $27;
    _is_digital ALIAS FOR $28;
    _is_promo ALIAS FOR $29;
    _released_at ALIAS FOR $30;
    _is_textless ALIAS FOR $31;
    _mtgo_foil_id ALIAS FOR $32;
    _is_reprint ALIAS FOR $33;
    _cmartists ALIAS FOR $34;
    _cmset ALIAS FOR $35;
    _cmrarity ALIAS FOR $36;
    _cmlanguage ALIAS FOR $37;
    _cmlayout ALIAS FOR $38;
    _cmwatermark ALIAS FOR $39;
    _cmframe ALIAS FOR $40;
    _cmframeeffects ALIAS FOR $41;
    _cmcolors ALIAS FOR $42;
    _cmcolor_identities ALIAS FOR $43;
    _cmcolor_indicators ALIAS FOR $44;
    _cmlegalities ALIAS FOR $45;
    _type_line ALIAS FOR $46;
    _printed_type_line ALIAS FOR $47;
    _cmcardtype_subtypes ALIAS FOR $48;
    _cmcardtype_supertypes ALIAS FOR $49;
    _face_order ALIAS FOR $50;
    _new_id ALIAS FOR $51;
    _oracle_id ALIAS FOR $52;
    _id ALIAS FOR $53;
    _art_crop_url ALIAS FOR $54;
    _normal_url ALIAS FOR $55;
    _png_url ALIAS FOR $56;
    _cmgames ALIAS FOR $57;
    _cmkeywords ALIAS FOR $58;

    pkey character varying;
    pkey2 character varying;
    pkey3 character varying;
    released_at_ date;
BEGIN
    -- check for nulls
    IF lower(_collector_number) = 'null' THEN
        _collector_number := NULL;
    END IF;
    IF lower(_flavor_text) = 'null' THEN
        _flavor_text := NULL;
    END IF;
    IF lower(_loyalty) = 'null' THEN
        _loyalty := NULL;
    END IF;
    IF lower(_mana_cost) = 'null' THEN
        _mana_cost := NULL;
    END IF;
    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;
    IF lower(_oracle_text) = 'null' THEN
        _oracle_text := NULL;
    END IF;
    IF lower(_power) = 'null' THEN
        _power := NULL;
    END IF;
    IF lower(_printed_name) = 'null' THEN
        _printed_name := NULL;
    END IF;
    IF lower(_printed_text) = 'null' THEN
        _printed_text := NULL;
    END IF;
    IF lower(_toughness) = 'null' THEN
        _toughness := NULL;
    END IF;
    IF lower(_arena_id) = 'null' THEN
        _arena_id := NULL;
    END IF;
    IF lower(_mtgo_id) = 'null' THEN
        _mtgo_id := NULL;
    END IF;
    IF lower(_tcgplayer_id) = 'null' THEN
        _tcgplayer_id := NULL;
    END IF;
    IF lower(_hand_modifier) = 'null' THEN
        _hand_modifier := NULL;
    END IF;
    IF lower(_life_modifier) = 'null' THEN
        _life_modifier := NULL;
    END IF;
    IF lower(_released_at) = 'null'  THEN
        released_at_ := NULL;
    ELSE
        released_at_ := to_date(_released_at, 'YYYY-MM-DD');
    END IF;
    IF lower(_mtgo_foil_id) = 'null'  THEN
        _mtgo_foil_id := NULL;
    END IF;
    IF lower(_cmset) = 'null' THEN
        _cmset := NULL;
    END IF;
    IF lower(_cmrarity) = 'null' THEN
        _cmrarity := NULL;
    END IF;
    IF lower(_cmlanguage) = 'null' THEN
        _cmlanguage := NULL;
    END IF;
    IF lower(_cmlayout) = 'null' THEN
        _cmlayout := NULL;
    END IF;
    IF lower(_cmwatermark) = 'null' THEN
        _cmwatermark := NULL;
    END IF;
    IF lower(_cmframe) = 'null' THEN
        _cmframe := NULL;
    END IF;
    IF lower(_type_line) = 'null' THEN
        _type_line := NULL;
    END IF;
    IF lower(_printed_type_line) = 'null' THEN
        _printed_type_line := NULL;
    END IF;
    IF lower(_oracle_id) = 'null' THEN
        _oracle_id := NULL;
    END IF;
    IF lower(_id) = 'null' THEN
        _id := NULL;
    END IF;
    IF lower(_art_crop_url) = 'null' THEN
        _art_crop_url := NULL;
    END IF;
    IF lower(_normal_url) = 'null' THEN
        _normal_url := NULL;
    END IF;
    IF lower(_png_url) = 'null' THEN
        _png_url := NULL;
    END IF;

    -- card
    INSERT INTO cmcard(
        collector_number,
        cmc,
        flavor_text,
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
        name_section,
        number_order,
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
        cmset,
        cmrarity,
        cmlanguage,
        cmlayout,
        cmwatermark,
        cmframe,
        type_line,
        printed_type_line,
        face_order,
        new_id,
        oracle_id,
        id,
        art_crop_url,
        normal_url,
        png_url)
    VALUES(
        _collector_number,
        _cmc,
        _flavor_text,
        _is_foil,
        _is_full_art,
        _is_highres_image,
        _is_nonfoil,
        _is_oversized,
        _is_reserved,
        _is_story_spotlight,
        _loyalty,
        _mana_cost,
        _multiverse_ids,
        _name_section,
        _number_order,
        _name,
        _oracle_text,
        _power,
        _printed_name,
        _printed_text,
        _toughness,
        _arena_id::integer,
        _mtgo_id::integer,
        _tcgplayer_id::integer,
        _hand_modifier,
        _life_modifier,
        _is_booster,
        _is_digital,
        _is_promo,
        released_at_,
        _is_textless,
        _mtgo_foil_id::integer,
        _is_reprint,
        _cmset,
        _cmrarity,
        _cmlanguage,
        _cmlayout,
        _cmwatermark,
        _cmframe,
        _type_line,
        _printed_type_line,
        _face_order,
        _new_id,
        _oracle_id,
        _id,
        _art_crop_url,
        _normal_url,
        _png_url)
    ON CONFLICT(new_id)
        DO UPDATE SET
            collector_number = EXCLUDED.collector_number,
            cmc = EXCLUDED.cmc,
            flavor_text = EXCLUDED.flavor_text,
            is_foil = EXCLUDED.is_foil,
            is_full_art = EXCLUDED.is_full_art,
            is_highres_image = EXCLUDED.is_highres_image,
            is_nonfoil = EXCLUDED.is_nonfoil,
            is_oversized = EXCLUDED.is_oversized,
            is_reserved = EXCLUDED.is_reserved,
            is_story_spotlight = EXCLUDED.is_story_spotlight,
            loyalty = EXCLUDED.loyalty,
            mana_cost = EXCLUDED.mana_cost,
            multiverse_ids = EXCLUDED.multiverse_ids,
            name_section = EXCLUDED.name_section,
            number_order = EXCLUDED.number_order,
            name = EXCLUDED.name,
            oracle_text = EXCLUDED.oracle_text,
            power = EXCLUDED.power,
            printed_name = EXCLUDED.printed_name,
            printed_text = EXCLUDED.printed_text,
            toughness = EXCLUDED.toughness,
            arena_id = EXCLUDED.arena_id::integer,
            mtgo_id = EXCLUDED.mtgo_id::integer,
            tcgplayer_id = EXCLUDED.tcgplayer_id::integer,
            hand_modifier = EXCLUDED.hand_modifier,
            life_modifier = EXCLUDED.life_modifier,
            is_booster = EXCLUDED.is_booster,
            is_digital = EXCLUDED.is_digital,
            is_promo = EXCLUDED.is_promo,
            released_at = released_at_,
            is_textless = EXCLUDED.is_textless,
            mtgo_foil_id = EXCLUDED.mtgo_foil_id::integer,
            is_reprint = EXCLUDED.is_reprint,
            cmset = EXCLUDED.cmset,
            cmrarity = EXCLUDED.cmrarity,
            cmlanguage = EXCLUDED.cmlanguage,
            cmlayout = EXCLUDED.cmlayout,
            cmwatermark = EXCLUDED.cmwatermark,
            cmframe = EXCLUDED.cmframe,
            type_line = EXCLUDED.type_line,
            printed_type_line = EXCLUDED.printed_type_line,
            face_order = EXCLUDED.face_order,
            new_id = EXCLUDED.new_id,
            oracle_id = EXCLUDED.oracle_id,
            id = EXCLUDED.id,
            art_crop_url = EXCLUDED.art_crop_url,
            normal_url = EXCLUDED.normal_url,
            png_url = EXCLUDED.png_url,
            date_updated = now();

    -- set and language
    IF _cmset IS NOT NULL AND _cmlanguage IS NOT NULL THEN
        INSERT INTO cmset_language(
            cmset,
            cmlanguage
        ) VALUES(
            _cmset,
            _cmlanguage
        )
        ON CONFLICT(
            cmset,
            cmlanguage
        )
            DO NOTHING;
    END IF;

     -- artists
    IF _cmartists IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmartists LOOP
            INSERT INTO cmcard_artist(
                cmcard,
                cmartist
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmartist
            )
                DO NOTHING;
        END LOOP;
    END IF;

    -- frame effects
    IF _cmframeeffects IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmframeeffects LOOP
            INSERT INTO cmcard_frameeffect(
                cmcard,
                cmframeeffect
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmframeeffect
            )
                DO NOTHING;
        END LOOP;
    END IF;

    -- colors
    IF _cmcolors IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolors LOOP
            INSERT INTO cmcard_color(
                cmcard,
                cmcolor
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmcolor
            )
                DO NOTHING;
            
        END LOOP;
    END IF;

    -- color identities
    IF _cmcolor_identities IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolor_identities LOOP
            INSERT INTO cmcard_coloridentity(
                cmcard,
                cmcolor
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmcolor
            )
                DO NOTHING;
        END LOOP;
    END IF;

    -- color indicators
    IF _cmcolor_indicators IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolor_indicators LOOP
            INSERT INTO cmcard_colorindicator(
                cmcard,
                cmcolor
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmcolor
            )
                DO NOTHING;
        END LOOP;
    END IF;

    -- legalities
    IF _cmlegalities IS NOT NULL THEN
        FOR pkey2, pkey3 IN SELECT * FROM jsonb_each_text(_cmlegalities) LOOP
            INSERT INTO cmcard_format_legality(
                cmcard,
                cmformat,
                cmlegality
            ) VALUES (
                _new_id,
                pkey2,
                pkey3
            )
            ON CONFLICT(
                cmcard,
                cmformat,
                cmlegality
            )
                DO NOTHING;
        END LOOP;
    END IF;

    -- subtypes
    IF _cmcardtype_subtypes IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcardtype_subtypes LOOP
            INSERT INTO cmcard_subtype(
                cmcard,
                cmcardtype
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmcardtype
            )
                DO NOTHING;
        END LOOP;
    END IF;

    -- supertypes
    IF _cmcardtype_subtypes IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcardtype_supertypes LOOP
            INSERT INTO cmcard_supertype(
                cmcard,
                cmcardtype
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmcardtype
            )
                DO NOTHING;
        END LOOP;
    END IF;

    -- games
    IF _cmgames IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmgames LOOP
            INSERT INTO cmcard_game(
                cmcard,
                cmgame
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmgame
            )
                DO NOTHING;
        END LOOP;
    END IF;

    -- keywords
    IF _cmkeywords IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmkeywords LOOP
            INSERT INTO cmcard_keyword(
                cmcard,
                cmkeyword
            ) VALUES (
                _new_id,
                pkey
            )
            ON CONFLICT(
                cmcard,
                cmkeyword
            )
                DO NOTHING;
        END LOOP;
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

