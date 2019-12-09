const express = require('express');
const router = express.Router();
const db = require('./db');
const pool = db.pool;

// select by name
router.get('/:cmcard', function(req, res, next) {
    const text = 'SELECT cmcard, cmcomponent, cmcard_part FROM cmcard_component_part WHERE cmcard = $1';
    const parameters = [req.params.cmcard];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateCardParts($1,$2,$3)';
    const parameters = [
        req.body.cmcard,
        req.body.cmcomponent,
        req.body.cmcard_part
    ];

    db.executeQuery(req, res, next, text, parameters);
});

// delete
router.delete('/', function(req, res, next) {
    const text = 'DELETE FROM cmcard_component_part';

    db.executeQuery(req, res, next, text, null);
});

module.exports = router;
