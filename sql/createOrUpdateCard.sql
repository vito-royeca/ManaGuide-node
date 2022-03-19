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
    character varying) RETURNS varchar AS $$
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

    pkey character varying;
    pkey2 character varying;
    pkey3 character varying;
    released_at_ date;
    row RECORD;
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

    SELECT new_id INTO pkey FROM cmcard WHERE new_id = _new_id;

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
            id)
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
            _id);
    ELSE
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
            date_updated = now()
        WHERE new_id = _new_id;
    END IF;

    -- set and language
    DELETE FROM cmset_language WHERE cmset = _cmset AND cmlanguage = _cmlanguage;
    IF _cmset IS NOT NULL AND _cmlanguage IS NOT NULL THEN
        INSERT INTO cmset_language(
            cmset,
            cmlanguage
        ) VALUES(
            _cmset,
            _cmlanguage
        );
    END IF;

    -- frame effects
    DELETE FROM cmcard_frameeffect WHERE cmcard = _new_id;
    IF _cmframeeffects IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmframeeffects LOOP
            INSERT INTO cmcard_frameeffect(
                cmcard,
                cmframeeffect
            ) VALUES (
                _new_id,
                pkey
            );
        END LOOP;
    END IF;

    -- colors
    DELETE FROM cmcard_color WHERE cmcard = _new_id;
    IF _cmcolors IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolors LOOP
            INSERT INTO cmcard_color(
                cmcard,
                cmcolor
            ) VALUES (
                _new_id,
                pkey
            );
        END LOOP;
    END IF;

    -- color identities
    DELETE FROM cmcard_coloridentity WHERE cmcard = _new_id;
    IF _cmcolor_identities IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolor_identities LOOP
            INSERT INTO cmcard_coloridentity(
                cmcard,
                cmcolor
            ) VALUES (
                _new_id,
                pkey
            );
        END LOOP;
    END IF;

    -- color indicators
    DELETE FROM cmcard_colorindicator WHERE cmcard = _new_id;
    IF _cmcolor_indicators IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolor_indicators LOOP
            INSERT INTO cmcard_colorindicator(
                cmcard,
                cmcolor
            ) VALUES (
                _new_id,
                pkey
            );
        END LOOP;
    END IF;

    -- legalities
    DELETE FROM cmcard_format_legality WHERE cmcard = _new_id;
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
            );
        END LOOP;
    END IF;

    -- subtypes
    DELETE FROM cmcard_subtype WHERE cmcard = _new_id;
    IF _cmcardtype_subtypes IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcardtype_subtypes LOOP
            INSERT INTO cmcard_subtype(
                cmcard,
                cmcardtype
            ) VALUES (
                _new_id,
                pkey
            );
        END LOOP;
    END IF;

    -- supertypes
    DELETE FROM cmcard_supertype WHERE cmcard = _new_id;
    IF _cmcardtype_subtypes IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcardtype_supertypes LOOP
            INSERT INTO cmcard_supertype(
                cmcard,
                cmcardtype
            ) VALUES (
                _new_id,
                pkey
            );
        END LOOP;
    END IF;

    RETURN _new_id;
END;
$$ LANGUAGE plpgsql;

