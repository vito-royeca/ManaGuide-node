CREATE OR REPLACE FUNCTION updateSetsCardCount() RETURNS void AS $$
DECLARE
    _card_count integer := 0;
    row RECORD;
BEGIN
    FOR row IN SELECT cmset, cmlanguage, card_count FROM cmset_language
        ORDER BY cmset, cmlanguage
    LOOP
        SELECT count(new_id) INTO _card_count FROM cmcard c
        WHERE c.cmset = row.cmset AND c.cmlanguage = row.cmlanguage;
        
        RAISE NOTICE 'Updating %_% to %', row.cmset, row.cmlanguage, _card_count;

        UPDATE cmset_language SET
            card_count = _card_count,
            date_updated = now()
        WHERE cmset = row.cmset AND cmlanguage = row.cmlanguage;

    END LOOP;

	RETURN;
END;
$$ LANGUAGE plpgsql;

