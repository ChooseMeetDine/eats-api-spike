var auth = {};
auth.ensureAuthenticated = function(req, res, next) {

  // A THOUGHT:
  // If the user is successfully authenticated, add userID to something like req.userID
  // In this way, we can use req.userID as parameter for fields like 'creator' when inserting into
  // DB. Sounds good, no?

  req = req;
  res = res;
  console.log('Authorizing....... done!');
  //  example-code from satelizer
  //
  // if (!req.header('Authorization')) {
  //   return res.status(401).send({
  //     message: 'Please make sure your request has an Authorization header'
  //   });
  // }
  // var token = req.header('Authorization').split(' ')[1];
  //
  // var payload = null;
  // try {
  //   payload = jwt.decode(token, config.TOKEN_SECRET);
  // } catch (err) {
  //   return res.status(401).send({
  //     message: err.message
  //   });
  // }
  //
  // if (payload.exp <= moment().unix()) {
  //   return res.status(401).send({
  //     message: 'Token has expired'
  //   });
  // }
  // req.user = payload.sub;
  next();
};

module.exports = auth;
