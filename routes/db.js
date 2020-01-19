const Pool = require("pg").Pool
const url = require("url")
const errorRouter = require('./error')

const pool = new Pool({
    user: 'user',
    host: 'localhost',
    database: 'database',
    password: 'password',
    port: 5432,
})

const displayAsValues = ["montage", "image", "list"]
const displayAsDefault = "list"
const sortedByValues = ["set_name", "set_release", "collector_number", "name", "cmc", "type", "rarity"]
const sortedByDefault = "name"
const orderByValues = ["asc", "desc"]
const orderByDefault = "asc"

exports.executeQuery = function(req, res, next, text, parameters) {
    const displayAs = setDefaultValue(req.query.displayAs, displayAsDefault, displayAsValues)
    const sortedBy = setDefaultValue(req.query.sortedBy, sortedByDefault, sortedByValues)
    const orderBy = setDefaultValue(req.query.orderBy, orderByDefault, orderByValues)

    pool.query(text, parameters)
        .then(queryResults => {
            if (req.query.json == "true") {
                res.status(200).json(queryResults.rows)
            } else {
                res.render(req.baseUrl.substr(1), {
                    baseUrl: req.baseUrl + url.parse(req.url).pathname,
                    query: req.query.query,
                    displayAs: displayAs,
                    sortedBy: sortedBy,
                    orderBy: orderBy,
                    data: queryResults.rows
                })
            }
        })
        .catch(error => {
            errorRouter.handleError(500, error, req, res, parameters)
        })
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

exports.cleanDisplayAs = function(displayAs) {
    return setDefaultValue(displayAs, displayAsDefault, displayAsValues)
}

exports.cleanSortedBy = function(sortedBy) {
    return setDefaultValue(sortedBy, sortedByDefault, sortedByValues)
}

exports.cleanOrderBy = function(orderBy) {
    return setDefaultValue(orderBy, orderByDefault, orderByValues)
}