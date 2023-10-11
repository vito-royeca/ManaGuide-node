CREATE OR REPLACE FUNCTION selectSet(
    character varying,
    character varying,
    character varying,
    character varying)
    RETURNS TABLE (
        card_count      integer,
        code            character varying,
        is_foil_only    boolean,
        is_online_only  boolean,
        logo_code       character varying,
        mtgo_code       character varying,
        keyrune_unicode character varying,
        keyrune_class character varying,
        year_section character varying,
        name            character varying,
        release_date    character varying,
        tcgplayer_id    integer,
        set_block       json,
        set_type        json,
        languages       json[],
        cards           json
    )
AS
$$
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
$$ LANGUAGE plpgsql;

