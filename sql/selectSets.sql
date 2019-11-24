CREATE OR REPLACE FUNCTION selectSets(
    character varying) RETURNS TABLE (
        card_count integer,
        code character varying,
        is_foil_only boolean,
        is_online_only boolean,
        mtgo_code character varying,
        my_keyrune_code character varying,
        my_name_section character varying,
        my_year_section character varying,
        name character varying,
        release_date character varying,
        tcgplayer_id integer,
        block json,
        type json,
        languages character varying[]) AS $$
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
                   ) AS block,
                   (
                       SELECT row_to_json(x) FROM (
                            SELECT st.name, st.name_section
                            FROM cmsettype st WHERE st.name = s.cmsettype
                        ) x
                   ) AS type,
                   array(
                        SELECT cmlanguage FROM cmset_language l WHERE l.cmset = s.code
	               ) AS languages
            FROM cmset s';

    IF _code IS NOT NULL THEN
        command := command || ' WHERE s.code = '''||_code||''' ORDER BY s.name ASC';
    ELSE
        command := command || ' ORDER BY s.name ASC';
    END IF;

    RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;

