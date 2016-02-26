var express = require('express');
var router = express.Router();
var restaurantHandler = require('../datahandlers/restaurants');
var validator = require('../validators/restaurants');
var valid = require('../validators/test');
var connection = require('../socket/socket');

router.get('/', validator.validateGet, function(req, res) {
  connection.sendDataToId('id001', 'Someone connected to /restaurants');
  restaurantHandler
    .get(req)
    .then(function(response) {
      res.send(response.route);
    })
    .catch(function(err) {
      res.status(500).send(err);
    });
});

router.post('/', valid.postBody, function(req, res) {
  res.send(req.valid);
});

module.exports = router;
