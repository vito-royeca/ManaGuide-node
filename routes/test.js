const express = require('express')
const router = express.Router()
const tcgplayer = require('./tcgplayer')

router.get('/', function(req, res, next) {
    res.render("test")
});

router.post('/tcgplayerAuthenticate', function(req, res, next) {
    tcgplayer.authenticate(function() {
        res.render("test", {tcgplayerToken: tcgplayer.token})
    })
        /*.then(function() {
            res.render("test", {tcgplayerToken: tcgplayer.token})
        }).catch(err => {
            console.log(err)
        })*/
})

module.exports = router