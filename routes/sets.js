const express = require('express')
const router = express.Router()
const db = require('./db')
var url = require('url')

// select all
router.get('/', function(req, res, next) {
    const sql = 'SELECT * from selectSets(null, $1, $2)'
    const parameters = [req.query.page,
        req.query.limit]

    db.executeQuery(req, res, next, sql, parameters, null)
})

// select by code
router.get('/:code/:page/:limit', function(req, res, next) {
    const sql = 'SELECT * from selectSets($1, $2, $3)'
    const parameters = [req.params.code]

    db.executeQuery(req, res, next, sql, parameters, null)
})

module.exports = router
