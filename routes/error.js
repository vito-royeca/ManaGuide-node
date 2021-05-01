exports.handleError = function(code, err, req, res) {
    if (err.message != null) {
        console.log(err)
    }
    res.locals.status = code
    res.locals.message = "Ooops... something went wrong."
    res.render('error')
}