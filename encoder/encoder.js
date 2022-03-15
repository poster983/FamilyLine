import "./env.js"
import mongoose from "mongoose";
import { connection, encoderQueue } from "./db.js"

import {imageEncoder} from "./encoders/images.js"

const db = mongoose.connection.db;

const rawQueue = db.collection("encoder-queue");
const rawMedia = db.collection("media");

// Wait for new jobs
rawQueue.watch().on("change", async (data) => {
    handleQueue();
    
    // if(data.operationType == 'insert') {
        
    // }
    //console.log("DATA", data)
});

async function handleQueue() {
    const job = await encoderQueue.get()
    console.log("JOB", job)
    if(job) {
        const mediaDoc = await rawMedia.findOne({_id: job.payload.mediaID})
        if(mediaDoc) {
            //start encoding
            if(mediaDoc.type == "IMAGE") {
                imageEncoder(job, mediaDoc);
            }
        } else {
            // remove job as media does not exist
            encoderQueue.ack(job.ack)
        }
        console.log("MEDIADOC", mediaDoc)
    }
    
}


handleQueue();