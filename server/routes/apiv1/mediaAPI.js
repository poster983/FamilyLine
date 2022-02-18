var express = require('express');
var router = express.Router();
const proxy = require('express-http-proxy');
//const url = require('url');
var crypto = require("crypto-js");

const SMCloudStore = require('smcloudstore')

// Complete with the connection options for GenericS3

const connection = {
    endPoint: process.env.S3_FULL_URL,
    accessKey: process.env.S3_KEY_ID,
    secretKey: process.env.S3_APPLICATION_KEY,
    region: process.env.S3_REGION
}

// Return an instance of the GenericS3Provider class
const storage = SMCloudStore.Create('generic-s3', connection)

function getS3SignatureKey(key, dateStamp, regionName, serviceName) {
    var kDate = crypto.HmacSHA256(dateStamp, "AWS4" + key);
    var kRegion = crypto.HmacSHA256(regionName, kDate);
    var kService = crypto.HmacSHA256(serviceName, kRegion);
    var kSigning = crypto.HmacSHA256("aws4_request", kService);
    return kSigning;
}

router.get("/s3/new/*", async (req,res,next) => {
  try {
    console.log(req.params[0])
    let stream = await storage.getObject(process.env.S3_BUCKET, req.params[0])
    console.log(stream)
    res.write(stream)
    res.end()
  } catch(e) {
    console.error(e)
    if(e?.code == 'NoSuchKey') {
      const err = new Error("Image not found"); 
      err.status = 404;
      return next(err)
    } else {
      return next(e);
    }
  }
  

});


router.use('/s3/*', proxy(process.env.S3_FULL_URL, { //process.env.S3_FULL_URL
  proxyReqPathResolver: function (req) {
    console.log(req.params)
    return req.url + req.params[0]
  },
  //proxyReqPathResolver: req => url.parse(req.baseUrl).path,
  proxyReqOptDecorator: function (proxyReqOpts, srcReq) {
    //proxyReqOpts.headers = {"Authorization": `AWS ${process.env.S3_KEY_ID}:${getS3SignatureKey(process.env.S3_APPLICATION_KEY, Date.now())}`};
    return proxyReqOpts;
  }
  // userResHeaderDecorator(headers, userReq, userRes, proxyReq, proxyRes) {
  //   // recieves an Object of headers, returns an Object of headers.
  //   console.log(headers)
  //   proxyReq.set("Authorization", `AWS AWSAccessKeyId:Signature`)
  //   //console.log(proxyReq, )
  //   return headers;
  // }
}));





module.exports = router;
