var express = require('express');
var router = express.Router();
var userHandler = require('../datahandlers/users');
var validator = require('../validators/users');

router.get('/', validator.validateGet, function(req, res) {
  userHandler
    .get(req)
    .then(function(response) {
      res.send(response.route);
    })
    .catch(function(err) {
      res.status(500).send(err);
    });
});

module.exports = router;
