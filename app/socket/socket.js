var io = {};
var connection = {};

connection.inits = function (incomingIo) {
  io = incomingIo;
  //Denna loggar vid varje klient anslutning.
  io.on('connection', function (socket) {
    console.log('connection socket io' + socket);
  });
};

connection.sendDataToId = function (pollId, dataToSend) {
  io.sockets.emit(pollId, dataToSend);
};

/* Detta är namespace
connection.socketNS = function () {
  var nsp = io.of('/polls');
  nsp.on('connection', function (socket) {
    console.log('someone connected to the poll');
    socket.emit('data2', 'everyone!');
  });
};
*/

module.exports = connection;
