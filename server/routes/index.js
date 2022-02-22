import express from 'express';
var router = express.Router();


/* GET home page. */
router.get('/*', function(req, res, next) {
  console.log("Send Flutter App")
  res.render('index', { title: 'Express' });
});


export default router;
