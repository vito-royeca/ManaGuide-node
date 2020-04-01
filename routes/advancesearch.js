const express = require('express')
const url = require("url")
const router = express.Router()
const db = require('./db')
const my = require('./my')
const errorRouter = require('./error')

router.get('/', function(req, res, next) {
    res.render("advancesearch",  {
        baseUrl: req.baseUrl + url.parse(req.url).pathname
    })
})


module.exports = router
