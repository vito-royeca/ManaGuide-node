const express = require('express')
const router = express.Router()
const db = require('./db')
var url = require('url')

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * from selectSets(null)'

    db.executeQuery(req, res, next, text, null)
})

// select by code
router.get('/:code', function(req, res, next) {
    const text = 'SELECT * from selectSets($1)'
    const parameters = [req.params.code]

    db.executeQuery(req, res, next, text, parameters)
})

module.exports = router
