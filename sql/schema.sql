--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-0+deb12u1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-0+deb12u1)

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
-- Name: advancesearchcards(character varying, character varying[], character varying[], character varying[], character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.advancesearchcards(character varying, character varying[], character varying[], character varying[], character varying, character varying) RETURNS TABLE(new_id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, number_order double precision, name character varying, name_section character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, tcgplayer_id integer, released_at date, art_crop_url character varying, normal_url character varying, png_url character varying, set json, rarity json, language json, layout json, colors json[], prices json[], faces json[], supertypes json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _query ALIAS FOR $1;
    _colors ALIAS FOR $2;
    _rarities ALIAS FOR $3;
    _types ALIAS FOR $4;
    _sortedBy ALIAS FOR $5;
    _orderBy ALIAS FOR $6;
    command character varying;
BEGIN
    IF lower(_query) = 'null' THEN
        _query := NULL;
    END IF;

    IF lower(_sortedBy) = 'set_name' THEN
        _sortedBy = 's.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
	IF lower(_sortedBy) = 'set_release' THEN
        _sortedBy = 's.release_date ' || _orderBy || ', s.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
    END IF;
    IF lower(_sortedBy) = 'collector_number' THEN
        _sortedBy = 'c.number_order ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
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
                    c.new_id,
                    c.collector_number,
                    c.face_order,
                    c.loyalty,
                    c.mana_cost,
                    c.number_order,
                    c.name,
                    c.name_section,
                    c.printed_name,
                    c.printed_type_line,
                    c.type_line,
	                c.power,
                    c.toughness,
                    c.tcgplayer_id,
                    c.released_at,
                    c.art_crop_url,
                    c.normal_url,
                    c.png_url,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class, s.keyrune_unicode
                            FROM cmset s WHERE s.code = c.cmset
                            LIMIT 1
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name
                            FROM cmrarity r WHERE r.name = c.cmrarity
                            LIMIT 1
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                            LIMIT 1
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                            LIMIT 1
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_color v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                            LIMIT 10
                        ) x
                    ) AS colors,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                            LIMIT 1
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT
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
                                art_crop_url,
                                normal_url,
                                png_url
                            FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                            ORDER BY face_order
                            LIMIT 10
                        ) x
                    ) AS faces ';

    -- Supertypes
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                            WHERE v.cmcard = c.new_id
                            LIMIT 50
                        ) x
                    ) AS supertypes ';               

    command := command || 'FROM cmcard c ';
    command := command || 'LEFT join cmset s ON c.cmset = s.code ';
    command := command || 'WHERE c.cmlanguage = ''en'' ';
    command := command || 'AND c.new_id NOT IN(select cmcard_face from cmcard_face LIMIT 20) ';

    IF _query IS NOT NULL THEN
         command := command || 'AND lower(c.name) LIKE ''%' || _query || '%'' ';
    END IF;

    IF array_length(_colors, 1) > 0 THEN
        command := command || format('AND c.new_id IN(select cmcard from cmcard_color WHERE cmcolor = ANY(''%s'')) ', _colors);
    END IF;

    IF array_length(_rarities, 1) > 0 THEN
        command := command || format('AND c.cmrarity IN(select name from cmrarity WHERE name = ANY(''%s'') LIMIT 20) ', _rarities);
    END IF;

    IF array_length(_types, 1) > 0 THEN
        command := command || format('AND c.new_id IN(select cmcard from cmcard_supertype WHERE cmcardtype = ANY(''%s'')) ', _types);
    END IF;

    command := command || 'ORDER BY ' || _sortedBy || '';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.advancesearchcards(character varying, character varying[], character varying[], character varying[], character varying, character varying) OWNER TO managuide;

--
-- Name: advancesearchcards(character varying, character varying[], character varying[], character varying[], character varying[], character varying[], character varying, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.advancesearchcards(character varying, character varying[], character varying[], character varying[], character varying[], character varying[], character varying, character varying, integer, integer) RETURNS TABLE(new_id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, number_order double precision, name character varying, name_section character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, tcgplayer_id integer, released_at date, art_crop_url character varying, normal_url character varying, png_url character varying, set json, rarity json, language json, layout json, colors json[], prices json[], faces json[], supertypes json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _query ALIAS FOR $1;
    _colors ALIAS FOR $2;
    _rarities ALIAS FOR $3;
    _types ALIAS FOR $4;
    _keywords ALIAS FOR $5;
    _artists ALIAS FOR $6;
    _sortedBy ALIAS FOR $7;
    _orderBy ALIAS FOR $8;
    _pageSize ALIAS FOR $9;
    _pageOffset ALIAS FOR $10;
    command character varying;
BEGIN
    IF lower(_query) = 'null' THEN
        _query := NULL;
    ELSE
        _query := lower(_query);
    END IF;

    IF lower(_sortedBy) = 'name' THEN
        _sortedBy = 'regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'collector_number' THEN
        _sortedBy = 'c.number_order ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'type' THEN
        _sortedBy = 'c.type_line ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g''), c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'rarity' THEN
        _sortedBy = 'r.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g''), c.released_at DESC';
    END IF;

    command := 'SELECT DISTINCT ON (regexp_replace(c.name, ''"'', '''', ''g''))
                    c.new_id,
                    c.collector_number,
                    c.face_order,
                    c.loyalty,
                    c.mana_cost,
                    c.number_order,
                    c.name,
                    c.name_section,
                    c.printed_name,
                    c.printed_type_line,
                    c.type_line,
	                c.power,
                    c.toughness,
                    c.tcgplayer_id,
                    c.released_at,
                    c.art_crop_url,
                    c.normal_url,
                    c.png_url,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class, s.keyrune_unicode
                            FROM cmset s WHERE s.code = c.cmset
                            LIMIT 1
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name
                            FROM cmrarity r WHERE r.name = c.cmrarity
                            LIMIT 1
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                            LIMIT 1
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                            LIMIT 1
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_color v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                            LIMIT 10
                        ) x
                    ) AS colors,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                            LIMIT 1
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT
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
                                art_crop_url,
                                normal_url,
                                png_url
                            FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                            ORDER BY face_order
                            LIMIT 10
                        ) x
                    ) AS faces ';

    -- Supertypes
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                            WHERE v.cmcard = c.new_id
                            LIMIT 50
                        ) x
                    ) AS supertypes ';               

    command := command || 'FROM cmcard c ';
    -- command := command || 'WHERE c.cmlanguage = ''en'' ';
    command := command || 'WHERE c.new_id NOT IN(select cmcard_face from cmcard_face LIMIT 20) ';

    IF _query IS NOT NULL THEN
         command := command || 'AND lower(c.name) LIKE ''%' || _query || '%'' ';
    END IF;

    IF array_length(_colors, 1) > 0 THEN
        command := command || format('AND c.new_id IN(select cmcard from cmcard_color WHERE cmcolor = ANY(''%s'')) ', _colors);
    END IF;

    IF array_length(_rarities, 1) > 0 THEN
        command := command || format('AND c.cmrarity IN(select name from cmrarity WHERE name = ANY(''%s'') LIMIT 20) ', _rarities);
    END IF;

    IF array_length(_types, 1) > 0 THEN
        command := command || format('AND c.new_id IN(select cmcard from cmcard_supertype WHERE cmcardtype = ANY(''%s'')) ', _types);
    END IF;

    IF array_length(_keywords, 1) > 0 THEN
        command := command || format('AND c.new_id IN(select cmcard from cmcard_keyword WHERE cmkeyword = ANY(''%s'')) ', _keywords);
    END IF;

    IF array_length(_artists, 1) > 0 THEN
        command := command || format('AND c.new_id IN(select cmcard from cmcard_artist WHERE cmartist = ANY(''%s'')) ', _artists);
    END IF;

    command := command || 'ORDER BY ' || _sortedBy || ' ';
    command := command || 'LIMIT ' || _pageSize || ' OFFSET ' || _pageOffset || '';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.advancesearchcards(character varying, character varying[], character varying[], character varying[], character varying[], character varying[], character varying, character varying, integer, integer) OWNER TO managuide;

--
-- Name: createorupdateartist(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdateartist(character varying, character varying, character varying, character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _first_name ALIAS FOR $2;
    _last_name ALIAS FOR $3;
    _name_section ALIAS FOR $4;
    _info ALIAS FOR $5;

    row cmartist%ROWTYPE;
    _new_info character varying;

BEGIN
    -- check for nulls
    IF lower(_first_name) = 'null' THEN
        _first_name := NULL;
    END IF;
    IF lower(_last_name) = 'null' THEN
        _last_name := NULL;
    END IF;
    IF lower(_name_section) = 'null' THEN
        _name_section := NULL;
    END IF;
    IF lower(_info) = 'null' THEN
        _info := NULL;
    END IF;

    SELECT * INTO row FROM cmartist
        WHERE name = _name
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmartist(
            name,
            first_name,
            last_name,
            name_section,
            info)
        VALUES(
            _name,
            _first_name,
            _last_name,
            _name_section,
            _info);
    ELSE
        IF row.first_name IS DISTINCT FROM _first_name OR
           row.last_name IS DISTINCT FROM _last_name OR
           row.name_section IS DISTINCT FROM _name_section OR
           row.info IS DISTINCT FROM _info THEN
            IF row.info IS NULL THEN
                _new_info := _info;
            ELSE
                IF _info IS NULL THEN
                    _new_info := NULL;
                ELSE
                    IF right(row.info, char_length(_info)) <> _info THEN
                        _new_info := row.info || '; ' || _info;
                    END IF;
                END IF;
            END IF;

            UPDATE cmartist SET
                name = _name,
                first_name = _first_name,
                last_name = _last_name,
                name_section = _name_section,
                info = _new_info,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdateartist(character varying, character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying[], character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[]); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying[], character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[]) RETURNS void
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

    -- row types
    rowCard cmcard%ROWTYPE;
    rowSetLanguage cmset_language%ROWTYPE;
    rowArtist cmcard_artist%ROWTYPE;
    rowFrameEffect cmcard_frameeffect%ROWTYPE;
    rowColor cmcard_color%ROWTYPE;
    rowColorIndentity cmcard_coloridentity%ROWTYPE;
    rowColorIndicator cmcard_colorindicator%ROWTYPE;
    rowFormatLegality cmcard_format_legality%ROWTYPE;
    rowSubtype cmcard_subtype%ROWTYPE;
    rowSupertype cmcard_supertype%ROWTYPE;
    rowGame cmcard_game%ROWTYPE;
    rowKeyword cmcard_keyword%ROWTYPE;

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

    SELECT * INTO rowCard FROM cmcard
        WHERE new_id = _new_id
        LIMIT 1;

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
        SELECT * INTO rowSetLanguage FROM cmset_language
            WHERE cmset = _cmset AND cmlanguage = _cmlanguage
            LIMIT 1;

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

     -- artists
    IF _cmartists IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmartists LOOP
            SELECT * INTO rowArtist FROM cmcard_artist
                WHERE cmcard = _new_id AND cmartist = pkey
                LIMIT 1;

            IF NOT FOUND THEN
                INSERT INTO cmcard_artist(
                    cmcard,
                    cmartist
                ) VALUES (
                    _new_id,
                    pkey
                );
            END IF;    
        END LOOP;
    END IF;

    -- frame effects
    IF _cmframeeffects IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmframeeffects LOOP
            SELECT * INTO rowFrameEffect FROM cmcard_frameeffect
                WHERE cmcard = _new_id AND cmframeeffect = pkey
                LIMIT 1;

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
            SELECT * INTO rowColor FROM cmcard_color
                WHERE cmcard = _new_id AND cmcolor = pkey
                LIMIT 1;

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
            SELECT * INTO rowColorIndentity FROM cmcard_coloridentity
                WHERE cmcard = _new_id AND cmcolor = pkey
                LIMIT 1;

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
            SELECT * INTO rowColorIndicator FROM cmcard_colorindicator
                WHERE cmcard = _new_id AND cmcolor = pkey
                LIMIT 1;

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
            SELECT * INTO rowFormatLegality FROM cmcard_format_legality
                WHERE cmcard = _new_id AND cmformat = pkey2 AND cmlegality = pkey3
                LIMIT 1;

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
            SELECT * INTO rowSubtype FROM cmcard_subtype
                WHERE cmcard = _new_id AND cmcardtype = pkey
                LIMIT 1;

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
            SELECT * INTO rowSupertype FROM cmcard_supertype
               WHERE cmcard = _new_id AND cmcardtype = pkey
               LIMIT 1;

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

    -- games
    IF _cmgames IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmgames LOOP
            SELECT * INTO rowGame FROM cmcard_game
               WHERE cmcard = _new_id AND cmgame = pkey
               LIMIT 1;

            IF NOT FOUND THEN
                INSERT INTO cmcard_game(
                    cmcard,
                    cmgame
                ) VALUES (
                    _new_id,
                    pkey
                );
            END IF;    
        END LOOP;
    END IF;

    -- keywords
    IF _cmkeywords IS NOT NULL THEN
        FOREACH pkey IN ARRAY _cmkeywords LOOP
            SELECT * INTO rowKeyword FROM cmcard_keyword
               WHERE cmcard = _new_id AND cmkeyword = pkey
               LIMIT 1;

            IF NOT FOUND THEN
                INSERT INTO cmcard_keyword(
                    cmcard,
                    cmkeyword
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


ALTER FUNCTION public.createorupdatecard(character varying, double precision, character varying, boolean, boolean, boolean, boolean, boolean, boolean, boolean, character varying, character varying, integer[], character varying, double precision, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, character varying, boolean, character varying, boolean, character varying[], character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[], character varying[], character varying[], jsonb, character varying, character varying, character varying[], character varying[], integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying[], character varying[]) OWNER TO managuide;

--
-- Name: createorupdatecardfaces(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
        AND cmcard_face = _cmcard_face
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatecardfaces(character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatecardotherlanguages(); Type: FUNCTION; Schema: public; Owner: managuide
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
            SELECT * INTO rowOtherLanguage FROM cmcard_otherlanguage
                WHERE cmcard = row.new_id AND cmcard_otherlanguage = row2.new_id
                LIMIT 1;

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


ALTER FUNCTION public.createorupdatecardotherlanguages() OWNER TO managuide;

--
-- Name: createorupdatecardotherprintings(); Type: FUNCTION; Schema: public; Owner: managuide
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
            SELECT * INTO rowOtherPrinting FROM cmcard_otherprinting
                WHERE cmcard = row.new_id AND cmcard_otherprinting = row2.new_id
                LIMIT 1;

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


ALTER FUNCTION public.createorupdatecardotherprintings() OWNER TO managuide;

--
-- Name: createorupdatecardparts(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
        WHERE id = _cmcard_part
        LIMIT 1;

    SELECT * INTO row FROM cmcard_component_part
        WHERE cmcard = _cmcard
        AND cmcomponent = _cmcomponent
        AND cmcard_part = cmcard_part_new_id
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatecardparts(character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatecardprice(double precision, double precision, double precision, double precision, double precision, integer, boolean); Type: FUNCTION; Schema: public; Owner: managuide
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

    SELECT new_id INTO _new_id FROM cmcard
        WHERE tcgplayer_id = _tcgplayer_id
        LIMIT 1;

    IF FOUND THEN
        SELECT * INTO row FROM cmcardprice
            WHERE cmcard = _new_id AND
                is_foil = _is_foil
                LIMIT 1;

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


ALTER FUNCTION public.createorupdatecardprice(double precision, double precision, double precision, double precision, double precision, integer, boolean) OWNER TO managuide;

--
-- Name: createorupdatecardtype(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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

    SELECT * INTO row FROM cmcardtype
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatecardtype(character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatecardvariations(); Type: FUNCTION; Schema: public; Owner: managuide
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
        -- LIMIT 200
    LOOP
        FOR row2 IN SELECT new_id FROM cmcard c
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                new_id IS DISTINCT FROM row.new_id AND
                cmset = row.cmset AND
                c.name = row.name AND
                cmlanguage = row.cmlanguage
            ORDER BY s.release_date, c.name
            -- LIMIT 100
        LOOP
            SELECT * INTO rowVariation FROM cmcard_variation
                WHERE cmcard = row.new_id AND cmcard_variation = row2.new_id
                LIMIT 1;

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


ALTER FUNCTION public.createorupdatecardvariations() OWNER TO managuide;

--
-- Name: createorupdatecolor(character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: managuide
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
    SELECT * INTO row FROM cmcolor WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatecolor(character varying, character varying, character varying, boolean) OWNER TO managuide;

--
-- Name: createorupdatecomponent(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatecomponent(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmcomponent%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmcomponent
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatecomponent(character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdateformat(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdateformat(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmformat%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmformat
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdateformat(character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdateframe(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
    SELECT * INTO row FROM cmframe
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdateframe(character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdateframeeffect(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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

    SELECT * INTO row FROM cmframeeffect
        WHERE id = _id
        LIMIT 1;

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


ALTER FUNCTION public.createorupdateframeeffect(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdategame(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdategame(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmgame%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmgame
        WHERE name = _name
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmgame(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
        
            UPDATE cmgame SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdategame(character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatekeyword(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatekeyword(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmkeyword%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmkeyword
        WHERE name = _name
        LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO cmkeyword(
            name,
            name_section)
        VALUES(
            _name,
            _name_section);
    ELSE
        IF row.name IS DISTINCT FROM _name OR
           row.name_section IS DISTINCT FROM _name_section THEN
        
            UPDATE cmkeyword SET
                name = _name,
                name_section = _name_section,
                date_updated = now()
            WHERE name = _name;
        END IF;    
    END IF;

    RETURN;
END;
$_$;


ALTER FUNCTION public.createorupdatekeyword(character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatelanguage(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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

    SELECT * INTO row FROM cmlanguage
        WHERE code = _code
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatelanguage(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatelayout(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
    SELECT * INTO row FROM cmlayout
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatelayout(character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatelegality(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatelegality(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmlegality%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmlegality
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatelegality(character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdaterarity(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdaterarity(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmrarity%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmrarity
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdaterarity(character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdaterule(character varying, character varying, character varying, double precision, integer, integer); Type: FUNCTION; Schema: public; Owner: managuide
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
        "order" = _order
        LIMIT 1;

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


ALTER FUNCTION public.createorupdaterule(character varying, character varying, character varying, double precision, integer, integer) OWNER TO managuide;

--
-- Name: createorupdateruling(character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: managuide
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
    SELECT * INTO row FROM cmruling
        WHERE oracle_id = _oracle_id
        LIMIT 1;

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


ALTER FUNCTION public.createorupdateruling(character varying, character varying, date) OWNER TO managuide;

--
-- Name: createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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

    SELECT * INTO row FROM cmset
        WHERE code = _code
        LIMIT 1;

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
            SELECT * INTO parent_row FROM cmset
                WHERE code = _cmset_parent
                LIMIT 1;

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


ALTER FUNCTION public.createorupdateset(integer, character varying, boolean, boolean, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatesetblock(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
    SELECT * INTO row FROM cmsetblock
        WHERE code = _code
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatesetblock(character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatesettype(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatesettype(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmartist%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmsettype
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatesettype(character varying, character varying) OWNER TO managuide;

--
-- Name: createorupdatewatermark(character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.createorupdatewatermark(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _name ALIAS FOR $1;
    _name_section ALIAS FOR $2;

    row cmwatermark%ROWTYPE;
BEGIN
    SELECT * INTO row FROM cmwatermark
        WHERE name = _name
        LIMIT 1;

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


ALTER FUNCTION public.createorupdatewatermark(character varying, character varying) OWNER TO managuide;

--
-- Name: createserverupdate(boolean); Type: FUNCTION; Schema: public; Owner: managuide
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


ALTER FUNCTION public.createserverupdate(boolean) OWNER TO managuide;

--
-- Name: deletecard(character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
    DELETE from cmcard_subtype WHERE cmcard = _new_id;
    DELETE from cmcard_supertype WHERE cmcard = _new_id;
    DELETE from cmcardprice WHERE cmcard = _new_id;
	DELETE from cmcard_variation WHERE cmcard = _new_id;
    DELETE from cmcard_game WHERE cmcard = _new_id;
    DELETE from cmcard_artist WHERE cmcard = _new_id;
    DELETE from cmcard_keyword WHERE cmcard = _new_id;
    DELETE from cmcard WHERE new_id = _new_id;

    RETURN true;
END;
$_$;


ALTER FUNCTION public.deletecard(character varying) OWNER TO managuide;

--
-- Name: deleteset(character varying); Type: FUNCTION; Schema: public; Owner: managuide
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


ALTER FUNCTION public.deleteset(character varying) OWNER TO managuide;

--
-- Name: searchcards(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
        _sortedBy = 'c.number_order ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'name' THEN
        _sortedBy = 'regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'cmc' THEN
        _sortedBy = 'c.cmc ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'type' THEN
        _sortedBy = 'c.type_line ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;
    IF lower(_sortedBy) = 'rarity' THEN
        _sortedBy = 'r.name ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy || ', c.released_at DESC';
    END IF;

    command := 'SELECT DISTINCT ON (regexp_replace(c.name, ''"'', '''', ''g''))
                    c.new_id,
                    c.collector_number,
                    c.face_order,
                    c.loyalty,
                    c.mana_cost,
                    c.number_order,
                    c.name,
                    c.name_section,
                    c.printed_name,
                    c.printed_type_line,
                    c.type_line,
	                c.power,
                    c.toughness,
                    c.tcgplayer_id,
                    c.released_at,
                    c.art_crop_url,
                    c.normal_url,
                    c.png_url,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class, s.keyrune_unicode
                            FROM cmset s WHERE s.code = c.cmset
                            LIMIT 1
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name
                            FROM cmrarity r WHERE r.name = c.cmrarity
                            LIMIT 1
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                            LIMIT 1
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                            LIMIT 1
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                            LIMIT 1
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT
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
                                art_crop_url,
                                normal_url,
                                png_url
                            FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                            ORDER BY face_order
                            LIMIT 10
                        ) x
                    ) AS faces ';

    -- Supertypes
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                            WHERE v.cmcard = c.new_id
                            LIMIT 50
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


ALTER FUNCTION public.searchcards(character varying, character varying, character varying) OWNER TO managuide;

--
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
-- Name: selectcard(character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
                            LIMIT 1
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
                            FROM cmrarity v
                            WHERE v.name = c.cmrarity
                            LIMIT 1
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.code, v.name
                            FROM cmlanguage v
                            WHERE v.code = c.cmlanguage
                            LIMIT 1
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                            LIMIT 1
                        ) x
                    ) AS layout,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
                            FROM cmwatermark v
                            WHERE v.name = c.cmwatermark
                            LIMIT 1
                        ) x
                    ) AS watermark,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
                            FROM cmframe v
                            WHERE v.name = c.cmframe
                            LIMIT 1
                        ) x
                    ) AS frame,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name
                            FROM cmartist v
                            WHERE v.name = c.cmartist
                            LIMIT 10
                        ) x
                    ) AS artist,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_color v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                            LIMIT 10
                        ) x
                    ) AS colors,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_coloridentity v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                            LIMIT 10
                        ) x
                    ) AS color_identities,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_colorindicator v left join cmcolor w on v.cmcolor = w.symbol
                            WHERE v.cmcard = c.new_id
                            LIMIT 10
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
                                            LIMIT 1
                                        ) x
                                    ) AS set,
                                    (
                                        SELECT row_to_json(x) FROM (
                                            SELECT v.code, v.name
                                            FROM cmlanguage v
                                            WHERE v.code = x.cmlanguage
                                            LIMIT 1
                                        ) x
                                    ) AS language,
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
                                            WHERE w.cmcard = x.new_id
                                            LIMIT 100
                                        ) x
                                    ) AS faces
								)
							b) AS card
                            FROM cmcard_component_part v left join cmcomponent w on v.cmcomponent = w.name
							left join cmcard x on v.cmcard_part = x.new_id
                            WHERE v.cmcard = c.new_id AND v.cmcard_part != c.new_id
                            LIMIT 100
                        ) x
                    ) AS component_parts ';
    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' || command ||
                            'FROM cmcard c left join cmcard_face w on w.cmcard_face = c.new_id
                            WHERE w.cmcard = ''' || _new_id || '''' ||
                        ' LIMIT 10) x
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
                                        LIMIT 1
                                    ) x
                                ) AS rarity,
                                (
                                    SELECT row_to_json(x) FROM (
                                        SELECT v.code, v.display_code, v.name
                                        FROM cmlanguage v
                                        WHERE v.code = w.code
                                        LIMIT 1
                                    ) x
                                ) AS language,
                                (
                                    SELECT row_to_json(x) FROM (
                                        SELECT y.code, y.name, y.keyrune_class, y.keyrune_unicode
                                        FROM cmset y
                                        WHERE y.code = c.cmset
                                        LIMIT 1
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
                                        LIMIT 100
                                    ) x
                                ) AS faces
                            FROM cmcard c left join cmlanguage w on w.code = cmlanguage
                            left join cmcard_otherlanguage x on x.cmcard_otherlanguage = c.new_id
                            WHERE x.cmcard = ''' || _new_id || '''' || ' and x.cmcard_otherlanguage LIKE ''%' || _collector_number || '''' ||
                            ' group by w.code, x.cmcard_otherlanguage, c.cmset, c.name, c.printed_name, c.cmrarity, c.collector_number,
                              c.art_crop_url, c.normal_url, c.png_url 
							 order by w.code
                             LIMIT 50
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
                                        LIMIT 1
                                    ) x
                                ) AS rarity,
								(
                                    SELECT row_to_json(x) FROM (
                                        SELECT y.code, y.name, y.keyrune_class, y.keyrune_unicode
                                        FROM cmset y
                                        WHERE y.code = c.cmset
                                        LIMIT 1
                                    ) x
                                ) AS set,
								array(
                                    SELECT row_to_json(x) FROM (
                                        SELECT new_id, art_crop_url, normal_url, png_url
                                        FROM cmcard c left join cmcard_face w on w.cmcard_face = c.new_id
                                        WHERE w.cmcard = x.cmcard_otherprinting
                                        LIMIT 100
                                    ) x
                                ) AS faces,
                                array(
                                    SELECT row_to_json(x) FROM (
                                        SELECT id, v.market, v.is_foil
                                        FROM cmcardprice v
                                        WHERE v.cmcard = c.new_id
                                        LIMIT 1
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
                            LIMIT 10
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
                                    LIMIT 1
                                ) x
                            ) AS rarity,
                            (
                                SELECT row_to_json(x) FROM (
                                    SELECT y.code, y.name, y.keyrune_class, y.keyrune_unicode
                                    FROM cmset y
                                    WHERE y.code = c.cmset
                                    LIMIT 1
                                ) x
                            ) AS set,
                            (
                                SELECT row_to_json(x) FROM (
                                    SELECT v.code, v.name
                                    FROM cmlanguage v
                                    WHERE v.code = c.cmlanguage
                                    LIMIT 1
                                ) x
                            ) AS language
                        FROM cmcard c left join cmcard_variation w on w.cmcard_variation = c.new_id
                        WHERE w.cmcard = ''' || _new_id || '''' ||
                        ' order by c.collector_number
                        LIMIT 50
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
                        LIMIT 50
                    ) x
                ) AS format_legalities ';

    -- Frame Effects
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.description, w.id, w.name
                        FROM cmcard_frameeffect v left join cmframeeffect w on v.cmframeeffect = w.id
                        WHERE v.cmcard = c.new_id
                        LIMIT 50
                    ) x
                ) AS frame_effects ';

    -- Subtypes
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.name
                        FROM cmcard_subtype v left join cmcardtype w on v.cmcardtype = w.name
                        WHERE v.cmcard = c.new_id
                        LIMIT 50
                    ) x
                ) AS subtypes ';

    -- Supertypes
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT w.name
                        FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                        WHERE v.cmcard = c.new_id
                        LIMIT 50
                    ) x
                ) AS supertypes ';

    -- Prices
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                        FROM cmcardprice v
                        WHERE v.cmcard = c.new_id
                        LIMIT 1
                    ) x
                ) AS prices ';

	-- Rulings
    command := command ||
               ', array(
                    SELECT row_to_json(x) FROM (
                        SELECT v.id, v.date_published, v.text
                        FROM cmruling v
                        WHERE v.oracle_id = c.oracle_id
                        LIMIT 100
                    ) x
                ) AS rulings ';

    command := command || 'FROM cmcard c WHERE c.new_id = ''' || _new_id || '''';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectcard(character varying) OWNER TO managuide;

--
-- Name: selectcards(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
        _sortedBy = 'c.number_order ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
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
                            LIMIT 1
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name
                            FROM cmrarity r WHERE r.name = c.cmrarity
                            LIMIT 1
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                            LIMIT 1
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                            LIMIT 1
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                            LIMIT 1
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT
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
                                art_crop_url,
                                normal_url,
                                png_url
                            FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                            ORDER BY face_order
                            LIMIT 10
                        ) x
                    ) AS faces ';

    -- Supertypes
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                            WHERE v.cmcard = c.new_id
                            LIMIT 50
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


ALTER FUNCTION public.selectcards(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: selectotherprintings(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.selectotherprintings(character varying, character varying, character varying, character varying) RETURNS TABLE(new_id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, my_name_section character varying, my_number_order double precision, name character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, tcgplayer_id integer, released_at date, set json, rarity json, language json, layout json, prices json[], faces json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _newId ALIAS FOR $1;
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
        _sortedBy = 'c.number_order ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
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
                    c.my_name_section,
                    my_number_order,
                    c.name,
                    printed_name,
                    printed_type_line,
                    type_line,
	                power,
                    toughness,
                    c.tcgplayer_id,
                    released_at,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class, s.keyrune_unicode
                            FROM cmset s WHERE s.code = c.cmset
                            LIMIT 1
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name, r.name_section
                            FROM cmrarity r WHERE r.name = c.cmrarity
                            LIMIT 1
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                            LIMIT 1
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.name_section, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                            LIMIT 1
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                            LIMIT 1
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command ||
                            'FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                            LIMIT 100
                        ) x
                    ) AS faces ';

    command := command || 'FROM cmcard c LEFT JOIN cmset s ON c.cmset = s.code ';
	command := command || 'LEFT JOIN cmrarity r ON c.cmrarity = r.name ';
    command := command || 'WHERE c.new_id = ''' || _newId || ''' ';
    command := command || 'AND c.cmlanguage = ''' || _cmlanguage || ''' ';
    command := command || 'AND c.new_id NOT IN(select cmcard_face from cmcard_face) ';
    command := command || 'ORDER BY ' || _sortedBy || ' LIMIT 200';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectotherprintings(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: selectprintings(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.selectprintings(character varying, character varying, character varying, character varying) RETURNS TABLE(new_id character varying, collector_number character varying, face_order integer, loyalty character varying, mana_cost character varying, number_order double precision, name character varying, name_section character varying, printed_name character varying, printed_type_line character varying, type_line character varying, power character varying, toughness character varying, tcgplayer_id integer, released_at date, art_crop_url character varying, normal_url character varying, png_url character varying, set json, rarity json, language json, layout json, prices json[], faces json[], supertypes json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _newId ALIAS FOR $1;
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
        _sortedBy = 'c.number_order ' || _orderBy || ', regexp_replace(c.name, ''"'', '''', ''g'') ' || _orderBy;
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
                    c.new_id,
                    c.collector_number,
                    c.face_order,
                    c.loyalty,
                    c.mana_cost,
                    c.number_order,
                    c.name,
                    c.name_section,
                    c.printed_name,
                    c.printed_type_line,
                    c.type_line,
	                c.power,
                    c.toughness,
                    c.tcgplayer_id,
                    c.released_at,
                    c.art_crop_url,
                    c.normal_url,
                    c.png_url,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT s.code, s.name, s.keyrune_class, s.keyrune_unicode
                            FROM cmset s WHERE s.code = c.cmset
                            LIMIT 1
                        ) x
                    ) AS set,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT r.name
                            FROM cmrarity r WHERE r.name = c.cmrarity
                            LIMIT 1
                        ) x
                    ) AS rarity,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.name
                            FROM cmlanguage l WHERE l.code = c.cmlanguage
                            LIMIT 1
                        ) x
                    ) AS language,
                    (
                        SELECT row_to_json(x) FROM (
                            SELECT v.name, v.description
                            FROM cmlayout v
                            WHERE v.name = c.cmlayout
                            LIMIT 1
                        ) x
                    ) AS layout,
                    array(
                        SELECT row_to_json(x) FROM (
                            SELECT v.id, v.low, v.median, v.high, v.market, v.direct_low, v.is_foil, v.date_updated
                            FROM cmcardprice v
                            WHERE v.cmcard = c.new_id
                            LIMIT 100
                        ) x
                    ) AS prices ';

    -- Faces
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' || command ||
                            'FROM cmcard d left join cmcard_face w on w.cmcard_face = d.new_id
                            WHERE w.cmcard = c.new_id
                            LIMIT 100
                        ) x
                    ) AS faces ';

    -- Supertypes
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (
                            SELECT w.name
                            FROM cmcard_supertype v left join cmcardtype w on v.cmcardtype = w.name
                            WHERE v.cmcard = c.new_id
                            LIMIT 100
                        ) x
                    ) AS supertypes ';   

    -- FROM cmcard c
    --                         left join cmcard_otherprinting x on x.cmcard_otherprinting = c.new_id
    --                         left join cmset y on y.code = c.cmset
    --                         WHERE x.cmcard = ''' || _new_id || '''' ||
    --                         ' order by y.release_date desc, c.collector_number

    command := command || 'FROM cmcard c left join cmcard_otherprinting x on x.cmcard_otherprinting = c.new_id ';
	command := command || 'left join cmset s on s.code = c.cmset ';
    command := command || 'WHERE x.cmcard = ''' || _newId || ''' ';
    command := command || 'AND c.cmlanguage = ''' || _cmlanguage || ''' ';
    command := command || 'ORDER BY ' || _sortedBy || '';


    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectprintings(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
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
                            FROM cmrule p WHERE p.id = s.cmrule_parent LIMIT 100
                        ) x
                    ) AS parent';

    -- Children
    command := command ||
                    ', array(
                        SELECT row_to_json(x) FROM (' ||
                            command || ', (SELECT children from selectRules(c.id))'
                            ' FROM cmrule c
                            WHERE c.cmrule_parent = s.id ORDER BY c.term LIMIT 100'
                        ') x
                    ) AS children ';
                    
    command := command ||                
                    'FROM cmrule s';

    IF _id IS NOT NULL THEN
        command := command || ' WHERE s.id = ' || _id || '';
    ELSE
	    command := command || ' WHERE s.cmrule_parent IS NULL';
    END IF;

    command := command || ' ORDER BY s.order ASC LIMIT 100';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectrules(integer) OWNER TO managuide;

--
-- Name: selectset(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: managuide
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
                            LIMIT 1
                        ) x
                   ) AS set_block,
                   (
                       SELECT row_to_json(x) FROM (
                            SELECT st.name
                            FROM cmsettype st WHERE st.name = s.cmsettype
                            LIMIT 1
                        ) x
                   ) AS set_type,
                   array(
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.display_code, l.name
                            FROM cmset_language sl left join cmlanguage l on sl.cmlanguage = l.code
                            WHERE sl.cmset = s.code
                            LIMIT 100
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


ALTER FUNCTION public.selectset(character varying, character varying, character varying, character varying) OWNER TO managuide;

--
-- Name: selectsets(); Type: FUNCTION; Schema: public; Owner: managuide
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
                            LIMIT 1
                        ) x
                   ) AS set_block,
                   (
                       SELECT row_to_json(x) FROM (
                            SELECT st.name
                            FROM cmsettype st WHERE st.name = s.cmsettype
                            LIMIT 1
                        ) x
                   ) AS set_type,
                   array(
                        SELECT row_to_json(x) FROM (
                            SELECT l.code, l.display_code, l.name
                            FROM cmset_language sl left join cmlanguage l on sl.cmlanguage = l.code
                            WHERE sl.cmset = s.code
                            LIMIT 100
                        ) x
	               ) AS languages
                    FROM cmset s WHERE s.card_count > 0';


    command := command || ' GROUP BY cmset_parent, card_count, code';
    command := command || ' ORDER BY release_date DESC, cmset_parent DESC, name ASC';

    
    RETURN QUERY EXECUTE command;
END;
$$;


ALTER FUNCTION public.selectsets() OWNER TO managuide;

--
-- Name: selectsets(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.selectsets(character varying, integer, integer) RETURNS TABLE(page integer, page_limit integer, page_count integer, row_count integer, data json[])
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    _page ALIAS FOR $2;
    _page_limit ALIAS FOR $3;
    dataCommand character varying;
    pageCommand character varying;
    command     character varying;
BEGIN
    dataCommand := 'SELECT card_count,
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
                    cmset_parent,
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
            FROM cmset s WHERE s.card_count > 0 ';

    IF _page = 1 THEN
        pageCommand := 'LIMIT ' || _page_limit;
    ELSE
        pageCommand := 'OFFSET ' || (_page - 1) * _page_limit || ' LIMIT ' || _page_limit;
    END IF;

    IF _code IS NOT NULL THEN
        dataCommand := dataCommand || ' AND s.code = ''' || _code || ''' ORDER BY s.name ASC ' || pageCommand;
    ELSE
        dataCommand := dataCommand || ' ORDER BY s.release_date DESC, s.name ASC ' || pageCommand;
    END IF;


    command := 'SELECT ' || _page || ',' || _page_limit ||
           ', (count(*)::integer / 100) + (CASE WHEN (count(*)::integer / 100) > 0 THEN 1 ELSE 0 END),
           count(*)::integer,
           array(SELECT row_to_json(x) FROM (' || dataCommand || ') x) AS data
           FROM cmset
           WHERE card_count > 0 ';

    RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectsets(character varying, integer, integer) OWNER TO managuide;

--
-- Name: selectsubsets(character varying); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.selectsubsets(character varying) RETURNS TABLE(card_count integer, cmset_parent character varying, parent_level integer, code character varying, is_foil_only boolean, is_online_only boolean, mtgo_code character varying, keyrune_unicode character varying, keyrune_class character varying, my_name_section character varying, my_year_section character varying, name character varying, release_date character varying, tcgplayer_id integer)
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _code ALIAS FOR $1;
    command     character varying;
BEGIN
    IF lower(_code) = 'null' THEN
        _code := NULL;
    END IF;
	
    command :=
	'WITH RECURSIVE sets AS (
        SELECT card_count,
		       cmset_parent,
			   1 as parent_level,
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
               tcgplayer_id
		from cmset where cmset_parent = ''' || _code || '''
    UNION ALL
        SELECT b.card_count,
		       b.cmset_parent,
			   sets.parent_level + 1 AS parent_level,
	           b.code,
	           b.is_foil_only,
	           b.is_online_only,
	           b.mtgo_code,
	           b.keyrune_unicode,
	           b.keyrune_class,
	           b.my_name_section,
	           b.my_year_section,
               b.name,
               b.release_date,
               b.tcgplayer_id
		from cmset b
        JOIN sets ON b.cmset_parent = sets.code 
)
SELECT * FROM sets;';

	RETURN QUERY EXECUTE command;
END;
$_$;


ALTER FUNCTION public.selectsubsets(character varying) OWNER TO managuide;

--
-- Name: updatesetscardcount(); Type: FUNCTION; Schema: public; Owner: managuide
--

CREATE FUNCTION public.updatesetscardcount() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    _card_count integer := 0;
    row RECORD;
BEGIN
    FOR row IN SELECT cmset, cmlanguage, card_count FROM cmset_language
        ORDER BY cmset, cmlanguage
    LOOP
        SELECT count(new_id) INTO _card_count FROM cmcard c
        WHERE c.cmset = row.cmset AND c.cmlanguage = row.cmlanguage;
        
        RAISE NOTICE 'Updating %_% to %', row.cmset, row.cmlanguage, _card_count;

        UPDATE cmset_language SET
            card_count = _card_count,
            date_updated = now()
        WHERE cmset = row.cmset AND cmlanguage = row.cmlanguage;

    END LOOP;

	RETURN;
END;
$$;


ALTER FUNCTION public.updatesetscardcount() OWNER TO managuide;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cmartist; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmartist (
    first_name character varying,
    last_name character varying,
    name_section character varying,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    name character varying NOT NULL,
    info character varying
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
-- Name: cmcard_artist; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_artist (
    cmcard character varying NOT NULL,
    cmartist character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_artist OWNER TO managuide;

--
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
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_frameeffect OWNER TO managuide;

--
-- Name: cmcard_game; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_game (
    cmcard character varying NOT NULL,
    cmgame character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_game OWNER TO managuide;

--
-- Name: cmcard_keyword; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmcard_keyword (
    cmcard character varying NOT NULL,
    cmkeyword character varying NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcard_keyword OWNER TO managuide;

--
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
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
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
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cmcardtype OWNER TO managuide;

--
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
-- Name: cmgame; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmgame (
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    name character varying NOT NULL,
    name_section character varying
);


ALTER TABLE public.cmgame OWNER TO managuide;

--
-- Name: cmkeyword; Type: TABLE; Schema: public; Owner: managuide
--

CREATE TABLE public.cmkeyword (
    date_created timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now(),
    name character varying NOT NULL,
    name_section character varying
);


ALTER TABLE public.cmkeyword OWNER TO managuide;

--
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
-- Name: serverupdate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: managuide
--

ALTER SEQUENCE public.serverupdate_id_seq OWNED BY public.serverupdate.id;


--
-- Name: cmcard_format_legality id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality ALTER COLUMN id SET DEFAULT nextval('public.cmcard_format_legality_id_seq'::regclass);


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
-- Name: serverupdate id; Type: DEFAULT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.serverupdate ALTER COLUMN id SET DEFAULT nextval('public.serverupdate_id_seq'::regclass);


--
-- Name: cmartist cmartist_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmartist
    ADD CONSTRAINT cmartist_pkey PRIMARY KEY (name);


--
-- Name: cmcard_artist cmcard_artist_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_artist
    ADD CONSTRAINT cmcard_artist_pkey PRIMARY KEY (cmcard, cmartist);


--
-- Name: cmcard_color cmcard_color_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_color_pkey PRIMARY KEY (cmcard, cmcolor);


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
    ADD CONSTRAINT cmcard_component_part_pkey PRIMARY KEY (cmcard, cmcomponent, cmcard_part);


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
-- Name: cmcard_game cmcard_game_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_game
    ADD CONSTRAINT cmcard_game_pkey PRIMARY KEY (cmcard, cmgame);


--
-- Name: cmcard_keyword cmcard_keyword_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_keyword
    ADD CONSTRAINT cmcard_keyword_pkey PRIMARY KEY (cmcard, cmkeyword);


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
    ADD CONSTRAINT cmcard_pkey PRIMARY KEY (new_id);


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
-- Name: cmgame cmgame_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmgame
    ADD CONSTRAINT cmgame_pkey PRIMARY KEY (name);


--
-- Name: cmkeyword cmkeyword_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmkeyword
    ADD CONSTRAINT cmkeyword_pkey PRIMARY KEY (name);


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
-- Name: cmwatermark cmwatermark_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmwatermark
    ADD CONSTRAINT cmwatermark_pkey PRIMARY KEY (name);


--
-- Name: serverupdate serverupdate_pkey; Type: CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.serverupdate
    ADD CONSTRAINT serverupdate_pkey PRIMARY KEY (id);


--
-- Name: cmartist_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmartist_name_index ON public.cmartist USING btree (name varchar_ops);


--
-- Name: cmcard_cmartist_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmartist_index ON public.cmcard USING btree (cmartist varchar_pattern_ops) INCLUDE (cmartist);


--
-- Name: cmcard_cmframe_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmframe_index ON public.cmcard USING btree (cmframe varchar_pattern_ops) INCLUDE (cmframe);


--
-- Name: cmcard_cmlanguage_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmlanguage_index ON public.cmcard USING btree (cmlanguage varchar_pattern_ops) INCLUDE (cmlanguage);


--
-- Name: cmcard_cmlayout_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmlayout_index ON public.cmcard USING btree (cmlayout varchar_pattern_ops) INCLUDE (cmlayout);


--
-- Name: cmcard_cmrarity_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmrarity_index ON public.cmcard USING btree (cmrarity varchar_pattern_ops) INCLUDE (cmrarity);


--
-- Name: cmcard_cmset_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmset_index ON public.cmcard USING btree (cmset varchar_pattern_ops) INCLUDE (cmset);


--
-- Name: cmcard_cmwatermark_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_cmwatermark_index ON public.cmcard USING btree (cmwatermark varchar_pattern_ops) INCLUDE (cmwatermark);


--
-- Name: cmcard_collector_number_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_collector_number_index ON public.cmcard USING btree (collector_number varchar_pattern_ops) INCLUDE (collector_number);


--
-- Name: cmcard_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_name_index ON public.cmcard USING btree (name varchar_pattern_ops);


--
-- Name: cmcard_new_id_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_new_id_index ON public.cmcard USING btree (new_id varchar_pattern_ops) INCLUDE (new_id);


--
-- Name: cmcard_tcgplayer_id_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcard_tcgplayer_id_index ON public.cmcard USING btree (tcgplayer_id DESC);


--
-- Name: cmcardtype_name_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmcardtype_name_index ON public.cmcardtype USING btree (name varchar_ops);


--
-- Name: cmlanguage_code_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmlanguage_code_index ON public.cmlanguage USING btree (code varchar_ops);


--
-- Name: cmset_card_count_index; Type: INDEX; Schema: public; Owner: managuide
--

CREATE INDEX cmset_card_count_index ON public.cmset USING btree (card_count);


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
-- Name: cmcard_artist cmartist_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_artist
    ADD CONSTRAINT cmartist_fkey FOREIGN KEY (cmartist) REFERENCES public.cmartist(name);


--
-- Name: cmcard_face cmcard_face_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_face_fkey FOREIGN KEY (cmcard_face) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_color cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_color
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_coloridentity cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_coloridentity
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_colorindicator cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_colorindicator
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_component_part cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_face cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_face
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_format_legality cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_format_legality
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_frameeffect cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_frameeffect
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_otherlanguage cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherlanguage
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_otherprinting cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_otherprinting
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_subtype cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_subtype
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_supertype cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_supertype
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_variation cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_variation
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcardprice cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardprice
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcardstatistics cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcardstatistics
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id) NOT VALID;


--
-- Name: cmcard_game cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_game
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id);


--
-- Name: cmcard_keyword cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_keyword
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id);


--
-- Name: cmcard_artist cmcard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_artist
    ADD CONSTRAINT cmcard_fkey FOREIGN KEY (cmcard) REFERENCES public.cmcard(new_id);


--
-- Name: cmcard_component_part cmcard_part_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_component_part
    ADD CONSTRAINT cmcard_part_fkey FOREIGN KEY (cmcard_part) REFERENCES public.cmcard(new_id) NOT VALID;


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
-- Name: cmcard_game cmgame_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_game
    ADD CONSTRAINT cmgame_fkey FOREIGN KEY (cmgame) REFERENCES public.cmgame(name);


--
-- Name: cmcard_keyword cmkeyword_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard_keyword
    ADD CONSTRAINT cmkeyword_fkey FOREIGN KEY (cmkeyword) REFERENCES public.cmkeyword(name) NOT VALID;


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
-- Name: cmcard cmwatermark_fkey; Type: FK CONSTRAINT; Schema: public; Owner: managuide
--

ALTER TABLE ONLY public.cmcard
    ADD CONSTRAINT cmwatermark_fkey FOREIGN KEY (cmwatermark) REFERENCES public.cmwatermark(name) NOT VALID;


--
-- PostgreSQL database dump complete
--

