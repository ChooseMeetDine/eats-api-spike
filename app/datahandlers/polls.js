var Promise = require('bluebird');
var using = Promise.using;
var postgres = require('../shared/postgres');
var handler = {};

var getAllPolls = function() {
  var query = 'select * from poll, restaurant_poll where poll.id = restaurant_poll.poll';
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

var createPoll = function(req) {
  var parameters = req.body; //Maybe not this exactly?
  var query = 'INSERT INTO poll (name, creator)' +
    'VALUES (' + parameters + ', ' + req.user + ')';


  return using(postgres(), function(conn) {
      return conn.queryAsync(query);
    })
    .catch(function(err) {
      return Promise.reject(err);
    })
    .then(function(result) {
      //do we need to query the database to get the data or is it already here?
      return result.rows;
    });
};

var updatePoll = function(req) {
  var parameters = req.body; //Maybe not this exactly?

  var query = 'INSERT INTO restaurant_poll (restaurant, poll)' +
    'VALUES (' + parameters.restaurant + ', ' + parameters.restaurant + ')';

  return using(postgres(), function(conn) {
      return conn.queryAsync(query);
    })
    .catch(function(err) {
      return Promise.reject(err);
    })
    .then(function(result) {
      //do we need to query the database to get the data or is it already here?
      return result.rows;
    });
};

handler.get = function(req) {
  req = req; //not used yet, dont want linter error..
  var response = {};

  return getAllPolls()
    .then(function(result) {
      response.route = result;
      response.socket = null;
      return response;
    });
};

handler.post = function(req) {
  var response = {};

  return createPoll(req)
    .then(function(result) {
      response.route = result;
      response.socket = result;
      return response;
    });
};

handler.put = function(req) {
  var response = {};

  return updatePoll(req)
    .then(function(result) {
      response.route = result;
      response.socket = result;
      return response;
    });
};

module.exports = handler;
