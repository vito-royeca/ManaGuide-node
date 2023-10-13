const express = require('express')
const router = express.Router()
const db = require('./db')
const my = require('./my')

// select by new_id and cmlanguage
router.get('/:new_id/:cmlanguage', function(req, res, next) {
    const sql = 'SELECT * from selectPrintings($1,$2,$3,$4)'
    const parameters = [
        req.params.new_id,
        req.params.cmlanguage,
        db.cleanSortedBy(req.query.sortedBy),
        db.cleanOrderBy(req.query.orderBy)]

    db.executeQuery(req, res, next, sql, parameters, callback)
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
