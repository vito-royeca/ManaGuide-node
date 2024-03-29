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
    character varying,
    integer,
    character varying,
    character varying,
    character varying) RETURNS void AS $$
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
$$ LANGUAGE plpgsql;

