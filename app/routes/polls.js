var express = require('express');
var router = express.Router();
var pollHandler = require('../datahandlers/polls');
var socket = require('../socket/socket');
var validator = require('../validators/polls');

router.get('/', validator.validateGet, function(req, res) {
  pollHandler
    .get(req)
    .then(function(response) {
      console.log('Sending data through HTTP... ' + JSON.stringify(response.route));
      res.send(response.route);
    })
    .catch(function(err) {
      res.status(500).send(err);
    });
});

router.post('/', validator.validatePost, function(req, res) {
  pollHandler
    .post(req)
    .then(function(response) {

      if (!socket.openConnection(response.socket)) {
        console.log('WARNING: could not open TCP-connection');
        response.route.warning = 'WARNING: could not open TCP-connection';
      }
      console.log('Sending data through HTTP... ' + JSON.stringify(response.route));
      res.send(response.route);
    })
    .catch(function(err) {
      res.status(500).send(err);
    });
});

router.put('/', validator.validatePut, function(req, res) {
  pollHandler
    .put(req)
    .then(function(response) {

      if (socket.send(response.socket)) {
        console.log('Sending data through HTTP... ' + JSON.stringify(response.route));
        res.send(response.route);
      } else {
        res.send('ERROR: Socket could not send data');
      }
    })
    .catch(function(err) {
      res.status(500).send(err);
    });
});

module.exports = router;
