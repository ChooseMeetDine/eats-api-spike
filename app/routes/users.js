var express = require('express');
var router = express.Router();
<<<<<<< HEAD
var userHandler = require('../datahandlers/users');
var validator = require('../validators/users');

router.get('/', validator.validateGet, function(req, res) {
  userHandler
    .get(req)
    .then(function(response) {
=======
var usersHandler = require('../datahandlers/users');

router.get('/', function(req, res) {
  usersHandler
    .get(req)
    .then(function(response) {
      console.log(response.route);
      console.log(response.route[3].name);
      console.log(response.route[3].name);
      console.log(response.route[3].name);
>>>>>>> 17d4b9cd88aaf2e246a607c9ced50e40bef4df1c
      res.send(response.route);
    })
    .catch(function(err) {
      res.status(500).send(err);
    });
});

module.exports = router;
