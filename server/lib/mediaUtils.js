import {
  extname
} from 'path';
import {
  promises as fsP
} from 'fs';
import imagemin from 'imagemin';
import imageminWebp from 'imagemin-webp';
import storage from "../../s3.js"
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
  const allowedImageTypes = /jpeg|jpg|png|webp/ // convert to webp
  const allowedVideoTypes = /mp4|webm/ // convert to webm
  const allowedAudioTypes = /mp3|ogg|opus|wav|flac/ // convert to ogg
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


const preprocess = {}

/**
 * Preprocesses the uploaded image
 * @param {Object} fileinfo - From muller
 * @param {String} fileinfo.filename
 * @param {String} fileinfo.path
 * @param {String} fileinfo.mimetype
 * @param {String} fileinfo.destination - the base path, no file name
 * @param {Object} [options] 
 * @param {String} [options.name] - Rename the file to this
 */
preprocess.image = async () => {
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
  const results = await Promise.all(converted, thumbnail)

  return {
    unmodified: newFileName,
    compressed: results[0].destinationPath,
    thumbnail: results[1].destinationPath
  }

  // let result = await webp.buffer2webpbuffer(file,ogExt.slice(1),"-q 100");
  // console.log(result)


  //convert webp to smaller webp thumbnail + rename

}


/**
 * Preprocesses the uploaded image
 * @param {Object} options
 * @param {Object} options.fileinfo - From muller
 * @param {String} options.fileinfo.paths
 * @param {String} options.fileinfo.path
 * @param {String} options.fileinfo.mimetype
 * @param {String} options.fileinfo.destination - the base path, no file name
 * @param {String} options.imageID
 * @param {String} options.groupID
 */
export function uploadImage({fileinfo, imageID}) {
  
}