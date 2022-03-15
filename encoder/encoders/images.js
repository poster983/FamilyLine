import mongoose from "mongoose";
import { encoderQueue } from "../db.js"
import storage from "../s3.js"
import heicConvert from "heic-convert";
import {updateProgress, setError, createThumbnail, encodeImageToBlurhash} from "./common.js"
import { v4 as uuidv4 } from 'uuid';
import sharp from "sharp";
const db = mongoose.connection.db;


const rawMedia = db.collection("media");

export async function imageEncoder(job, mediaDoc) {
    console.log("Encoding image: " + mediaDoc._id);

    //ping the job 
    encoderQueue.ping(job.ack);

    //process
    rawMedia.updateOne({_id: mediaDoc._id, 'encoding.started': {$exists : false}}, {$set: { encoding: { // update the progress
        progress: 0.1,
        started: Date.now()
    }}});
    
    //Get Raw file from S3
    let object;
    try {
        encoderQueue.ping(job.ack);
        object = await storage.getObjectAsBuffer(process.env.S3_BUCKET, job.payload.processingPath)
        //updateProgress(mediaDoc._id, 0.2)
    } catch(e) {
        console.error(e);
        return await setError(mediaDoc._id, e);
    }
    
    let waiton = [];
    
    // edge case for heic
    if(job.payload.mimetype == "image/heic") {
        encoderQueue.ping(job.ack);
        object =  await encodeHEIC(job,mediaDoc,object);
        //updateProgress(mediaDoc._id, 0.3)
    } 

    //encode blurhash
    encoderQueue.ping(job.ack);
    waiton.push(encodeImageToBlurhash(mediaDoc, object));
    waiton.push(createThumbnail(mediaDoc, object));
    waiton.push(encodeWebp(mediaDoc, object))

    //create thumbnail
    // try {
        
    //     encoderQueue.ping(job.ack);
    //     updateProgress(mediaDoc._id, 0.4)
    // } catch(e) {
    //     console.error(e);
    //     return await setError(mediaDoc._id, e);
    // }

    try {
        await Promise.all(waiton);
        await rawMedia.updateOne({_id: mediaDoc._id}, {$set: { encoding: { // update the progress
            progress: 1,
            finished: Date.now()
        }}});
        await encoderQueue.ack(job.ack);
    } catch(e) {
        console.log(e);
        await setError(e);
    }
    return true;
    /*else if(job.payload.mimetype == "image/webp") { //just upload it no processing

    } else { // process

    }*/
}   


async function encodeHEIC(job,mediaDoc,rawFile) {
    //console.log("NOT IMPLEMENTED")
    const buffer = await heicConvert({buffer: rawFile, format: "PNG"})
    job.payload.mimetype = "image/png"
    return buffer;
}


async function encodeWebp(mediaDoc,rawFile) {
    return new Promise((resolve, reject) => {
      sharp(rawFile)
          // .resize({ width: 256})
          .webp({quality: 80})
          .toBuffer(async (err, buffer, prop) => {
              if (err) return reject(err);
              const versionID = uuidv4();
              const link = `groups/${mediaDoc.groupID.valueOf()}/usermedia/display/${mediaDoc._id}/${versionID}`;
              
              
              
              const session = await mongoose.startSession();
              await session.withTransaction(async () => {                
                try {
                  await Promise.all([
                    rawMedia.updateOne({
                      _id: mediaDoc._id
                    }, {
                      $set: {
                        
                        "files.display": [{
                            size: buffer.length,
                            mimetype: "image/webp",
                            versionID: versionID
                          }],
                        }
                      
                    }),
                    storage.putObject(process.env.S3_BUCKET, link, buffer, {metadata: {
                      'Content-Type': "image/webp"
                    }})
  
                  ])
                } catch(e) {
                  await session.abortTransaction();
                  //delete object
                  try{  
                    await storage.deleteObject(process.env.S3_BUCKET, link);
                  } catch {
                    console.error(e);
                  }
                  
                  return reject(e)
                }
  
              });
              session.endSession();
              return resolve();
              //resolve(encode(new Uint8ClampedArray(buffer), prop.width, prop.height, 4, 4));
          });
    })
  }