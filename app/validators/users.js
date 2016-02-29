var userValidator = {};

userValidator.validateGet = function(req, res, next) {
  console.log('Validating GET-request for user...... done!');
  next();
};
userValidator.validatePost = function(req, res, next) {
  console.log('Validating POST-request for user...... done!');
  next();
};
userValidator.validatePut = function(req, res, next) {
  console.log('Validating PUT-request for user...... done!');
  next();
};

module.exports = userValidator;
