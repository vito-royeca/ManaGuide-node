CREATE OR REPLACE FUNCTION createSetMaterializedView(
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _code ALIAS FOR $1;
    _language ALIAS FOR $2;
    command character varying;
BEGIN

    command := 'CREATE MATERIALIZED VIEW IF NOT EXISTS matv_cmset_' || _code || '_' || _language || ' AS ';
    command := command || 'SELECT card_count
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
            array(SELECT selectCards(''' || _code || ''', ''' || _language || ''', ''name'', ''ASC''))
        ) AS cards
        FROM cmset s WHERE s.code = ''' || _code || '''';

    EXECUTE command;

    RETURN;
END;
$$ LANGUAGE plpgsql;
