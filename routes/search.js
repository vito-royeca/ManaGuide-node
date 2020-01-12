const express = require('express')
const router = express.Router()
const db = require('./db')

// select by query
router.get('/', function(req, res, next) {
    const text = 'SELECT * from searchCards($1)'
    const query = req.query.query
    var message = null

    if (query == null) {
        message = "Search query is empty"
    } else {
        if (query.length < 3) {
            message = "Search query must be at least three characters."
        }
    }

    if (message != null) {
        res.statusCode = 500
        res.end(message)
    } else {
        const parameters = [query]

        if (!req.query.displayAs || req.query.displayAs === "") {
            req.query.displayAs = "montage"
        }
        if (!req.query.sortedBy || req.query.sortedBy === "") {
            req.query.sortedBy = "name"
        }
        if (!req.query.orderBy || req.query.orderBy === "") {
            req.query.orderBy = "ascending"
        }
        db.executeQuery(req, res, next, text, parameters)
    }
})

module.exports = router
