const express = require('express')
const router = express.Router()
const db = require('./db')

// select by id
router.get('/:id', function(req, res, next) {
    const sql = 'SELECT * FROM selectCard($1)'
    const parameters = [req.params.id]

    db.executeQuery(req, res, next, sql, parameters, callback)
});

function callback(req, res, dict) {
    res.render(req.baseUrl.substr(1), dict)
}

module.exports = router