var express = require('express');
var router = express.Router();
var docs = require('./docs');
var restaurants = require('./restaurants');
var users = require('./users');
var polls = require('./polls');
var auth = require('./../middlewares/authorization');
var bodyParser = require('body-parser');

// create application/json parser
var jsonParser = bodyParser.json();

var root = function(req, res) {
  res.send('<p>Du gick till rooten i API:et och här är env-variabeln MONGO_DB_USER i .env: ' +
    process.env.MONGO_DB_USER + '</p>');
};


router.get('/', root);
router.use('/docs', docs);
router.use('/polls', auth.ensureAuthenticated, jsonParser, polls);
router.use('/restaurants', auth.ensureAuthenticated, jsonParser, restaurants);
router.use('/users', auth.ensureAuthenticated, jsonParser, users);

module.exports = router;
