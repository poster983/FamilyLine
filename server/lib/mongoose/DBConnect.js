import mongoose from "mongoose";
console.log("Connecting to MongoDB...",  process.env.MONGODB_CONNECTION_STRING)
export let connection = await mongoose.connect(process.env.MONGODB_CONNECTION_STRING, {
    //directConnection: true
}); // TODO: { autoIndex: false } set for production 


console.log("Connected!")
