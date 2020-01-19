const express = require('express')
const router = express.Router()
const db = require('./db')
const pool = db.pool

// select all
router.get('/', function(req, res, next) {
    const sql = 'SELECT id, name, name_section, description FROM cmframeeffect ORDER BY name ASC'

    db.executeQuery(req, res, next, sql, null, null)
})

// select by name
router.get('/:name', function(req, res, next) {
    const sql = 'SELECT id, name, name_section, description FROM cmframeeffect WHERE name = $1'
    const parameters = [req.params.name]

    db.executeQuery(req, res, next, sql, parameters, null)
})

module.exports = router
