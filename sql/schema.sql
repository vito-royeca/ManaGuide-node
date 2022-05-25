--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11
-- Dumped by pg_dump version 14.2

-- Started on 2022-05-25 12:28:13 EDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 285 (class 1255 OID 39272)
-- Name: createorupdateartist(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdateartist(character varying, character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _first_name ALIAS FOR $2;
    _last_name ALIAS FOR $3;
    _name_section ALIAS FOR $4;

    row cmartist%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmartist WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmartist(
            name,
            first_name,
            last_name,
            name_section)
        VALUES(
            _name,
            _first_name,
            _last_name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.first_name IS DISTINCT FROM _first_name OR
           row.last_name IS DISTINCT FROM _last_name OR
           row.name_section IS DISTINCT FROM _name_section THEN

            UPDATE cmartist SET
                name = _name,
                first_name = _first_name,
                last_name = _last_name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdateartist(character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 39313)
-- Name: createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer, character varying, character varying, character varying, character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION public.createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer, character varying, character varying, character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 39274)
-- Name: createorupdatecardfaces(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecardfaces(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcard_face ALIAS FOR $2;

    row cmcard_face%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmcard_face
    WHERE cmcard = _cmcard
        AND cmcard_face = _cmcard_face;

    IF NOT FOUND THEN
        INSERT INTO cmcard_face(
            cmcard,
            cmcard_face)
        VALUES(
            _cmcard,
            _cmcard_face);
    ELSE
        IF row.cmcard IS DISTINCT FROM _cmcard OR
           row.cmcard_face IS DISTINCT FROM _cmcard_face THEN

            UPDATE cmcard_face SET
                cmcard = _cmcard,
                cmcard_face = _cmcard_face,
                date_updated = now()
            WHERE cmcard = _cmcard
                AND cmcard_face = _cmcard_face;
        END IF;        
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatecardfaces(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 39300)
-- Name: createorupdatecardotherlanguages(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecardotherlanguages() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    currentRow integer := 0;
    row RECORD;
    row2 RECORD;
    rowOtherLanguage cmcard_otherlanguage%ROWTYPE;
BEGIN
    RAISE NOTICE 'other languages: %', currentRow;

    FOR row IN SELECT new_id, c.name, cmset, cmlanguage FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.new_id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.new_id NOT IN (SELECT cmcard_part FROM cmcard_component_part)
        ORDER BY s.release_date, c.name
    LOOP
        FOR row2 IN SELECT new_id FROM cmcard c
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                s.code = row.cmset AND
                c.name = row.name AND
                cmlanguage IS DISTINCT FROM row.cmlanguage
            ORDER BY s.release_date, c.name
        LOOP
            SELECT * INTO rowOtherLanguage FROM cmcard_otherlanguage WHERE cmcard = row.new_id AND cmcard_otherlanguage = row2.new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_otherlanguage(
                    cmcard,
                    cmcard_otherlanguage)
                VALUES(
                    row.new_id,
                    row2.new_id);
            END IF;        
        END LOOP;

        currentRow := currentRow + 1;
        IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'other languages: %', currentRow;
        END IF;
    END LOOP;

    RETURN;
END;
$$;


ALTER FUNCTION public.createorupdatecardotherlanguages() OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 39301)
-- Name: createorupdatecardotherprintings(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecardotherprintings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    currentRow integer := 0;
    rows integer := 0;
    row RECORD;
    row2 RECORD;
    rowOtherPrinting cmcard_otherprinting%ROWTYPE;
BEGIN
    RAISE NOTICE 'other printings: %', currentRow;

    FOR row IN SELECT new_id, c.name, cmset, cmlanguage FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.new_id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.new_id NOT IN (SELECT cmcard_part FROM cmcard_component_part)
        ORDER BY s.release_date, c.name
    LOOP
        FOR row2 IN SELECT new_id FROM cmcard c
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                new_id IS DISTINCT FROM row.new_id AND
                cmset IS DISTINCT FROM row.cmset AND
                c.name = row.name AND
                cmlanguage = row.cmlanguage
            ORDER BY s.release_date, c.name
        LOOP
            SELECT * INTO rowOtherPrinting FROM cmcard_otherprinting WHERE cmcard = row.new_id AND cmcard_otherprinting = row2.new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_otherprinting(
                    cmcard,
                    cmcard_otherprinting)
                VALUES(
                    row.new_id,
                    row2.new_id);
            END IF;        
        END LOOP;

        currentRow := currentRow + 1;
        IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'other printings: %', currentRow;
        END IF;
    END LOOP;

    RETURN;
END;
$$;


ALTER FUNCTION public.createorupdatecardotherprintings() OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 39275)
-- Name: createorupdatecardparts(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecardparts(character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcomponent ALIAS FOR $2;
    _cmcard_part ALIAS FOR $3;

    row cmcard_component_part%ROWTYPE;
    cmcard_part_new_id character varying;
BEGIN
    SELECT new_id INTO cmcard_part_new_id FROM cmcard
        WHERE id = _cmcard_part;

    SELECT * INTO row FROM cmcard_component_part
        WHERE cmcard = _cmcard
        AND cmcomponent = _cmcomponent
        AND cmcard_part = cmcard_part_new_id;

    IF NOT FOUND THEN
        INSERT INTO cmcard_component_part(
            cmcard,
            cmcomponent,
            cmcard_part)
        VALUES(
            _cmcard,
            _cmcomponent,
            cmcard_part_new_id);
    ELSE
        IF row.cmcard IS DISTINCT FROM _cmcard OR
           row.cmcomponent IS DISTINCT FROM _cmcomponent OR
           row.cmcard_part IS DISTINCT FROM cmcard_part_new_id THEN

            UPDATE cmcard_component_part SET
                cmcard = _cmcard,
                cmcomponent = _cmcomponent,
                cmcard_part = cmcard_part_new_id,
                date_updated = now()
            WHERE cmcard = _cmcard
            AND cmcomponent = _cmcomponent
            AND cmcard_part = cmcard_part_new_id;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatecardparts(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 39293)
-- Name: createorupdatecardprice(double precision, double precision, double precision, double precision, double precision, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecardprice(double precision, double precision, double precision, double precision, double precision, integer, boolean) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _low ALIAS FOR $1;
    _median ALIAS FOR $2;
    _high ALIAS FOR $3;
    _market ALIAS FOR $4;
    _direct_low ALIAS FOR $5;
    _tcgplayer_id ALIAS FOR $6;
    _is_foil ALIAS FOR $7;

    row cmcardprice%ROWTYPE;
    _new_id character varying;
BEGIN
    IF _low = 0.0 THEN
        _low := NULL;
    END IF;
    IF _median = 0.0 THEN
        _median := NULL;
    END IF;
    IF _high = 0.0 THEN
        _high := NULL;
    END IF;
    IF _market = 0.0 THEN
        _market := NULL;
    END IF;
    IF _direct_low = 0.0 THEN
        _direct_low := NULL;
    END IF;

    SELECT new_id INTO _new_id FROM cmcard WHERE tcgplayer_id = _tcgplayer_id;

    IF FOUND THEN
        SELECT * INTO row FROM cmcardprice
            WHERE cmcard = _new_id AND
                is_foil = _is_foil;

        IF NOT FOUND THEN
            INSERT INTO cmcardprice(
                low,
                median,
                high,
                market,
                direct_low,
                cmcard,
                is_foil)
            VALUES(
                _low,
                _median,
                _high,
                _market,
                _direct_low,
                _new_id,
                _is_foil);
        ELSE
            IF row.low IS DISTINCT FROM _low OR
               row.median IS DISTINCT FROM _median OR
               row.high IS DISTINCT FROM _high OR
               row.market IS DISTINCT FROM _market OR
               row.direct_low IS DISTINCT FROM _direct_low OR
               row.cmcard IS DISTINCT FROM _new_id OR
               row.is_foil IS DISTINCT FROM _is_foil THEN
                
                UPDATE cmcardprice SET
                    low = _low,
                    median = _median,
                    high = _high,
                    market = _market,
                    direct_low = _direct_low,
                    cmcard = _new_id,
                    is_foil = _is_foil,
                    date_updated = now()
                WHERE cmcard = _new_id AND
                    is_foil = _is_foil;
            END IF;        
        END IF;
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatecardprice(double precision, double precision, double precision, double precision, double precision, integer, boolean) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 39279)
-- Name: createorupdatecardtype(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecardtype(character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _cmcardtype_parent ALIAS FOR $3;

    row cmcardtype%ROWTYPE;
BEGIN
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;

    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;
    IF lower(_cmcardtype_parent) = 'null' THEN
        _cmcardtype_parent := NULL;
    END IF;

    IF _cmcardtype_parent IS NOT NULL THEN
        PERFORM createOrUpdateCardType(_cmcardtype_parent, LEFT(_cmcardtype_parent, 1), NULL);
    END IF;

    SELECT * INTO row FROM cmcardtype WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmcardtype(
            name,
            name_section,
            cmcardtype_parent)
        VALUES(
            _name,
            _name_section,
            _cmcardtype_parent);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.cmcardtype_parent IS DISTINCT FROM _cmcardtype_parent THEN

            UPDATE cmcardtype SET
                name = _name,
                name_section = _name_section,
                cmcardtype_parent = _cmcardtype_parent,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatecardtype(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 39302)
-- Name: createorupdatecardvariations(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecardvariations() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    currentRow integer := 0;
    rows integer := 0;
    row RECORD;
    row2 RECORD;
    rowVariation cmcard_variation%ROWTYPE;
BEGIN
    RAISE NOTICE 'variations: %', currentRow;

    FOR row IN SELECT new_id, c.name, cmset, cmlanguage FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.new_id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.new_id NOT IN (SELECT cmcard_part FROM cmcard_component_part)
        ORDER BY s.release_date, c.name
    LOOP
        FOR row2 IN SELECT new_id FROM cmcard c
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                new_id IS DISTINCT FROM row.new_id AND
                cmset = row.cmset AND
                c.name = row.name AND
                cmlanguage = row.cmlanguage
            ORDER BY s.release_date, c.name
        LOOP
            SELECT * INTO rowVariation FROM cmcard_variation WHERE cmcard = row.new_id AND cmcard_variation = row2.new_id;

            IF NOT FOUND THEN
                INSERT INTO cmcard_variation(
                    cmcard,
                    cmcard_variation)
                VALUES(
                    row.new_id,
                    row2.new_id);
            END IF;        
        END LOOP;

        currentRow := currentRow + 1;
        IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'variations: %', currentRow;
        END IF;
    END LOOP;

    RETURN;
END;
$$;


ALTER FUNCTION public.createorupdatecardvariations() OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 39280)
-- Name: createorupdatecolor(character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecolor(character varying, character varying, character varying, boolean) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _symbol ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
    _is_mana_color ALIAS FOR $4;

    row cmcolor%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmcolor WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmcolor(
            symbol,
            name,
            name_section,
            is_mana_color)
        VALUES(
            _symbol,
            _name,
            _name_section,
            _is_mana_color);
    ELSE
        IF row.symbol IS DISTINCT FROM _symbol OR
           row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.is_mana_color IS DISTINCT FROM _is_mana_color THEN

            UPDATE cmcolor SET
                symbol = _symbol,
                name = _name,
                name_section = _name_section,
                is_mana_color = _is_mana_color,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatecolor(character varying, character varying, character varying, boolean) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 39281)
-- Name: createorupdatecomponent(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecomponent(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmcomponent%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmcomponent WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmcomponent(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN

            UPDATE cmcomponent SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatecomponent(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 39282)
-- Name: createorupdateformat(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdateformat(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmformat%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmformat WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmformat(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN

            UPDATE cmformat SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdateformat(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 39283)
-- Name: createorupdateframe(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdateframe(character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _description ALIAS FOR $3;

    row cmframe%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmframe WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmframe(
            name,
            name_section,
            description)
        VALUES(
            _name,
            _name_section,
            _description);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.description = _description THEN

            UPDATE cmframe SET
                name = _name,
                name_section = _name_section,
                description = _description,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdateframe(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 39284)
-- Name: createorupdateframeeffect(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdateframeeffect(character varying, character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _id ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
    _description ALIAS FOR $4;

    row cmframeeffect%ROWTYPE;
BEGIN
    -- check for nulls
    IF lower(_id) = 'null' THEN
        _id := NULL;
    END IF;
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;
    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;
    IF lower(_description) = 'null' THEN
        _description := NULL;
    END IF;

    SELECT * INTO row FROM cmframeeffect WHERE id = _id;

    IF NOT FOUND THEN
        INSERT INTO cmframeeffect(
            id,
            name,
            name_section,
            description)
        VALUES(
            _id,
            _name,
            _name_section,
            _description);
    ELSE
        IF row.id IS DISTINCT FROM _id OR
           row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.description IS DISTINCT FROM _description THEN
            
            UPDATE cmframeeffect SET
                id = _id,
                name = _name,
                name_section = _name_section,
                description = _description,
                date_updated = now()
            WHERE id = _id;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdateframeeffect(character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 39285)
-- Name: createorupdatelanguage(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatelanguage(character varying, character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    _display_code ALIAS FOR $2;
    _name ALIAS FOR $3;
    _name_section ALIAS FOR $4;

    row cmlanguage%ROWTYPE;
BEGIN
    -- check for nulls
    IF lower(_display_code) = 'null' THEN
        _display_code := NULL;
    END IF;
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;
    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;

    SELECT * INTO row FROM cmlanguage WHERE code = _code;

    IF NOT FOUND THEN
        INSERT INTO cmlanguage(
            code,
            display_code,
            name,
            name_section)
        VALUES(
            _code,
            _display_code,
            _name,
            _name_section);
    ELSE
        IF row.code IS DISTINCT FROM _code OR
           row.display_code IS DISTINCT FROM _display_code OR
           row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
            
            UPDATE cmlanguage SET
                code = _code,
                display_code = _display_code,
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE code = _code;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatelanguage(character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 39286)
-- Name: createorupdatelayout(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatelayout(character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _description ALIAS FOR $3;

    row cmlayout%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmlayout WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmlayout(
            name,
            name_section,
            description)
        VALUES(
            _name,
            _name_section,
            _description);
    ELSE
        if row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.description IS DISTINCT FROM _description THEN
        
            UPDATE cmlayout SET
                name = _name,
                name_section = _name_section,
                description = _description,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatelayout(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 39287)
-- Name: createorupdatelegality(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatelegality(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmlegality%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmlegality WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmlegality(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
        
            UPDATE cmlegality SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatelegality(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 39289)
-- Name: createorupdaterarity(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdaterarity(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmrarity%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmrarity WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmrarity(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
        
            UPDATE cmrarity SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdaterarity(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 39290)
-- Name: createorupdaterule(character varying, character varying, character varying, double precision, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdaterule(character varying, character varying, character varying, double precision, integer, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _term ALIAS FOR $1;
    _term_section ALIAS FOR $2;
    _definition ALIAS FOR $3;
    _order ALIAS FOR $4;
    _cmrule_parent ALIAS FOR $5;
    _id ALIAS FOR $6;

    row cmrule%ROWTYPE;
BEGIN
    IF lower(_term) = 'null' THEN
        _term := NULL;
    END IF;
    IF lower(_term_section) = 'null' THEN
        _term_section := NULL;
    END IF;
    IF lower(_definition) = 'null' THEN
        _definition := NULL;
    END IF;
    IF _cmrule_parent = -1 THEN
        _cmrule_parent := NULL;
    END IF;

    SELECT * INTO row FROM cmrule
        WHERE term = _term AND
        term_section = _term_section AND
        definition = _definition AND
        "order" = _order;

    IF NOT FOUND THEN
        INSERT INTO cmrule(
            term,
            term_section,
            definition,
            "order",
            cmrule_parent,
            id)
        VALUES(
            _term,
            _term_section,
            _definition,
            _order,
            _cmrule_parent,
            _id);
    ELSE
        IF row.term IS DISTINCT FROM _term OR
           row.term_section IS DISTINCT FROM _term_section OR
           row.definition IS DISTINCT FROM _definition OR
           row."order" IS DISTINCT FROM _order OR
           row.cmrule_parent IS DISTINCT FROM _cmrule_parent OR
           row.id IS DISTINCT FROM _id THEN
            
            UPDATE cmrule SET
                term = _term,
                term_section = _term_section,
                definition = _definition,
                "order" = _order,
                cmrule_parent = _cmrule_parent,
                id = _id,
                date_updated = now()
            WHERE term = _term AND
                term_section = _term_section AND
                definition = _definition AND
                "order" = _order;
        END IF;        
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdaterule(character varying, character varying, character varying, double precision, integer, integer) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 39291)
-- Name: createorupdateruling(character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdateruling(character varying, character varying, date) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _oracle_id ALIAS FOR $1;
    _text ALIAS FOR $2;
    _date_published ALIAS FOR $3;

    row cmruling%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmruling WHERE oracle_id = _oracle_id;

    IF NOT FOUND THEN
        INSERT INTO cmruling(
            oracle_id,
            text,
            date_published)
        VALUES(
            _oracle_id,
            _text,
            _date_published);
    ELSE
        IF row.oracle_id IS DISTINCT FROM _oracle_id OR
           row.text IS DISTINCT FROM _text OR
           row.date_published IS DISTINCT FROM _date_published THEN

            UPDATE cmruling SET
                oracle_id = _oracle_id,
                text = _text,
                date_published = _date_published,
                date_updated = now()
            WHERE oracle_id = _oracle_id;
        END IF;  
    END IF;        

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdateruling(character varying, character varying, date) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 39297)
-- Name: createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _card_count ALIAS FOR $1;
    _code ALIAS FOR $2;
    _is_foil_only ALIAS FOR $3;
    _is_online_only ALIAS FOR $4;
    _logo_code ALIAS FOR $5;
    _mtgo_code ALIAS FOR $6;
    _keyrune_unicode ALIAS FOR $7;
    _keyrune_class ALIAS FOR $8;
    _name_section ALIAS FOR $9;
    _year_section ALIAS FOR $10;
    _name ALIAS FOR $11;
    _release_date ALIAS FOR $12;
    _tcgplayer_id ALIAS FOR $13;
    _cmsetblock ALIAS FOR $14;
    _cmsettype ALIAS FOR $15;
    _cmset_parent ALIAS FOR $16;

    row cmset%rowtype;
    parent_row cmset%rowtype;
BEGIN
    -- check for nulls
    IF lower(_logo_code) = 'null' THEN
        _logo_code := NULL;
    END IF;
    IF lower(_mtgo_code) = 'null' THEN
        _mtgo_code := NULL;
    END IF;
    IF lower(_keyrune_unicode) = 'null' THEN
        _keyrune_unicode := NULL;
    END IF;
    IF lower(_keyrune_class) = 'null' THEN
        _keyrune_class := NULL;
    END IF;
    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;
    IF lower(_year_section) = 'null' THEN
        _year_section := NULL;
    END IF;
    IF lower(_name) = 'null' THEN
        _name := NULL;
    END IF;
    IF lower(_release_date) = 'null' THEN
        _release_date := NULL;
    END IF;
    IF lower(_cmsetblock) = 'null' THEN
        _cmsetblock := NULL;
    END IF;
    IF lower(_cmsettype) = 'null' THEN
        _cmsettype := NULL;
    END IF;
    IF lower(_cmset_parent) = 'null' THEN
        _cmset_parent := NULL;
    END IF;

    SELECT * INTO row FROM cmset WHERE code = _code;

    IF NOT FOUND THEN
        INSERT INTO cmset(
            card_count,
            code,
            is_foil_only,
            is_online_only,
            logo_code,
            mtgo_code,
            keyrune_unicode,
            keyrune_class,
            name_section,
            year_section,
            name,
            release_date,
            tcgplayer_id,
            cmsetblock,
            cmsettype)
        VALUES(
            _card_count,
            _code,
            _is_foil_only,
            _is_online_only,
            _logo_code,
            _mtgo_code,
            _keyrune_unicode,
            _keyrune_class,
            _name_section,
            _year_section,
            _name,
            _release_date,
            _tcgplayer_id,
            _cmsetblock,
            _cmsettype);
    ELSE
        IF _cmset_parent IS NOT NULL THEN
            SELECT * INTO parent_row FROM cmset WHERE code = _cmset_parent;

            IF row.card_count IS DISTINCT FROM _card_count OR
               row.is_foil_only IS DISTINCT FROM _is_foil_only OR
               row.is_online_only IS DISTINCT FROM _is_online_only OR
               row.logo_code IS DISTINCT FROM _logo_code OR
               row.mtgo_code IS DISTINCT FROM _mtgo_code OR
               row.keyrune_unicode IS DISTINCT FROM (CASE WHEN (_keyrune_unicode != parent_row.keyrune_unicode) THEN _keyrune_unicode ELSE parent_row.keyrune_unicode END) OR
               row.keyrune_class IS DISTINCT FROM (CASE WHEN (_keyrune_class != parent_row.keyrune_class) THEN _keyrune_class ELSE parent_row.keyrune_class END) OR
               row.name_section IS DISTINCT FROM (CASE WHEN (_name_section != parent_row.name_section) THEN _name_section ELSE parent_row.name_section END) OR
               row.year_section IS DISTINCT FROM (CASE WHEN (_year_section != parent_row.year_section) THEN _year_section ELSE parent_row.year_section END) OR
               row.name IS DISTINCT FROM _name OR
               row.release_date IS DISTINCT FROM (CASE WHEN (_release_date != parent_row.release_date) THEN _release_date ELSE parent_row.release_date END) OR
               row.tcgplayer_id IS DISTINCT FROM _tcgplayer_id OR
               row.cmsetblock IS DISTINCT FROM _cmsetblock OR
               row.cmsettype IS DISTINCT FROM _cmsettype OR
               row.cmset_parent IS DISTINCT FROM _cmset_parent  THEN
                
                UPDATE cmset SET
                    card_count = _card_count,
                    is_foil_only = _is_foil_only,
                    is_online_only = _is_online_only,
                    logo_code = _logo_code,
                    mtgo_code = _mtgo_code,
                    keyrune_unicode = (CASE WHEN (_keyrune_unicode != parent_row.keyrune_unicode) THEN _keyrune_unicode ELSE parent_row.keyrune_unicode END),
                    keyrune_class = (CASE WHEN (_keyrune_class != parent_row.keyrune_class) THEN _keyrune_class ELSE parent_row.keyrune_class END),
                    name_section = (CASE WHEN (_name_section != parent_row.name_section) THEN _name_section ELSE parent_row.name_section END),
                    year_section = (CASE WHEN (_year_section != parent_row.year_section) THEN _year_section ELSE parent_row.year_section END),
                    name = _name,
                    release_date = (CASE WHEN (_release_date != parent_row.release_date) THEN _release_date ELSE parent_row.release_date END),
                    tcgplayer_id = _tcgplayer_id,
                    cmsetblock = _cmsetblock,
                    cmsettype = _cmsettype,
                    cmset_parent = _cmset_parent,
                    date_updated = now()
                WHERE code = _code;
            END IF;    
        ELSE
            IF row.card_count IS DISTINCT FROM _card_count OR
               row.is_foil_only IS DISTINCT FROM _is_foil_only OR
               row.is_online_only IS DISTINCT FROM _is_online_only OR
               row.logo_code IS DISTINCT FROM _logo_code OR
               row.mtgo_code IS DISTINCT FROM _mtgo_code OR
               row.keyrune_unicode IS DISTINCT FROM _keyrune_unicode OR
               row.keyrune_class IS DISTINCT FROM _keyrune_class OR
               row.name_section IS DISTINCT FROM _name_section OR
               row.year_section IS DISTINCT FROM _year_section OR
               row.name IS DISTINCT FROM _name OR
               row.release_date IS DISTINCT FROM _release_date OR
               row.tcgplayer_id IS DISTINCT FROM _tcgplayer_id OR
               row.cmsetblock IS DISTINCT FROM _cmsetblock OR
               row.cmsettype IS DISTINCT FROM _cmsettype THEN
                
                UPDATE cmset SET
                    card_count = _card_count,
                    is_foil_only = _is_foil_only,
                    is_online_only = _is_online_only,
                    logo_code = _logo_code,
                    mtgo_code = _mtgo_code,
                    keyrune_unicode = _keyrune_unicode,
                    keyrune_class = _keyrune_class,
                    name_section = _name_section,
                    year_section = _year_section,
                    name = _name,
                    release_date = _release_date,
                    tcgplayer_id = _tcgplayer_id,
                    cmsetblock = _cmsetblock,
                    cmsettype = _cmsettype,
                    date_updated = now()
                WHERE code = _code;
            END IF;    
        END IF;
    END IF;

	RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 39294)
-- Name: createorupdatesetblock(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatesetblock(character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;

    row cmsetblock%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmsetblock WHERE code = _code;

    IF NOT FOUND THEN
        INSERT INTO cmsetblock(
            code,
            name,
            name_section)
        VALUES(
            _code,
            _name,
            _name_section);
    ELSE
        IF row.code IS DISTINCT FROM _code OR
           row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
        
            UPDATE cmsetblock SET
                code = _code,
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE code = _code;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatesetblock(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 39295)
-- Name: createorupdatesettype(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatesettype(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmartist%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmsettype WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmsettype(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
            
            UPDATE cmsettype SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatesettype(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 39296)
-- Name: createorupdatewatermark(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatewatermark(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmwatermark%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmwatermark WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmwatermark(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
        
            UPDATE cmwatermark SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatewatermark(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 39292)
-- Name: createserverupdate(boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createserverupdate(boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _full_update ALIAS FOR $1;

    pkey character varying;
BEGIN
        INSERT INTO serverupdate(
            full_update)
        VALUES(
            _full_update);

    RETURN _full_update;
END;
$_$;


ALTER FUNCTION public.createserverupdate(boolean) OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 32484)
-- Name: deletecard(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.deletecard(character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _new_id ALIAS FOR $1;

    pkey character varying;
BEGIN
    DELETE from cmcard_color WHERE cmcard = _new_id;
    DELETE from cmcard_coloridentity WHERE cmcard = _new_id;
	DELETE from cmcard_colorindicator WHERE cmcard = _new_id;
	DELETE from cmcard_component_part WHERE cmcard = _new_id;
    DELETE from cmcard_component_part WHERE cmcard_part = _new_id;
	DELETE from cmcard_face WHERE cmcard_face = _new_id;
	DELETE from cmcard_face WHERE cmcard = _new_id;
    DELETE from cmcard_format_legality WHERE cmcard = _new_id;
    DELETE from cmcard_frameeffect WHERE cmcard = _new_id;
	DELETE from cmcard_otherlanguage WHERE cmcard = _new_id;
    DELETE from cmcard_otherprinting WHERE cmcard = _new_id;
	DELETE from cmcard_store_price WHERE cmcard = _new_id;
    DELETE from cmcard_subtype WHERE cmcard = _new_id;
    DELETE from cmcard_supertype WHERE cmcard = _new_id;
    DELETE from cmcardprice WHERE cmcard = _new_id;
	DELETE from cmcard_variation WHERE cmcard = _new_id;
    DELETE from cmcard WHERE new_id = _new_id;

    RETURN true;
END;
$_$;


ALTER FUNCTION public.deletecard(character varying) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 32485)
-- Name: deleteset(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.deleteset(character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;

    _new_id character varying;
    _card_count integer := 0;
BEGIN

    FOR _new_id IN SELECT new_id FROM cmcard where cmset = _code LOOP
        PERFORM deleteCard(_new_id);
        _card_count := _card_count + 1;
    END LOOP;

    DELETE FROM cmset_language WHERE cmset = _code;
    DELETE FROM cmset WHERE code = _code;

    RETURN _card_count;
END;
$_$;


ALTER FUNCTION public.deleteset(character varying) OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 39320)
-- Name: searchcards(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.searchcards(character varying, character varying, character varying) RETURNS TABLE(new_id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, number_order double precision, name character varying, name_section character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, tcgplayer_id integer, released_at date, art_crop_url character varying, normal_url character varying, png_url character varying, set json, rarity json, language json, layout json, prices json[], faces json[], supertypes json[])
    LANGUAGE plpgsql
    AS $_$
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
        _sortedBy = 'c.my_number_order ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'name' THEN
        _sortedBy = 'regexp_replace(c.name, ''"'', '''', ''g'')';
    END IF;
    IF lower(_sortedBy) = 'cmc' THEN
        _sortedBy = 'c.cmc ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'type' THEN
        _sortedBy = 'c.type_line ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'rarity' THEN
        _sortedBy = 'r.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;

    command := 'SELECT
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
                    tcgplayer_id,
                    released_at,
                    art_crop_url,
                    normal_url,
                    png_url,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class, s.keyrune_unicode
                            FROM cmset s WHERE s.code = c.cmset
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name
                            FROM cmrarity r WHERE r.name = c.cmrarity
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' || command ||
                            'FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                        ) x
                    ) AS faces ';

    -- Supertypes
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS supertypes ';               

    command := command || 'FROM cmcard c ';
    command := command || 'WHERE c.cmlanguage = ''en'' ';
    command := command || 'AND c.new_id NOT IN(select cmcard_face from cmcard_face) ';
    command := command || 'AND lower(c.name) LIKE ''%' || _query || '%'' ';
    command := command || 'ORDER BY ' || _sortedBy || '';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.searchcards(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 32487)
-- Name: searchrules(character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.searchrules(character varying) RETURNS TABLE(id integer, term character varying, term_section character varying, definition character varying, "order" double precision, parent json, children json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _query ALIAS FOR $1;
    command character varying;
BEGIN
    _query := lower(_query);

    command := 'SELECT id,
                    term,
                    term_section,
                    definition,
                    "order",
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT p.id, p.term, p.definition
                            FROM cmrule p WHERE p.id = s.cmrule_parent
                        ) x
                    ) AS parent';

    -- Children
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command || ', (SELECT children from selectRules(c.id))'
                            ' FROM cmrule c
                            WHERE c.cmrule_parent = s.id ORDER BY c.term'
                        ') x
                    ) AS children FROM cmrule s';

    command := command || ' WHERE lower(s.term) LIKE ''%' || _query || '%'' ';
    command := command || ' OR lower(s.definition) LIKE ''%' || _query || '%'' ';

    command := command || ' ORDER BY s.order ASC';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.searchrules(character varying) OWNER TO managuide;

--
-- TOC entry 277 (class 1255 OID 39317)
-- Name: selectcard(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectcard(character varying) RETURNS TABLE(collector_number character varying, cmc double precision, face_order integer, flavor_text character varying, is_foil boolean, is_full_art boolean, is_highres_image boolean, is_nonfoil boolean, is_oversized boolean, is_reserved boolean, is_story_spotlight boolean, loyalty character varying, mana_cost character varying, number_order double precision, name character varying, oracle_text character varying, power character varying, printed_name character varying, printed_text character varying, toughness character varying, arena_id integer, mtgo_id integer, tcgplayer_id integer, hand_modifier character varying, life_modifier character varying, is_booster boolean, is_digital boolean, is_promo boolean, released_at date, is_textless boolean, mtgo_foil_id integer, is_reprint boolean, new_id character varying, printed_type_line character varying, type_line character varying, multiverse_ids integer[], art_crop_url character varying, normal_url character varying, png_url character varying, set json, rarity json, language json, layout json, watermark json, frame json, artist json, colors json[], color_identities json[], color_indicators json[], component_parts json[], faces json[], other_languages json[], other_printings json[], variations json[], format_legalities json[], frame_effects json[], subtypes json[], supertypes json[], prices json[], rulings json[])
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION public.selectcard(character varying) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 39319)
-- Name: selectcards(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectcards(character varying, character varying, character varying, character varying) RETURNS TABLE(new_id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, number_order double precision, name character varying, name_section character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, tcgplayer_id integer, released_at date, art_crop_url character varying, normal_url character varying, png_url character varying, set json, rarity json, language json, layout json, prices json[], faces json[], supertypes json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _cmset ALIAS FOR $1;
    _cmlanguage ALIAS FOR $2;
    _sortedBy ALIAS FOR $3;
    _orderBy ALIAS FOR $4;
    command character varying;
BEGIN
    IF lower(_sortedBy) = 'set_name' THEN
        _sortedBy = 's.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
	IF lower(_sortedBy) = 'set_release' THEN
        _sortedBy = 's.release_date ' || _orderBy || ', s.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'collector_number' THEN
        _sortedBy = 'c.my_number_order ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'name' THEN
        _sortedBy = 'regexp_replace(c.name, ''"'', '''', ''g'')';
    END IF;
    IF lower(_sortedBy) = 'cmc' THEN
        _sortedBy = 'c.cmc ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'type' THEN
        _sortedBy = 'c.type_line ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'rarity' THEN
        _sortedBy = 'r.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;

    command := 'SELECT
                    new_id,
                    collector_number,
                    face_order,
                    loyalty,
                    mana_cost,
                    number_order,
                    c.name,
                    c.name_section,
                    printed_name,
                    printed_type_line,
                    type_line,
	                power,
                    toughness,
                    c.tcgplayer_id,
                    released_at,
                    art_crop_url,
                    normal_url,
                    png_url,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class, s.keyrune_unicode
                            FROM cmset s WHERE s.code = c.cmset
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name
                            FROM cmrarity r WHERE r.name = c.cmrarity
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' || command ||
                            'FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                        ) x
                    ) AS faces ';

    -- Supertypes
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                            WHERE v.cmcard = c.new_id
                        ) x
                    ) AS supertypes ';                

    command := command || 'FROM cmcard c LEFT JOIN cmset s ON c.cmset = s.code ';
	command := command || 'LEFT JOIN cmrarity r ON c.cmrarity = r.name ';
    command := command || 'WHERE c.cmset = ''' || _cmset || ''' ';
    command := command || 'AND c.cmlanguage = ''' || _cmlanguage || ''' ';
    command := command || 'AND c.new_id NOT IN(select cmcard_face from cmcard_face) ';
    command := command || 'ORDER BY ' || _sortedBy || '';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectcards(character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 32492)
-- Name: selectrules(integer); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.selectrules(integer) RETURNS TABLE(id integer, term character varying, term_section character varying, definition character varying, "order" double precision, parent json, children json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _id ALIAS FOR $1;
    command character varying;
BEGIN
    command := 'SELECT id,
                    term,
                    term_section,
                    definition,
                    "order",
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT p.id, p.term, p.definition
                            FROM cmrule p WHERE p.id = s.cmrule_parent
                        ) x
                    ) AS parent';

    -- Children
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command || ', (SELECT children from selectRules(c.id))'
                            ' FROM cmrule c
                            WHERE c.cmrule_parent = s.id ORDER BY c.term'
                        ') x
                    ) AS children FROM cmrule s';

    IF _id IS NOT NULL THEN
        command := command || ' WHERE s.id = ' || _id || '';
    ELSE
	    command := command || ' WHERE s.cmrule_parent IS NULL';
    END IF;

    command := command || ' ORDER BY s.order ASC';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectrules(integer) OWNER TO managuide;

--
-- TOC entry 256 (class 1255 OID 32493)
-- Name: selectset(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectset(character varying, character varying, character varying, character varying) RETURNS TABLE(card_count integer, code character varying, is_foil_only boolean, is_online_only boolean, logo_code character varying, mtgo_code character varying, keyrune_unicode character varying, keyrune_class character varying, year_section character varying, name character varying, release_date character varying, tcgplayer_id integer, set_block json, set_type json, languages json[], cards json)
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    _language ALIAS FOR $2;
    _sortedBy ALIAS FOR $3;
    _orderBy ALIAS FOR $4;
    command character varying;
BEGIN
    command := 'SELECT card_count,
                    code,
                    is_foil_only,
                    is_online_only,
                    logo_code,
                    mtgo_code,
                    keyrune_unicode,
                    keyrune_class,
                    year_section,
                    name,
                    release_date,
                    tcgplayer_id,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT sb.code, sb.name
                            FROM cmsetblock sb WHERE sb.code = s.cmsetblock
                        ) x
                   ) AS set_block,
                   (
                       SELECT row_to_json(x) FROM (
                            SELECT st.name
                            FROM cmsettype st WHERE st.name = s.cmsettype
                        ) x
                   ) AS set_type,
                   array(
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.display_code, l.name
                            FROM cmset_language sl left join cmlanguage l on sl.cmlanguage = l.code
                            WHERE sl.cmset = s.code
                        ) x
	               ) AS languages,
                   array_to_json(
                        array(SELECT selectCards(''' || _code || ''', ''' || _language || ''', ''' || _sortedBy || ''', ''' || _orderBy || '''))
                   ) AS cards
            FROM cmset s ';

    IF _code IS NOT NULL THEN
        command := command || 'WHERE s.code = ''' || _code || '''';
    END IF;

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectset(character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 32494)
-- Name: selectsets(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectsets() RETURNS TABLE(card_count integer, code character varying, is_foil_only boolean, is_online_only boolean, logo_code character varying, mtgo_code character varying, keyrune_unicode character varying, keyrune_class character varying, year_section character varying, name character varying, release_date character varying, tcgplayer_id integer, cmset_parent character varying, set_block json, set_type json, languages json[])
    LANGUAGE plpgsql
    AS $$
DECLARE
    command     character varying;
BEGIN
    command := 'SELECT card_count,
                    code,
                    is_foil_only,
                    is_online_only,
                    logo_code,
                    mtgo_code,
                    keyrune_unicode,
                    keyrune_class,
                    year_section,
                    name,
                    release_date,
                    tcgplayer_id,
					cmset_parent,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT sb.code, sb.name
                            FROM cmsetblock sb WHERE sb.code = s.cmsetblock
                        ) x
                   ) AS set_block,
                   (
                       SELECT row_to_json(x) FROM (
                            SELECT st.name
                            FROM cmsettype st WHERE st.name = s.cmsettype
                        ) x
                   ) AS set_type,
                   array(
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.display_code, l.name
                            FROM cmset_language sl left join cmlanguage l on sl.cmlanguage = l.code
                            WHERE sl.cmset = s.code
                        ) x
	               ) AS languages
                    FROM cmset s WHERE s.card_count > 0';


    command := command || ' GROUP BY cmset_parent, card_count, code';
    command := command || ' ORDER BY release_date DESC, cmset_parent DESC, cmset_parent DESC';

    
    RETURN QUERY EXECUTE command;
END;
$$;


ALTER FUNCTION public.selectsets() OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 39627)
-- Name: testfunc(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.testfunc(character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_art_crop_url ALIAS FOR $1;
	rowCard cmcard%ROWTYPE;
BEGIN	
	SELECT * INTO rowCard FROM cmcard WHERE new_id = 'zen_en_21';
	
	IF coalesce(rowCard.art_crop_url, '') <> coalesce(_art_crop_url, '') THEN
		RAISE NOTICE 'coalesce: % <> %', rowCard.art_crop_url, _art_crop_url;
	ELSE
	    RAISE NOTICE 'coalesce: % = %', rowCard.art_crop_url, _art_crop_url;
	END IF;
	
	IF rowCard.art_crop_url IS DISTINCT FROM _art_crop_url THEN
		RAISE NOTICE '% IS DISTINCT FROM %', rowCard.art_crop_url, _art_crop_url;
	ELSE
	    RAISE NOTICE '% = %', rowCard.art_crop_url, _art_crop_url;
	END IF;
	
	RETURN;
END;
$_$;


ALTER FUNCTION public.testfunc(character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 32495)
-- Name: cmartist; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmartist (
    first_name character varying,
    last_name character varying,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    name character varying NOT NULL
);


ALTER TABLE public.cmartist OWNER TO managuide;

--
-- TOC entry 203 (class 1259 OID 32503)
-- Name: cmcard; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard (
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
    multiverse_ids integer[],
    name_section character varying,
    name character varying NOT NULL,
    oracle_text character varying,
    power character varying,
    printed_name character varying,
    printed_text character varying,
    toughness character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
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
    cmartist character varying,
    cmset character varying,
    cmrarity character varying,
    cmlanguage character varying,
    cmlayout character varying,
    cmwatermark character varying,
    cmframe character varying,
    printed_type_line character varying,
    type_line character varying,
    number_order double precision,
    new_id character varying NOT NULL,
    oracle_id character varying,
    id character varying,
    art_crop_url character varying,
    normal_url character varying,
    png_url character varying
);


ALTER TABLE public.cmcard OWNER TO managuide;

--
-- TOC entry 204 (class 1259 OID 32511)
-- Name: cmcard_color; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_color (
    cmcard character varying NOT NULL,
    cmcolor character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_color OWNER TO managuide;

--
-- TOC entry 205 (class 1259 OID 32519)
-- Name: cmcard_coloridentity; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_coloridentity (
    cmcard character varying NOT NULL,
    cmcolor character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_coloridentity OWNER TO managuide;

--
-- TOC entry 206 (class 1259 OID 32527)
-- Name: cmcard_colorindicator; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_colorindicator (
    cmcard character varying NOT NULL,
    cmcolor character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_colorindicator OWNER TO managuide;

--
-- TOC entry 207 (class 1259 OID 32535)
-- Name: cmcard_component_part; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_component_part (
    cmcard character varying NOT NULL,
    cmcomponent character varying NOT NULL,
    cmcard_part character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_component_part OWNER TO managuide;

--
-- TOC entry 208 (class 1259 OID 32543)
-- Name: cmcard_face; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_face (
    cmcard character varying NOT NULL,
    cmcard_face character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_face OWNER TO managuide;

--
-- TOC entry 209 (class 1259 OID 32551)
-- Name: cmcard_format_legality; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_format_legality (
    cmcard character varying NOT NULL,
    cmformat character varying NOT NULL,
    cmlegality character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    id integer NOT NULL
);


ALTER TABLE public.cmcard_format_legality OWNER TO managuide;

--
-- TOC entry 210 (class 1259 OID 32559)
-- Name: cmcard_format_legality_id_seq; Type: SEQUENCE; Schema: public; Owner: managuide
--

CREATE SEQUENCE public.cmcard_format_legality_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cmcard_format_legality_id_seq OWNER TO managuide;

--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 210
-- Name: cmcard_format_legality_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcard_format_legality_id_seq OWNED BY public.cmcard_format_legality.id;


--
-- TOC entry 211 (class 1259 OID 32561)
-- Name: cmcard_frameeffect; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_frameeffect (
    cmcard character varying NOT NULL,
    cmframeeffect character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_frameeffect OWNER TO managuide;

--
-- TOC entry 212 (class 1259 OID 32569)
-- Name: cmcard_otherlanguage; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_otherlanguage (
    cmcard character varying NOT NULL,
    cmcard_otherlanguage character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_otherlanguage OWNER TO managuide;

--
-- TOC entry 213 (class 1259 OID 32577)
-- Name: cmcard_otherprinting; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_otherprinting (
    cmcard character varying NOT NULL,
    cmcard_otherprinting character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_otherprinting OWNER TO managuide;

--
-- TOC entry 214 (class 1259 OID 32595)
-- Name: cmcard_subtype; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_subtype (
    cmcard character varying NOT NULL,
    cmcardtype character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    cmcard2 character varying
);


ALTER TABLE public.cmcard_subtype OWNER TO managuide;

--
-- TOC entry 215 (class 1259 OID 32603)
-- Name: cmcard_supertype; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_supertype (
    cmcard character varying NOT NULL,
    cmcardtype character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_supertype OWNER TO managuide;

--
-- TOC entry 216 (class 1259 OID 32611)
-- Name: cmcard_variation; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_variation (
    cmcard character varying NOT NULL,
    cmcard_variation character varying NOT NULL,
    date_created time without time zone DEFAULT now(),
    date_updated time without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_variation OWNER TO managuide;

--
-- TOC entry 217 (class 1259 OID 32619)
-- Name: cmcardprice; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcardprice (
    high double precision,
    low double precision,
    cmcard character varying NOT NULL,
    id integer NOT NULL,
    median double precision,
    condition character varying,
    is_foil boolean,
    market double precision,
    direct_low double precision,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcardprice OWNER TO managuide;

--
-- TOC entry 218 (class 1259 OID 32627)
-- Name: cmcardprice_id_seq; Type: SEQUENCE; Schema: public; Owner: managuide
--

CREATE SEQUENCE public.cmcardprice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cmcardprice_id_seq OWNER TO managuide;

--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 218
-- Name: cmcardprice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcardprice_id_seq OWNED BY public.cmcardprice.id;


--
-- TOC entry 219 (class 1259 OID 32629)
-- Name: cmcardstatistics; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcardstatistics (
    id integer NOT NULL,
    cmcard character varying NOT NULL,
    views bigint,
    rating double precision,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcardstatistics OWNER TO managuide;

--
-- TOC entry 220 (class 1259 OID 32637)
-- Name: cmcardstatistics_id_seq; Type: SEQUENCE; Schema: public; Owner: managuide
--

CREATE SEQUENCE public.cmcardstatistics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cmcardstatistics_id_seq OWNER TO managuide;

--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 220
-- Name: cmcardstatistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcardstatistics_id_seq OWNED BY public.cmcardstatistics.id;


--
-- TOC entry 221 (class 1259 OID 32639)
-- Name: cmcardtype; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcardtype (
    name character varying NOT NULL,
    name_section character varying,
    cmcardtype_parent character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcardtype OWNER TO managuide;

--
-- TOC entry 222 (class 1259 OID 32647)
-- Name: cmcolor; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcolor (
    symbol character varying NOT NULL,
    name_section character varying,
    is_mana_color boolean,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    name character varying NOT NULL
);


ALTER TABLE public.cmcolor OWNER TO managuide;

--
-- TOC entry 223 (class 1259 OID 32655)
-- Name: cmcomponent; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcomponent (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcomponent OWNER TO managuide;

--
-- TOC entry 224 (class 1259 OID 32663)
-- Name: cmformat; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmformat (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmformat OWNER TO managuide;

--
-- TOC entry 225 (class 1259 OID 32671)
-- Name: cmframe; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmframe (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    description character varying
);


ALTER TABLE public.cmframe OWNER TO managuide;

--
-- TOC entry 226 (class 1259 OID 32679)
-- Name: cmframeeffect; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmframeeffect (
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    description character varying,
    id character varying NOT NULL,
    name character varying
);


ALTER TABLE public.cmframeeffect OWNER TO managuide;

--
-- TOC entry 227 (class 1259 OID 32687)
-- Name: cmlanguage; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmlanguage (
    code character varying NOT NULL,
    display_code character varying,
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmlanguage OWNER TO managuide;

--
-- TOC entry 228 (class 1259 OID 32695)
-- Name: cmlayout; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmlayout (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    description character varying
);


ALTER TABLE public.cmlayout OWNER TO managuide;

--
-- TOC entry 229 (class 1259 OID 32703)
-- Name: cmlegality; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmlegality (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmlegality OWNER TO managuide;

--
-- TOC entry 230 (class 1259 OID 32711)
-- Name: cmrarity; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmrarity (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmrarity OWNER TO managuide;

--
-- TOC entry 231 (class 1259 OID 32719)
-- Name: cmrule; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmrule (
    term character varying,
    term_section character varying,
    definition character varying,
    "order" double precision,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    id integer NOT NULL,
    cmrule_parent integer
);


ALTER TABLE public.cmrule OWNER TO managuide;

--
-- TOC entry 232 (class 1259 OID 32727)
-- Name: cmruling; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmruling (
    text character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    oracle_id character varying,
    date_published date,
    id integer NOT NULL
);


ALTER TABLE public.cmruling OWNER TO managuide;

--
-- TOC entry 233 (class 1259 OID 32735)
-- Name: cmruling_id_seq; Type: SEQUENCE; Schema: public; Owner: managuide
--

CREATE SEQUENCE public.cmruling_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cmruling_id_seq OWNER TO managuide;

--
-- TOC entry 3787 (class 0 OID 0)
-- Dependencies: 233
-- Name: cmruling_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmruling_id_seq OWNED BY public.cmruling.id;


--
-- TOC entry 234 (class 1259 OID 32737)
-- Name: cmset; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmset (
    card_count integer NOT NULL,
    code character varying NOT NULL,
    is_foil_only boolean,
    is_online_only boolean,
    mtgo_code character varying,
    name_section character varying,
    year_section character varying,
    name character varying NOT NULL,
    release_date character varying,
    tcgplayer_id integer,
    cmsetblock character varying,
    cmsettype character varying,
    cmset_parent character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    keyrune_unicode character varying,
    keyrune_class character varying,
    is_images_redownloaded boolean,
    logo_code character varying
);


ALTER TABLE public.cmset OWNER TO managuide;

--
-- TOC entry 235 (class 1259 OID 32745)
-- Name: cmset_language; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmset_language (
    cmset character varying NOT NULL,
    cmlanguage character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmset_language OWNER TO managuide;

--
-- TOC entry 236 (class 1259 OID 32753)
-- Name: cmsetblock; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmsetblock (
    code character varying NOT NULL,
    name_section character varying,
    name character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmsetblock OWNER TO managuide;

--
-- TOC entry 237 (class 1259 OID 32761)
-- Name: cmsettype; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmsettype (
    name character varying NOT NULL,
    name_section character varying(1),
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmsettype OWNER TO managuide;

--
-- TOC entry 238 (class 1259 OID 32777)
-- Name: cmwatermark; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmwatermark (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmwatermark OWNER TO managuide;

--
-- TOC entry 239 (class 1259 OID 32785)
-- Name: serverupdate; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.serverupdate (
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    full_update boolean NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.serverupdate OWNER TO managuide;

--
-- TOC entry 240 (class 1259 OID 32790)
-- Name: serverupdate_id_seq; Type: SEQUENCE; Schema: public; Owner: managuide
--

CREATE SEQUENCE public.serverupdate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.serverupdate_id_seq OWNER TO managuide;

--
-- TOC entry 3795 (class 0 OID 0)
-- Dependencies: 240
-- Name: serverupdate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.serverupdate_id_seq OWNED BY public.serverupdate.id;


--
-- TOC entry 3421 (class 2604 OID 32792)
-- Name: cmcard_format_legality id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality ALTER COLUMN id SET DEFAULT nextval('public.cmcard_format_legality_id_seq'::regclass);


--
-- TOC entry 3436 (class 2604 OID 32794)
-- Name: cmcardprice id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice ALTER COLUMN id SET DEFAULT nextval('public.cmcardprice_id_seq'::regclass);


--
-- TOC entry 3439 (class 2604 OID 32795)
-- Name: cmcardstatistics id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardstatistics ALTER COLUMN id SET DEFAULT nextval('public.cmcardstatistics_id_seq'::regclass);


--
-- TOC entry 3464 (class 2604 OID 32796)
-- Name: cmruling id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmruling ALTER COLUMN id SET DEFAULT nextval('public.cmruling_id_seq'::regclass);


--
-- TOC entry 3477 (class 2604 OID 32797)
-- Name: serverupdate id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.serverupdate ALTER COLUMN id SET DEFAULT nextval('public.serverupdate_id_seq'::regclass);


--
-- TOC entry 3480 (class 2606 OID 32818)
-- Name: cmartist cmartist_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmartist
    ADD CONSTRAINT cmartist_pkey PRIMARY KEY (name);


--
-- TOC entry 3495 (class 2606 OID 32820)
-- Name: cmcard_color cmcard_color_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_color_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- TOC entry 3497 (class 2606 OID 32822)
-- Name: cmcard_coloridentity cmcard_coloridentity_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_coloridentity_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- TOC entry 3499 (class 2606 OID 32824)
-- Name: cmcard_coloridentity cmcard_coloridentity_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_coloridentity_unique UNIQUE (cmcard, cmcolor);


--
-- TOC entry 3501 (class 2606 OID 32826)
-- Name: cmcard_colorindicator cmcard_colorindicator_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_colorindicator_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- TOC entry 3503 (class 2606 OID 32828)
-- Name: cmcard_colorindicator cmcard_colorindicator_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_colorindicator_unique UNIQUE (cmcard, cmcolor);


--
-- TOC entry 3505 (class 2606 OID 32830)
-- Name: cmcard_component_part cmcard_component_part_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_component_part_pkey PRIMARY KEY (cmcard, cmcomponent, cmcard_part);


--
-- TOC entry 3509 (class 2606 OID 32832)
-- Name: cmcard_face cmcard_face_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_pkey PRIMARY KEY (cmcard, cmcard_face);


--
-- TOC entry 3511 (class 2606 OID 32834)
-- Name: cmcard_face cmcard_face_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_unique UNIQUE (cmcard, cmcard_face);


--
-- TOC entry 3513 (class 2606 OID 32836)
-- Name: cmcard_format_legality cmcard_format_legality_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_format_legality_pkey PRIMARY KEY (id);


--
-- TOC entry 3515 (class 2606 OID 32838)
-- Name: cmcard_format_legality cmcard_format_legality_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_format_legality_unique UNIQUE (cmcard, cmformat, cmlegality);


--
-- TOC entry 3517 (class 2606 OID 32840)
-- Name: cmcard_frameeffect cmcard_frameeffect_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_frameeffect_pkey PRIMARY KEY (cmcard, cmframeeffect);


--
-- TOC entry 3519 (class 2606 OID 32842)
-- Name: cmcard_frameeffect cmcard_frameeffect_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_frameeffect_unique UNIQUE (cmcard, cmframeeffect);


--
-- TOC entry 3521 (class 2606 OID 32844)
-- Name: cmcard_otherlanguage cmcard_otherlanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_otherlanguage_pkey PRIMARY KEY (cmcard, cmcard_otherlanguage);


--
-- TOC entry 3523 (class 2606 OID 32846)
-- Name: cmcard_otherprinting cmcard_otherprinting_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_otherprinting_pkey PRIMARY KEY (cmcard, cmcard_otherprinting);


--
-- TOC entry 3507 (class 2606 OID 32855)
-- Name: cmcard_component_part cmcard_part_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_part_unique UNIQUE (cmcard, cmcomponent, cmcard_part);


--
-- TOC entry 3492 (class 2606 OID 32857)
-- Name: cmcard cmcard_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmcard_pkey PRIMARY KEY (new_id);


--
-- TOC entry 3525 (class 2606 OID 32861)
-- Name: cmcard_subtype cmcard_subtype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_subtype_pkey PRIMARY KEY (cmcard, cmcardtype);


--
-- TOC entry 3527 (class 2606 OID 32863)
-- Name: cmcard_subtype cmcard_subtype_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_subtype_unique UNIQUE (cmcard, cmcardtype);


--
-- TOC entry 3529 (class 2606 OID 32865)
-- Name: cmcard_supertype cmcard_supertype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_supertype_pkey PRIMARY KEY (cmcard, cmcardtype);


--
-- TOC entry 3531 (class 2606 OID 32867)
-- Name: cmcard_supertype cmcard_supertype_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_supertype_unique UNIQUE (cmcard, cmcardtype);


--
-- TOC entry 3533 (class 2606 OID 32869)
-- Name: cmcard_variation cmcard_variation_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_variation_pkey PRIMARY KEY (cmcard, cmcard_variation);


--
-- TOC entry 3546 (class 2606 OID 32871)
-- Name: cmformat cmcardformat_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmformat
    ADD CONSTRAINT cmcardformat_pkey PRIMARY KEY (name);


--
-- TOC entry 3535 (class 2606 OID 32873)
-- Name: cmcardprice cmcardprice_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmcardprice_pkey PRIMARY KEY (id);


--
-- TOC entry 3537 (class 2606 OID 32875)
-- Name: cmcardstatistics cmcardstatistics_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardstatistics
    ADD CONSTRAINT cmcardstatistics_pkey PRIMARY KEY (id);


--
-- TOC entry 3540 (class 2606 OID 32877)
-- Name: cmcardtype cmcardtype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardtype
    ADD CONSTRAINT cmcardtype_pkey PRIMARY KEY (name);


--
-- TOC entry 3542 (class 2606 OID 32879)
-- Name: cmcolor cmcolor_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcolor
    ADD CONSTRAINT cmcolor_pkey PRIMARY KEY (symbol);


--
-- TOC entry 3544 (class 2606 OID 32881)
-- Name: cmcomponent cmcomponent_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcomponent
    ADD CONSTRAINT cmcomponent_pkey PRIMARY KEY (name);


--
-- TOC entry 3548 (class 2606 OID 32883)
-- Name: cmframe cmframe_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmframe
    ADD CONSTRAINT cmframe_pkey PRIMARY KEY (name);


--
-- TOC entry 3550 (class 2606 OID 32885)
-- Name: cmframeeffect cmframeeffect_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmframeeffect
    ADD CONSTRAINT cmframeeffect_pkey PRIMARY KEY (id);


--
-- TOC entry 3553 (class 2606 OID 32887)
-- Name: cmlanguage cmlanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlanguage
    ADD CONSTRAINT cmlanguage_pkey PRIMARY KEY (code);


--
-- TOC entry 3555 (class 2606 OID 32889)
-- Name: cmlayout cmlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlayout
    ADD CONSTRAINT cmlayout_pkey PRIMARY KEY (name);


--
-- TOC entry 3557 (class 2606 OID 32891)
-- Name: cmlegality cmlegality_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlegality
    ADD CONSTRAINT cmlegality_pkey PRIMARY KEY (name);


--
-- TOC entry 3559 (class 2606 OID 32893)
-- Name: cmrarity cmrarity_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrarity
    ADD CONSTRAINT cmrarity_pkey PRIMARY KEY (name);


--
-- TOC entry 3561 (class 2606 OID 32895)
-- Name: cmrule cmrule_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrule
    ADD CONSTRAINT cmrule_pkey PRIMARY KEY (id);


--
-- TOC entry 3563 (class 2606 OID 32897)
-- Name: cmruling cmruling_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmruling
    ADD CONSTRAINT cmruling_pkey PRIMARY KEY (id);


--
-- TOC entry 3569 (class 2606 OID 32899)
-- Name: cmset_language cmset_language_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_language_pkey PRIMARY KEY (cmset, cmlanguage);


--
-- TOC entry 3571 (class 2606 OID 32901)
-- Name: cmset_language cmset_language_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_language_unique UNIQUE (cmset, cmlanguage);


--
-- TOC entry 3567 (class 2606 OID 32903)
-- Name: cmset cmset_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmset_pkey PRIMARY KEY (code);


--
-- TOC entry 3573 (class 2606 OID 32905)
-- Name: cmsetblock cmsetblock_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmsetblock
    ADD CONSTRAINT cmsetblock_pkey PRIMARY KEY (code);


--
-- TOC entry 3575 (class 2606 OID 32907)
-- Name: cmsettype cmsettype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmsettype
    ADD CONSTRAINT cmsettype_pkey PRIMARY KEY (name);


--
-- TOC entry 3577 (class 2606 OID 32911)
-- Name: cmwatermark cmwatermark_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmwatermark
    ADD CONSTRAINT cmwatermark_pkey PRIMARY KEY (name);


--
-- TOC entry 3579 (class 2606 OID 32913)
-- Name: serverupdate serverupdate_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.serverupdate
    ADD CONSTRAINT serverupdate_pkey PRIMARY KEY (id);


--
-- TOC entry 3478 (class 1259 OID 32914)
-- Name: cmartist_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmartist_name_index ON public.cmartist USING btree (name varchar_ops);


--
-- TOC entry 3481 (class 1259 OID 32915)
-- Name: cmcard_cmartist_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmartist_index ON public.cmcard USING btree (cmartist varchar_pattern_ops) INCLUDE (cmartist);


--
-- TOC entry 3482 (class 1259 OID 32916)
-- Name: cmcard_cmframe_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmframe_index ON public.cmcard USING btree (cmframe varchar_pattern_ops) INCLUDE (cmframe);


--
-- TOC entry 3483 (class 1259 OID 32917)
-- Name: cmcard_cmlanguage_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmlanguage_index ON public.cmcard USING btree (cmlanguage varchar_pattern_ops) INCLUDE (cmlanguage);


--
-- TOC entry 3484 (class 1259 OID 32918)
-- Name: cmcard_cmlayout_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmlayout_index ON public.cmcard USING btree (cmlayout varchar_pattern_ops) INCLUDE (cmlayout);


--
-- TOC entry 3485 (class 1259 OID 32919)
-- Name: cmcard_cmrarity_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmrarity_index ON public.cmcard USING btree (cmrarity varchar_pattern_ops) INCLUDE (cmrarity);


--
-- TOC entry 3486 (class 1259 OID 32920)
-- Name: cmcard_cmset_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmset_index ON public.cmcard USING btree (cmset varchar_pattern_ops) INCLUDE (cmset);


--
-- TOC entry 3487 (class 1259 OID 32921)
-- Name: cmcard_cmwatermark_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmwatermark_index ON public.cmcard USING btree (cmwatermark varchar_pattern_ops) INCLUDE (cmwatermark);


--
-- TOC entry 3488 (class 1259 OID 32922)
-- Name: cmcard_collector_number_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_collector_number_index ON public.cmcard USING btree (collector_number varchar_pattern_ops) INCLUDE (collector_number);


--
-- TOC entry 3489 (class 1259 OID 32923)
-- Name: cmcard_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_name_index ON public.cmcard USING btree (name varchar_pattern_ops);


--
-- TOC entry 3490 (class 1259 OID 32924)
-- Name: cmcard_new_id_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_new_id_index ON public.cmcard USING btree (new_id varchar_pattern_ops) INCLUDE (new_id);


--
-- TOC entry 3493 (class 1259 OID 32925)
-- Name: cmcard_tcgplayer_id_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_tcgplayer_id_index ON public.cmcard USING btree (tcgplayer_id DESC);


--
-- TOC entry 3538 (class 1259 OID 32927)
-- Name: cmcardtype_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcardtype_name_index ON public.cmcardtype USING btree (name varchar_ops);


--
-- TOC entry 3551 (class 1259 OID 32928)
-- Name: cmlanguage_code_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmlanguage_code_index ON public.cmlanguage USING btree (code varchar_ops);


--
-- TOC entry 3564 (class 1259 OID 32929)
-- Name: cmset_card_count_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmset_card_count_index ON public.cmset USING btree (card_count);


--
-- TOC entry 3565 (class 1259 OID 32930)
-- Name: cmset_code_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmset_code_index ON public.cmset USING btree (code varchar_ops);


--
-- TOC entry 3580 (class 2606 OID 32931)
-- Name: cmcard cmartist_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmartist_fkey FOREIGN KEY (cmartist) REFERENCES public.cmartist(name) NOT VALID;


--
-- TOC entry 3596 (class 2606 OID 32936)
-- Name: cmcard_face cmcard_face_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_fkey FOREIGN KEY (cmcard_face) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3587 (class 2606 OID 32941)
-- Name: cmcard_color cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3589 (class 2606 OID 32946)
-- Name: cmcard_coloridentity cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3591 (class 2606 OID 32951)
-- Name: cmcard_colorindicator cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3593 (class 2606 OID 32956)
-- Name: cmcard_component_part cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3597 (class 2606 OID 32961)
-- Name: cmcard_face cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3598 (class 2606 OID 32966)
-- Name: cmcard_format_legality cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3601 (class 2606 OID 32971)
-- Name: cmcard_frameeffect cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3603 (class 2606 OID 32976)
-- Name: cmcard_otherlanguage cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3604 (class 2606 OID 32981)
-- Name: cmcard_otherprinting cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3605 (class 2606 OID 32991)
-- Name: cmcard_subtype cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3607 (class 2606 OID 32996)
-- Name: cmcard_supertype cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3609 (class 2606 OID 33001)
-- Name: cmcard_variation cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3610 (class 2606 OID 33006)
-- Name: cmcardprice cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3611 (class 2606 OID 33011)
-- Name: cmcardstatistics cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardstatistics
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3594 (class 2606 OID 33016)
-- Name: cmcard_component_part cmcard_part_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_part_fkey FOREIGN KEY (cmcard_part) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- TOC entry 3606 (class 2606 OID 33021)
-- Name: cmcard_subtype cmcardtype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcardtype_fkey FOREIGN KEY (cmcardtype) REFERENCES public.cmcardtype(name);


--
-- TOC entry 3608 (class 2606 OID 33026)
-- Name: cmcard_supertype cmcardtype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcardtype_fkey FOREIGN KEY (cmcardtype) REFERENCES public.cmcardtype(name);


--
-- TOC entry 3612 (class 2606 OID 33031)
-- Name: cmcardtype cmcardtype_parent; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardtype
    ADD CONSTRAINT cmcardtype_parent FOREIGN KEY (cmcardtype_parent) REFERENCES public.cmcardtype(name) NOT VALID;


--
-- TOC entry 3588 (class 2606 OID 33036)
-- Name: cmcard_color cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- TOC entry 3590 (class 2606 OID 33041)
-- Name: cmcard_coloridentity cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- TOC entry 3592 (class 2606 OID 33046)
-- Name: cmcard_colorindicator cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- TOC entry 3595 (class 2606 OID 33051)
-- Name: cmcard_component_part cmcomponent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcomponent_fkey FOREIGN KEY (cmcomponent) REFERENCES public.cmcomponent(name);


--
-- TOC entry 3599 (class 2606 OID 33056)
-- Name: cmcard_format_legality cmformat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmformat_fkey FOREIGN KEY (cmformat) REFERENCES public.cmformat(name);


--
-- TOC entry 3581 (class 2606 OID 33061)
-- Name: cmcard cmframe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmframe_fkey FOREIGN KEY (cmframe) REFERENCES public.cmframe(name) NOT VALID;


--
-- TOC entry 3602 (class 2606 OID 33066)
-- Name: cmcard_frameeffect cmframeeffect_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmframeeffect_fkey FOREIGN KEY (cmframeeffect) REFERENCES public.cmframeeffect(id) NOT VALID;


--
-- TOC entry 3582 (class 2606 OID 33071)
-- Name: cmcard cmlanguage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmlanguage_fkey FOREIGN KEY (cmlanguage) REFERENCES public.cmlanguage(code) NOT VALID;


--
-- TOC entry 3617 (class 2606 OID 33076)
-- Name: cmset_language cmlanguage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmlanguage_fkey FOREIGN KEY (cmlanguage) REFERENCES public.cmlanguage(code);


--
-- TOC entry 3583 (class 2606 OID 33081)
-- Name: cmcard cmlayout_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmlayout_fkey FOREIGN KEY (cmlayout) REFERENCES public.cmlayout(name) NOT VALID;


--
-- TOC entry 3600 (class 2606 OID 33086)
-- Name: cmcard_format_legality cmlegality_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmlegality_fkey FOREIGN KEY (cmlegality) REFERENCES public.cmlegality(name);


--
-- TOC entry 3584 (class 2606 OID 33091)
-- Name: cmcard cmrarity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmrarity_fkey FOREIGN KEY (cmrarity) REFERENCES public.cmrarity(name) NOT VALID;


--
-- TOC entry 3613 (class 2606 OID 33096)
-- Name: cmrule cmrule_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrule
    ADD CONSTRAINT cmrule_parent_fkey FOREIGN KEY (cmrule_parent) REFERENCES public.cmrule(id) NOT VALID;


--
-- TOC entry 3585 (class 2606 OID 33101)
-- Name: cmcard cmset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmset_fkey FOREIGN KEY (cmset) REFERENCES public.cmset(code) NOT VALID;


--
-- TOC entry 3618 (class 2606 OID 33106)
-- Name: cmset_language cmset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_fkey FOREIGN KEY (cmset) REFERENCES public.cmset(code);


--
-- TOC entry 3614 (class 2606 OID 33111)
-- Name: cmset cmset_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmset_parent_fkey FOREIGN KEY (cmset_parent) REFERENCES public.cmset(code) NOT VALID;


--
-- TOC entry 3615 (class 2606 OID 33116)
-- Name: cmset cmsetblock_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmsetblock_fkey FOREIGN KEY (cmsetblock) REFERENCES public.cmsetblock(code) NOT VALID;


--
-- TOC entry 3616 (class 2606 OID 33121)
-- Name: cmset cmsettype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmsettype_fkey FOREIGN KEY (cmsettype) REFERENCES public.cmsettype(name) NOT VALID;


--
-- TOC entry 3586 (class 2606 OID 33136)
-- Name: cmcard cmwatermark_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmwatermark_fkey FOREIGN KEY (cmwatermark) REFERENCES public.cmwatermark(name) NOT VALID;


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA public TO managuide_dev;


--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 255
-- Name: FUNCTION searchrules(character varying); Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON FUNCTION public.searchrules(character varying) TO managuide_dev;


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 261
-- Name: FUNCTION selectrules(integer); Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON FUNCTION public.selectrules(integer) TO managuide_dev;


--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE cmartist; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmartist TO managuide_dev;


--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE cmcard; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard TO managuide_dev;


--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE cmcard_color; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_color TO managuide_dev;


--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE cmcard_coloridentity; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_coloridentity TO managuide_dev;


--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE cmcard_colorindicator; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_colorindicator TO managuide_dev;


--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE cmcard_component_part; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_component_part TO managuide_dev;


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE cmcard_face; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_face TO managuide_dev;


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE cmcard_format_legality; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_format_legality TO managuide_dev;


--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 210
-- Name: SEQUENCE cmcard_format_legality_id_seq; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON SEQUENCE public.cmcard_format_legality_id_seq TO managuide_dev;


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE cmcard_frameeffect; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_frameeffect TO managuide_dev;


--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE cmcard_otherlanguage; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_otherlanguage TO managuide_dev;


--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE cmcard_otherprinting; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_otherprinting TO managuide_dev;


--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE cmcard_subtype; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_subtype TO managuide_dev;


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE cmcard_supertype; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_supertype TO managuide_dev;


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE cmcard_variation; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcard_variation TO managuide_dev;


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE cmcardprice; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcardprice TO managuide_dev;


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 218
-- Name: SEQUENCE cmcardprice_id_seq; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON SEQUENCE public.cmcardprice_id_seq TO managuide_dev;


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE cmcardstatistics; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcardstatistics TO managuide_dev;


--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE cmcardstatistics_id_seq; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON SEQUENCE public.cmcardstatistics_id_seq TO managuide_dev;


--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE cmcardtype; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcardtype TO managuide_dev;


--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE cmcolor; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcolor TO managuide_dev;


--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE cmcomponent; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmcomponent TO managuide_dev;


--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE cmformat; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmformat TO managuide_dev;


--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE cmframe; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmframe TO managuide_dev;


--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE cmframeeffect; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmframeeffect TO managuide_dev;


--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE cmlanguage; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmlanguage TO managuide_dev;


--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE cmlayout; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmlayout TO managuide_dev;


--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE cmlegality; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmlegality TO managuide_dev;


--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE cmrarity; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmrarity TO managuide_dev;


--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE cmrule; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmrule TO managuide_dev;


--
-- TOC entry 3786 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE cmruling; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmruling TO managuide_dev;


--
-- TOC entry 3788 (class 0 OID 0)
-- Dependencies: 233
-- Name: SEQUENCE cmruling_id_seq; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON SEQUENCE public.cmruling_id_seq TO managuide_dev;


--
-- TOC entry 3789 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE cmset; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmset TO managuide_dev;


--
-- TOC entry 3790 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE cmset_language; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmset_language TO managuide_dev;


--
-- TOC entry 3791 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE cmsetblock; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmsetblock TO managuide_dev;


--
-- TOC entry 3792 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE cmsettype; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmsettype TO managuide_dev;


--
-- TOC entry 3793 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE cmwatermark; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.cmwatermark TO managuide_dev;


--
-- TOC entry 3794 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE serverupdate; Type: ACL; Schema: public; Owner: managuide
--

GRANT ALL ON TABLE public.serverupdate TO managuide_dev;


--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 240
-- Name: SEQUENCE serverupdate_id_seq; Type: ACL; Schema: public; Owner: managuide
--

GRANT SELECT ON SEQUENCE public.serverupdate_id_seq TO managuide_dev;


--
-- TOC entry 1897 (class 826 OID 33141)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO managuide_dev;


-- Completed on 2022-05-25 12:28:17 EDT

--
-- PostgreSQL database dump complete
--

