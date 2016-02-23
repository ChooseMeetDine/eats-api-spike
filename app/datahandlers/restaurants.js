var Promise = require('bluebird');
var using = Promise.using;
var postgres = require('../shared/postgres');
var handler = {};
var RestaurantModel = require('../models/restaurant');

var getAllRestaurants = function(req) {
  var model = new RestaurantModel(req);
  var query = model.select();

  return using(postgres(), function(conn) {
      return conn.queryAsync(query);
    })
    .catch(function(err) {
      return Promise.reject(err);
    })
    .then(function(result) {
      return result.rows;
    });
};

handler.get = function(req) {

  var response = {};

  return getAllRestaurants(req)
    .then(function(result) {
      response.route = result;
      response.socket = null;
      return response;
    });
};

var createRestaurant = function(req) {
  var model = new RestaurantModel(req);
  var query = model.insert();

  return using(postgres(), function(conn) {
      return conn.queryAsync(query);
    })
    .catch(function(err) {
      return Promise.reject(err);
    })
    .then(function(result) {
      return result.rows;
    });
};

handler.post = function(req) {
  var response = {};
  return createRestaurant(req)
    .then(function(result) {
      response.route = result;
      response.socket = null;
      return response;
    });
};




module.exports = handler;
