const express = require('express')
const router = express.Router()
const db = require('./db')
const my = require('./my')
const errorRouter = require('./error')
const e = require('express')

// select by query
router.get('/', function(req, res, next) {
    const sql = 'SELECT * from advanceSearchCards($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)'
    const name = req.query.name.replace(/\'/g, "''").trim()
    const colors = req.query.colors
    const rarities = req.query.rarities
    const types = req.query.types
    const keywords = req.query.keywords
    const artists = req.query.artists
    const pageSize = req.query.pageSize
    const pageOffset = req.query.pageOffset
    let message = null

    if (name == null &&
        colors.length == 0 &&
        rarities.length == 0 &&
        types.length == 0 &&
        keywords.length == 0 &&
        artists.length == 0 &&
        pageSize == null &&
        pageOffset == null) {
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
            keywords,
            artists,
            db.cleanSortedBy(req.query.sortedBy),
            db.cleanOrderBy(req.query.orderBy),
            pageSize,
            pageOffset]

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
