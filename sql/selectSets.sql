CREATE OR REPLACE FUNCTION selectSets()
    RETURNS TABLE(
        card_count      integer,
        code            character varying,
        is_foil_only    boolean,
        is_online_only  boolean,
        logo_code       character varying,
        mtgo_code       character varying,
        keyrune_unicode character varying,
        keyrune_class   character varying,
        year_section    character varying,
        name            character varying,
        release_date    character varying,
        tcgplayer_id    integer,
		cmset_parent    character varying,
        set_block       json,
        set_type        json,
        languages       json[])
AS
$$
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
$$ LANGUAGE plpgsql;

