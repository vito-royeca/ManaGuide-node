CREATE OR REPLACE FUNCTION createOrUpdateCard(
    character varying,
    double precision,
    character varying,
    jsonb,
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
    date,
    boolean,
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
    character varying,
    character varying) RETURNS varchar AS $$
DECLARE
    _collector_number ALIAS FOR $1;
    _cmc ALIAS FOR $2;
    _flavor_text ALIAS FOR $3;
    _image_uris ALIAS FOR $4;
    _is_foil ALIAS FOR $5;
    _is_full_art ALIAS FOR $6;
    _is_highres_image ALIAS FOR $7;
    _is_nonfoil ALIAS FOR $8;
    _is_oversized ALIAS FOR $9;
    _is_reserved ALIAS FOR $10;
    _is_story_spotlight ALIAS FOR $11;
    _loyalty ALIAS FOR $12;
    _mana_cost ALIAS FOR $13;
    _multiverse_ids ALIAS FOR $14;
    _my_name_section ALIAS FOR $15;
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
    _is_variation ALIAS FOR $32;
    _mtgo_foil_id ALIAS FOR $33;
    _is_reprint ALIAS FOR $34;
    _id ALIAS FOR $35;
    _card_back_id ALIAS FOR $36;
    _oracle_id ALIAS FOR $37;
    _illustration_id ALIAS FOR $38;
    _cmartist ALIAS FOR $39;
    _cmset ALIAS FOR $40;
    _cmrarity ALIAS FOR $41;
    _cmlanguage ALIAS FOR $42;
    _cmlayout ALIAS FOR $43;

    pkey character varying;
    pkey2 character varying;
    pkey3 character varying;
BEGIN
    -- check for nulls
    IF _collector_number IS NULL OR lower(_collector_number) = 'null' THEN
        _collector_number := NULL;
    END IF;
    IF _flavor_text IS NULL OR lower(_flavor_text) = 'null' THEN
        _flavor_text := NULL;
    END IF;
    IF _image_uris IS NULL THEN
        _image_uris := NULL;
    END IF;
    IF _loyalty IS NULL OR lower(_loyalty) = 'null' THEN
        _loyalty := NULL;
    END IF;
    IF _mana_cost IS NULL OR lower(_mana_cost) = 'null' THEN
        _mana_cost := NULL;
    END IF;
    IF _my_name_section IS NULL OR lower(_my_name_section) = 'null' THEN
        _my_name_section := NULL;
    END IF;
    IF _name IS NULL OR lower(_name) = 'null' THEN
        _name := NULL;
    END IF;
    IF _oracle_text IS NULL OR lower(_oracle_text) = 'null' THEN
        _oracle_text := NULL;
    END IF;
    IF _power IS NULL OR lower(_power) = 'null' THEN
        _power := NULL;
    END IF;
    IF _printed_name IS NULL OR lower(_printed_name) = 'null' THEN
        _printed_name := NULL;
    END IF;
    IF _printed_text IS NULL OR lower(_printed_text) = 'null' THEN
        _printed_text := NULL;
    END IF;
    IF _toughness IS NULL OR lower(_toughness) = 'null' THEN
        _toughness := NULL;
    END IF;
    IF _arena_id IS NULL OR lower(_arena_id) = 'null' THEN
        _arena_id := NULL;
    END IF;
    IF _mtgo_id IS NULL OR lower(_mtgo_id) = 'null' THEN
        _mtgo_id := NULL;
    END IF;
    IF _tcgplayer_id IS NULL OR lower(_tcgplayer_id) = 'null' THEN
        _tcgplayer_id := NULL;
    END IF;
    IF _hand_modifier IS NULL OR lower(_hand_modifier) = 'null' THEN
        _hand_modifier := NULL;
    END IF;
    IF _life_modifier IS NULL OR lower(_life_modifier) = 'null' THEN
        _life_modifier := NULL;
    END IF;
    IF _released_at IS NULL THEN
        _released_at := NULL;
    END IF;
    IF _mtgo_foil_id IS NULL OR lower(_mtgo_foil_id) = 'null'  THEN
        _mtgo_foil_id := NULL;
    END IF;
    IF _card_back_id IS NULL OR lower(_card_back_id) = 'null' THEN
        _card_back_id := NULL;
    END IF;
    IF _oracle_id IS NULL OR lower(_oracle_id) = 'null' THEN
        _oracle_id := NULL;
    END IF;
    IF _illustration_id IS NULL OR lower(_illustration_id) = 'null' THEN
        _illustration_id := NULL;
    END IF;
    IF _cmartist IS NULL OR lower(_cmartist) = 'null' THEN
        _cmartist := NULL;
    END IF;
    IF _cmset IS NULL OR lower(_cmset) = 'null' THEN
        _cmset := NULL;
    END IF;
    IF _cmrarity IS NULL OR lower(_cmrarity) = 'null' THEN
        _cmrarity := NULL;
    END IF;
    IF _cmlanguage IS NULL OR lower(_cmlanguage) = 'null' THEN
        _cmlanguage := NULL;
    END IF;
    IF _cmlayout IS NULL OR lower(_cmlayout) = 'null' THEN
        _cmlayout := NULL;
    END IF;

    SELECT id INTO pkey FROM cmcard WHERE id = _id;

    IF NOT FOUND THEN
        INSERT INTO cmcard(
            collector_number,
            cmc,
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
            is_variation,
            mtgo_foil_id,
            is_reprint,
            id,
            card_back_id,
            oracle_id,
            illustration_id,
            cmartist,
            cmset,
            cmrarity,
            cmlanguage,
            cmlayout)
        VALUES(
            _collector_number,
            _cmc,
            _flavor_text,
            _image_uris::jsonb,
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
            _my_name_section,
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
            _released_at,
            _is_textless,
            _is_variation,
            _mtgo_foil_id::integer,
            _is_reprint,
            _id,
            _card_back_id,
            _oracle_id,
            _illustration_id,
            _cmartist,
            _cmset,
            _cmrarity,
            _cmlanguage,
            _cmlayout);
    ELSE
        UPDATE cmcard SET
            collector_number = _collector_number,
            cmc = _cmc,
            flavor_text = _flavor_text,
            image_uris = _image_uris,
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
            my_name_section = _my_name_section,
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
            released_at = _released_at,
            is_textless = _is_textless,
            is_variation = _is_variation,
            mtgo_foil_id = _mtgo_foil_id::integer,
            is_reprint = _is_reprint,
            id = _id,
            card_back_id = _card_back_id,
            oracle_id = _oracle_id,
            illustration_id = _illustration_id,
            cmartist = _cmartist,
            cmset = _cmset,
            cmrarity = _cmrarity,
            cmlanguage = _cmlanguage,
            cmlayout = _cmlayout,
            date_updated = now()
        WHERE id = _id;
    END IF;

    IF _cmset IS NOT NULL AND _cmlanguage IS NOT NULL THEN
        SELECT cmset, cmlanguage INTO pkey2, pkey3 FROM cmset_language WHERE cmset = _cmset AND cmlanguage = _cmlanguage;

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

    RETURN _id;
END;
$$ LANGUAGE plpgsql;

