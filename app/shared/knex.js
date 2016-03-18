// This is currently only used for GET /users in the routes folder
var pg = require('knex')({
  client: 'pg',
  connection: process.env.POSTGRES_CONNECTION,
  searchPath: 'knex,public',
  pool: {
    min: 1,
    max: 20
  }
});

module.exports = pg;
