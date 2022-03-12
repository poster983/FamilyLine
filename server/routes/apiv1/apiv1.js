import express from 'express';
var router = express.Router();
import mediaAPI from "./mediaAPI.js"
import authAPI from "./authAPI.js"
import mongoose from 'mongoose';
import { error } from "../../lib/errorUtils.js";
import cors from "cors"
router.use(cors());
router.options('*', cors())
//router.use(verifyIDs)

router.use('/group/:groupID/media',  mediaAPI);
router.use('/auth', authAPI)

//error
router.use(function(err, req, res, next) {
    // set locals, only providing error in development
    //console.error(err)

    if(!err.status){
        err.status = 500;
    }
    // if(Raven) {
    //     if(err.status != 404) {
    //         var extra = {};
    //         extra.level = err.level;
    //         console.log(extra);
    //         RavenUber.captureException(err, extra);
    //     }
    // }
    res.locals.message = err.message;
    // if(config.has("secrets.loggingDSN") && Raven){
    //     res.locals.raven = true;
    // } else {
    //     res.locals.raven = false;
    // }
    //res.locals.error = req.app.get("env") === "development" ? err : {status: err.status};

    //console.log(err)
    // render the error page
  
    //res.set("errormessage", encodeURIComponent(err.message));
    res.status(err.status);
    //res.render("error");
    res.json({
        message: err.message,
        status: err.status,
        full: req.app.get("env") === "development" ? err : null
    })
  

});

export default router;
