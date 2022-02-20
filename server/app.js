var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
require('dotenv').config()

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


app.use('/apiv1', require('./routes/apiv1/apiv1'));
app.use('/dev', require('./routes/dev'));


app.use('/', require('./routes/index'));

//404 handler
app.use(function(req, res, next) {
    var err = new Error("Not Found");
    err.status = 404;
    next(err);
});


// error handler
// app.use(function(err, req, res, next) {
//     // set locals, only providing error in development
//     //console.error(err)

//     if(!err.status){
//         err.status = 500;
//     }
//     // if(Raven) {
//     //     if(err.status != 404) {
//     //         var extra = {};
//     //         extra.level = err.level;
//     //         console.log(extra);
//     //         RavenUber.captureException(err, extra);
//     //     }
//     // }
//     res.locals.message = err.message;
//     // if(config.has("secrets.loggingDSN") && Raven){
//     //     res.locals.raven = true;
//     // } else {
//     //     res.locals.raven = false;
//     // }
//     res.locals.error = req.app.get("env") === "development" ? err : {status: err.status};

//     //console.log(err)
//     // render the error page
  
//     res.set("errormessage", encodeURIComponent(err.message));
//     res.status(err.status);
//     res.render("error");
  

// });

export default app;
