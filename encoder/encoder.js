import "./env.js"
import mongoose from "mongoose";
import { connection, encoderQueue } from "./db.js"
import process from 'process';


import {imageEncoder} from "./encoders/images.js"

const db = mongoose.connection.db;

const rawQueue = db.collection("encoder-queue");
const rawMedia = db.collection("media");

process.on('uncaughtException', function (exception) {
    console.log(exception); // to see your exception details in the console
    // if you are on production, maybe you can send the exception details to your
    // email as well ?
});

// Wait for new jobs
rawQueue.watch().on("change", async (data) => {
    //handleQueue();
    
     if(data.operationType == 'insert') {
         console.log("insert")
         setImmediate(handleQueue)
     }
    //console.log("DATA", data)
});
let activeJobs = 0;
async function handleQueue() {
    console.log("Active jobs:", activeJobs)
    if(activeJobs >= process.env.CONCURRENT_JOB_LIMIT) {
        console.log("Skipping: Too many jobs open")
        return;
    }
    activeJobs++
    const job = await encoderQueue.get()
    console.log("JOB", job)
    if(job) {
        
        setImmediate(handleQueue) // go again if theres more in the queue
        const mediaDoc = await rawMedia.findOne({_id: job.payload.mediaID})
        console.log("MEDIADOC", mediaDoc)
        if(mediaDoc) {
            //start encoding
            if(mediaDoc.type == "IMAGE") {
                imageEncoder(job, mediaDoc).then((_) => {
                    
                    activeJobs--;
                    setImmediate(handleQueue)
                }).catch((e) => {
                    console.error(e) 
                    activeJobs--;
                    setImmediate(handleQueue)
                });
            }
            
        } else {
            // remove job as media does not exist
            try {
                encoderQueue.ack(job.ack)
            } catch(e) {
                console.error(e)
            }
            
            activeJobs--;
            setImmediate(handleQueue)
        }
        
        
    } else {
        activeJobs--;
    }
    
}


setImmediate(handleQueue)