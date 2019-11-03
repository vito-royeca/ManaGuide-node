const express = require('express');
const router = express.Router();
const db = require('./db');
var url = require('url');

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * from selectSets(null)';
    db.executeQuery(req, res, next, text, null);
});

// select by code
router.get('/:code', function(req, res, next) {
    const text = 'SELECT * from selectSets($1)';
    const parameters = [req.params.code];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateSet($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14)';
    const parameters = [
        req.body.card_count,
        req.body.code,
        req.body.is_foil_only,
        req.body.is_online_only,
        req.body.mtgo_code,
        req.body.my_keyrune_code,
        req.body.my_name_section,
        req.body.my_year_section,
        req.body.name,
        req.body.release_date,
        req.body.tcgplayer_id,
        req.body.cmsetblock,
        req.body.cmsettype,
        req.body.cmset_parent
    ];

    db.executeQuery(req, res, next, text, parameters);
});

// update Keyrune Code
router.post('/updatekeyrune/:code', function(req, res, next) {
    const text = 'UPDATE cmset SET my_keyrune_code = $1 WHERE code = $2';
    const code = req.params.code;
    const my_keyrune_code = req.body.my_keyrune_code;
    const parameters = [my_keyrune_code, code];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
