const express = require('express')
const router = express.Router()
const db = require('./db')

router.get('/', function(req, res, next) {
    const sql = 'SELECT * from selectRules(null)'

    db.executeQuery(req, res, next, sql, null, null)
});


// select by query
router.get('/search/', function(req, res, next) {
    const sql = 'SELECT * from searchRules($1)'
    const query = req.query.rules_query.replace(/\'/g, "''").trim()
    var message = null

    if (query == null) {
        message = "Search query is empty"
    }

    if (message != null) {
        errorRouter.handleError(400, new Error(message), req, res)
    } else {
        const parameters = [query]

        db.executeQuery(req, res, next, sql, parameters, callback)
    }
})

router.get('/:id', function(req, res, next) {
    const sql = 'SELECT * from selectRules($1)'
    const parameters = [req.params.id]

    db.executeQuery(req, res, next, sql, parameters, null)
});

function callback(req, res, queryResults) {
    queryResults.rules_query = req.query.rules_query.replace(/\'/g, "''").trim()
    delete queryResults.query

    if (req.query.json == "true") {
        res.status(200).json(queryResults)
    } else {
        res.render(req.baseUrl.substr(1), queryResults)
    }
}

module.exports = router