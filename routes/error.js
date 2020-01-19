exports.handleError = function(code, err, req, res, parameters)  {
    console.log(err.message)
    console.log(parameters)

    res.locals.message = err.message
    res.locals.status = code
    res.render('error')
}