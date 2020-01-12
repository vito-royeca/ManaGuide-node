const Pool = require('pg').Pool

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
            if (req.query.web == "true") {
                res.render(req.baseUrl.substr(1),
                    {
                        query: req.query.query,
                        data: queryResults.rows
                    })
            } else {
                res.status(200).json(queryResults.rows)
            }
        })
        .catch(error => {
            console.log(error.message)
            console.log(parameters)
            res.statusCode = 500
            res.end(error.message)
        })
}

