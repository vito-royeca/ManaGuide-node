CREATE OR REPLACE FUNCTION createOrUpdateCardVariations() RETURNS void AS $$
DECLARE
    currentRow integer := 0;
    rows integer := 0;
    row RECORD;
    row2 RECORD;
    rowVariation cmcard_variation%ROWTYPE;
BEGIN
    RAISE NOTICE 'variations: %', currentRow;

    FOR row IN SELECT new_id, c.name, cmset, cmlanguage FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
        WHERE
            c.new_id NOT IN (SELECT cmcard_face FROM cmcard_face) AND
            c.new_id NOT IN (SELECT cmcard_part FROM cmcard_component_part)
        ORDER BY s.release_date, c.name
        -- LIMIT 200
    LOOP
        FOR row2 IN SELECT new_id FROM cmcard c
                LEFT JOIN cmset s ON c.cmset = s.code
            WHERE
                new_id IS DISTINCT FROM row.new_id AND
                cmset = row.cmset AND
                c.name = row.name AND
                cmlanguage = row.cmlanguage
            ORDER BY s.release_date, c.name
            -- LIMIT 100
        LOOP
            SELECT * INTO rowVariation FROM cmcard_variation
                WHERE cmcard = row.new_id AND cmcard_variation = row2.new_id
                LIMIT 1;

            IF NOT FOUND THEN
                INSERT INTO cmcard_variation(
                    cmcard,
                    cmcard_variation)
                VALUES(
                    row.new_id,
                    row2.new_id);
            END IF;        
        END LOOP;

        currentRow := currentRow + 1;
        IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'variations: %', currentRow;
        END IF;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;

