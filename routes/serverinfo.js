const express = require('express')
const router = express.Router()
const db = require('./db')

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT id, scryfall_version, keyrune_version FROM server_info'

    db.executeQuery(req, res, next, text, null)
})

module.exports = router