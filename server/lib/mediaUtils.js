import {
  extname
} from 'path';
import {
  promises as fsP
} from 'fs';
import imagemin from 'imagemin';
import imageminWebp from 'imagemin-webp';
import storage from "../s3.js"

import { encode } from "blurhash";

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


/**
 * Database Media schema
 * @typedef {Object} DBMedia
 * @property {String} id - media id
 * @property {String} groupID - The group that this media belongs to. 
 * @property {String} type - can be 'video', 'audio', 'image', document'
 * @property {Date} uploaded - Upload date
 * @property {Date} lastModified - Last modified date
 * @property {Date} sortDate - Day to sort tis against the other photos in th UT (day photo was taken for instance)
 * @property {Object|null} processing - can be null if the object does not need processing
 * @property {Number} processing.progress - 0 to 1
 * @property {Date|null} processing.finished
 * @property {Date|null} processing.started 
 * @property {Object} metadata - TBD
 * @property {String} notes - user defined notes.
 * @property {String} blurhash - Blurhash string to show the user before the actual picture loads
 * @property {Object} files - Holds info about the different types of files that make up this Media
 * @property {Object|null} files.original - The original and unmodified file for archival | if null then we didnt save it
 * @property {Number} files.original.size - size in kb
 * @property {String} files.original.name - the original file name
 * @property {String} files.original.mimetype - the original mimetype 
 * @property {Object|null} files.compressed - The compressed version.
 * @property {Number} files.compressed.size - size in kb
 */



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
  const allowedImageTypes = /jpeg|jpg|png|webp/ // convert to webp
  const allowedVideoTypes = /mp4|webm/ // convert to webm
  const allowedAudioTypes = /mp3|ogg|opus|wav/ // convert to ogg
  const allowedDocumentTypes = /pdf|epub/
  let type = null;
  console.log(file)
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


/**
 * Queue an image for 
 * @param {Object} options
 * @param {Object} options.fileinfo - From muller
 * @param {String} options.fileinfo.paths
 * @param {String} options.fileinfo.mimetype
 * @param {String} options.fileinfo.destination - the base path, no file name
 * @param {String} options.imageID
 * @param {String} options.groupID
 * @async
 */
export async function uploadImage(fileinfo, imageID) {
  let uploads = [];
  //if(fileinfo.paths.original)
  //uploads.push(storage.putObject(process.env.S3_BUCKET, )) 
}



/**
 * 
 * @param {Object} fileinfo - From muller
 * @param {String} fileinfo.filename
 * @param {String} fileinfo.originalname
 * @param {String} fileinfo.path
 * @param {String} fileinfo.mimetype
 * @param {String} groupID 
 */
export async function uploadObject(fileinfo, groupID) {

  //determine if object needs to be queued for processing (images, video, audio, not docs)

  //generate blurhash

  //create record of object in DB.  (uuid, groupID, type[image,video,audio,doc], uploadDate, modifiedDate, processing{},  metadata{}, notes:Str, blurhash, paths: {original: })

  //if queue then upload object to DB 


}

