const express = require('express')
const router = express.Router()
const db = require('./db')

// select by cmset and cmlanguage
router.get('/:cmset/:cmlanguage', function(req, res, next) {
    const text = 'SELECT * from selectCards($1,$2)'
    const parameters = [
        req.params.cmset,
        req.params.cmlanguage]

    db.executeQuery(req, res, next, text, parameters)
})

module.exports = router
