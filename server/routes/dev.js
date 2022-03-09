import express from 'express';
var router = express.Router();

router.get('/echo/*', function(req, res, next) {
    res.json(req)
  });




export default router;
