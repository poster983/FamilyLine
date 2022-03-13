import mongoose from "mongoose";
import mongoDbQueue from "mongodb-queue-up"
import {connection} from "./DBConnect.js"
import util from "util";
await connection
//MARK: Setup Queues
export let encoder = {}
encoder.raw = mongoDbQueue(mongoose.connection.db, 'encoder-queue');
encoder.raw.createIndexes((err) => {if(err){console.error(err)}});
encoder.raw.clean((err) => {if(err){console.error(err)}});
encoder.add = util.promisify(encoder.raw.add.bind(encoder.raw));
encoder.ack = util.promisify(encoder.raw.ack.bind(encoder.raw));