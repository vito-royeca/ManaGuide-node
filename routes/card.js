const express = require('express')
const router = express.Router()
const db = require('./db')
const my = require('./my')

// select by id
router.get('/:id', function(req, res, next) {
    const sql = 'SELECT * FROM selectCard($1)'
    const parameters = [req.params.id]

    db.executeQuery(req, res, next, sql, parameters, callback)
});

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