import mongoose from "mongoose";
console.log("Connecting to MongoDB...")
export let connection = await mongoose.connect(process.env.MONGODB_CONNECTION_STRING);
console.log("Connected!")
