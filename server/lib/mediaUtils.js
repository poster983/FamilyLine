const path = require('path');
const fsP = require('fs').promises;
import('node-fetch')
import imagemin from 'imagemin';
import imageminWebp from 'imagemin-webp';
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



exports.getFileName = (file) => file.replace(/\.[^/.]+$/, "");

exports.mediaTypes = {
    Audio: Symbol("AUDIO"),
    Video: Symbol("VIDEO"),
    Image: Symbol("IMAGE"),
    Document: Symbol("DOCUMENT"),
}

exports.checkFileType = (file) => {
    // Allowed ext
    const allowedImageTypes = /jpeg|jpg|png|webp|heic/ // convert to webp
    const allowedVideoTypes = /mp4|webm/ // convert to webm
    const allowedAudioTypes = /mp3|ogg|opus|wav|flac/ // convert to ogg
    const allowedDocumentTypes = /pdf|epub/
    let type = null;
    console.log(file)
    if(allowedImageTypes.test(path.extname(file.originalname).toLowerCase()) && allowedImageTypes.test(file.mimetype)) { // image
      type = exports.mediaTypes.Image;
    } else if(allowedVideoTypes.test(path.extname(file.originalname).toLowerCase()) && allowedVideoTypes.test(file.mimetype)) { // Video
      type = exports.mediaTypes.Video;
    } else if(allowedAudioTypes.test(path.extname(file.originalname).toLowerCase()) && allowedAudioTypes.test(file.mimetype)) { // Audio 
      type = exports.mediaTypes.Audio;
    } else if(allowedDocumentTypes.test(path.extname(file.originalname).toLowerCase()) && allowedDocumentTypes.test(file.mimetype)) { // Document
      type = exports.mediaTypes.Document;
    } else {}
  
    return type;
  }


exports.preprocess = {}

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
exports.preprocess.image = async (fileinfo, options) => {
  if(!options) {
    options = {};
  }
  
  const ogExt = path.extname(fileinfo.originalname);

  //if name != null then rename original   
  if(!options?.name) options.name=fileinfo.filename

  const newFileName = fileinfo.destination + "/" + options.name+ogExt
  console.log(newFileName)
  //rename original
  await fsP.rename(fileinfo.path, newFileName)
  //read in original file
  let file;
  try {
    file = await fsP.readFile(newFileName);
  } catch(e) {
    console.error(e)
    //delete original file 
    try {
      fsP.unlink(newFileName);
    } catch(e) {
      console.error(e)
      return new Error("Could not delete uploaded file")
    }
    return e;
  }

  const destination = fileinfo.destination + "/" + option
  //convert original to webp + rename
  const converted = await imagemin(newFileName, {
    destination: fileinfo.destination,
    plugins: [
      imageminWebp({
           quality: 100
        //   ,
        //   resize: {
        //     width: 1000,
        //     height: 0
        //   }
      }),
      
    ],
  })
  console.log(converted.destinationPath)
  // let result = await webp.buffer2webpbuffer(file,ogExt.slice(1),"-q 100");
  // console.log(result)


  //convert webp to smaller webp thumbnail + rename

  

  


}