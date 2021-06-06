var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  console.log("Estás llamando al recurso index");
  res.render('index', { title: 'Mostapha App' });
});

module.exports = router;
