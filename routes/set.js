const express = require('express')
const router = express.Router()
const db = require('./db')
var url = require('url')

// select by cmset and cmlanguage
router.get('/:cmset/:cmlanguage', function(req, res, next) {
    const sql = 'SELECT * from selectSet($1,$2,$3,$4)'
    const parameters = [
        req.params.cmset,
        req.params.cmlanguage,
        db.cleanSortedBy(req.query.sortedBy),
        db.cleanOrderBy(req.query.orderBy)]

    db.executeQuery(req, res, next, sql, parameters, null)
})

module.exports = router