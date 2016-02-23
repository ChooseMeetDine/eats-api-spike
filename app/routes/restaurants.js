var express = require('express');
var router = express.Router();
var restaurantHandler = require('../datahandlers/restaurants');
var validator = require('../validators/restaurants');
var connection = require('../socket/socket');

router.get('/', validator.validateGet, function (req, res) {
  connection.sendDataToId('id001', 'Someone connected to /restaurants');
  restaurantHandler
    .get(req)
    .then(function (response) {
      res.send(response.route);
    })
    .catch(function (err) {
      res.status(500).send(err);
    });
});

module.exports = router;
