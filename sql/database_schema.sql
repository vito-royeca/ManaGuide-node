--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

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
-- Name: createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer) RETURNS character varying
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
    _my_name_section ALIAS FOR $14;
    _my_number_order ALIAS FOR $15;
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
    _id ALIAS FOR $34;
    _card_back_id ALIAS FOR $35;
    _oracle_id ALIAS FOR $36;
    _illustration_id ALIAS FOR $37;
    _cmartist ALIAS FOR $38;
    _cmset ALIAS FOR $39;
    _cmrarity ALIAS FOR $40;
    _cmlanguage ALIAS FOR $41;
    _cmlayout ALIAS FOR $42;
    _cmwatermark ALIAS FOR $43;
    _cmframe ALIAS FOR $44;
    _cmframeeffects ALIAS FOR $45;
    _cmcolors ALIAS FOR $46;
    _cmcolor_identities ALIAS FOR $47;
    _cmcolor_indicators ALIAS FOR $48;
    _cmlegalities ALIAS FOR $49;
    _type_line ALIAS FOR $50;
    _printed_type_line ALIAS FOR $51;
    _cmcardtype_subtypes ALIAS FOR $52;
    _cmcardtype_supertypes ALIAS FOR $53;
    _face_order ALIAS FOR $54;

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


ALTER FUNCTION public.createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer) OWNER TO postgres;

--
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
-- Name: createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _card_count ALIAS FOR $1;
    _code ALIAS FOR $2;
    _is_foil_only ALIAS FOR $3;
    _is_online_only ALIAS FOR $4;
    _mtgo_code ALIAS FOR $5;
    _keyrune_unicode ALIAS FOR $6;
    _keyrune_class ALIAS FOR $7;
    _my_name_section ALIAS FOR $8;
    _my_year_section ALIAS FOR $9;
    _name ALIAS FOR $10;
    _release_date ALIAS FOR $11;
    _tcgplayer_id ALIAS FOR $12;
    _cmsetblock ALIAS FOR $13;
    _cmsettype ALIAS FOR $14;
    _cmset_parent ALIAS FOR $15;

    pkey character varying;
    parent_row cmset%rowtype;
BEGIN
    -- check for nulls
    IF lower(_mtgo_code) = 'null' THEN
        _mtgo_code := NULL;
    END IF;
    IF lower(_keyrune_unicode) = 'null' THEN
        _keyrune_unicode := NULL;
    END IF;
    IF lower(_keyrune_class) = 'null' THEN
        _keyrune_class := NULL;
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
            keyrune_unicode,
            keyrune_class,
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
            _keyrune_unicode,
            _keyrune_class,
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
                keyrune_unicode = parent_row.keyrune_unicode,
                keyrune_class = parent_row.keyrune_class,
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
                keyrune_unicode = _keyrune_unicode,
                keyrune_class = _keyrune_class,
                my_name_section = _my_name_section,
                my_year_section = _my_year_section,
                name = _name,
                release_date = _release_date,
                tcgplayer_id = _tcgplayer_id,
                cmsetblock = _cmsetblock,
                cmsettype = _cmsettype,
                date_updated = now()
            WHERE code = _code;

            UPDATE cmset SET
                keyrune_unicode = _keyrune_unicode,
                keyrune_class = _keyrune_class,
                my_name_section = _my_name_section,
                my_year_section = _my_year_section,
                date_updated = now()
            WHERE cmset_parent = _code;
        END IF;
    END IF;

	RETURN _code;
END;
$_$;


ALTER FUNCTION public.createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying) OWNER TO postgres;

--
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
-- Name: searchcards(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.searchcards(character varying, character varying, character varying) RETURNS TABLE(id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, my_name_section character varying, my_number_order double precision, name character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, set json, rarity json, language json, prices json[], faces json[])
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
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class
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
                           'FROM cmcard d left join cmcard_face w on w.cmcard_face = d.id
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
-- Name: searchrules(character varying); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.searchrules(character varying) OWNER TO postgres;

--
-- Name: selectcard(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectcard(character varying) RETURNS TABLE(collector_number character varying, cmc double precision, face_order integer, flavor_text character varying, is_foil boolean, is_full_art boolean, is_highres_image boolean, is_nonfoil boolean, is_oversized boolean, is_reserved boolean, is_story_spotlight boolean, loyalty character varying, mana_cost character varying, my_name_section character varying, my_number_order double precision, name character varying, oracle_text character varying, power character varying, printed_name character varying, printed_text character varying, toughness character varying, arena_id integer, mtgo_id integer, tcgplayer_id integer, hand_modifier character varying, life_modifier character varying, is_booster boolean, is_digital boolean, is_promo boolean, released_at date, is_textless boolean, mtgo_foil_id integer, is_reprint boolean, id character varying, card_back_id character varying, oracle_id character varying, illustration_id character varying, printed_type_line character varying, type_line character varying, multiverse_ids integer[], set json, rarity json, language json, layout json, watermark json, frame json, artist json, colors json[], color_identities json[], color_indicators json[], component_parts json[], faces json[], other_languages json[], other_printings json[], variations json[], format_legalities json[], frame_effects json[], subtypes json[], supertypes json[], prices json[], rulings json[])
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
                                	select x.id,
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
							left join cmcard x on v.cmcard_part = x.id
                            WHERE v.cmcard = c.id
                        ) x
                    ) AS component_parts ';
    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' || command ||
                            'FROM cmcard c left join cmcard_face w on w.cmcard_face = c.id
                            WHERE w.cmcard = ''' || _id || '''' ||
                        ') x
                    ) AS faces ';

    -- Other Languages
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT c.id,
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
                            left join cmcard_otherlanguage x on x.cmcard_otherlanguage = c.id
                            left join cmset y on y.code = c.cmset
                            WHERE x.cmcard = ''' || _id || '''' ||
                            ' order by y.release_date desc
                        ) x
                    ) AS other_languages ';

    -- Other Printings
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
						    SELECT c.id,
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
                            FROM cmcard c
                            left join cmcard_otherprinting w on w.cmcard_otherprinting = c.id
                            left join cmset y on y.code = c.cmset
                            WHERE w.cmcard = ''' || _id || '''' ||
                            ' order by y.release_date desc
                        ) x
                    ) AS other_printings ';

    -- Variations
    command := command ||
                ', array(
                    SELECT row_to_json(x) FROM (
						SELECT c.id,
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
                        FROM cmcard c left join cmcard_variation w on w.cmcard_variation = c.id
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

	-- Rulings
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT v.id, v.date_published, v.text
                        FROM cmruling v
                        WHERE v.oracle_id = c.oracle_id
                    ) x
                ) AS rulings ';

    command := command || 'FROM cmcard c WHERE c.id = ''' || _id || '''';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectcard(character varying) OWNER TO postgres;

--
-- Name: selectcards(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectcards(character varying, character varying, character varying, character varying) RETURNS TABLE(id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, my_name_section character varying, my_number_order double precision, name character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, set json, rarity json, language json, prices json[], faces json[])
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
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class
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
                            'FROM cmcard d left join cmcard_face w on w.cmcard_face = d.id
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
-- Name: selectrules(integer); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.selectrules(integer) OWNER TO postgres;

--
-- Name: selectset(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectset(character varying, character varying, character varying, character varying) RETURNS TABLE(card_count integer, code character varying, is_foil_only boolean, is_online_only boolean, mtgo_code character varying, keyrune_unicode character varying, keyrune_class character varying, my_name_section character varying, my_year_section character varying, name character varying, release_date character varying, tcgplayer_id integer, set_block json, set_type json, languages json[], cards json)
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
                    keyrune_unicode,
                    keyrune_class,
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
-- Name: selectsets(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectsets(character varying) RETURNS TABLE(card_count integer, code character varying, is_foil_only boolean, is_online_only boolean, mtgo_code character varying, keyrune_unicode character varying, keyrune_class character varying, my_name_section character varying, my_year_section character varying, name character varying, release_date character varying, tcgplayer_id integer, parent json, set_block json, set_type json, languages json[])
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
                    keyrune_unicode,
                    keyrune_class,
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


ALTER FUNCTION public.selectsets(character varying) OWNER TO postgres;

--
-- Name: updatesetkeyrune(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.updatesetkeyrune(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    _keyrune_unicode ALIAS FOR $2;
    _keyrune_class ALIAS FOR $3;
BEGIN

    UPDATE cmset SET
        keyrune_unicode = _keyrune_unicode,
        keyrune_class = _keyrune_class,
        date_updated = now()
    WHERE code = _code OR cmset_parent = _code;

    RETURN _code;
END;
$_$;


ALTER FUNCTION public.updatesetkeyrune(character varying, character varying, character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
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
-- Name: cmcard_component_part_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcard_component_part_id_seq OWNED BY public.cmcard_component_part.id;


--
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
-- Name: cmcard_format_legality_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcard_format_legality_id_seq OWNED BY public.cmcard_format_legality.id;


--
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
-- Name: cmcard_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcard_price_id_seq OWNED BY public.cmcard_store_price.id;


--
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
-- Name: cmcardprice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcardprice_id_seq OWNED BY public.cmcardprice.id;


--
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
-- Name: cmcardstatistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmcardstatistics_id_seq OWNED BY public.cmcardstatistics.id;


--
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
-- Name: cmruling_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.cmruling_id_seq OWNED BY public.cmruling.id;


--
-- Name: cmset; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmset (
    card_count integer NOT NULL,
    code character varying NOT NULL,
    is_foil_only boolean,
    is_online_only boolean,
    mtgo_code character varying,
    my_name_section character varying,
    my_year_section character varying,
    name character varying NOT NULL,
    release_date character varying,
    tcgplayer_id integer,
    cmsetblock character varying,
    cmsettype character varying,
    cmset_parent character varying,
    date_created timestamp without time zone DEFAULT now(),
    date_updated timestamp without time zone DEFAULT now(),
    keyrune_unicode character varying,
    keyrune_class character varying
);


ALTER TABLE public.cmset OWNER TO managuide;

--
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
-- Name: cmcard_component_part id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part ALTER COLUMN id SET DEFAULT nextval('public.cmcard_component_part_id_seq'::regclass);


--
-- Name: cmcard_format_legality id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality ALTER COLUMN id SET DEFAULT nextval('public.cmcard_format_legality_id_seq'::regclass);


--
-- Name: cmcard_store_price id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_store_price ALTER COLUMN id SET DEFAULT nextval('public.cmcard_price_id_seq'::regclass);


--
-- Name: cmcardprice id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice ALTER COLUMN id SET DEFAULT nextval('public.cmcardprice_id_seq'::regclass);


--
-- Name: cmcardstatistics id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardstatistics ALTER COLUMN id SET DEFAULT nextval('public.cmcardstatistics_id_seq'::regclass);


--
-- Name: cmruling id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmruling ALTER COLUMN id SET DEFAULT nextval('public.cmruling_id_seq'::regclass);


--
-- Name: cmartist cmartist_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmartist
    ADD CONSTRAINT cmartist_pkey PRIMARY KEY (name);


--
-- Name: cmcard_color cmcard_color_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_color_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- Name: cmcard_color cmcard_color_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_color_unique UNIQUE (cmcard, cmcolor);


--
-- Name: cmcard_coloridentity cmcard_coloridentity_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_coloridentity_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- Name: cmcard_coloridentity cmcard_coloridentity_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_coloridentity_unique UNIQUE (cmcard, cmcolor);


--
-- Name: cmcard_colorindicator cmcard_colorindicator_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_colorindicator_pkey PRIMARY KEY (cmcard, cmcolor);


--
-- Name: cmcard_colorindicator cmcard_colorindicator_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_colorindicator_unique UNIQUE (cmcard, cmcolor);


--
-- Name: cmcard_component_part cmcard_component_part_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_component_part_pkey PRIMARY KEY (id);


--
-- Name: cmcard_face cmcard_face_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_pkey PRIMARY KEY (cmcard, cmcard_face);


--
-- Name: cmcard_face cmcard_face_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_unique UNIQUE (cmcard, cmcard_face);


--
-- Name: cmcard_format_legality cmcard_format_legality_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_format_legality_pkey PRIMARY KEY (id);


--
-- Name: cmcard_format_legality cmcard_format_legality_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_format_legality_unique UNIQUE (cmcard, cmformat, cmlegality);


--
-- Name: cmcard_frameeffect cmcard_frameeffect_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_frameeffect_pkey PRIMARY KEY (cmcard, cmframeeffect);


--
-- Name: cmcard_frameeffect cmcard_frameeffect_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_frameeffect_unique UNIQUE (cmcard, cmframeeffect);


--
-- Name: cmcard_otherlanguage cmcard_otherlanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_otherlanguage_pkey PRIMARY KEY (cmcard, cmcard_otherlanguage);


--
-- Name: cmcard_otherprinting cmcard_otherprinting_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_otherprinting_pkey PRIMARY KEY (cmcard, cmcard_otherprinting);


--
-- Name: cmcard_component_part cmcard_part_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_part_unique UNIQUE (cmcard, cmcomponent, cmcard_part);


--
-- Name: cmcard cmcard_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmcard_pkey PRIMARY KEY (id);


--
-- Name: cmcard_store_price cmcard_price_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_store_price
    ADD CONSTRAINT cmcard_price_pkey PRIMARY KEY (id);


--
-- Name: cmcard_subtype cmcard_subtype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_subtype_pkey PRIMARY KEY (cmcard, cmcardtype);


--
-- Name: cmcard_subtype cmcard_subtype_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_subtype_unique UNIQUE (cmcard, cmcardtype);


--
-- Name: cmcard_supertype cmcard_supertype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_supertype_pkey PRIMARY KEY (cmcard, cmcardtype);


--
-- Name: cmcard_supertype cmcard_supertype_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_supertype_unique UNIQUE (cmcard, cmcardtype);


--
-- Name: cmcard_variation cmcard_variation_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_variation_pkey PRIMARY KEY (cmcard, cmcard_variation);


--
-- Name: cmformat cmcardformat_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmformat
    ADD CONSTRAINT cmcardformat_pkey PRIMARY KEY (name);


--
-- Name: cmcardprice cmcardprice_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmcardprice_pkey PRIMARY KEY (id);


--
-- Name: cmcardstatistics cmcardstatistics_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardstatistics
    ADD CONSTRAINT cmcardstatistics_pkey PRIMARY KEY (id);


--
-- Name: cmcardtype cmcardtype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardtype
    ADD CONSTRAINT cmcardtype_pkey PRIMARY KEY (name);


--
-- Name: cmcolor cmcolor_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcolor
    ADD CONSTRAINT cmcolor_pkey PRIMARY KEY (symbol);


--
-- Name: cmcomponent cmcomponent_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcomponent
    ADD CONSTRAINT cmcomponent_pkey PRIMARY KEY (name);


--
-- Name: cmframe cmframe_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmframe
    ADD CONSTRAINT cmframe_pkey PRIMARY KEY (name);


--
-- Name: cmframeeffect cmframeeffect_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmframeeffect
    ADD CONSTRAINT cmframeeffect_pkey PRIMARY KEY (id);


--
-- Name: cmlanguage cmlanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlanguage
    ADD CONSTRAINT cmlanguage_pkey PRIMARY KEY (code);


--
-- Name: cmlayout cmlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlayout
    ADD CONSTRAINT cmlayout_pkey PRIMARY KEY (name);


--
-- Name: cmlegality cmlegality_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmlegality
    ADD CONSTRAINT cmlegality_pkey PRIMARY KEY (name);


--
-- Name: cmrarity cmrarity_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrarity
    ADD CONSTRAINT cmrarity_pkey PRIMARY KEY (name);


--
-- Name: cmrule cmrule_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrule
    ADD CONSTRAINT cmrule_pkey PRIMARY KEY (id);


--
-- Name: cmruling cmruling_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmruling
    ADD CONSTRAINT cmruling_pkey PRIMARY KEY (id);


--
-- Name: cmset_language cmset_language_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_language_pkey PRIMARY KEY (cmset, cmlanguage);


--
-- Name: cmset_language cmset_language_unique; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_language_unique UNIQUE (cmset, cmlanguage);


--
-- Name: cmset cmset_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmset_pkey PRIMARY KEY (code);


--
-- Name: cmsetblock cmsetblock_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmsetblock
    ADD CONSTRAINT cmsetblock_pkey PRIMARY KEY (code);


--
-- Name: cmsettype cmsettype_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmsettype
    ADD CONSTRAINT cmsettype_pkey PRIMARY KEY (name);


--
-- Name: cmstore cmstore_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmstore
    ADD CONSTRAINT cmstore_pkey PRIMARY KEY (name);


--
-- Name: cmwatermark cmwatermark_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmwatermark
    ADD CONSTRAINT cmwatermark_pkey PRIMARY KEY (name);


--
-- Name: cmartist_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmartist_name_index ON public.cmartist USING btree (name varchar_ops);


--
-- Name: cmcard_cmlanguage_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmlanguage_index ON public.cmcard USING btree (cmlanguage text_pattern_ops);


--
-- Name: cmcard_id_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_id_index ON public.cmcard USING btree (id varchar_ops);


--
-- Name: cmcard_id_name_cmset_cmlanguage_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_id_name_cmset_cmlanguage_index ON public.cmcard USING btree (id varchar_ops, name varchar_ops, cmset varchar_ops, cmlanguage varchar_ops);


--
-- Name: cmcard_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_name_index ON public.cmcard USING btree (name varchar_pattern_ops);


--
-- Name: cmcard_tcgplayer_id_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_tcgplayer_id_index ON public.cmcard USING btree (tcgplayer_id DESC);


--
-- Name: cmcardprice_camcard_cmstore_is_foil_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcardprice_camcard_cmstore_is_foil_index ON public.cmcardprice USING btree (cmstore varchar_ops DESC, cmcard varchar_ops DESC, is_foil DESC);


--
-- Name: cmcardtype_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcardtype_name_index ON public.cmcardtype USING btree (name varchar_ops);


--
-- Name: cmlanguage_code_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmlanguage_code_index ON public.cmlanguage USING btree (code varchar_ops);


--
-- Name: cmset_code_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmset_code_index ON public.cmset USING btree (code varchar_ops);


--
-- Name: cmcard cmartist_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmartist_fkey FOREIGN KEY (cmartist) REFERENCES public.cmartist(name) NOT VALID;


--
-- Name: cmcard_face cmcard_face_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_fkey FOREIGN KEY (cmcard_face) REFERENCES public.cmcard(id) NOT VALID;


--
-- Name: cmcard_frameeffect cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id) NOT VALID;


--
-- Name: cmcard_color cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_coloridentity cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_colorindicator cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_format_legality cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_subtype cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_supertype cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_component_part cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_face cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id) NOT VALID;


--
-- Name: cmcard_variation cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id) NOT VALID;


--
-- Name: cmcard_otherlanguage cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_otherprinting cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcard_store_price cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_store_price
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id);


--
-- Name: cmcardprice cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(id) NOT VALID;


--
-- Name: cmcard_otherlanguage cmcard_otherlanguage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_otherlanguage_fkey FOREIGN KEY (cmcard_otherlanguage) REFERENCES public.cmcard(id);


--
-- Name: cmcard_otherprinting cmcard_otherprinting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_otherprinting_fkey FOREIGN KEY (cmcard_otherprinting) REFERENCES public.cmcard(id);


--
-- Name: cmcard_component_part cmcard_part_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_part_fkey FOREIGN KEY (cmcard_part) REFERENCES public.cmcard(id);


--
-- Name: cmcard_variation cmcard_variation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_variation_fkey FOREIGN KEY (cmcard_variation) REFERENCES public.cmcard(id) NOT VALID;


--
-- Name: cmcard_subtype cmcardtype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcardtype_fkey FOREIGN KEY (cmcardtype) REFERENCES public.cmcardtype(name);


--
-- Name: cmcard_supertype cmcardtype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcardtype_fkey FOREIGN KEY (cmcardtype) REFERENCES public.cmcardtype(name);


--
-- Name: cmcardtype cmcardtype_parent; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardtype
    ADD CONSTRAINT cmcardtype_parent FOREIGN KEY (cmcardtype_parent) REFERENCES public.cmcardtype(name) NOT VALID;


--
-- Name: cmcard_color cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- Name: cmcard_coloridentity cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- Name: cmcard_colorindicator cmcolor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcolor_fkey FOREIGN KEY (cmcolor) REFERENCES public.cmcolor(symbol);


--
-- Name: cmcard_component_part cmcomponent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcomponent_fkey FOREIGN KEY (cmcomponent) REFERENCES public.cmcomponent(name);


--
-- Name: cmcard_format_legality cmformat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmformat_fkey FOREIGN KEY (cmformat) REFERENCES public.cmformat(name);


--
-- Name: cmcard cmframe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmframe_fkey FOREIGN KEY (cmframe) REFERENCES public.cmframe(name) NOT VALID;


--
-- Name: cmcard_frameeffect cmframeeffect_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmframeeffect_fkey FOREIGN KEY (cmframeeffect) REFERENCES public.cmframeeffect(id) NOT VALID;


--
-- Name: cmcard cmlanguage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmlanguage_fkey FOREIGN KEY (cmlanguage) REFERENCES public.cmlanguage(code) NOT VALID;


--
-- Name: cmset_language cmlanguage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmlanguage_fkey FOREIGN KEY (cmlanguage) REFERENCES public.cmlanguage(code);


--
-- Name: cmcard cmlayout_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmlayout_fkey FOREIGN KEY (cmlayout) REFERENCES public.cmlayout(name) NOT VALID;


--
-- Name: cmcard_format_legality cmlegality_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmlegality_fkey FOREIGN KEY (cmlegality) REFERENCES public.cmlegality(name);


--
-- Name: cmcard cmrarity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmrarity_fkey FOREIGN KEY (cmrarity) REFERENCES public.cmrarity(name) NOT VALID;


--
-- Name: cmrule cmrule_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmrule
    ADD CONSTRAINT cmrule_parent_fkey FOREIGN KEY (cmrule_parent) REFERENCES public.cmrule(id) NOT VALID;


--
-- Name: cmcard cmset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmset_fkey FOREIGN KEY (cmset) REFERENCES public.cmset(code) NOT VALID;


--
-- Name: cmset_language cmset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset_language
    ADD CONSTRAINT cmset_fkey FOREIGN KEY (cmset) REFERENCES public.cmset(code);


--
-- Name: cmset cmset_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmset_parent_fkey FOREIGN KEY (cmset_parent) REFERENCES public.cmset(code) NOT VALID;


--
-- Name: cmset cmsetblock_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmsetblock_fkey FOREIGN KEY (cmsetblock) REFERENCES public.cmsetblock(code) NOT VALID;


--
-- Name: cmset cmsettype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmset
    ADD CONSTRAINT cmsettype_fkey FOREIGN KEY (cmsettype) REFERENCES public.cmsettype(name) NOT VALID;


--
-- Name: cmcard_store_price cmstore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_store_price
    ADD CONSTRAINT cmstore_fkey FOREIGN KEY (cmstore) REFERENCES public.cmstore(name) NOT VALID;


--
-- Name: cmcardprice cmstore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmstore_fkey FOREIGN KEY (cmstore) REFERENCES public.cmstore(name) NOT VALID;


--
-- Name: cmcard cmwatermark_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmwatermark_fkey FOREIGN KEY (cmwatermark) REFERENCES public.cmwatermark(name) NOT VALID;


--
-- PostgreSQL database dump complete
--

