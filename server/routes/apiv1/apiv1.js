var express = require('express');
var router = express.Router();

router.use('/media', require('./media'));

module.exports = router;
