const express = require('express')
const router = express.Router()
const db = require('./db')

// select all
router.get('/', function(req, res, next) {
    const text = 'SELECT name, name_section, code, display_code FROM cmlanguage ORDER BY name ASC'

    db.executeQuery(req, res, next, text, null)
})

// select by name
router.get('/:code', function(req, res, next) {
    const text = 'SELECT name, name_section, code, display_code FROM cmlanguage WHERE code = $1'
    const parameters = [req.params.name]

    db.executeQuery(req, res, next, text, parameters)
})

module.exports = router
