var Promise = require('bluebird');
var using = Promise.using;
var postgres = require('../shared/postgres');
var handler = {};

var getAllRestaurants = function() {
  var query = 'select * from restaurants';
  return using(postgres(), function(conn) {
      return conn.queryAsync(query);
    })
    .catch(function(err) {
      return Promise.reject(err);
    })
    .then(function(result) {
      return result.rows[0];
    });
};

handler.get = function(req) {
  req = req; //not used yet, dont want linter error..

  var response = {};

  return getAllRestaurants()
    .then(function(result) {
      response.route = null;
      response.socket = result;
      return response;
    });
};




module.exports = handler;
