var restaurantValidator = {};

restaurantValidator.validateGet = function(req, res, next) {
  console.log('Validating GET-request for restaurants...... done!');
  next();
};

module.exports = restaurantValidator;
