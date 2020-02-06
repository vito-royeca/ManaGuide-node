const express = require('express')
const router = express.Router()
const db = require('./db')
const my = require('./my')
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

        db.executeQuery(req, res, next, sql, parameters, callback)
    }
})

function callback(req, res, queryResults) {
    const data = queryResults.rows
    var newData = []

    for (var i=0; i<data.length; i++) {
        newData.push(my.updateCardImageUrls(data[i]))
    }

    if (req.query.json == "true") {
        res.status(200).json(newData)
    } else {
        var dict = db.defaultResponse(req, res)
        dict["data"] = newData

        res.render(req.baseUrl.substr(1), dict)
    }
}

module.exports = router
