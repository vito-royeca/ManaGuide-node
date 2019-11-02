const express = require('express');
const router = express.Router();
const db = require('./db');

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * FROM cmsetblock ORDER BY name ASC';

    db.executeQuery(req, res, next, text, null);
});

// select by code
router.get('/:code', function(req, res, next) {
    const text = 'SELECT * FROM cmsetblock WHERE code = $1';
    const parameters = [req.params.code];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateSetBlock($1,$2,$3)';
    const parameters = [
        req.body.code,
        req.body.name,
        req.body.name_section
    ];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
