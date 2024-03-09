const express = require('express')
const router = express.Router()
const db = require('./db')

// select by cmset and cmlanguage
router.get('/:cmset/:cmlanguage', function(req, res, next) {
    const sql = 'SELECT selectCards($1,$2)'
    const parameters = [
        req.params.cmset,
        req.params.cmlanguage]

    db.executeQuery(req, res, next, sql, parameters, null)
})

module.exports = router
