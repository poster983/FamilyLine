
import { Router } from 'express';
const router = Router({mergeParams: true});
import { tmpdir } from 'os';
import { error } from "../../lib/errorUtils.js";
import { promises as fsP } from 'fs';
import {PaginationParameters} from "mongoose-paginate-v2";
import storage from "../../s3.js"
import mongoose from "mongoose";
import multer from 'multer';
const upload = multer({ 
  dest: tmpdir()+'/familyline_useruploads', 
  limits: { fileSize: 2000000000 }
})
console.log("Upload Directory: " + tmpdir()+'/familyline_useruploads')
import DBMedia from '../../lib/mongoose/DBMedia.js';
import {verifyAccessToken, checkGroup} from "../../lib/authUtils.js"
import { uploadObject} from "../../lib/mediaUtils.js";

// Complete with the connection options for GenericS3
console.log(process.env.S3_ENDPOINT)


//verify ids middleware
const verifyIDs = (req,res,next) => {
  if(req.params.groupID && !mongoose.isValidObjectId(req.params.groupID)) {
      return next(error("'groupID' is invalid", 400));
  }

  if(req.params.mediaID && !mongoose.isValidObjectId(req.params.mediaID)) {
      return next(error("'mediaID' is invalid", 400));
  }
  return next();
}


/**
 * @api {post} /apiv1/group/:groupID/media/
 * @apiName UploadMedia
 * @apiGroup Media
 * @apiHeader {String} Authorization - Formatted as `Bearer {AccessToken}`
 * @apiParam {String} groupID - The id of the group that this media belongs too.
 * @apiSuccess {String} status - processing
 * @apiVersion 1.0.0
 */
 router.post("/", verifyIDs, verifyAccessToken, checkGroup, upload.single('file'), async (req,res,next) => {
    //console.log("GroupID", req.params['groupID'])
    if(req.file == null) {
      return next(error("Multipart file upload required", 400))
    }
    console.log(req.file)
    try { 
      const status = await uploadObject(req.file, req.params.groupID)
      fsP.unlink(req.file.path);
      res.status(201);
      res.json(status)
    } catch(e) {
      fsP.unlink(req.file.path);
      return next(e)
    }
 });


/**
 * @api {get} /apiv1/group/:groupID/media/
 * @apiName ListAllMedia
 * @apiGroup Media
 * @apiDescription Lists all media in order with pagenation
 * @apiHeader {String} Authorization - Formatted as `Bearer {AccessToken}`
 * @apiQuery {Object} [filter] - Mongodb filter Query (ignores groupID).  
 * @apiQuery {Object} [sort] - Mongodb Sort Syntax. Pass as a json string
 * @apiQuery {Number} [page=1] - Page number for pagination
 * @apiQuery {Number} [limit=10] - Number of records to return on a page.
 * @apiParam {String} groupID - The id of the group that this media belongs too.
 * @apiVersion 1.0.0
 */
 router.get("/", verifyIDs, verifyAccessToken, checkGroup, async (req,res,next) => {
  //console.log(req.query)
  try {
    if(req.query.filter) {
      req.query.filter = JSON.parse(req.query.filter)
      req.query.filter.groupID = req.params.groupID;
    } else {
      req.query.filter = {}
    }
    //console.
    let opts = new PaginationParameters(req).get()
    opts[0] = req.query.filter;
    //console.log(opts)
    let doc = await DBMedia.paginate(...opts)
    if(!doc) {
      return next(error("Media object not found",404));
    }
    return res.json(doc);
  } catch(e) {
    return next(error(e,500));
  }
  
});



/**
 * @api {get} /apiv1/group/:groupID/media/:mediaID/
 * @apiName GetMediaData
 * @apiGroup Media
 * @apiDescription Gets all metadata associated with the mediaID
 * @apiHeader {String} Authorization - Formatted as `Bearer {AccessToken}`
 * @apiParam {String} mediaID - The id of the object.
 * @apiParam {String} groupID - The id of the group that this media belongs too.
 * @apiVersion 1.0.0
 */
router.get("/:mediaID", verifyIDs, verifyAccessToken, checkGroup, async (req,res,next) => {
  try {
    let doc = await DBMedia.findById(req.params.mediaID)
    if(!doc) {
      return next(error("Media object not found",404));
    }
    doc.__v = undefined;
    return res.json(doc);
  } catch(e) {
    return next(error(e,500));
  }
  
});



/**

/**
 * @api {get} /apiv1/group/:groupID/media/:version/:mediaID/:versionID
 * @apiName GetMedia
 * @apiGroup Media
 * @apiHeader {String} Authorization - Formatted as `Bearer {AccessToken}`
 * @apiParam {String} version - Can be `original`, `thumbnail`, `display`  if display then remember to add the versionID
 * @apiParam {String} mediaID - The id of the object.
 * @apiParam {String} groupID - The id of the group that this media belongs too.
 * @apiParam {String} versionID - Used with display.  The version of the file to use.
 * @apiVersion 1.0.0
 */
router.get(["/:version/:mediaID", "/:version/:mediaID/:versionID"], verifyIDs, verifyAccessToken, checkGroup, async (req,res,next) => { // should ensure the user has sufficient permissions to view the file
  
  
  if(!req.params.version.match(/^((display)|(thumbnail)|(original))/g)) {
      return next(error(`Got ${req.params.version} expected 'display', 'thumbnail', or 'original'`, 400));
  }
  if(req.params.version ==='display' && !req.params.versionID) {
    return next(error("`versionID` required when using `display`", 400)) 
  } else if(req.params.version !=='display' && req.params.versionID) {
    return next(error("`versionID` required when using `display`", 400)) 
  }
  const path = `groups/${req.params.groupID}/usermedia/${req.params.version}/${req.params.mediaID}${(req.params.versionID)?"/"+req.params.versionID:''}`
  //^((display)|(thumbnail)|(original))
  try {
    //let metaData = await storage.h(process.env.S3_BUCKET, req.params[0])
    console.log("Fetching from bucket using: ", path)
    let stream = await storage.getObject(process.env.S3_BUCKET,path)
    stream.on('error', function error(err) {
        //continue to the next middlewares
        return next(err);
    });
    //stream
    console.log(stream.headers)
    res.set('Content-Type', stream.headers['content-type']);
    res.set('Content-Length', stream.headers['content-length']);
    res.set('Last-Modified', stream.headers['last-modified']);
    res.set('ETag', stream.headers['etag']);
    res.set('Cache-Control', 'private, max-age=604800')
    stream.pipe(res)
    //res.end()
  } catch(e) {
    console.error(e)
    if(e?.code == 'NoSuchKey') {
      const err = new Error("Media not found"); 
      err.status = 404;
      return next(err)
    } else {
      return next(e);
    }
  }
});






// router.use('/s3/*', proxy(process.env.S3_FULL_URL, { //process.env.S3_FULL_URL
//   proxyReqPathResolver: function (req) {
//     console.log(req.params)
//     return req.url + req.params[0]
//   },
//   //proxyReqPathResolver: req => url.parse(req.baseUrl).path,
//   proxyReqOptDecorator: function (proxyReqOpts, srcReq) {
//     //proxyReqOpts.headers = {"Authorization": `AWS ${process.env.S3_KEY_ID}:${getS3SignatureKey(process.env.S3_APPLICATION_KEY, Date.now())}`};
//     return proxyReqOpts;
//   }
//   // userResHeaderDecorator(headers, userReq, userRes, proxyReq, proxyRes) {
//   //   // recieves an Object of headers, returns an Object of headers.
//   //   console.log(headers)
//   //   proxyReq.set("Authorization", `AWS AWSAccessKeyId:Signature`)
//   //   //console.log(proxyReq, )
//   //   return headers;
//   // }
// }));





export default router;
