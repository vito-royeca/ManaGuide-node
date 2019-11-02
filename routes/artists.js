const express = require('express');
const router = express.Router();
const db = require('./db');

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * FROM cmartist ORDER BY last_name ASC';

    db.executeQuery(req, res, next, text, null);
});

// select by name
router.get('/:name', function(req, res, next) {
    const text = 'SELECT * FROM cmartist WHERE name = $1';
    const parameters = [req.params.name];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateArtist($1,$2,$3,$4)';
    const parameters = [
        req.body.name,
        req.body.first_name,
        req.body.last_name,
        req.body.name_section
    ];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
