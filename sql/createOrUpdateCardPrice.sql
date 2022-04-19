CREATE OR REPLACE FUNCTION createOrUpdateCardPrice(
    double precision,
    double precision,
    double precision,
    double precision,
    double precision,
    integer,
    boolean
) RETURNS void AS $$
DECLARE
    _low ALIAS FOR $1;
    _median ALIAS FOR $2;
    _high ALIAS FOR $3;
    _market ALIAS FOR $4;
    _direct_low ALIAS FOR $5;
    _tcgplayer_id ALIAS FOR $6;
    _is_foil ALIAS FOR $7;

    row cmcardprice%ROWTYPE;
    _new_id character varying;
BEGIN
    IF _low = 0.0 THEN
        _low := NULL;
    END IF;
    IF _median = 0.0 THEN
        _median := NULL;
    END IF;
    IF _high = 0.0 THEN
        _high := NULL;
    END IF;
    IF _market = 0.0 THEN
        _market := NULL;
    END IF;
    IF _direct_low = 0.0 THEN
        _direct_low := NULL;
    END IF;

    SELECT new_id INTO _new_id FROM cmcard WHERE tcgplayer_id = _tcgplayer_id;

    IF FOUND THEN
        SELECT * INTO row FROM cmcardprice
            WHERE cmcard = _new_id AND
                is_foil = _is_foil;

        IF NOT FOUND THEN
            INSERT INTO cmcardprice(
                low,
                median,
                high,
                market,
                direct_low,
                cmcard,
                is_foil)
            VALUES(
                _low,
                _median,
                _high,
                _market,
                _direct_low,
                _new_id,
                _is_foil);
        ELSE
            IF row.low IS DISTINCT FROM _low OR
               row.median IS DISTINCT FROM _median OR
               row.high IS DISTINCT FROM _high OR
               row.market IS DISTINCT FROM _market OR
               row.direct_low IS DISTINCT FROM _direct_low OR
               row.cmcard IS DISTINCT FROM _new_id OR
               row.is_foil IS DISTINCT FROM _is_foil THEN
                
                UPDATE cmcardprice SET
                    low = _low,
                    median = _median,
                    high = _high,
                    market = _market,
                    direct_low = _direct_low,
                    cmcard = _new_id,
                    is_foil = _is_foil,
                    date_updated = now()
                WHERE cmcard = _new_id AND
                    is_foil = _is_foil;
            END IF;        
        END IF;
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

