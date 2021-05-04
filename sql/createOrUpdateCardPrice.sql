CREATE OR REPLACE FUNCTION createOrUpdateCardPrice(
    double precision,
    double precision,
    double precision,
    double precision,
    double precision,
    integer,
    character varying,
    boolean
) RETURNS varchar AS $$
DECLARE
    _low ALIAS FOR $1;
    _median ALIAS FOR $2;
    _high ALIAS FOR $3;
    _market ALIAS FOR $4;
    _direct_low ALIAS FOR $5;
    _tcgplayer_id ALIAS FOR $6;
    _cmstore ALIAS FOR $7;
    _is_foil ALIAS FOR $8;

    _pkey character varying;
    _cmcard character varying;
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

    SELECT new_id INTO _cmcard FROM cmcard WHERE tcgplayer_id = _tcgplayer_id;

    IF FOUND THEN
        SELECT id INTO _pkey FROM cmcardprice
            WHERE cmcard = _cmcard AND
                cmstore = _cmstore AND
                is_foil = _is_foil;

        IF NOT FOUND THEN
            INSERT INTO cmcardprice(
                low,
                median,
                high,
                market,
                direct_low,
                cmcard,
                cmstore,
                is_foil)
            VALUES(
                _low,
                _median,
                _high,
                _market,
                _direct_low,
                _cmcard,
                _cmstore,
                _is_foil);
        ELSE
            UPDATE cmcardprice SET
                low = _low,
                median = _median,
                high = _high,
                market = _market,
                direct_low = _direct_low,
                cmcard = _cmcard,
                cmstore = _cmstore,
                is_foil = _is_foil,
                date_updated = now()
            WHERE cmcard = _cmcard AND
                cmstore = _cmstore AND
                is_foil = _is_foil;
        END IF;
    END IF;

    RETURN _pkey;
END;
$$ LANGUAGE plpgsql;

