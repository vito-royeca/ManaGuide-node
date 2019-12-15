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
                cmset_parent = _cmset_parent
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
$$ LANGUAGE plpgsql;

