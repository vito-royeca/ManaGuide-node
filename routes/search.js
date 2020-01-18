const express = require('express')
const router = express.Router()
const db = require('./db')

// select by query
router.get('/', function(req, res, next) {
    const text = 'SELECT * from searchCards($1,$2,$3)'
    const query = req.query.query.replace(/\'/g, "''").trim()
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
        const parameters = [
            query,
            req.query.sortedBy,
            req.query.orderBy]

        db.executeQuery(req, res, next, text, parameters)
    }
})

module.exports = router
