var io = require('socket.io')();
var app = {};
var socket;
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
