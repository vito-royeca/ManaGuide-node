const express = require('express');
const router = express.Router();
const db = require('./db');
const pool = db.pool;

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT oracle_id, text, date_published FROM cmruling ORDER BY date_published ASC';

    db.executeQuery(req, res, next, text, null);
});

// select by name
router.get('/:oracle_id', function(req, res, next) {
    const text = 'SELECT oracle_id, text, date_published FROM cmruling WHERE oracle_id = $1';
    const parameters = [req.params.name];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateRuling($1,$2,$3)';
    const parameters = [
        req.body.oracle_id,
        req.body.text,
        req.body.date_published
    ];

    db.executeQuery(req, res, next, text, parameters);
});

// delete
router.delete('/', function(req, res, next) {
    const text = 'DELETE FROM cmruling';

    db.executeQuery(req, res, next, text, null);
});

module.exports = router;
