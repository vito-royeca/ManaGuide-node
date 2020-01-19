const express = require('express')
const router = express.Router()
const db = require('./db')
const errorRouter = require('./error')

// select by query
router.get('/', function(req, res, next) {
    const sql = 'SELECT * from searchCards($1,$2,$3)'
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
        errorRouter.handleError(400, new Error(message), req, res)
    } else {
        const parameters = [
            query,
            db.cleanSortedBy(req.query.sortedBy),
            db.cleanOrderBy(req.query.orderBy)]

        db.executeQuery(req, res, next, sql, parameters, null)
    }
})

module.exports = router
