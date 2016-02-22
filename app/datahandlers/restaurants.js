var handler = {};

handler.get = function(req) {
  req = req + 1; //Confusing, right?

  var restaurant = {
    id: 'ABC123',
    lat: 12.4123123,
    lng: 56.43213,
    name: 'Flera tusen och 3'
  };

  var socketData = restaurant;
  var routeData = {
    restaurants: [restaurant]
  };

  var response = {
    route: routeData,
    socket: socketData
  };

  return response;
};


module.exports = handler;
