const express = require('express');
const router = express.Router();
const db = require('./db');

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * FROM cmcard ORDER BY name ASC';

    db.executeQuery(req, res, next, text, null);
});

// select by id
router.get('/:id', function(req, res, next) {
    const text = 'SELECT * FROM cmcard WHERE id = $1 ORDER BY name ASC';
    const parameters = [req.params.id];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateCard($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43)';
    const parameters = [
        req.body.collector_number,
        req.body.cmc,
        req.body.flavor_text,
        req.body.image_uris,
        req.body.is_foil,
        req.body.is_full_art,
        req.body.is_highres_image,
        req.body.is_nonfoil,
        req.body.is_oversized,
        req.body.is_reserved,
        req.body.is_story_spotlight,
        req.body.loyalty,
        req.body.mana_cost,
        req.body.multiverse_ids,
        req.body.my_name_section,
        req.body.name,
        req.body.oracle_text,
        req.body.power,
        req.body.printed_name,
        req.body.printed_text,
        req.body.toughness,
        req.body.arena_id,
        req.body.mtgo_id,
        req.body.tcgplayer_id,
        req.body.hand_modifier,
        req.body.life_modifier,
        req.body.is_booster,
        req.body.is_digital,
        req.body.is_promo,
        req.body.released_at,
        req.body.is_textless,
        req.body.is_variation,
        req.body.mtgo_foil_id,
        req.body.is_reprint,
        req.body.id,
        req.body.card_back_id,
        req.body.oracle_id,
        req.body.illustration_id,
        req.body.cmartist,
        req.body.cmset,
        req.body.cmrarity,
        req.body.cmlanguage,
        req.body.cmlayout
    ];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
