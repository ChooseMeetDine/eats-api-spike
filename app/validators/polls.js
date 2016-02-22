var pollValidator = {};

pollValidator.validateGet = function(req, res, next) {
  console.log('Validating GET-request for polls...... done!');
  next();
};
pollValidator.validatePost = function(req, res, next) {
  console.log('Validating POST-request for polls...... done!');
  next();
};
pollValidator.validatePut = function(req, res, next) {
  console.log('Validating PUT-request for polls...... done!');
  next();
};

module.exports = pollValidator;
