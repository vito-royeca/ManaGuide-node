const Pool = require("pg").Pool
const url = require("url")

const pool = new Pool({
    user: 'user',
    host: 'localhost',
    database: 'database',
    password: 'password',
    port: 5432,
})

exports.executeQuery = function(req, res, next, text, parameters)  {
    pool.query(text, parameters)
        .then(queryResults => {
            if (req.query.json == "true") {
                res.status(200).json(queryResults.rows)
            } else {
                if (!req.query.displayAs || req.query.displayAs === "") {
                    req.query.displayAs = "montage"
                }
                if (!req.query.sortedBy || req.query.sortedBy === "") {
                    req.query.sortedBy = "name"
                }
                if (!req.query.orderBy || req.query.orderBy === "") {
                    req.query.orderBy = "ascending"
                }

                res.render(req.baseUrl.substr(1),
                    {
                        baseUrl: req.baseUrl + url.parse(req.url).pathname,
                        query: req.query.query,
                        displayAs: req.query.displayAs,
                        sortedBy: req.query.sortedBy,
                        orderBy: req.query.orderBy,
                        data: queryResults.rows
                    })
            }
        })
        .catch(error => {
            console.log(error.message)
            console.log(parameters)
            res.statusCode = 500
            res.end(error.message)
        })
}

