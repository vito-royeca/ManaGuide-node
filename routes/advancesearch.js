const express = require('express')
const router = express.Router()
const db = require('./db')
const my = require('./my')
const errorRouter = require('./error')
const e = require('express')

// select by query
router.get('/', function(req, res, next) {
    const sql = 'SELECT * from advanceSearchCards($1,$2,$3,$4,$5,$6)'
    const name = req.query.name.replace(/\'/g, "''").trim()
    const colors = req.query.colors
    const rarities = req.query.rarities
    const types = req.query.types
    let message = null

    if (name == null &&
        colors.length == 0 &&
        rarities.length == 0 &&
        types.length == 0) {
        message = "No parameters"
    }

    if (message != null) {
        errorRouter.handleError(400, new Error(message), req, res)
    } else {
        const parameters = [
            name,
            colors,
            rarities,
            types,
            db.cleanSortedBy(req.query.sortedBy),
            db.cleanOrderBy(req.query.orderBy)]

        db.executeQuery(req, res, next, sql, parameters, callback)
    }
})

function callback(req, res, queryResults) {
    const data = queryResults.rows
    let newData = []

    for (var i=0; i<data.length; i++) {
        newData.push(my.updateCardImageUrls(data[i], req.query.mobile == "true"))
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
