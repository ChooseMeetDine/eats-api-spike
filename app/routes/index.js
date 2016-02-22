var express = require('express');
var router = express.Router();
var docs = require('./docs');
var restaurants = require('./restaurants');

router.get('/', function(req, res) {
  res.send('<p>Du gick till rooten i API:et och här är env-variabeln MONGO_DB_USER i .env: ' +
    process.env.MONGO_DB_USER + '</p>');
});

router.use('/docs', docs);
router.use('/restaurants', restaurants);

module.exports = router;
