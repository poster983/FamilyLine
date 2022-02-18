var express = require('express');
var router = express.Router();

router.get('/echo/*', function(req, res, next) {
    res.json(req)
  });

module.exports = router;
