import "./env.js"
import mongoose from "mongoose";
import { connection, encoder } from "./db.js"

const db = mongoose.connection.db;
console.log(db)

const rawQueue = db.collection("encoder-queue");

// Wait for new jobs
rawQueue.watch().on("change", (data) => {
    console.log(data)
})



