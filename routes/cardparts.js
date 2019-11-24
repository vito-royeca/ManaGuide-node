const express = require('express');
const router = express.Router();
const db = require('./db');
const pool = db.pool;

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * FROM cmcard_part ORDER BY name cmcard';

    db.executeQuery(req, res, next, text, null);
});

// select by name
router.get('/:cmcard', function(req, res, next) {
    const text = 'SELECT * FROM cmcard_part WHERE cmcard = $1';
    const parameters = [req.params.name];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateCardPart($1,$2,$3)';
    const parameters = [
        req.body.cmcard,
        req.body.cmcomponent,
        req.body.cmcard_part
    ];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
