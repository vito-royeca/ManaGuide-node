const express = require('express')
const router = express.Router()
const db = require('./db')

// select all
router.get('/', function(req, res, next) {
    const sql = 'SELECT id, scryfall_version, keyrune_version FROM server_info'

    db.executeQuery(req, res, next, sql, null, null)
})

module.exports = router