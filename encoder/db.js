import mongoose from "mongoose";
import mongoDbQueue from "mongodb-queue-up"
import util from "util";
console.log("Connecting to MongoDB...")
export let connection = await mongoose.connect(process.env.MONGODB_CONNECTION_STRING);
console.log("Connected!")
//MARK: Setup Queues
export let encoderQueue = {} 
encoderQueue.raw = mongoDbQueue(mongoose.connection.db, 'encoder-queue');
encoderQueue.add = util.promisify(encoderQueue.raw.add.bind(encoderQueue.raw));
encoderQueue.ack = util.promisify(encoderQueue.raw.ack.bind(encoderQueue.raw));
encoderQueue.get = util.promisify(encoderQueue.raw.get.bind(encoderQueue.raw));
encoderQueue.ping = util.promisify(encoderQueue.raw.ping.bind(encoderQueue.raw));