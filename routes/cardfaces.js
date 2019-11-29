const express = require('express');
const router = express.Router();
const db = require('./db');
const pool = db.pool;

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * FROM cmcard_face ORDER BY name cmcard';

    db.executeQuery(req, res, next, text, null);
});

// select by name
router.get('/:cmcard', function(req, res, next) {
    const text = 'SELECT * FROM cmcard_face WHERE cmcard = $1';
    const parameters = [req.params.name];

    db.executeQuery(req, res, next, text, parameters);
});

// create
router.post('/', function(req, res, next) {
    const text = 'SELECT createOrUpdateCardFaces($1,$2)';
    const parameters = [
        req.body.cmcard,
        req.body.cmcard_face
    ];

    db.executeQuery(req, res, next, text, parameters);
});

module.exports = router;
