CREATE OR REPLACE FUNCTION createServerUpdate(
    boolean) RETURNS boolean AS $$
DECLARE
    _full_update ALIAS FOR $1;

    pkey character varying;
BEGIN
        INSERT INTO serverupdate(
            full_update)
        VALUES(
            _full_update);

    RETURN _full_update;
END;
$$ LANGUAGE plpgsql;