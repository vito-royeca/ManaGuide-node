const express = require('express')
const url = require("url")
const router = express.Router()

router.get('/', function(req, res, next) {
    res.render("mobile", {
        baseUrl: req.baseUrl + url.parse(req.url).pathname
    })
});

module.exports = router