// var Promise = require('bluebird');
// var using = Promise.using;
var pg = require('../shared/knex');
var handler = {};

var getAllUsers = function() {
  return pg.select('*').from('user');
};

handler.get = function(req) {
  req = req; //not used yet, dont want linter error..

  var response = {};

  return getAllUsers()
    .then(function(result) {
      response.route = result;
      response.socket = null;
      return response;
    });
};




module.exports = handler;
