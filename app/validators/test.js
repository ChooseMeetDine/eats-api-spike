var validationObject = {};
var isvalid = require('isvalid');

var inRange = function(value, min, max) {
  return (value >= min && value <= max);
};

var isInteger = function(value) {
  return (typeof value === 'number' && (value % 1) === 0);
};

validationObject.postBody = function(req, res, next) {
  var template = {
    type: Object,
    unknownKeys: 'deny',
    required: 'implicit',
    schema: {
      'name': {
        type: String,
        required: true,
        errors: {
          type: 'name must be a String',
          required: 'name is required.'
        }
      },
      'lat': {
        type: Number,
        required: true,
        custom: function(value) {
          if (!inRange(value, -180, 180)) {
            throw new Error('lat has to be between -180 and 180');
          }
          return value;
        },
        errors: {
          type: 'lat must be a number',
          required: 'lat is required.'
        }
      },
      'lng': {
        type: Number,
        required: true,
        custom: function(value) {
          if (!inRange(value, -180, 180)) {
            throw new Error('lng has to be between -180 and 180');
          }
          return value;
        },
        errors: {
          type: 'lng must be a number',
          required: 'lng is required.'
        }
      },
      'pricerate': {
        type: Number,
        required: false,
        custom: [
          function(value) {
            if (!isInteger(value)) {
              throw new Error('pricerate must be an integer between 1 and 5');
            }
            return value;
          },
          function(value) {
            if (!inRange(value, 1, 5)) {
              throw new Error('pricerate must be an integer between 1 and 5');
            }
            return value;
          }
        ],
        errors: {
          type: 'pricerate must be an integer between 1 and 5'
        }
      },
      'info': {
        type: String,
        required: false,
        errors: {
          type: 'name must be a String'
        }
      },
    }
  };


  isvalid(req.body, template, function(err, validData) {
    if (err) {
      //Hantera fel på ett bättre sätt
      var errrr = {
        error: {
          message: err.message
        }
      };
      res.status(400).send(err);
    } else {
      req.valid = validData;
      next();
    }
  });
  console.log(req.body);
};



module.exports = validationObject;
