const express = require('express');
const router = express.Router();
const db = require('./db');

// select by id
router.get('/:id', function(req, res, next) {
    const text = 'SELECT * FROM selectCard($1)';
    const parameters = [req.params.id];

    db.executeQuery(req, res, next, text, parameters);
});

// select by cmset and cmlanguage
router.get('/:cmset/:cmlanguage', function(req, res, next) {
    const text = 'SELECT * from selectCards($1,$2)';
    const parameters = [
        req.params.cmset,
        req.params.cmlanguage];

    db.executeQuery(req, res, next, text, parameters);
});

// update price

module.exports = router;
