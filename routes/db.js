const Pool = require("pg").Pool
const url = require("url")
const errorRouter = require('./error')

const pool = new Pool({
    user: 'user',
    host: 'host',
    database: 'database',
    password: 'password',
    port: 5432,
})

const displayAsValues = ["montage", "image", "list"]
const displayAsDefault = "image"
const sortedByValues = ["set_name", "set_release", "collector_number", "name", "cmc", "type", "rarity"]
const sortedByDefault = "name"
const orderByValues = ["asc", "desc"]
const orderByDefault = "asc"

exports.executeQuery = function(req, res, next, sql, parameters, callback) {
    pool.query(sql, parameters)
        .then(queryResults => {
            if (callback == null) {
                defaultCallback(req, res, queryResults)
            } else {
                callback(req, res, queryResults)
            }
        })
        .catch(error => {
            errorRouter.handleError(500, error, req, res)
        })
}

function defaultCallback(req, res, queryResults) {
    if (req.query.json == "true") {
        res.status(200).json(queryResults.rows)
    } else {
        const displayAs = setDefaultValue(req.query.displayAs, displayAsDefault, displayAsValues)
        const sortedBy = setDefaultValue(req.query.sortedBy, sortedByDefault, sortedByValues)
        const orderBy = setDefaultValue(req.query.orderBy, orderByDefault, orderByValues)

        var dict = defaultResponse(req, res);
        dict["results"] = queryResults.rows

        res.render(req.baseUrl.substr(1), dict)
    }
}

function setDefaultValue(value, defaultValue, possibleValues) {
    var result = value

    if (!value || value === "") {
        result = defaultValue
    } else {
        if (!possibleValues.includes(value.toLowerCase())) {
            result = defaultValue
        }
    }

    return result
}

function defaultResponse(req, res) {
    const displayAs = setDefaultValue(req.query.displayAs, displayAsDefault, displayAsValues)
    const sortedBy = setDefaultValue(req.query.sortedBy, sortedByDefault, sortedByValues)
    const orderBy = setDefaultValue(req.query.orderBy, orderByDefault, orderByValues)

    return {
        baseUrl: req.baseUrl + url.parse(req.url).pathname,
        query: req.query.query,
        displayAs: displayAs,
        sortedBy: sortedBy,
        orderBy: orderBy
    }
}

exports.defaultResponse = defaultResponse

exports.cleanDisplayAs = function(displayAs) {
    return setDefaultValue(displayAs, displayAsDefault, displayAsValues)
}

exports.cleanSortedBy = function(sortedBy) {
    return setDefaultValue(sortedBy, sortedByDefault, sortedByValues)
}

exports.cleanOrderBy = function(orderBy) {
    return setDefaultValue(orderBy, orderByDefault, orderByValues)
}