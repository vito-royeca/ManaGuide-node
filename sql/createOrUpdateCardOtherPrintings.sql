CREATE OR REPLACE FUNCTION createOrUpdateCardOtherPrintings() RETURNS integer AS $$
DECLARE
    currentRow integer := 0;
    rows integer := 0;
    currentTime timestamp;
    row RECORD;
    row2 RECORD;
BEGIN
    DELETE FROM cmcard_otherprinting;

    SELECT count(*) INTO rows FROM cmcard c
        LEFT JOIN cmset s ON c.cmset = s.code
        WHERE id NOT IN (SELECT cmcard_face FROM cmcard_face);

    RAISE NOTICE '% - other printings: %/%', now(), currentRow, rows;
    FOR row IN SELECT id, c.name, cmset, cmlanguage FROM cmcard c
        LEFT JOIN cmset s ON c.cmset = s.code
        WHERE id NOT IN (SELECT cmcard_face FROM cmcard_face)
        ORDER BY s.release_date, c.name
    LOOP
        FOR row2 IN SELECT id FROM cmcard c
            LEFT JOIN cmset s ON c.cmset = s.code
            WHERE id <> row.id AND
            cmset <> row.cmset AND
			c.name = row.name AND
			cmlanguage = row.cmlanguage
			ORDER BY s.release_date, c.name
        LOOP
            INSERT INTO cmcard_otherprinting(
                cmcard,
                cmcard_otherprinting)
            VALUES(
                row.id,
                row2.id);
        END LOOP;

		currentRow := currentRow + 1;

		IF currentRow % 1000 = 0 THEN
            SELECT now() INTO currentTime;
            RAISE NOTICE '% - other printings: %/%', currentTime, currentRow, rows;
		END IF;

		--IF rows >= 50 THEN
		--	EXIT;
		--END IF;
    END LOOP;

    RETURN rows;
END;
$$ LANGUAGE plpgsql;

