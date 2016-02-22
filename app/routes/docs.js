var express = require('express');
var router = express.Router();
var aglio = require('aglio');
var path = require('path');

router.get('/', function(req, res) {
  var options = {
    themeTemplate: 'default',
    locals: {
      myVariable: 125
    }
  };
  aglio.renderFile('./public/docs/README.apib', './public/docs/documentation.html', options,
    function(err, warnings) {
      if (err) {
        return console.log(err);
      }
      if (warnings) {
        console.log(warnings);
      }
      res.sendFile(path.join(__dirname, '../../public/docs', 'documentation.html'));
    });
});



module.exports = router;
