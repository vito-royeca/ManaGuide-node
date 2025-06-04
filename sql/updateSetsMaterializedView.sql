CREATE OR REPLACE FUNCTION updateSetsMaterializedView() RETURNS void AS $$
DECLARE
    
BEGIN
    REFRESH MATERIALIZED VIEW matv_cmsets;

    RETURN;
END;
$$ LANGUAGE plpgsql;
