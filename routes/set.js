const express = require('express')
const router = express.Router()
const db = require('./db')
const my = require('./my')

// select by cmset and cmlanguage
router.get('/:cmset/:cmlanguage', function(req, res, next) {
    if (req.query.sortedBy == 'name' && req.query.orderBy == 'asc') {
        const sql = 'SELECT * from matv_cmset_' + req.params.cmset + '_' + req.params.cmlanguage
        db.executeQuery(req, res, next, sql, null, callback)
    } else {
        const sql = 'SELECT * from selectSet($1,$2,$3,$4)'
        const parameters = [
            req.params.cmset,
            req.params.cmlanguage,
            db.cleanSortedBy(req.query.sortedBy),
            db.cleanOrderBy(req.query.orderBy)]

        db.executeQuery(req, res, next, sql, parameters, callback)
    }
})

function callback(req, res, queryResults) {
    const data = queryResults.rows[0].cards
    let newData = []

    for (var i=0; i<data.length; i++) {
        newData.push(my.updateCardImageUrls(data[i], req.query.mobile == "true"))
    }

    let newQueryResults = queryResults.rows
    newQueryResults[0].cards = newData

    if (req.query.json == "true") {
        res.status(200).json(newQueryResults)
    } else {
        let dict = db.defaultResponse(req, res)
        dict["data"] = newQueryResults

        res.render(req.baseUrl.substr(1), dict)
    }
}

module.exports = router
