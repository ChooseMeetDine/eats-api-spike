var Promise = require('bluebird');
var using = Promise.using;
var postgres = require('../shared/postgres');
var handler = {};

var getAllUsers = function() {
  var query = 'select * from \"user\"';
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
