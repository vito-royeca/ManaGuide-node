CREATE OR REPLACE FUNCTION selectSets(character varying,
                                      integer,
                                      integer)
    RETURNS TABLE(
        page       integer,
        page_limit integer,
        page_count integer,
        row_count  integer,
        data       json[])
AS
$$
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
$$ LANGUAGE plpgsql;

