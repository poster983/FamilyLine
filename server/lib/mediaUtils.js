import {
  extname
} from 'path';
import {
  promises as fsP
} from 'fs';
import imagemin from 'imagemin';
import imageminWebp from 'imagemin-webp';
import sharp from "sharp";
import storage from "../s3.js"
import { error } from "./errorUtils.js";
import DBMedia from './mongoose/DBMedia.js';
import DBGroup from './mongoose/DBGroup.js';
import {encoder} from './mongoose/DBQueues.js';
import { encode } from "blurhash";
import { v4 as uuidv4 } from 'uuid';



//const imagemin = require("imagemin");
//const imageminWebp = require("imagemin-webp");
// const webp=require('webp-converter');
// SETUP WEBP EXECUTABLES

// const webpSetup = async () => {
//   webp.grant_permission();
//   try {
//     await fsP.access('./node_modules/webp-converter/temp')
//   } catch(e) {
//     fsP.mkdir('./node_modules/webp-converter/temp')
//   }
// };
// webpSetup();






export function getFileName(file) {
  return file.replace(/\.[^/.]+$/, "");
}


export const mediaTypes = {
  Audio: Symbol("AUDIO"),
  Video: Symbol("VIDEO"),
  Image: Symbol("IMAGE"),
  Document: Symbol("DOCUMENT"),
}

export function checkFileType(file) {
  // Allowed ext
  const allowedImageTypes = /jpeg|jpg|png|webp|heic/ // convert to webp
  const allowedVideoTypes = /mp4|webm/ // convert to webm
  const allowedAudioTypes = /mp3|ogg|opus|wav/ // convert to ogg
  const allowedDocumentTypes = /pdf|epub/
  let type = null;
  //console.log(file)
  if (allowedImageTypes.test(extname(file.originalname).toLowerCase()) && allowedImageTypes.test(file.mimetype)) { // image
    type = mediaTypes.Image;
  } else if (allowedVideoTypes.test(extname(file.originalname).toLowerCase()) && allowedVideoTypes.test(file.mimetype)) { // Video
    type = mediaTypes.Video;
  } else if (allowedAudioTypes.test(extname(file.originalname).toLowerCase()) && allowedAudioTypes.test(file.mimetype)) { // Audio 
    type = mediaTypes.Audio;
  } else if (allowedDocumentTypes.test(extname(file.originalname).toLowerCase()) && allowedDocumentTypes.test(file.mimetype)) { // Document
    type = mediaTypes.Document;
  } else {}

  return type;
}


export const preprocess = {}

/**
 * Preprocesses the uploaded image
 * @param {Object} fileinfo - From muller
 * @param {String} fileinfo.filename
 * @param {String} fileinfo.originalname
 * @param {String} fileinfo.path
 * @param {String} fileinfo.mimetype
 * @param {String} fileinfo.destination - the base path, no file name
 * @param {Object} [options] 
 * @param {String} [options.name] - Rename the file to this
 */
preprocess.image = async (fileinfo, options) => {
  if (!options) {
    options = {};
  }

  const ogExt = extname(fileinfo.originalname);

  //if name != null then rename original   
  if (!options?.name) options.name = fileinfo.filename

  const newFileName = fileinfo.destination + "/" + options.name + ogExt
  console.log(newFileName)
  //rename original
  await fsP.rename(fileinfo.path, newFileName)
  //read in original file
  let file;
  try {
    file = await fsP.readFile(newFileName);
  } catch (e) {
    console.error(e)
    //delete original file 
    try {
      fsP.unlink(newFileName);
    } catch (e) {
      console.error(e)
      return new Error("Could not delete uploaded file")
    }
    return e;
  }

  //const destination = fileinfo.destination + "/" + options
  //convert original to webp + rename
  const converted = imagemin([newFileName], {
    destination: fileinfo.destination + "/",
    plugins: [
      imageminWebp({
        quality: 90,
        metadata: 'all'
        // resize: {
        //   width: 256,
        //   height: 256
        // }
      }),
    ],
  })
  const thumbnail = imagemin([newFileName], {
    destination: fileinfo.destination + "/thumbnail",
    plugins: [
      imageminWebp({
        quality: 50,
        resize: {
          width: 256,
          height: 0
        }
      }),
    ],
  })
  const results = await Promise.all([converted, thumbnail])

  return {
    original: {path: newFileName, mime: fileinfo.mimetype},
    compressed: results[0].destinationPath,
    thumbnail: results[1].destinationPath
  }

  // let result = await webp.buffer2webpbuffer(file,ogExt.slice(1),"-q 100");
  // console.log(result)


  //convert webp to smaller webp thumbnail + rename

}


export function encodeImageToBlurhash (pathOrBuffer) {
  return new Promise((resolve, reject) => {
    try {
      sharp(pathOrBuffer)
      .raw()
      .ensureAlpha()
      .resize(32, 32, { fit: "inside" })
      .toBuffer((err, buffer, prop) => {
        if (err) return reject(err);
        resolve(encode(new Uint8ClampedArray(buffer), prop.width, prop.height, 4, 4));
      });
    } catch(e) {
      reject(e);
    }
    
  });
}







/**
 * 
 * @param {Object} fileinfo - From muller
 * @param {String} fileinfo.filename
 * @param {String} fileinfo.originalname
 * @param {String} fileinfo.path
 * @param {String} fileinfo.mimetype
 * @param {ObjectID} groupID 
 */
export async function uploadObject(fileinfo, groupID) {
  //determine if object needs to be queued for processing (images, video, audio, docs)
  const filetype = checkFileType(fileinfo);
  if(!filetype) {
    throw error("Unsupported Media Type", 415);
  }
  fileinfo.mimetype = fileinfo.mimetype.toLowerCase();
  let file;
  //open file
  try {
    file = await fsP.readFile(fileinfo.path);
  } catch (e) {
    console.error(e)
    throw e;
  }

  //generate blurhash
  // let blurhash = null;
  // if(filetype == mediaTypes.Image) {
  //   try {
  //     blurhash = await encodeImageToBlurhash(file)
  //     //console.log(blurhash)
  //   } catch(e) {
  //     throw error(e, 500)
  //   }
  // }
  
  

  //create record of object in DB.  (uuid, groupID, type[image,video,audio,doc], uploadDate, modifiedDate, processing{},  metadata{}, notes:Str, blurhash, paths: {original: })

  let dbobj = new DBMedia({
    groupID: groupID,
    type: filetype.description,
    encoding: {
      progress: 0
    },
    metadata: {
      filename: fileinfo.originalname
    },
    //blurhash: blurhash,
  })


  
  const mediaID = dbobj._id.valueOf();
  const processingPath = `groups/${groupID.valueOf()}/usermedia/original/${mediaID}`;
  //upload document to s3 
  try {
    await storage.putObject(process.env.S3_BUCKET, processingPath, file, {metadata: {
      'Content-Type': fileinfo.mimetype
    }});
  } catch(e) {
    throw error(e,500);
  }
  dbobj.encoding.link = processingPath;
  
  
  //console.log(dbobj)
  try {
    await dbobj.validate();
  } catch(e) {
    throw error(e, 500)
  }
  
  try {
   await dbobj.save();
  } catch(e) {
    throw error(e, 500);
  }
  

  let queueID = null;
  try {
    queueID = await encoder.add({mediaID: dbobj._id, processingPath: processingPath, mimetype: fileinfo.mimetype});
    // await new Promise((resolve, reject) => {
    //   queue.encoder.raw.add({mediaID: dbobj._id, processingPath: processingPath}, (e, i) => {
    //     if(e) {
    //       return reject(e);
    //     }
    //     resolve(i)
    //   })
    // })
  } catch(e) {
    throw error(e, 500);
  }
  

  return {status: "processing", queueID: queueID, mediaID: dbobj._id.valueOf()};
  //if queue then upload object to DB 

}

