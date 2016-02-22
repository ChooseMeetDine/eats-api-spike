var pg = require('pg');
var Promise = require('bluebird');
pg.defaults.poolSize = 50;

Promise.promisifyAll(pg, {
  filter: function(methodName) {
    return methodName === 'connect';
  },
  multiArgs: true
});
Promise.promisifyAll(pg);

function postgres(connectionString) {
  var close;
  if (!connectionString) {
    connectionString = process.env.POSTGRES_CONNECTION;
  }

  return pg.connectAsync(connectionString).spread(function(client, done) {
    close = done;
    return client;
  }).disposer(function() {
    if (close) {
      close();
    }
  });
}

module.exports = postgres;
