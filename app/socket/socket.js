var socket = {};

socket.send = function(socketData) {
  console.log('Sending data through websockets... ' + JSON.stringify(socketData));

  return true;
};

module.exports = socket;
