const express = require('express')
const router = express.Router()
const db = require('./db')

// select all
router.get('/', function(req, res, next) {
    const sql = 'SELECT * FROM cmgame ORDER BY name ASC'

    db.executeQuery(req, res, next, sql, null, null)
});

module.exports = router;
