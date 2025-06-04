CREATE OR REPLACE FUNCTION updateSetMaterializedView(
    character varying,
    character varying) RETURNS void AS $$
DECLARE
    _code ALIAS FOR $1;
    _language ALIAS FOR $2;
    command character varying;
BEGIN

    command := 'REFRESH MATERIALIZED VIEW matv_cmset_' || _code || '_' || _language || ';';

    EXECUTE command;

    RETURN;
END;
$$ LANGUAGE plpgsql;
