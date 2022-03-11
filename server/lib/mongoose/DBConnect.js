import mongoose from "mongoose";
export let connection = await mongoose.connect(process.env.MONGODB_CONNECTION_STRING);
