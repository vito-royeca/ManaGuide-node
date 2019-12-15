const express = require('express');
const router = express.Router();
const db = require('./db');
const pool = db.pool;

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT name, name_section FROM cmcomponent ORDER BY name ASC';

    db.executeQuery(req, res, next, text, null);
});

// select by name
router.get('/:name', function(req, res, next) {
    const text = 'SELECT name, name_section FROM cmcomponent WHERE name = $1';
    const parameters = [req.params.name];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
