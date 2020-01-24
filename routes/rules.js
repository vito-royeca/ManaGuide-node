const express = require('express')
const router = express.Router()
const db = require('./db')

router.get('/', function(req, res, next) {
    const sql = 'SELECT * from selectRules(null)'

    db.executeQuery(req, res, next, sql, null, null)
});

router.get('/:id', function(req, res, next) {
    const sql = 'SELECT * from selectRules($1)'
    const parameters = [req.params.id]

    db.executeQuery(req, res, next, sql, parameters, null)
});

module.exports = router