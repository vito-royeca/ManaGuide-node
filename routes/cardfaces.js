const express = require('express')
const router = express.Router()
const db = require('./db')
const pool = db.pool

// select by name
router.get('/:cmcard', function(req, res, next) {
    const text = 'SELECT cmcard, cmcard_face FROM cmcard_face WHERE cmcard = $1'
    const parameters = [req.params.cmcard]

    db.executeQuery(req, res, next, text, parameters)
});

module.exports = router
