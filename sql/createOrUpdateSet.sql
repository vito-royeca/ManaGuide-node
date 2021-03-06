CREATE OR REPLACE FUNCTION createOrUpdateSet(
    integer,
    character varying,
    boolean,
    boolean,
    character varying,
	character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    integer,
    character varying,
    character varying,
    character varying) RETURNS varchar AS $$
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
$$ LANGUAGE plpgsql;

