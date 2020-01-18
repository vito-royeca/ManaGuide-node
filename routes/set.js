const express = require('express')
const router = express.Router()
const db = require('./db')
var url = require('url')

// select by cmset and cmlanguage
router.get('/:cmset/:cmlanguage', function(req, res, next) {
    const text = 'SELECT * from selectSet($1,$2,$3,$4)'
    const parameters = [
        req.params.cmset,
        req.params.cmlanguage,
        req.query.sortedBy,
        req.query.orderBy]

    db.executeQuery(req, res, next, text, parameters)
})

module.exports = router
