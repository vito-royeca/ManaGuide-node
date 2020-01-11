const express = require('express')
const router = express.Router()
const db = require('./db')

// select by id
router.get('/:id', function(req, res, next) {
    const text = 'SELECT * FROM selectCard($1)'
    const parameters = [req.params.id]

    db.executeQuery(req, res, next, text, parameters)
});

module.exports = router