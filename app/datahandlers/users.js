<<<<<<< HEAD
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
=======
// var Promise = require('bluebird');
// var using = Promise.using;
var pg = require('../shared/knex');
var handler = {};

var getAllUsers = function() {
  return pg.select('*').from('user');
>>>>>>> 17d4b9cd88aaf2e246a607c9ced50e40bef4df1c
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
