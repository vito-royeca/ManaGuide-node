const express = require('express');
const router = express.Router();
const db = require('./db');
const pool = db.pool;

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * FROM cmcolor ORDER BY name ASC';

    db.executeQuery(req, res, next, text, null);
});

// select by name
router.get('/:name', function(req, res, next) {
    const text = 'SELECT symbol, name, name_section FROM cmcolor WHERE name = $1';
    const parameters = [req.params.name];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateColor($1,$2,$3,$4)';
    const parameters = [
        req.body.symbol,
        req.body.name,
        req.body.name_section,
        req.body.is_mana_color
    ];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
