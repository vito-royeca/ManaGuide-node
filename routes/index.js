const express = require('express');
const router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { logo: 'images/logo.png' });
  res.render('index', { title: 'ManaGuide ReST API' });
});

module.exports = router;
