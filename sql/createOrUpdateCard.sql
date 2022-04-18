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
    character varying,
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
    character varying) RETURNS void AS $$
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
    _cmartist ALIAS FOR $34;
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

    pkey character varying;
    pkey2 character varying;
    pkey3 character varying;
    released_at_ date;

    -- row types
    rowCard cmcard%ROWTYPE;
    rowSetLanguage cmset_language%ROWTYPE;
    rowFrameEffect cmcard_frameeffect%ROWTYPE;
    rowColor cmcard_color%ROWTYPE;
    rowColorIndentity cmcard_coloridentity%ROWTYPE;
    rowColorIndicator cmcard_colorindicator%ROWTYPE;
    rowFormatLegality cmcard_format_legality%ROWTYPE;
    rowSubtype cmcard_subtype%ROWTYPE;
    rowSupertype cmcard_supertype%ROWTYPE;

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
    IF lower(_cmartist) = 'null' THEN
        _cmartist := NULL;
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

    SELECT * INTO rowCard FROM cmcard WHERE new_id = _new_id;

    IF NOT FOUND THEN
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
            cmartist,
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
            _cmartist,
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
            _png_url);
    ELSE
        IF rowCard.collector_number IS DISTINCT FROM _collector_number OR
           rowCard.cmc IS DISTINCT FROM _cmc OR
           rowCard.flavor_text IS DISTINCT FROM _flavor_text OR
           rowCard.is_foil IS DISTINCT FROM _is_foil OR
           rowCard.is_full_art IS DISTINCT FROM _is_full_art OR
           rowCard.is_highres_image IS DISTINCT FROM _is_highres_image OR
           rowCard.is_nonfoil IS DISTINCT FROM _is_nonfoil OR
           rowCard.is_oversized IS DISTINCT FROM _is_oversized OR
           rowCard.is_reserved IS DISTINCT FROM _is_reserved OR
           rowCard.is_story_spotlight IS DISTINCT FROM _is_story_spotlight OR
           rowCard.loyalty IS DISTINCT FROM _loyalty OR
           rowCard.mana_cost IS DISTINCT FROM _mana_cost OR
           rowCard.multiverse_ids IS DISTINCT FROM _multiverse_ids OR
           rowCard.name_section IS DISTINCT FROM _name_section OR
           rowCard.number_order IS DISTINCT FROM _number_order OR
           rowCard.name IS DISTINCT FROM _name OR
           rowCard.oracle_text IS DISTINCT FROM _oracle_text OR
           rowCard.power IS DISTINCT FROM _power OR
           rowCard.printed_name IS DISTINCT FROM _printed_name OR
           rowCard.printed_text IS DISTINCT FROM _printed_text OR
           rowCard.toughness IS DISTINCT FROM _toughness OR
           rowCard.arena_id IS DISTINCT FROM _arena_id::integer OR
           rowCard.mtgo_id IS DISTINCT FROM _mtgo_id::integer OR
           rowCard.tcgplayer_id IS DISTINCT FROM _tcgplayer_id::integer OR
           rowCard.hand_modifier IS DISTINCT FROM _hand_modifier OR
           rowCard.life_modifier IS DISTINCT FROM _life_modifier OR
           rowCard.is_booster IS DISTINCT FROM _is_booster OR
           rowCard.is_digital IS DISTINCT FROM _is_digital OR
           rowCard.is_promo IS DISTINCT FROM _is_promo OR
           rowCard.released_at IS DISTINCT FROM released_at_ OR
           rowCard.is_textless IS DISTINCT FROM _is_textless OR
           rowCard.mtgo_foil_id IS DISTINCT FROM _mtgo_foil_id::integer OR
           rowCard.is_reprint IS DISTINCT FROM _is_reprint OR
           rowCard.cmartist IS DISTINCT FROM _cmartist OR
           rowCard.cmset IS DISTINCT FROM _cmset OR
           rowCard.cmrarity IS DISTINCT FROM _cmrarity OR
           rowCard.cmlanguage IS DISTINCT FROM _cmlanguage OR
           rowCard.cmlayout IS DISTINCT FROM _cmlayout OR
           rowCard.cmwatermark IS DISTINCT FROM _cmwatermark OR
           rowCard.cmframe IS DISTINCT FROM _cmframe OR
           rowCard.type_line IS DISTINCT FROM _type_line OR
           rowCard.printed_type_line IS DISTINCT FROM _printed_type_line OR
           rowCard.face_order IS DISTINCT FROM _face_order OR
           rowCard.new_id IS DISTINCT FROM _new_id OR
           rowCard.oracle_id IS DISTINCT FROM _oracle_id OR
           rowCard.id IS DISTINCT FROM _id OR
           rowCard.art_crop_url IS DISTINCT FROM _art_crop_url OR
           rowCard.normal_url IS DISTINCT FROM _normal_url OR
           rowCard.png_url IS DISTINCT FROM _png_url THEN
        
            UPDATE cmcard SET
                collector_number = _collector_number,
                cmc = _cmc,
                flavor_text = _flavor_text,
                is_foil = _is_foil,
                is_full_art = _is_full_art,
                is_highres_image = _is_highres_image,
                is_nonfoil = _is_nonfoil,
                is_oversized = _is_oversized,
                is_reserved = _is_reserved,
                is_story_spotlight = _is_story_spotlight,
                loyalty = _loyalty,
                mana_cost = _mana_cost,
                multiverse_ids = _multiverse_ids,
                name_section = _name_section,
                number_order = _number_order,
                name = _name,
                oracle_text = _oracle_text,
                power = _power,
                printed_name = _printed_name,
                printed_text = _printed_text,
                toughness = _toughness,
                arena_id = _arena_id::integer,
                mtgo_id = _mtgo_id::integer,
                tcgplayer_id = _tcgplayer_id::integer,
                hand_modifier = _hand_modifier,
                life_modifier = _life_modifier,
                is_booster = _is_booster,
                is_digital = _is_digital,
                is_promo = _is_promo,
                released_at = released_at_,
                is_textless = _is_textless,
                mtgo_foil_id = _mtgo_foil_id::integer,
                is_reprint = _is_reprint,
                cmartist = _cmartist,
                cmset = _cmset,
                cmrarity = _cmrarity,
                cmlanguage = _cmlanguage,
                cmlayout = _cmlayout,
                cmwatermark = _cmwatermark,
                cmframe = _cmframe,
                type_line = _type_line,
                printed_type_line = _printed_type_line,
                face_order = _face_order,
                new_id = _new_id,
                oracle_id = _oracle_id,
                id = _id,
                art_crop_url = _art_crop_url,
                normal_url = _normal_url,
                png_url = _png_url,
                date_updated = now()
            WHERE new_id = _new_id;
        END IF;    
    END IF;

    -- set and language
    IF _cmset IS NOT NULL AND _cmlanguage IS NOT NULL THEN
        SELECT * INTO rowSetLanguage FROM cmset_language WHERE cmset = _cmset AND cmlanguage = _cmlanguage;

        IF NOT FOUND THEN
            INSERT INTO cmset_language(
                cmset,
                cmlanguage
            ) VALUES(
                _cmset,
                _cmlanguage
            );
        END IF;    
    END IF;

    -- frame effects
    IF _cmframeeffects IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmframeeffects LOOP
            SELECT * INTO rowFrameEffect FROM cmcard_frameeffect WHERE cmcard = _new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_frameeffect(
                    cmcard,
                    cmframeeffect
                ) VALUES (
                    _new_id,
                    pkey
                );
            END IF;    
        END LOOP;
    END IF;

    -- colors
    IF _cmcolors IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolors LOOP
            SELECT * INTO rowColor FROM cmcard_color WHERE cmcard = _new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_color(
                    cmcard,
                    cmcolor
                ) VALUES (
                    _new_id,
                    pkey
                );
            END IF;    
        END LOOP;
    END IF;

    -- color identities
    IF _cmcolor_identities IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolor_identities LOOP
            SELECT * INTO rowColorIndentity FROM cmcard_coloridentity WHERE cmcard = _new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_coloridentity(
                    cmcard,
                    cmcolor
                ) VALUES (
                    _new_id,
                    pkey
                );
            END IF;    
        END LOOP;
    END IF;

    -- color indicators
    IF _cmcolor_indicators IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolor_indicators LOOP
            SELECT * INTO rowColorIndicator FROM cmcard_colorindicator WHERE cmcard = _new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_colorindicator(
                    cmcard,
                    cmcolor
                ) VALUES (
                    _new_id,
                    pkey
                );
            END IF;    
        END LOOP;
    END IF;

    -- legalities
    IF _cmlegalities IS NOT NULL THEN
        FOR pkey2, pkey3 IN SELECT * FROM jsonb_each_text(_cmlegalities) LOOP
            SELECT * INTO rowFormatLegality FROM cmcard_format_legality WHERE cmcard = _new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_format_legality(
                    cmcard,
                    cmformat,
                    cmlegality
                ) VALUES (
                    _new_id,
                    pkey2,
                    pkey3
                );
            END IF;    
        END LOOP;
    END IF;

    -- subtypes
    IF _cmcardtype_subtypes IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcardtype_subtypes LOOP
            SELECT * INTO rowSubtype FROM cmcard_subtype WHERE cmcard = _new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_subtype(
                    cmcard,
                    cmcardtype
                ) VALUES (
                    _new_id,
                    pkey
                );
            END IF;    
        END LOOP;
    END IF;

    -- supertypes
    IF _cmcardtype_subtypes IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcardtype_supertypes LOOP
            SELECT * INTO rowSupertype FROM cmcard_supertype WHERE cmcard = _new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_supertype(
                    cmcard,
                    cmcardtype
                ) VALUES (
                    _new_id,
                    pkey
                );
            END IF;    
        END LOOP;
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

