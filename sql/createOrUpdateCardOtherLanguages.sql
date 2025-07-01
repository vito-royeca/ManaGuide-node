CREATE OR REPLACE FUNCTION createOrUpdateCardOtherLanguages() RETURNS void AS $$
DECLARE
    currentRow integer := 0;
    row RECORD;
    row2 RECORD;
BEGIN
    RAISE NOTICE 'other languages: %', currentRow;

    FOR row IN SELECT new_id, c.name, cmset, cmlanguage FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.new_id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.new_id NOT IN (SELECT cmcard_part FROM cmcard_component_part)
        ORDER BY s.release_date, c.name
    LOOP
        FOR row2 IN SELECT new_id FROM cmcard c                    
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                s.code = row.cmset AND
                c.name = row.name AND
                cmlanguage IS DISTINCT FROM row.cmlanguage
            ORDER BY s.release_date, c.name
        LOOP
            INSERT INTO cmcard_otherlanguage(
                cmcard,
                cmcard_otherlanguage)
            VALUES(
                row.new_id,
                row2.new_id)
            ON CONFLICT(
                cmcard,
                cmcard_otherlanguage
            )
                DO NOTHING;
        END LOOP;

        currentRow := currentRow + 1;
        IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'other languages: %', currentRow;
        END IF;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;

