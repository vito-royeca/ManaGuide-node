const express = require('express');
const router = express.Router();
const db = require('./db');

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT id, scryfall_version, keyrune_version FROM server_info';

    db.executeQuery(req, res, next, text, null);
});

// update Scryfall version
router.post('/updatescryfall', function(req, res, next) {
    const text = 'UPDATE server_info SET date_updated = now(),  scryfall_version = $1';
    const parameters = [
        req.body.scryfall_version
    ];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;