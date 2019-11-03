const express = require('express');
const router = express.Router();
const db = require('./db');
const pool = db.pool;

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * FROM cmlegality ORDER BY name ASC';

    db.executeQuery(req, res, next, text, null);
});

// select by name
router.get('/:name', function(req, res, next) {
    const text = 'SELECT * FROM cmlegality WHERE name = $1';
    const parameters = [req.params.name];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateLegality($1,$2)';
    const parameters = [
        req.body.name,
        req.body.name_section
    ];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
