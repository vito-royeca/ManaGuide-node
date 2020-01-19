exports.handleError = function(code, err, req, res) {
    console.log(err.message)

    res.locals.message = "Ooops... something went wrong."
    res.locals.status = code
    res.render('error')
}