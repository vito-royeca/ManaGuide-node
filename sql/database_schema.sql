--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

-- Started on 2020-01-18 18:45:43 EST

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
-- TOC entry 244 (class 1255 OID 19736)
-- Name: createorupdateartist(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdateartist(character varying, character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _first_name ALIAS FOR $2;
    _last_name ALIAS FOR $3;
    _name_section ALIAS FOR $4;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmartist WHERE name = _name;

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
        UPDATE cmartist SET
            name = _name,
            first_name = _first_name,
            last_name = _last_name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdateartist(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 268 (class 1255 OID 25626)
-- Name: createorupdatecard(character varying, double precision, character varying, jsonb, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecard(character varying, double precision, character varying, jsonb, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
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
    _my_number_order ALIAS FOR $16;
    _name ALIAS FOR $17;
    _oracle_text ALIAS FOR $18;
    _power ALIAS FOR $19;
    _printed_name ALIAS FOR $20;
    _printed_text ALIAS FOR $21;
    _toughness ALIAS FOR $22;
    _arena_id ALIAS FOR $23;
    _mtgo_id ALIAS FOR $24;
    _tcgplayer_id ALIAS FOR $25;
    _hand_modifier ALIAS FOR $26;
    _life_modifier ALIAS FOR $27;
    _is_booster ALIAS FOR $28;
    _is_digital ALIAS FOR $29;
    _is_promo ALIAS FOR $30;
    _released_at ALIAS FOR $31;
    _is_textless ALIAS FOR $32;
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
    _cmwatermark ALIAS FOR $44;
    _cmframe ALIAS FOR $45;
    _cmframeeffects ALIAS FOR $46;
    _cmcolors ALIAS FOR $47;
    _cmcolor_identities ALIAS FOR $48;
    _cmcolor_indicators ALIAS FOR $49;
    _cmlegalities ALIAS FOR $50;
    _type_line ALIAS FOR $51;
    _printed_type_line ALIAS FOR $52;
    _cmcardtype_subtypes ALIAS FOR $53;
    _cmcardtype_supertypes ALIAS FOR $54;
    _face_order ALIAS FOR $55;

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
    IF lower(_my_name_section) = 'null' THEN
        _my_name_section := NULL;
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
    IF lower(_card_back_id) = 'null' THEN
        _card_back_id := NULL;
    END IF;
    IF lower(_oracle_id) = 'null' THEN
        _oracle_id := NULL;
    END IF;
    IF lower(_illustration_id) = 'null' THEN
        _illustration_id := NULL;
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
            id,
            card_back_id,
            oracle_id,
            illustration_id,
            cmartist,
            cmset,
            cmrarity,
            cmlanguage,
            cmlayout,
            cmwatermark,
            cmframe,
            type_line,
            printed_type_line,
            face_order)
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
            _my_number_order,
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
            _id,
            _card_back_id,
            _oracle_id,
            _illustration_id,
            _cmartist,
            _cmset,
            _cmrarity,
            _cmlanguage,
            _cmlayout,
            _cmwatermark,
            _cmframe,
            _type_line,
            _printed_type_line,
            _face_order);
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
            my_number_order = _my_number_order,
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
            id = _id,
            card_back_id = _card_back_id,
            oracle_id = _oracle_id,
            illustration_id = _illustration_id,
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
            date_updated = now()
        WHERE id = _id;
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
    DELETE FROM cmcard_frameeffect WHERE cmcard = _id;
    IF _cmframeeffects IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmframeeffects LOOP
            INSERT INTO cmcard_frameeffect(
                cmcard,
                cmframeeffect
            ) VALUES (
                _id,
                pkey
            );
        END LOOP;
    END IF;

    -- colors
    DELETE FROM cmcard_color WHERE cmcard = _id;
    IF _cmcolors IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolors LOOP
            INSERT INTO cmcard_color(
                cmcard,
                cmcolor
            ) VALUES (
                _id,
                pkey
            );
        END LOOP;
    END IF;

    -- color identities
    DELETE FROM cmcard_coloridentity WHERE cmcard = _id;
    IF _cmcolor_identities IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolor_identities LOOP
            INSERT INTO cmcard_coloridentity(
                cmcard,
                cmcolor
            ) VALUES (
                _id,
                pkey
            );
        END LOOP;
    END IF;

    -- color indicators
    DELETE FROM cmcard_colorindicator WHERE cmcard = _id;
    IF _cmcolor_indicators IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcolor_indicators LOOP
            INSERT INTO cmcard_colorindicator(
                cmcard,
                cmcolor
            ) VALUES (
                _id,
                pkey
            );
        END LOOP;
    END IF;

    -- legalities
    DELETE FROM cmcard_format_legality WHERE cmcard = _id;
    IF _cmlegalities IS NOT NULL THEN
        FOR pkey2, pkey3 IN SELECT * FROM jsonb_each_text(_cmlegalities) LOOP
            INSERT INTO cmcard_format_legality(
                cmcard,
                cmformat,
                cmlegality
            ) VALUES (
                _id,
                pkey2,
                pkey3
            );
        END LOOP;
    END IF;

    -- subtypes
    DELETE FROM cmcard_subtype WHERE cmcard = _id;
    IF _cmcardtype_subtypes IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcardtype_subtypes LOOP
            INSERT INTO cmcard_subtype(
                cmcard,
                cmcardtype
            ) VALUES (
                _id,
                pkey
            );
        END LOOP;
    END IF;

    -- supertypes
    DELETE FROM cmcard_supertype WHERE cmcard = _id;
    IF _cmcardtype_subtypes IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmcardtype_supertypes LOOP
            INSERT INTO cmcard_supertype(
                cmcard,
                cmcardtype
            ) VALUES (
                _id,
                pkey
            );
        END LOOP;
    END IF;

    RETURN _id;
END;
$_$;


ALTER FUNCTION public.createorupdatecard(character varying, double precision, character varying, jsonb, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer) OWNER TO managuide;

--
-- TOC entry 278 (class 1255 OID 25582)
-- Name: createorupdatecardfaces(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecardfaces(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcard_face ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT cmcard INTO pkey FROM cmcard_face
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
        UPDATE cmcard_face SET
            cmcard = _cmcard,
            cmcard_face = _cmcard_face,
            date_updated = now()
        WHERE cmcard = _cmcard
            AND cmcard_face = _cmcard_face;
    END IF;

    RETURN _cmcard;
END;
$_$;


ALTER FUNCTION public.createorupdatecardfaces(character varying, character varying) OWNER TO managuide;

--
-- TOC entry 269 (class 1255 OID 21081)
-- Name: createorupdatecardotherlanguages(); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecardotherlanguages() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    currentRow integer := 0;
    rows integer := 0;
    row RECORD;
    row2 RECORD;
BEGIN
    DELETE FROM cmcard_otherlanguage;

    SELECT count(*) INTO rows FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.id NOT IN (SELECT cmcard_part FROM cmcard_component_part);

    RAISE NOTICE 'other languages: %/%', currentRow, rows;
    FOR row IN SELECT id, c.name, cmset, cmlanguage FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.id NOT IN (SELECT cmcard_part FROM cmcard_component_part)
        ORDER BY s.release_date, c.name
    LOOP
        FOR row2 IN SELECT id FROM cmcard c
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                s.code = row.cmset AND
			    c.name = row.name AND
			    cmlanguage <> row.cmlanguage
			ORDER BY s.release_date, c.name
        LOOP
            INSERT INTO cmcard_otherlanguage(
                cmcard,
                cmcard_otherlanguage)
            VALUES(
                row.id,
                row2.id);
        END LOOP;

		currentRow := currentRow + 1;

		IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'other languages: %/%', currentRow, rows;
		END IF;
    END LOOP;

    RETURN rows;
END;
$$;


ALTER FUNCTION public.createorupdatecardotherlanguages() OWNER TO managuide;

--
-- TOC entry 280 (class 1255 OID 21082)
-- Name: createorupdatecardotherprintings(); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecardotherprintings() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    currentRow integer := 0;
    rows integer := 0;
    row RECORD;
    row2 RECORD;
BEGIN
    DELETE FROM cmcard_otherprinting;

    SELECT count(*) INTO rows FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.id NOT IN (SELECT cmcard_part FROM cmcard_component_part);

    RAISE NOTICE 'other printings: %/%', currentRow, rows;
    FOR row IN SELECT id, c.name, cmset, cmlanguage FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.id NOT IN (SELECT cmcard_part FROM cmcard_component_part)
        ORDER BY s.release_date, c.name
    LOOP
        FOR row2 IN SELECT id FROM cmcard c
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                id <> row.id AND
                cmset <> row.cmset AND
			    c.name = row.name AND
			    cmlanguage = row.cmlanguage
			ORDER BY s.release_date, c.name
        LOOP
            INSERT INTO cmcard_otherprinting(
                cmcard,
                cmcard_otherprinting)
            VALUES(
                row.id,
                row2.id);
        END LOOP;

		currentRow := currentRow + 1;

		IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'other printings: %/%', currentRow, rows;
		END IF;
    END LOOP;

    RETURN rows;
END;
$$;


ALTER FUNCTION public.createorupdatecardotherprintings() OWNER TO managuide;

--
-- TOC entry 281 (class 1255 OID 22178)
-- Name: createorupdatecardparts(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecardparts(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _cmcard ALIAS FOR $1;
    _cmcomponent ALIAS FOR $2;
    _cmcard_part ALIAS FOR $3;

    pkey character varying;
BEGIN
    SELECT cmcard INTO pkey FROM cmcard_component_part
    WHERE cmcard = _cmcard
      AND cmcomponent = _cmcomponent
      AND cmcard_part = _cmcard_part;

    IF NOT FOUND THEN
        INSERT INTO cmcard_component_part(
            cmcard,
            cmcomponent,
            cmcard_part)
        VALUES(
            _cmcard,
            _cmcomponent,
            _cmcard_part);
    ELSE
        UPDATE cmcard_component_part SET
            cmcard = _cmcard,
            cmcomponent = _cmcomponent,
            cmcard_part = _cmcard_part,
            date_updated = now()
        WHERE cmcard = _cmcard
          AND cmcomponent = _cmcomponent
          AND cmcard_part = _cmcard_part;
    END IF;

    RETURN _cmcard;
END;
$_$;


ALTER FUNCTION public.createorupdatecardparts(character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 279 (class 1255 OID 23678)
-- Name: createorupdatecardprice(double precision, double precision, double precision, double precision, double precision, integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecardprice(double precision, double precision, double precision, double precision, double precision, integer, character varying, boolean) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _low ALIAS FOR $1;
    _median ALIAS FOR $2;
    _high ALIAS FOR $3;
    _market ALIAS FOR $4;
    _direct_low ALIAS FOR $5;
    _tcgplayer_id ALIAS FOR $6;
    _cmstore ALIAS FOR $7;
    _is_foil ALIAS FOR $8;

    _pkey character varying;
    _cmcard character varying;
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

    SELECT id INTO _cmcard FROM cmcard WHERE tcgplayer_id = _tcgplayer_id;

    IF FOUND THEN
        SELECT id INTO _pkey FROM cmcardprice
            WHERE cmcard = _cmcard AND
                cmstore = _cmstore AND
                is_foil = _is_foil;

        IF NOT FOUND THEN
            INSERT INTO cmcardprice(
                low,
                median,
                high,
                market,
                direct_low,
                cmcard,
                cmstore,
                is_foil)
            VALUES(
                _low,
                _median,
                _high,
                _market,
                _direct_low,
                _cmcard,
                _cmstore,
                _is_foil);
        ELSE
            UPDATE cmcardprice SET
                low = _low,
                median = _median,
                high = _high,
                market = _market,
                direct_low = _direct_low,
                cmcard = _cmcard,
                cmstore = _cmstore,
                is_foil = _is_foil,
                date_updated = now()
            WHERE cmcard = _cmcard AND
                cmstore = _cmstore AND
                is_foil = _is_foil;
        END IF;
    END IF;

    RETURN _pkey;
END;
$_$;


ALTER FUNCTION public.createorupdatecardprice(double precision, double precision, double precision, double precision, double precision, integer, character varying, boolean) OWNER TO managuide;

--
-- TOC entry 275 (class 1255 OID 19740)
-- Name: createorupdatecardtype(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecardtype(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _cmcardtype_parent ALIAS FOR $3;

    pkey character varying;
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
        SELECT createOrUpdateCardType(_cmcardtype_parent, LEFT(_cmcardtype_parent, 1), NULL) INTO pkey;
    END IF;

    SELECT name INTO pkey FROM cmcardtype WHERE name = _name;

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
        UPDATE cmcardtype SET
            name = _name,
            name_section = _name_section,
            cmcardtype_parent = _cmcardtype_parent,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdatecardtype(character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 263 (class 1255 OID 21075)
-- Name: createorupdatecardvariations(); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecardvariations() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    currentRow integer := 0;
    rows integer := 0;
    row RECORD;
    row2 RECORD;
BEGIN
    DELETE FROM cmcard_variation;

	SELECT count(*) INTO rows FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.id NOT IN (SELECT cmcard_part FROM cmcard_component_part);

    RAISE NOTICE 'variations: %/%', currentRow, rows;
    FOR row IN SELECT id, c.name, cmset, cmlanguage FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.id NOT IN (SELECT cmcard_part FROM cmcard_component_part)
        ORDER BY s.release_date, c.name
    LOOP
        FOR row2 IN SELECT id FROM cmcard c
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                id <> row.id AND
                cmset = row.cmset AND
			    c.name = row.name AND
			    cmlanguage = row.cmlanguage
			ORDER BY s.release_date, c.name
        LOOP
            INSERT INTO cmcard_variation(
                cmcard,
                cmcard_variation)
            VALUES(
                row.id,
                row2.id);
        END LOOP;

		currentRow := currentRow + 1;

		IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'variations: %/%', currentRow, rows;
		END IF;
    END LOOP;

    RETURN rows;
END;
$$;


ALTER FUNCTION public.createorupdatecardvariations() OWNER TO managuide;

--
-- TOC entry 257 (class 1255 OID 19741)
-- Name: createorupdatecolor(character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecolor(character varying, character varying, character varying, boolean) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _symbol ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
    _is_mana_color ALIAS FOR $4;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmcolor WHERE name = _name;

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
        UPDATE cmcolor SET
            symbol = _symbol,
            name = _name,
            name_section = _name_section,
            is_mana_color = _is_mana_color,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdatecolor(character varying, character varying, character varying, boolean) OWNER TO managuide;

--
-- TOC entry 258 (class 1255 OID 19742)
-- Name: createorupdatecomponent(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecomponent(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmcomponent WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmcomponent(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmcomponent SET
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdatecomponent(character varying, character varying) OWNER TO managuide;

--
-- TOC entry 259 (class 1255 OID 19743)
-- Name: createorupdateformat(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdateformat(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmformat WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmformat(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmformat SET
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdateformat(character varying, character varying) OWNER TO managuide;

--
-- TOC entry 260 (class 1255 OID 19744)
-- Name: createorupdateframe(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdateframe(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _description ALIAS FOR $3;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmframe WHERE name = _name;

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
        UPDATE cmframe SET
            name = _name,
            name_section = _name_section,
            description = _description,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdateframe(character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 282 (class 1255 OID 19745)
-- Name: createorupdateframeeffect(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdateframeeffect(character varying, character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _id ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;
    _description ALIAS FOR $4;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmframeeffect WHERE name = _name;

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
        UPDATE cmframeeffect SET
            id = _id,
            name = _name,
            name_section = _name_section,
            description = _description,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdateframeeffect(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 272 (class 1255 OID 19746)
-- Name: createorupdatelanguage(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatelanguage(character varying, character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    _display_code ALIAS FOR $2;
    _name ALIAS FOR $3;
    _name_section ALIAS FOR $4;

    pkey character varying;
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

    SELECT code INTO pkey FROM cmlanguage WHERE code = _code;

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
        UPDATE cmlanguage SET
            code = _code,
            display_code = _display_code,
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE code = _code;
    END IF;

    RETURN _code;
END;
$_$;


ALTER FUNCTION public.createorupdatelanguage(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 271 (class 1255 OID 19747)
-- Name: createorupdatelayout(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatelayout(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;
    _description ALIAS FOR $3;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmlayout WHERE name = _name;

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
        UPDATE cmlayout SET
            name = _name,
            name_section = _name_section,
            description = _description,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdatelayout(character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 273 (class 1255 OID 19748)
-- Name: createorupdatelegality(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatelegality(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmlegality WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmlegality(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmlegality SET
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdatelegality(character varying, character varying) OWNER TO managuide;

--
-- TOC entry 264 (class 1255 OID 19749)
-- Name: createorupdaterarity(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdaterarity(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmrarity WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmrarity(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmrarity SET
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdaterarity(character varying, character varying) OWNER TO managuide;

--
-- TOC entry 277 (class 1255 OID 23292)
-- Name: createorupdaterule(character varying, character varying, character varying, double precision, integer, integer); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdaterule(character varying, character varying, character varying, double precision, integer, integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _term ALIAS FOR $1;
    _term_section ALIAS FOR $2;
    _definition ALIAS FOR $3;
    _order ALIAS FOR $4;
    _cmrule_parent ALIAS FOR $5;
    _id ALIAS FOR $6;

    pkey character varying;
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

    SELECT id INTO pkey FROM cmrule
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

    RETURN pkey;
END;
$_$;


ALTER FUNCTION public.createorupdaterule(character varying, character varying, character varying, double precision, integer, integer) OWNER TO managuide;

--
-- TOC entry 270 (class 1255 OID 19750)
-- Name: createorupdateruling(character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdateruling(character varying, character varying, date) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _oracle_id ALIAS FOR $1;
    _text ALIAS FOR $2;
    _date_published ALIAS FOR $3;

    pkey character varying;
BEGIN
        INSERT INTO cmruling(
            oracle_id,
            text,
            date_published)
        VALUES(
            _oracle_id,
            _text,
            _date_published);

    RETURN _oracle_id;
END;
$_$;


ALTER FUNCTION public.createorupdateruling(character varying, character varying, date) OWNER TO managuide;

--
-- TOC entry 265 (class 1255 OID 19751)
-- Name: createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _card_count ALIAS FOR $1;
    _code ALIAS FOR $2;
    _is_foil_only ALIAS FOR $3;
    _is_online_only ALIAS FOR $4;
    _mtgo_code ALIAS FOR $5;
    _my_keyrune_code ALIAS FOR $6;
    _my_name_section ALIAS FOR $7;
    _my_year_section ALIAS FOR $8;
    _name ALIAS FOR $9;
    _release_date ALIAS FOR $10;
    _tcgplayer_id ALIAS FOR $11;
    _cmsetblock ALIAS FOR $12;
    _cmsettype ALIAS FOR $13;
    _cmset_parent ALIAS FOR $14;

    pkey character varying;
    parent_row cmset%rowtype;
BEGIN
    -- check for nulls
    IF lower(_mtgo_code) = 'null' THEN
        _mtgo_code := NULL;
    END IF;
    IF lower(_my_keyrune_code) = 'null' THEN
        _my_keyrune_code := NULL;
    END IF;
    IF lower(_my_name_section) = 'null' THEN
        _my_name_section := NULL;
    END IF;
    IF lower(_my_year_section) = 'null' THEN
        _my_year_section := NULL;
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

    SELECT code INTO pkey FROM cmset WHERE code = _code;

    IF NOT FOUND THEN
        INSERT INTO cmset(
            card_count,
            code,
            is_foil_only,
            is_online_only,
            mtgo_code,
            my_keyrune_code,
            my_name_section,
            my_year_section,
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
            _mtgo_code,
            _my_keyrune_code,
            _my_name_section,
            _my_year_section,
            _name,
            _release_date,
            _tcgplayer_id,
            _cmsetblock,
            _cmsettype);
    ELSE
        IF _cmset_parent IS NOT NULL THEN
            SELECT * INTO parent_row FROM cmset WHERE code = _cmset_parent;

            UPDATE cmset SET
                card_count = _card_count,
                is_foil_only = _is_foil_only,
                is_online_only = _is_online_only,
                mtgo_code = _mtgo_code,
                my_keyrune_code = parent_row.my_keyrune_code,
                my_name_section = parent_row.my_name_section,
                my_year_section = parent_row.my_year_section,
                name = _name,
                release_date = parent_row.release_date,
                tcgplayer_id = _tcgplayer_id,
                cmsetblock = _cmsetblock,
                cmsettype = _cmsettype,
                cmset_parent = _cmset_parent,
                date_updated = now()
            WHERE code = _code;
        ELSE
            UPDATE cmset SET
                card_count = _card_count,
                is_foil_only = _is_foil_only,
                is_online_only = _is_online_only,
                mtgo_code = _mtgo_code,
                my_keyrune_code = _my_keyrune_code,
                my_name_section = _my_name_section,
                my_year_section = _my_year_section,
                name = _name,
                release_date = _release_date,
                tcgplayer_id = _tcgplayer_id,
                cmsetblock = _cmsetblock,
                cmsettype = _cmsettype
            WHERE code = _code;

            UPDATE cmset SET
                my_keyrune_code = _my_keyrune_code,
                my_name_section = _my_name_section,
                my_year_section = _my_year_section
            WHERE cmset_parent = _code;
        END IF;
    END IF;

	RETURN _code;
END;
$_$;


ALTER FUNCTION public.createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 276 (class 1255 OID 19752)
-- Name: createorupdatesetblock(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatesetblock(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    _name ALIAS FOR $2;
    _name_section ALIAS FOR $3;

    pkey character varying;
BEGIN
    SELECT code INTO pkey FROM cmsetblock WHERE code = _code;

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
        UPDATE cmsetblock SET
            code = _code,
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE code = _code;
    END IF;

    RETURN _code;
END;
$_$;


ALTER FUNCTION public.createorupdatesetblock(character varying, character varying, character varying) OWNER TO managuide;

--
-- TOC entry 261 (class 1255 OID 19753)
-- Name: createorupdatesettype(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatesettype(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmsettype WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmsettype(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmsettype SET
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdatesettype(character varying, character varying) OWNER TO managuide;

--
-- TOC entry 274 (class 1255 OID 23673)
-- Name: createorupdatestore(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatestore(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmstore WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmstore(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmstore SET
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdatestore(character varying, character varying) OWNER TO managuide;

--
-- TOC entry 262 (class 1255 OID 19754)
-- Name: createorupdatewatermark(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatewatermark(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    pkey character varying;
BEGIN
    SELECT name INTO pkey FROM cmwatermark WHERE name = _name;

    IF NOT FOUND THEN
        INSERT INTO cmwatermark(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        UPDATE cmwatermark SET
            name = _name,
            name_section = _name_section,
            date_updated = now()
        WHERE name = _name;
    END IF;

    RETURN _name;
END;
$_$;


ALTER FUNCTION public.createorupdatewatermark(character varying, character varying) OWNER TO managuide;

--
-- TOC entry 285 (class 1255 OID 27939)
-- Name: searchcards(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.searchcards(character varying, character varying, character varying) RETURNS TABLE(id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, my_name_section character varying, my_number_order double precision, name character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, image_uris jsonb, set json, rarity json, language json, prices json[], faces json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _query ALIAS FOR $1;
    _sortedBy ALIAS FOR $2;
    _orderBy ALIAS FOR $3;
    command character varying;
BEGIN
    IF lower(_sortedBy) = 'set_name' THEN
        _sortedBy = 's.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
	IF lower(_sortedBy) = 'set_release' THEN
        _sortedBy = 's.release_date ' || _orderBy || ', s.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'collector_number' THEN
        _sortedBy = 'c.my_number_order ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'name' THEN
        _sortedBy = 'c.name';
    END IF;
    IF lower(_sortedBy) = 'cmc' THEN
        _sortedBy = 'c.cmc ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'type' THEN
        _sortedBy = 'c.type_line ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'rarity' THEN
        _sortedBy = 'r.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;

    command := 'SELECT
                    id,
                    collector_number,
                    face_order,
                    loyalty,
                    mana_cost,
                    c.my_name_section,
                    my_number_order,
                    c.name,
                    printed_name,
                    printed_type_line,
                    type_line,
	                power,
                    toughness,
                    image_uris,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name
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
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                        ) x
                    ) AS language,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_created
                            FROM cmcardprice v
                            WHERE v.cmcard = c.id
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                   ', array(
                       SELECT row_to_json(x) FROM (' ||
                           command ||
                           'FROM cmcard c left join cmcard_face w on w.cmcard_face = c.id
                           WHERE w.cmcard = c.id
                        ) x
                   ) AS faces ';

    _query := lower(_query);
    command := command || 'FROM cmcard c LEFT JOIN cmset s ON c.cmset = s.code ';
    command := command || 'LEFT JOIN cmrarity r ON c.cmrarity = r.name ';
    command := command || 'WHERE c.cmlanguage = ''en'' ';
    command := command || 'AND c.id NOT IN(select cmcard_face from cmcard_face) ';
    command := command || 'AND lower(c.name) LIKE ''%' || _query || '%'' ';
    command := command || 'GROUP BY c.id,
                    c.collector_number,
                    c.face_order,
                    c.loyalty,
                    c.mana_cost,
                    c.my_name_section,
                    c.my_number_order,
                    c.name,
                    c.printed_name,
                    c.printed_type_line,
                    c.type_line,
	                c.power,
                    c.toughness,
                    r.name,
                    s.release_date,
					s.name ';
    command := command || 'ORDER BY ' || _sortedBy || '';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.searchcards(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 25649)
-- Name: selectcard(character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.selectcard(character varying) RETURNS TABLE(collector_number character varying, cmc double precision, face_order integer, flavor_text character varying, is_foil boolean, is_full_art boolean, is_highres_image boolean, is_nonfoil boolean, is_oversized boolean, is_reserved boolean, is_story_spotlight boolean, loyalty character varying, mana_cost character varying, my_name_section character varying, my_number_order double precision, name character varying, oracle_text character varying, power character varying, printed_name character varying, printed_text character varying, toughness character varying, arena_id integer, mtgo_id integer, tcgplayer_id integer, hand_modifier character varying, life_modifier character varying, is_booster boolean, is_digital boolean, is_promo boolean, released_at date, is_textless boolean, mtgo_foil_id integer, is_reprint boolean, id character varying, card_back_id character varying, oracle_id character varying, illustration_id character varying, printed_type_line character varying, type_line character varying, image_uris jsonb, multiverse_ids integer[], set json, rarity json, language json, layout json, watermark json, frame json, artist json, colors json[], color_identities json[], color_indicators json[], component_parts json[], faces json[], other_languages json[], other_printings json[], variations json[], format_legalities json[], frame_effects json[], subtypes json[], supertypes json[], prices json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _id ALIAS FOR $1;
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
                    c.id,
                    c.card_back_id,
                    c.oracle_id,
                    c.illustration_id,
                    c.printed_type_line,
                    c.type_line,
                    c.image_uris,
                    c.multiverse_ids,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.code, v.name
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
                    ) AS color_indicators,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name, w.name_section
                            FROM cmcard_component_part v left join cmcomponent w on v.cmcomponent = w.name
                            WHERE v.cmcard = c.id
                        ) x
                    ) AS component_parts ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command ||
                            'FROM cmcard c left join cmcard_face w on w.cmcard_face = c.id
                            WHERE w.cmcard = ''' || _id || '''' ||
                        ') x
                    ) AS faces ';

    -- Other Languages
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command ||
                            'FROM cmcard c left join cmlanguage w on w.code = cmlanguage
                            left join cmcard_otherlanguage x on x.cmcard_otherlanguage = c.id
                            left join cmset y on y.code = c.cmset
                            WHERE x.cmcard = ''' || _id || '''' ||
                            ' order by y.release_date desc
                        ) x
                    ) AS other_languages ';

    -- Other Printings
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command ||
                            'FROM cmcard c
                            left join cmcard_otherprinting w on w.cmcard_otherprinting = c.id
                            left join cmset y on y.code = c.cmset
                            WHERE w.cmcard = ''' || _id || '''' ||
                            ' order by y.release_date desc
                        ) x
                    ) AS other_printings ';

    -- Variations
    command := command ||
                ', array(
                    SELECT row_to_json(x) FROM (' ||
                        command ||
                        'FROM cmcard c left join cmcard_variation w on w.cmcard_variation = c.id
                        left join cmset y on y.code = c.cmset
                        WHERE w.cmcard = ''' || _id || '''' ||
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
                        WHERE v.cmcard = c.id
                    ) x
                ) AS format_legalities ';

    -- Frame Effects
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.id, w.name, w.name_section, w.description
                        FROM cmcard_frameeffect v left join cmframeeffect w on v.cmframeeffect = w.id
                        WHERE v.cmcard = c.id
                    ) x
                ) AS frame_effects ';

    -- Subtypes
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.name, w.name_section, w.cmcardtype_parent AS parent
                        FROM cmcard_subtype v left join cmcardtype w on v.cmcardtype = w.name
                        WHERE v.cmcard = c.id
                    ) x
                ) AS subtypes ';

    -- Supertypes
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.name, w.name_section, w.cmcardtype_parent AS parent
                        FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                        WHERE v.cmcard = c.id
                    ) x
                ) AS supertypes ';

    -- Prices
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_created
                        FROM cmcardprice v
                        WHERE v.cmcard = c.id
                    ) x
                ) AS prices ';

    command := command || 'FROM cmcard c WHERE c.id = ''' || _id || '''';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectcard(character varying) OWNER TO managuide;

--
-- TOC entry 286 (class 1255 OID 27938)
-- Name: selectcards(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectcards(character varying, character varying, character varying, character varying) RETURNS TABLE(id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, my_name_section character varying, my_number_order double precision, name character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, image_uris jsonb, set json, rarity json, language json, prices json[], faces json[])
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
        _sortedBy = 's.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
	IF lower(_sortedBy) = 'set_release' THEN
        _sortedBy = 's.release_date ' || _orderBy || ', s.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'collector_number' THEN
        _sortedBy = 'c.my_number_order ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'name' THEN
        _sortedBy = 'c.name';
    END IF;
    IF lower(_sortedBy) = 'cmc' THEN
        _sortedBy = 'c.cmc ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'type' THEN
        _sortedBy = 'c.type_line ' || _orderBy || ', c.name ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'rarity' THEN
        _sortedBy = 'r.name ' || _orderBy || ', c.name ' || _orderBy;
    END IF;

    command := 'SELECT
                    id,
                    collector_number,
                    face_order,
                    loyalty,
                    mana_cost,
                    c.my_name_section,
                    my_number_order,
                    c.name,
                    printed_name,
                    printed_type_line,
                    type_line,
	                power,
                    toughness,
                    image_uris,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name
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
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                        ) x
                    ) AS language,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_created
                            FROM cmcardprice v
                            WHERE v.cmcard = c.id
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command ||
                            'FROM cmcard c left join cmcard_face w on w.cmcard_face = c.id
                            WHERE w.cmcard = c.id
                        ) x
                    ) AS faces ';

    command := command || 'FROM cmcard c LEFT JOIN cmset s ON c.cmset = s.code ';
	command := command || 'LEFT JOIN cmrarity r ON c.cmrarity = r.name ';
    command := command || 'WHERE c.cmset = ''' || _cmset || ''' ';
    command := command || 'AND c.cmlanguage = ''' || _cmlanguage || ''' ';
    command := command || 'ORDER BY ' || _sortedBy || '';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectcards(character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 27935)
-- Name: selectset(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectset(character varying, character varying, character varying, character varying) RETURNS TABLE(card_count integer, code character varying, is_foil_only boolean, is_online_only boolean, mtgo_code character varying, my_keyrune_code character varying, my_name_section character varying, my_year_section character varying, name character varying, release_date character varying, tcgplayer_id integer, set_block json, set_type json, languages json[], cards json)
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
                    mtgo_code,
                    my_keyrune_code,
                    my_name_section,
                    my_year_section,
                    name,
                    release_date,
                    tcgplayer_id,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT sb.code, sb.name, sb.name_section
                            FROM cmsetblock sb WHERE sb.code = s.cmsetblock
                        ) x
                   ) AS set_block,
                   (
                       SELECT row_to_json(x) FROM (
                            SELECT st.name, st.name_section
                            FROM cmsettype st WHERE st.name = s.cmsettype
                        ) x
                   ) AS set_type,
                   array(
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.display_code, l.name, l.name_section
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
-- TOC entry 267 (class 1255 OID 27154)
-- Name: selectsets(character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.selectsets(character varying) RETURNS TABLE(card_count integer, code character varying, is_foil_only boolean, is_online_only boolean, mtgo_code character varying, my_keyrune_code character varying, my_name_section character varying, my_year_section character varying, name character varying, release_date character varying, tcgplayer_id integer, parent json, set_block json, set_type json, languages json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    command character varying;
BEGIN
    command := 'SELECT card_count,
                    code,
                    is_foil_only,
                    is_online_only,
                    mtgo_code,
                    my_keyrune_code,
                    my_name_section,
                    my_year_section,
                    name,
                    release_date,
                    tcgplayer_id,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT p.code
                            FROM cmset p WHERE p.code = s.cmset_parent
                        ) x
                   ) AS parent,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT sb.code, sb.name, sb.name_section
                            FROM cmsetblock sb WHERE sb.code = s.cmsetblock
                        ) x
                   ) AS set_block,
                   (
                       SELECT row_to_json(x) FROM (
                            SELECT st.name, st.name_section
                            FROM cmsettype st WHERE st.name = s.cmsettype
                        ) x
                   ) AS set_type,
                   array(
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.display_code, l.name, l.name_section
                            FROM cmset_language sl left join cmlanguage l on sl.cmlanguage = l.code
                            WHERE sl.cmset = s.code
                        ) x
	               ) AS languages
            FROM cmset s';

    IF _code IS NOT NULL THEN
        command := command || ' WHERE s.code = ''' || _code || ''' ORDER BY s.name ASC';
    ELSE
        command := command || ' ORDER BY s.release_date DESC, s.name ASC';
    END IF;

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectsets(character varying) OWNER TO managuide;

--
-- TOC entry 266 (class 1255 OID 22956)
-- Name: updatesetkeyrune(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.updatesetkeyrune(character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    _my_keyrune_code ALIAS FOR $2;
BEGIN

    UPDATE cmset SET
        my_keyrune_code = _my_keyrune_code,
        date_updated = now()
    WHERE code = _code OR cmset_parent = _code;

    RETURN _code;
END;
$_$;


ALTER FUNCTION public.updatesetkeyrune(character varying, character varying) OWNER TO managuide;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 19756)
-- Name: cmartist; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmartist (
    first_name character varying,
    last_name character varying,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    name character varying NOT NULL
);


ALTER TABLE public.cmartist OWNER TO managuide;

--
-- TOC entry 203 (class 1259 OID 19763)
-- Name: cmcard; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard (
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
    name character varying NOT NULL,
    oracle_text character varying,
    power character varying,
    printed_name character varying,
    printed_text character varying,
    toughness character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
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
    id character varying NOT NULL,
    card_back_id character varying,
    oracle_id character varying,
    illustration_id character varying,
    cmset character varying,
    cmrarity character varying,
    cmlanguage character varying,
    cmlayout character varying,
    cmwatermark character varying,
    cmframe character varying,
    printed_type_line character varying,
    type_line character varying,
    my_number_order double precision
);


ALTER TABLE public.cmcard OWNER TO managuide;

--
-- TOC entry 204 (class 1259 OID 19770)
-- Name: cmcard_color; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_color (
    cmcard character varying NOT NULL,
    cmcolor character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_color OWNER TO managuide;

--
-- TOC entry 205 (class 1259 OID 19777)
-- Name: cmcard_coloridentity; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_coloridentity (
    cmcard character varying NOT NULL,
    cmcolor character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_coloridentity OWNER TO managuide;

--
-- TOC entry 206 (class 1259 OID 19784)
-- Name: cmcard_colorindicator; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_colorindicator (
    cmcard character varying NOT NULL,
    cmcolor character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_colorindicator OWNER TO managuide;

--
-- TOC entry 210 (class 1259 OID 19812)
-- Name: cmcard_component_part; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_component_part (
    cmcard character varying NOT NULL,
    cmcomponent character varying NOT NULL,
    cmcard_part character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    id integer NOT NULL
);


ALTER TABLE public.cmcard_component_part OWNER TO managuide;

--
-- TOC entry 241 (class 1259 OID 25663)
-- Name: cmcard_component_part_id_seq; Type: SEQUENCE; Schema: public; Owner: managuide
--

CREATE SEQUENCE public.cmcard_component_part_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cmcard_component_part_id_seq OWNER TO managuide;

--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 241
-- Name: cmcard_component_part_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcard_component_part_id_seq OWNED BY public.cmcard_component_part.id;


--
-- TOC entry 207 (class 1259 OID 19791)
-- Name: cmcard_face; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_face (
    cmcard character varying NOT NULL,
    cmcard_face character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_face OWNER TO managuide;

--
-- TOC entry 208 (class 1259 OID 19798)
-- Name: cmcard_format_legality; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_format_legality (
    cmcard character varying NOT NULL,
    cmformat character varying NOT NULL,
    cmlegality character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    id integer NOT NULL
);


ALTER TABLE public.cmcard_format_legality OWNER TO managuide;

--
-- TOC entry 242 (class 1259 OID 25675)
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
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 242
-- Name: cmcard_format_legality_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcard_format_legality_id_seq OWNED BY public.cmcard_format_legality.id;


--
-- TOC entry 209 (class 1259 OID 19805)
-- Name: cmcard_frameeffect; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_frameeffect (
    cmcard character varying NOT NULL,
    cmframeeffect character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_frameeffect OWNER TO managuide;

--
-- TOC entry 230 (class 1259 OID 20908)
-- Name: cmcard_otherlanguage; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_otherlanguage (
    cmcard character varying NOT NULL,
    cmcard_otherlanguage character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_otherlanguage OWNER TO managuide;

--
-- TOC entry 231 (class 1259 OID 20927)
-- Name: cmcard_otherprinting; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_otherprinting (
    cmcard character varying NOT NULL,
    cmcard_otherprinting character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_otherprinting OWNER TO managuide;

--
-- TOC entry 234 (class 1259 OID 22604)
-- Name: cmcard_store_price; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_store_price (
    normal double precision,
    foil double precision,
    cmcard character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    cmstore character varying NOT NULL
);


ALTER TABLE public.cmcard_store_price OWNER TO managuide;

--
-- TOC entry 233 (class 1259 OID 22602)
-- Name: cmcard_price_id_seq; Type: SEQUENCE; Schema: public; Owner: managuide
--

CREATE SEQUENCE public.cmcard_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cmcard_price_id_seq OWNER TO managuide;

--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 233
-- Name: cmcard_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcard_price_id_seq OWNED BY public.cmcard_store_price.id;


--
-- TOC entry 211 (class 1259 OID 19819)
-- Name: cmcard_subtype; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_subtype (
    cmcard character varying NOT NULL,
    cmcardtype character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_subtype OWNER TO managuide;

--
-- TOC entry 212 (class 1259 OID 19826)
-- Name: cmcard_supertype; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_supertype (
    cmcard character varying NOT NULL,
    cmcardtype character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_supertype OWNER TO managuide;

--
-- TOC entry 229 (class 1259 OID 20867)
-- Name: cmcard_variation; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_variation (
    cmcard character varying NOT NULL,
    cmcard_variation character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcard_variation OWNER TO managuide;

--
-- TOC entry 237 (class 1259 OID 23631)
-- Name: cmcardprice; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcardprice (
    high double precision,
    low double precision,
    cmcard character varying NOT NULL,
    cmstore character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    median double precision,
    condition character varying,
    is_foil boolean,
    market double precision,
    direct_low double precision
);


ALTER TABLE public.cmcardprice OWNER TO managuide;

--
-- TOC entry 238 (class 1259 OID 23639)
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
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 238
-- Name: cmcardprice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcardprice_id_seq OWNED BY public.cmcardprice.id;


--
-- TOC entry 240 (class 1259 OID 25558)
-- Name: cmcardstatistics; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcardstatistics (
    id integer NOT NULL,
    cmcard character varying NOT NULL,
    views bigint,
    rating double precision,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcardstatistics OWNER TO managuide;

--
-- TOC entry 239 (class 1259 OID 25556)
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
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 239
-- Name: cmcardstatistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcardstatistics_id_seq OWNED BY public.cmcardstatistics.id;


--
-- TOC entry 213 (class 1259 OID 19833)
-- Name: cmcardtype; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcardtype (
    name character varying NOT NULL,
    name_section character varying,
    cmcardtype_parent character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcardtype OWNER TO managuide;

--
-- TOC entry 214 (class 1259 OID 19840)
-- Name: cmcolor; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcolor (
    symbol character varying NOT NULL,
    name_section character varying,
    is_mana_color boolean,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    name character varying NOT NULL
);


ALTER TABLE public.cmcolor OWNER TO managuide;

--
-- TOC entry 215 (class 1259 OID 19847)
-- Name: cmcomponent; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcomponent (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmcomponent OWNER TO managuide;

--
-- TOC entry 216 (class 1259 OID 19854)
-- Name: cmformat; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmformat (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmformat OWNER TO managuide;

--
-- TOC entry 217 (class 1259 OID 19861)
-- Name: cmframe; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmframe (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    description character varying
);


ALTER TABLE public.cmframe OWNER TO managuide;

--
-- TOC entry 218 (class 1259 OID 19868)
-- Name: cmframeeffect; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmframeeffect (
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    description character varying,
    id character varying NOT NULL,
    name character varying
);


ALTER TABLE public.cmframeeffect OWNER TO managuide;

--
-- TOC entry 219 (class 1259 OID 19875)
-- Name: cmlanguage; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmlanguage (
    code character varying NOT NULL,
    display_code character varying,
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmlanguage OWNER TO managuide;

--
-- TOC entry 220 (class 1259 OID 19882)
-- Name: cmlayout; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmlayout (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    description character varying
);


ALTER TABLE public.cmlayout OWNER TO managuide;

--
-- TOC entry 221 (class 1259 OID 19889)
-- Name: cmlegality; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmlegality (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmlegality OWNER TO managuide;

--
-- TOC entry 222 (class 1259 OID 19896)
-- Name: cmrarity; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmrarity (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmrarity OWNER TO managuide;

--
-- TOC entry 236 (class 1259 OID 23258)
-- Name: cmrule; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmrule (
    term character varying,
    term_section character varying,
    definition character varying,
    "order" double precision,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    id integer NOT NULL,
    cmrule_parent integer
);


ALTER TABLE public.cmrule OWNER TO managuide;

--
-- TOC entry 223 (class 1259 OID 19903)
-- Name: cmruling; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmruling (
    text character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    oracle_id character varying,
    date_published date,
    id integer NOT NULL
);


ALTER TABLE public.cmruling OWNER TO managuide;

--
-- TOC entry 243 (class 1259 OID 25687)
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
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 243
-- Name: cmruling_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmruling_id_seq OWNED BY public.cmruling.id;


--
-- TOC entry 224 (class 1259 OID 19910)
-- Name: cmset; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmset (
    card_count integer NOT NULL,
    code character varying NOT NULL,
    is_foil_only boolean,
    is_online_only boolean,
    mtgo_code character varying,
    my_keyrune_code character varying,
    my_name_section character varying,
    my_year_section character varying,
    name character varying NOT NULL,
    release_date character varying,
    tcgplayer_id integer,
    cmsetblock character varying,
    cmsettype character varying,
    cmset_parent character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmset OWNER TO managuide;

--
-- TOC entry 225 (class 1259 OID 19917)
-- Name: cmset_language; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmset_language (
    cmset character varying NOT NULL,
    cmlanguage character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmset_language OWNER TO managuide;

--
-- TOC entry 226 (class 1259 OID 19924)
-- Name: cmsetblock; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmsetblock (
    code character varying NOT NULL,
    name_section character varying,
    name character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmsetblock OWNER TO managuide;

--
-- TOC entry 227 (class 1259 OID 19931)
-- Name: cmsettype; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmsettype (
    name character varying NOT NULL,
    name_section character varying(1),
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmsettype OWNER TO managuide;

--
-- TOC entry 235 (class 1259 OID 22619)
-- Name: cmstore; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmstore (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmstore OWNER TO managuide;

--
-- TOC entry 228 (class 1259 OID 19938)
-- Name: cmwatermark; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmwatermark (
    name character varying NOT NULL,
    name_section character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cmwatermark OWNER TO managuide;

--
-- TOC entry 232 (class 1259 OID 21827)
-- Name: server_info; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.server_info (
    scryfall_version character varying,
    keyrune_version character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    id character varying
);


ALTER TABLE public.server_info OWNER TO managuide;

--
-- TOC entry 3384 (class 2604 OID 25665)
-- Name: cmcard_component_part id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part ALTER COLUMN id SET DEFAULT nextval('public.cmcard_component_part_id_seq'::regclass);


--
-- TOC entry 3379 (class 2604 OID 25677)
-- Name: cmcard_format_legality id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality ALTER COLUMN id SET DEFAULT nextval('public.cmcard_format_legality_id_seq'::regclass);


--
-- TOC entry 3431 (class 2604 OID 22608)
-- Name: cmcard_store_price id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_store_price ALTER COLUMN id SET DEFAULT nextval('public.cmcard_price_id_seq'::regclass);


--
-- TOC entry 3439 (class 2604 OID 23641)
-- Name: cmcardprice id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice ALTER COLUMN id SET DEFAULT nextval('public.cmcardprice_id_seq'::regclass);


--
-- TOC entry 3440 (class 2604 OID 25561)
-- Name: cmcardstatistics id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardstatistics ALTER COLUMN id SET DEFAULT nextval('public.cmcardstatistics_id_seq'::regclass);


--
-- TOC entry 3411 (class 2604 OID 25689)
-- Name: cmruling id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmruling ALTER COLUMN id SET DEFAULT nextval('public.cmruling_id_seq'::regclass);


--
-- TOC entry 3445 (class 2606 OID 19946)
-- Name: cmartist cmartist_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmartist
    ADD CONSTRAINT cmartist_pkey PRIMARY KEY (name);


--
-- TOC entry 3454 (class 2606 OID 19948)
-- Name: cmcard_color cmcard_color_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_color_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- TOC entry 3456 (class 2606 OID 19950)
-- Name: cmcard_color cmcard_color_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_color_unique UNIQUE (cmcard, cmcolor);


--
-- TOC entry 3458 (class 2606 OID 19952)
-- Name: cmcard_coloridentity cmcard_coloridentity_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_coloridentity_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- TOC entry 3460 (class 2606 OID 19954)
-- Name: cmcard_coloridentity cmcard_coloridentity_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_coloridentity_unique UNIQUE (cmcard, cmcolor);


--
-- TOC entry 3462 (class 2606 OID 19956)
-- Name: cmcard_colorindicator cmcard_colorindicator_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_colorindicator_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- TOC entry 3464 (class 2606 OID 19958)
-- Name: cmcard_colorindicator cmcard_colorindicator_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_colorindicator_unique UNIQUE (cmcard, cmcolor);


--
-- TOC entry 3478 (class 2606 OID 25674)
-- Name: cmcard_component_part cmcard_component_part_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_component_part_pkey PRIMARY KEY (id);


--
-- TOC entry 3466 (class 2606 OID 19960)
-- Name: cmcard_face cmcard_face_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_pkey PRIMARY KEY (cmcard, cmcard_face);


--
-- TOC entry 3468 (class 2606 OID 19962)
-- Name: cmcard_face cmcard_face_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_unique UNIQUE (cmcard, cmcard_face);


--
-- TOC entry 3470 (class 2606 OID 25686)
-- Name: cmcard_format_legality cmcard_format_legality_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_format_legality_pkey PRIMARY KEY (id);


--
-- TOC entry 3472 (class 2606 OID 19966)
-- Name: cmcard_format_legality cmcard_format_legality_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_format_legality_unique UNIQUE (cmcard, cmformat, cmlegality);


--
-- TOC entry 3474 (class 2606 OID 19968)
-- Name: cmcard_frameeffect cmcard_frameeffect_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_frameeffect_pkey PRIMARY KEY (cmcard, cmframeeffect);


--
-- TOC entry 3476 (class 2606 OID 19970)
-- Name: cmcard_frameeffect cmcard_frameeffect_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_frameeffect_unique UNIQUE (cmcard, cmframeeffect);


--
-- TOC entry 3529 (class 2606 OID 20916)
-- Name: cmcard_otherlanguage cmcard_otherlanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_otherlanguage_pkey PRIMARY KEY (cmcard, cmcard_otherlanguage);


--
-- TOC entry 3531 (class 2606 OID 20935)
-- Name: cmcard_otherprinting cmcard_otherprinting_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_otherprinting_pkey PRIMARY KEY (cmcard, cmcard_otherprinting);


--
-- TOC entry 3480 (class 2606 OID 19974)
-- Name: cmcard_component_part cmcard_part_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_part_unique UNIQUE (cmcard, cmcomponent, cmcard_part);


--
-- TOC entry 3451 (class 2606 OID 19976)
-- Name: cmcard cmcard_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmcard_pkey PRIMARY KEY (id);


--
-- TOC entry 3533 (class 2606 OID 22613)
-- Name: cmcard_store_price cmcard_price_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_store_price
    ADD CONSTRAINT cmcard_price_pkey PRIMARY KEY (id);


--
-- TOC entry 3482 (class 2606 OID 19978)
-- Name: cmcard_subtype cmcard_subtype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_subtype_pkey PRIMARY KEY (cmcard, cmcardtype);


--
-- TOC entry 3484 (class 2606 OID 19980)
-- Name: cmcard_subtype cmcard_subtype_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_subtype_unique UNIQUE (cmcard, cmcardtype);


--
-- TOC entry 3486 (class 2606 OID 19982)
-- Name: cmcard_supertype cmcard_supertype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_supertype_pkey PRIMARY KEY (cmcard, cmcardtype);


--
-- TOC entry 3488 (class 2606 OID 19984)
-- Name: cmcard_supertype cmcard_supertype_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_supertype_unique UNIQUE (cmcard, cmcardtype);


--
-- TOC entry 3527 (class 2606 OID 20896)
-- Name: cmcard_variation cmcard_variation_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_variation_pkey PRIMARY KEY (cmcard, cmcard_variation);


--
-- TOC entry 3497 (class 2606 OID 19986)
-- Name: cmformat cmcardformat_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmformat
    ADD CONSTRAINT cmcardformat_pkey PRIMARY KEY (name);


--
-- TOC entry 3540 (class 2606 OID 23649)
-- Name: cmcardprice cmcardprice_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmcardprice_pkey PRIMARY KEY (id);


--
-- TOC entry 3542 (class 2606 OID 25568)
-- Name: cmcardstatistics cmcardstatistics_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardstatistics
    ADD CONSTRAINT cmcardstatistics_pkey PRIMARY KEY (id);


--
-- TOC entry 3491 (class 2606 OID 19988)
-- Name: cmcardtype cmcardtype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardtype
    ADD CONSTRAINT cmcardtype_pkey PRIMARY KEY (name);


--
-- TOC entry 3493 (class 2606 OID 19990)
-- Name: cmcolor cmcolor_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcolor
    ADD CONSTRAINT cmcolor_pkey PRIMARY KEY (symbol);


--
-- TOC entry 3495 (class 2606 OID 19992)
-- Name: cmcomponent cmcomponent_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcomponent
    ADD CONSTRAINT cmcomponent_pkey PRIMARY KEY (name);


--
-- TOC entry 3499 (class 2606 OID 19994)
-- Name: cmframe cmframe_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmframe
    ADD CONSTRAINT cmframe_pkey PRIMARY KEY (name);


--
-- TOC entry 3501 (class 2606 OID 19996)
-- Name: cmframeeffect cmframeeffect_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmframeeffect
    ADD CONSTRAINT cmframeeffect_pkey PRIMARY KEY (id);


--
-- TOC entry 3504 (class 2606 OID 19998)
-- Name: cmlanguage cmlanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlanguage
    ADD CONSTRAINT cmlanguage_pkey PRIMARY KEY (code);


--
-- TOC entry 3506 (class 2606 OID 20000)
-- Name: cmlayout cmlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlayout
    ADD CONSTRAINT cmlayout_pkey PRIMARY KEY (name);


--
-- TOC entry 3508 (class 2606 OID 20002)
-- Name: cmlegality cmlegality_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlegality
    ADD CONSTRAINT cmlegality_pkey PRIMARY KEY (name);


--
-- TOC entry 3510 (class 2606 OID 20004)
-- Name: cmrarity cmrarity_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrarity
    ADD CONSTRAINT cmrarity_pkey PRIMARY KEY (name);


--
-- TOC entry 3537 (class 2606 OID 23283)
-- Name: cmrule cmrule_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrule
    ADD CONSTRAINT cmrule_pkey PRIMARY KEY (id);


--
-- TOC entry 3512 (class 2606 OID 25697)
-- Name: cmruling cmruling_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmruling
    ADD CONSTRAINT cmruling_pkey PRIMARY KEY (id);


--
-- TOC entry 3517 (class 2606 OID 20006)
-- Name: cmset_language cmset_language_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_language_pkey PRIMARY KEY (cmset, cmlanguage);


--
-- TOC entry 3519 (class 2606 OID 20008)
-- Name: cmset_language cmset_language_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_language_unique UNIQUE (cmset, cmlanguage);


--
-- TOC entry 3515 (class 2606 OID 20010)
-- Name: cmset cmset_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmset_pkey PRIMARY KEY (code);


--
-- TOC entry 3521 (class 2606 OID 20012)
-- Name: cmsetblock cmsetblock_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmsetblock
    ADD CONSTRAINT cmsetblock_pkey PRIMARY KEY (code);


--
-- TOC entry 3523 (class 2606 OID 20014)
-- Name: cmsettype cmsettype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmsettype
    ADD CONSTRAINT cmsettype_pkey PRIMARY KEY (name);


--
-- TOC entry 3535 (class 2606 OID 22628)
-- Name: cmstore cmstore_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmstore
    ADD CONSTRAINT cmstore_pkey PRIMARY KEY (name);


--
-- TOC entry 3525 (class 2606 OID 20016)
-- Name: cmwatermark cmwatermark_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmwatermark
    ADD CONSTRAINT cmwatermark_pkey PRIMARY KEY (name);


--
-- TOC entry 3443 (class 1259 OID 20017)
-- Name: cmartist_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmartist_name_index ON public.cmartist USING btree (name varchar_ops);


--
-- TOC entry 3446 (class 1259 OID 25635)
-- Name: cmcard_cmlanguage_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmlanguage_index ON public.cmcard USING btree (cmlanguage text_pattern_ops);


--
-- TOC entry 3447 (class 1259 OID 20018)
-- Name: cmcard_id_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_id_index ON public.cmcard USING btree (id varchar_ops);


--
-- TOC entry 3448 (class 1259 OID 21076)
-- Name: cmcard_id_name_cmset_cmlanguage_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_id_name_cmset_cmlanguage_index ON public.cmcard USING btree (id varchar_ops, name varchar_ops, cmset varchar_ops, cmlanguage varchar_ops);


--
-- TOC entry 3449 (class 1259 OID 25636)
-- Name: cmcard_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_name_index ON public.cmcard USING btree (name varchar_pattern_ops);


--
-- TOC entry 3452 (class 1259 OID 23721)
-- Name: cmcard_tcgplayer_id_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_tcgplayer_id_index ON public.cmcard USING btree (tcgplayer_id DESC);


--
-- TOC entry 3538 (class 1259 OID 23726)
-- Name: cmcardprice_camcard_cmstore_is_foil_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcardprice_camcard_cmstore_is_foil_index ON public.cmcardprice USING btree (cmstore varchar_ops DESC, cmcard varchar_ops DESC, is_foil DESC);


--
-- TOC entry 3489 (class 1259 OID 20019)
-- Name: cmcardtype_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcardtype_name_index ON public.cmcardtype USING btree (name varchar_ops);


--
-- TOC entry 3502 (class 1259 OID 25637)
-- Name: cmlanguage_code_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmlanguage_code_index ON public.cmlanguage USING btree (code varchar_ops);


--
-- TOC entry 3513 (class 1259 OID 20020)
-- Name: cmset_code_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmset_code_index ON public.cmset USING btree (code varchar_ops);


--
-- TOC entry 3543 (class 2606 OID 20021)
-- Name: cmcard cmartist_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmartist_fkey FOREIGN KEY (cmartist) REFERENCES public.cmartist(name) NOT VALID;


--
-- TOC entry 3557 (class 2606 OID 20990)
-- Name: cmcard_face cmcard_face_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_fkey FOREIGN KEY (cmcard_face) REFERENCES public.cmcard(id) NOT VALID;


--
-- TOC entry 3561 (class 2606 OID 20026)
-- Name: cmcard_frameeffect cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id) NOT VALID;


--
-- TOC entry 3550 (class 2606 OID 20031)
-- Name: cmcard_color cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3552 (class 2606 OID 20036)
-- Name: cmcard_coloridentity cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3554 (class 2606 OID 20041)
-- Name: cmcard_colorindicator cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3558 (class 2606 OID 20046)
-- Name: cmcard_format_legality cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3566 (class 2606 OID 20051)
-- Name: cmcard_subtype cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3568 (class 2606 OID 20056)
-- Name: cmcard_supertype cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3563 (class 2606 OID 20061)
-- Name: cmcard_component_part cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3556 (class 2606 OID 20066)
-- Name: cmcard_face cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id) NOT VALID;


--
-- TOC entry 3576 (class 2606 OID 20897)
-- Name: cmcard_variation cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id) NOT VALID;


--
-- TOC entry 3578 (class 2606 OID 20917)
-- Name: cmcard_otherlanguage cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3580 (class 2606 OID 20936)
-- Name: cmcard_otherprinting cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3582 (class 2606 OID 22614)
-- Name: cmcard_store_price cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_store_price
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- TOC entry 3585 (class 2606 OID 23650)
-- Name: cmcardprice cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id) NOT VALID;


--
-- TOC entry 3579 (class 2606 OID 20922)
-- Name: cmcard_otherlanguage cmcard_otherlanguage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_otherlanguage_fkey FOREIGN KEY (cmcard_otherlanguage) REFERENCES public.cmcard(id);


--
-- TOC entry 3581 (class 2606 OID 20941)
-- Name: cmcard_otherprinting cmcard_otherprinting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_otherprinting_fkey FOREIGN KEY (cmcard_otherprinting) REFERENCES public.cmcard(id);


--
-- TOC entry 3564 (class 2606 OID 20071)
-- Name: cmcard_component_part cmcard_part_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_part_fkey FOREIGN KEY (cmcard_part) REFERENCES public.cmcard(id);


--
-- TOC entry 3577 (class 2606 OID 20902)
-- Name: cmcard_variation cmcard_variation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_variation_fkey FOREIGN KEY (cmcard_variation) REFERENCES public.cmcard(id) NOT VALID;


--
-- TOC entry 3567 (class 2606 OID 20076)
-- Name: cmcard_subtype cmcardtype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcardtype_fkey FOREIGN KEY (cmcardtype) REFERENCES public.cmcardtype(name);


--
-- TOC entry 3569 (class 2606 OID 20081)
-- Name: cmcard_supertype cmcardtype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcardtype_fkey FOREIGN KEY (cmcardtype) REFERENCES public.cmcardtype(name);


--
-- TOC entry 3570 (class 2606 OID 20086)
-- Name: cmcardtype cmcardtype_parent; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardtype
    ADD CONSTRAINT cmcardtype_parent FOREIGN KEY (cmcardtype_parent) REFERENCES public.cmcardtype(name) NOT VALID;


--
-- TOC entry 3551 (class 2606 OID 20091)
-- Name: cmcard_color cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- TOC entry 3553 (class 2606 OID 20096)
-- Name: cmcard_coloridentity cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- TOC entry 3555 (class 2606 OID 20101)
-- Name: cmcard_colorindicator cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- TOC entry 3565 (class 2606 OID 20106)
-- Name: cmcard_component_part cmcomponent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcomponent_fkey FOREIGN KEY (cmcomponent) REFERENCES public.cmcomponent(name);


--
-- TOC entry 3559 (class 2606 OID 20116)
-- Name: cmcard_format_legality cmformat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmformat_fkey FOREIGN KEY (cmformat) REFERENCES public.cmformat(name);


--
-- TOC entry 3544 (class 2606 OID 20121)
-- Name: cmcard cmframe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmframe_fkey FOREIGN KEY (cmframe) REFERENCES public.cmframe(name) NOT VALID;


--
-- TOC entry 3562 (class 2606 OID 20126)
-- Name: cmcard_frameeffect cmframeeffect_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmframeeffect_fkey FOREIGN KEY (cmframeeffect) REFERENCES public.cmframeeffect(id) NOT VALID;


--
-- TOC entry 3545 (class 2606 OID 20131)
-- Name: cmcard cmlanguage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmlanguage_fkey FOREIGN KEY (cmlanguage) REFERENCES public.cmlanguage(code) NOT VALID;


--
-- TOC entry 3574 (class 2606 OID 20136)
-- Name: cmset_language cmlanguage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmlanguage_fkey FOREIGN KEY (cmlanguage) REFERENCES public.cmlanguage(code);


--
-- TOC entry 3546 (class 2606 OID 20141)
-- Name: cmcard cmlayout_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmlayout_fkey FOREIGN KEY (cmlayout) REFERENCES public.cmlayout(name) NOT VALID;


--
-- TOC entry 3560 (class 2606 OID 20146)
-- Name: cmcard_format_legality cmlegality_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmlegality_fkey FOREIGN KEY (cmlegality) REFERENCES public.cmlegality(name);


--
-- TOC entry 3547 (class 2606 OID 20151)
-- Name: cmcard cmrarity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmrarity_fkey FOREIGN KEY (cmrarity) REFERENCES public.cmrarity(name) NOT VALID;


--
-- TOC entry 3584 (class 2606 OID 23284)
-- Name: cmrule cmrule_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrule
    ADD CONSTRAINT cmrule_parent_fkey FOREIGN KEY (cmrule_parent) REFERENCES public.cmrule(id) NOT VALID;


--
-- TOC entry 3548 (class 2606 OID 20156)
-- Name: cmcard cmset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmset_fkey FOREIGN KEY (cmset) REFERENCES public.cmset(code) NOT VALID;


--
-- TOC entry 3575 (class 2606 OID 20161)
-- Name: cmset_language cmset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_fkey FOREIGN KEY (cmset) REFERENCES public.cmset(code);


--
-- TOC entry 3571 (class 2606 OID 20166)
-- Name: cmset cmset_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmset_parent_fkey FOREIGN KEY (cmset_parent) REFERENCES public.cmset(code) NOT VALID;


--
-- TOC entry 3572 (class 2606 OID 20171)
-- Name: cmset cmsetblock_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmsetblock_fkey FOREIGN KEY (cmsetblock) REFERENCES public.cmsetblock(code) NOT VALID;


--
-- TOC entry 3573 (class 2606 OID 20176)
-- Name: cmset cmsettype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmsettype_fkey FOREIGN KEY (cmsettype) REFERENCES public.cmsettype(name) NOT VALID;


--
-- TOC entry 3583 (class 2606 OID 22629)
-- Name: cmcard_store_price cmstore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_store_price
    ADD CONSTRAINT cmstore_fkey FOREIGN KEY (cmstore) REFERENCES public.cmstore(name) NOT VALID;


--
-- TOC entry 3586 (class 2606 OID 23655)
-- Name: cmcardprice cmstore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmstore_fkey FOREIGN KEY (cmstore) REFERENCES public.cmstore(name) NOT VALID;


--
-- TOC entry 3549 (class 2606 OID 20181)
-- Name: cmcard cmwatermark_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmwatermark_fkey FOREIGN KEY (cmwatermark) REFERENCES public.cmwatermark(name) NOT VALID;


-- Completed on 2020-01-18 18:45:51 EST

--
-- PostgreSQL database dump complete
--

