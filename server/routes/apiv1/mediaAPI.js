import { Router } from 'express';
var router = Router();
import { tmpdir } from 'os';
import { error } from "../../lib/errorUtils.js";
import { promises as fsP } from 'fs';

import storage from "../../s3.js"
import mongoose from "mongoose";
import multer from 'multer';
const upload = multer({ 
  dest: tmpdir()+'/familyline_useruploads', 
  limits: { fileSize: 2000000000 }
})



import { uploadObject} from "../../lib/mediaUtils.js";

// Complete with the connection options for GenericS3
console.log(process.env.S3_ENDPOINT)


/**
 * @api {post} /apiv1/media/:*
 * @apiName UploadMedia
 * @apiGroup Media
 * @apiParam {String} * - Path to S3 Object.
 * @apiSuccess {String} fullsizeURI
 * @apiSuccess {String} thumbnailURI
 * @apiVersion 1.0.0
 */
 router.post("/", upload.single('file'), async (req,res,next) => {
    if(req.file == null) {
      return next(error("Multipart file upload required", 400))
    }
    // const info = checkFileType(req.file)
    // if(info==null) {
    //   //delete that file
    //   try {
    //     fsP.unlink(req.file.path);
    //   } catch(e) {
    //     console.error(e)
    //   }
    //   return next(error("This filetype is not supported.", 400))
    // }
    // const photoID = uuidv4();
    //console.log(info)
    try { 
      const status = await uploadObject(req.file, mongoose.Types.ObjectId("55153a8014829a865bbf700d"))
      fsP.unlink(req.file.path);
      res.status(201);
      res.json(status)
    } catch(e) {
      fsP.unlink(req.file.path);
      return next(e)
    }
    
    // if(info === mediaTypes.Image) { // convert image
    //   // const files =  await preprocess.image(req.file, {name: photoID})
    //   // 
    //   // res.json(files)
    // } else {
    //   return next(error("File type not implemented", 501))
    // }

    


 });



/**
 * @api {get} /apiv1/media/:*
 * @apiName GetObject
 * @apiGroup Media
 * @apiParam {String} * - Path to S3 Object.
 * @apiSuccess {Blob}
 * @apiVersion 1.0.0
 */
router.get("/*", async (req,res,next) => { // should ensure the user has sufficient permissions to view the file
  try {
    //let metaData = await storage.h(process.env.S3_BUCKET, req.params[0])
    console.log(req.params[0])
    let stream = await storage.getObject(process.env.S3_BUCKET, "usermedia/"+req.params[0])
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
      const err = new Error("Image not found"); 
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
