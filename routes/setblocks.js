const express = require('express')
const router = express.Router()
const db = require('./db')

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT * FROM cmsetblock ORDER BY name ASC'

    db.executeQuery(req, res, next, text, null)
})

// select by code
router.get('/:code', function(req, res, next) {
    const text = 'SELECT code, name, name_section FROM cmsetblock WHERE code = $1'
    const parameters = [req.params.code]

    db.executeQuery(req, res, next, text, parameters)
})

module.exports = router
