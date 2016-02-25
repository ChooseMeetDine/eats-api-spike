var Promise = require('bluebird');
var using = Promise.using;
var postgres = require('../shared/postgres');
var handler = {};
var connection = require('../socket/socket');

var getAllRestaurants = function () {
  var query = 'select * from restaurant';
  return using(postgres(), function (conn) {
      return conn.queryAsync(query);
    })
    .catch(function (err) {
      return Promise.reject(err);
    })
    .then(function (result) {
      return result.rows;
    });
};

handler.get = function (req) {
  req = req; //not used yet, dont want linter error..

  var response = {};

  return getAllRestaurants()
    .then(function (result) {
      response.route = result;
      response.socket = null;
      return response;
    });
};




module.exports = handler;
