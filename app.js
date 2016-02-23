var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var routes = require('./app/routes/index');
var connection = require('./app/socket/socket');

app.use('/', routes);

connection.inits(io);

var port = process.env.PORT || 3001;

http.listen(port, function () {
  console.log('Eats API-server listening on port: ' + port);
});

module.exports = app;
