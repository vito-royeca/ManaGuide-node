delete from cmset_language;
delete from cmcard;
delete from cmset;
delete from cmsetblock;
delete from cmsettype;
delete from cmartist;
delete from cmrarity;
delete from cmlanguage;
delete from cmlayout;

--update cmset set my_keyrune_code = null;
--select * from cmset where code = 'aer';


/*
SELECT card_count,
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
       ) AS type

       FROM cmset s ORDER BY s.name ASC;

 */