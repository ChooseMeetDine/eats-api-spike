var express = require('express');
var router = express.Router();
var usersHandler = require('../datahandlers/users');

router.get('/', function(req, res) {
  usersHandler
    .get(req)
    .then(function(response) {
      console.log(response.route);
      console.log(response.route[3].name);
      console.log(response.route[3].name);
      console.log(response.route[3].name);
      res.send(response.route);
    })
    .catch(function(err) {
      res.status(500).send(err);
    });
});

module.exports = router;
