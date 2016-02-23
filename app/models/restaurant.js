function RestaurantModel(req) {
  RestaurantModel.data = req.body;
}

RestaurantModel.data = {};

RestaurantModel.prototype.select = function select() {
  //Bygg med knex
  var query = 'select id, name, lat, lng, info from restaurant ';
  return query;
};

RestaurantModel.prototype.insert = function select() {
  var d = RestaurantModel.data;
  //Bygg med knex
  var query = 'INSERT INTO restaurant ' +
    '(name, lat, lng, info, price_rate, creator, created, temporary) ' +
    'VALUES (' + d.name + ', ' + d.lat + ', ' + d.lng + ', ' + d.info + ', ' + d.priceRate +
    ', ' + d.user + ', now(), false);';

  return query;
};


module.exports = RestaurantModel;
