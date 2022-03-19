CREATE OR REPLACE FUNCTION selectSubsets(character varying)
    RETURNS TABLE(
        card_count      integer,
		cmset_parent    character varying,
		parent_level    integer,
        code            character varying,
        is_foil_only    boolean,
        is_online_only  boolean,
        mtgo_code       character varying,
        keyrune_unicode character varying,
        keyrune_class character varying,
        my_name_section character varying,
        my_year_section character varying,
        name            character varying,
        release_date    character varying,
        tcgplayer_id    integer)
AS
$$
DECLARE
    _code ALIAS FOR $1;
    command     character varying;
BEGIN
    IF lower(_code) = 'null' THEN
        _code := NULL;
    END IF;
	
    command :=
	'WITH RECURSIVE sets AS (
        SELECT card_count,
		       cmset_parent,
			   1 as parent_level,
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
               tcgplayer_id
		from cmset where cmset_parent = ''' || _code || '''
    UNION ALL
        SELECT b.card_count,
		       b.cmset_parent,
			   sets.parent_level + 1 AS parent_level,
	           b.code,
	           b.is_foil_only,
	           b.is_online_only,
	           b.mtgo_code,
	           b.keyrune_unicode,
	           b.keyrune_class,
	           b.my_name_section,
	           b.my_year_section,
               b.name,
               b.release_date,
               b.tcgplayer_id
		from cmset b
        JOIN sets ON b.cmset_parent = sets.code 
)
SELECT * FROM sets;';

	RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql;