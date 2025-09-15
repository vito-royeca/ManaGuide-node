CREATE OR REPLACE FUNCTION deleteSet(
    character varying) RETURNS integer AS $$
DECLARE
    _code ALIAS FOR $1;

    _new_id character varying;
    _card_count integer := 0;
BEGIN

    FOR _new_id IN SELECT new_id FROM cmcard where cmset = _code LOOP
        PERFORM deleteCard(_new_id);
        _card_count := _card_count + 1;
    END LOOP;

    DELETE FROM cmset_language WHERE cmset = _code;
    DELETE FROM cmset WHERE code = _code;
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_ar';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_de';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_en';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_es';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_fr';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_grc';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_he';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_it';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_ja';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_ko';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_la';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_ph';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_pt';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_qya';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_ru';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_sa';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_zhs';
    DROP MATERIALIZED VIEW IF EXISTS  'matv_cmset_' || _code || '_zht';

    RETURN _card_count;
END;
$$ LANGUAGE plpgsql;