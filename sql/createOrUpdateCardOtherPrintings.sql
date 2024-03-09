CREATE OR REPLACE FUNCTION createOrUpdateCardOtherPrintings() RETURNS void AS $$
DECLARE
    currentRow integer := 0;
    rows integer := 0;
    row RECORD;
    row2 RECORD;
    rowOtherPrinting cmcard_otherprinting%ROWTYPE;
BEGIN
    RAISE NOTICE 'other printings: %', currentRow;

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
                new_id IS DISTINCT FROM row.new_id AND
                cmset IS DISTINCT FROM row.cmset AND
                c.name = row.name AND
                cmlanguage = row.cmlanguage
            ORDER BY s.release_date, c.name
        LOOP
            SELECT * INTO rowOtherPrinting FROM cmcard_otherprinting
                WHERE cmcard = row.new_id AND cmcard_otherprinting = row2.new_id
                LIMIT 1;

            IF NOT FOUND THEN
                INSERT INTO cmcard_otherprinting(
                    cmcard,
                    cmcard_otherprinting)
                VALUES(
                    row.new_id,
                    row2.new_id);
            END IF;        
        END LOOP;

        currentRow := currentRow + 1;
        IF currentRow % 1000 = 0 THEN
            RAISE NOTICE 'other printings: %', currentRow;
        END IF;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;

