CREATE OR REPLACE FUNCTION selectSets(
    character varying)
    RETURNS TABLE (
        card_count      integer,
        code            character varying,
        is_foil_only    boolean,
        is_online_only  boolean,
        mtgo_code       character varying,
        my_keyrune_code character varying,
        my_name_section character varying,
        my_year_section character varying,
        name            character varying,
        release_date    character varying,
        tcgplayer_id    integer,
        set_block       json,
        set_type        json,
        languages       json[]
    )
AS
$$
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
        command := command || ' ORDER BY s.name ASC';
    END IF;

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

