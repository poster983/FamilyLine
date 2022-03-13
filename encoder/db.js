import mongoose from "mongoose";
import mongoDbQueue from "mongodb-queue-up"
import util from "util";
export let connection = await mongoose.connect(process.env.MONGODB_CONNECTION_STRING);
//MARK: Setup Queues
export let encoder = {}
encoder.raw = mongoDbQueue(mongoose.connection.db, 'encoder-queue');
encoder.add = util.promisify(encoder.raw.add.bind(encoder.raw));
encoder.ack = util.promisify(encoder.raw.ack.bind(encoder.raw));
encoder.get = util.promisify(encoder.raw.get.bind(encoder.raw));
encoder.ping = util.promisify(encoder.raw.ping.bind(encoder.raw));