const express = require('express')
const router = express.Router()
const db = require('./db')
const pool = db.pool

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT oracle_id, text, date_published FROM cmruling ORDER BY date_published ASC'

    db.executeQuery(req, res, next, text, null)
})

// select by name
router.get('/:oracle_id', function(req, res, next) {
    const text = 'SELECT oracle_id, text, date_published FROM cmruling WHERE oracle_id = $1'
    const parameters = [req.params.name]

    db.executeQuery(req, res, next, text, parameters)
})

module.exports = router
