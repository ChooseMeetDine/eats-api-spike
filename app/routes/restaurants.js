var express = require('express');
var router = express.Router();
var restaurantHandler = require('../datahandlers/restaurants');
var restaurantSocket = require('../socket/socket');

router.get('/', function(req, res) {
  var response = restaurantHandler.get(req);

  if (restaurantSocket.send(response.socket)) {
    console.log('Sending data through HTTP... ' + JSON.stringify(response.route));
    res.send(response.route);
  } else {
    res.send('ERROR: Socket could not send data');
  }
});

router.get('/:id', function(req, res) {
  var response = restaurantHandler.get(req);

  res.send(response);
});

router.get('/updates', function(req, res) {
  var response = restaurantHandler.get(req);

  res.send(response);
});


module.exports = router;
