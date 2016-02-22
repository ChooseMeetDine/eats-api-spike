var express = require('express');
var router = express.Router();
var restaurantHandler = require('../datahandlers/restaurants');
var validator = require('../validators/restaurants');

router.get('/', validator.validateGet, function(req, res) {
  restaurantHandler
    .get(req)
    .then(function(response) {
      var response = restaurantHandler.get(req);
      res.send(response.route);
    })
    .catch(function(err) {
      res.status(500).send(err);
    });
});

module.exports = router;
