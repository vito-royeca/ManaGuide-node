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

    SELECT new_id INTO _new_id FROM cmcard
        WHERE tcgplayer_id = _tcgplayer_id
        LIMIT 1;

    IF FOUND THEN
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
            _is_foil)
        ON CONFLICT(cmcard, is_foil)
            DO UPDATE SET
                low = EXCLUDED.low,
                median = EXCLUDED.median,
                high = EXCLUDED.high,
                market = EXCLUDED.market,
                direct_low = EXCLUDED.direct_low,
                cmcard = EXCLUDED.cmcard,
                is_foil = EXCLUDED.is_foil,
                date_updated = now();
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;

