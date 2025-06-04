CREATE OR REPLACE FUNCTION createSetsMaterializedView() RETURNS void AS $$
DECLARE
    
BEGIN
    CREATE MATERIALIZED VIEW IF NOT EXISTS matv_cmsets AS 
        SELECT card_count,
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
        FROM cmset s WHERE s.card_count > 0
        GROUP BY cmset_parent, card_count, code
        ORDER BY release_date DESC, cmset_parent DESC, name ASC;

    RETURN;
END;
$$ LANGUAGE plpgsql;
