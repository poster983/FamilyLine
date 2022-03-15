import mongoose from "mongoose";
import  "../db.js"
const db = mongoose.connection.db;
const rawMedia = db.collection("media");
import {
  encode
} from "blurhash";
import storage from "../s3.js"
import sharp from "sharp";

export function encodeImageToBlurhash(mediaDoc, pathOrBuffer) {
  return new Promise((resolve, reject) => {
    try {
      sharp(pathOrBuffer)
        .raw()
        .ensureAlpha()
        .resize(32, 32, {
          fit: "inside"
        })
        .toBuffer(async (err, buffer, prop) => {
          if (err) return reject(err);
          try {
            await rawMedia.updateOne({
              _id: mediaDoc._id
            }, {
              $set: {
                blurhash: encode(new Uint8ClampedArray(buffer), prop.width, prop.height, 4, 4)
              }
            });
          } catch(e) {
            console.error(e)
            return reject(e);
          }
          
          resolve();
        });
    } catch (e) {
      console.error(e)
      reject(e);
    }

  });
}



export async function createThumbnail(mediaDoc,rawFile) {
  return new Promise((resolve, reject) => {
      sharp(rawFile)
          .resize({ width: 256})
          .webp( {quality: 40})
          .toBuffer(async (err, buffer, prop) => {
              if (err) return reject(err);
              const link = `groups/${mediaDoc.groupID.valueOf()}/usermedia/thumbnail/${mediaDoc._id}`;
              
              
              
              const session = await mongoose.startSession();
              await session.withTransaction(async () => {

                
                try {
                  await Promise.all([
                    rawMedia.updateOne({
                      _id: mediaDoc._id
                    }, {
                      $set: {
                        "files.thumbnail.size": Buffer.byteLength(buffer)
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


export async function updateProgress(mediaID, progress) {
  return await rawMedia.updateOne({
    _id: mediaID
  }, {
    $set: {
      encoding: { // update the progress
        progress: progress,
      }
    }
  });
}

export async function setError(mediaID, error) {
  return await rawMedia.updateOne({
    _id: mediaID
  }, {
    $set: {
      encoding: { // update the progress
        error: error.toString(),
        progress: -1
      }
    }
  });
}