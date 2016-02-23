var io = require('socket.io')();
var app = {};
var socket;
/**
 *
 *	All kod här i är troligen riktig skräpkod som inte ens är nära på att fungera.
 *	Men det är för att jag bara satt upp filen så att den som vill sitta med det bara behöver
 *	pilla i denna filen och inte krocka med resten.
 *
 * Lycka till!
 *
 */


app.openConnection = function(socketData) {

  if (!socket) {
    io.on('connection', function(soc) {
      socket = soc;
      console.log('Opened channel on:' + socketData);
    });
  }


  return true;
};

app.send = function(socketData) {
  if (!socket) {
    return false;
  }
  var channel = socketData.channel;
  socket.emit(channel, socketData.data);
  console.log('Sending data through websockets at channel:' +
    socketData.channel +
    ' ... ' + JSON.stringify(socketData.data));

  return true;
};

module.exports = app;
