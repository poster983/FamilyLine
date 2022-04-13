import mongoose from "mongoose";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from 'uuid';


//MARK: Long Lived  Refresh Bearer Tokens
const expireSeconds = process.env.AUTH_REFRESH_TOKEN_TIMEOUT; // 1 hour 
console.log(expireSeconds)
/**
 * Long lived refresh bearer token to be exchanged for access tokens
 * @typedef {Object} DBRefreshToken
 * @property {String} _id - Token Primary Key (jwtid)
 * @property {ObjectId} userID - The user this token authenticates 
 * @property {String} generationID - The time this token will no longer work and gets deleted from the db
 * @property {Date} created - Date token created
 * @property {String} [device=unknown] - String that identifies the device that this request came from
 * @property {String} token - The primary key and hashed bearer token
 */
const DBRefreshToken = new mongoose.Schema({
    _id: {type: String, default: uuidv4},
    // expire_at: {type: Date, default: Date.now, }, // 2hours = 7200
    userID: {type: mongoose.Schema.ObjectId, required: true},
    generationID: {type: String},
    created: {type: Date, default: Date.now},
    lastRefreshed: {type: Date, default: Date.now, expires: parseInt(expireSeconds)},
    device: {
        ip: {type: String},
        ua: String
    },
    //token: {type: String, unique: true, required: true}
    //[{type: {type: String, required: true}, size: Number, mimetype: String}]
})


/**
 * creates a new token to be saved in the db
 * @returns {String} New Bearer Token
 */
 DBRefreshToken.methods.generateToken = function() {
    const expireEPH = Date.now()
    this.generationID = uuidv4();
    this.lastRefreshed = expireEPH;
    const token = jwt.sign({
        userID: this.userID.valueOf(),
        generationID: this.generationID,
        type: 'refresh',
        exp: Math.floor(Date.now() / 1000)+parseInt(expireSeconds) 
    }, process.env.AUTH_JWT_PRIVATE_KEY, {  jwtid: this._id}); //expiresIn: expireSeconds*1000,
    return token;
}

// //Hashes the token before saving 
// DBRefreshToken.pre(
//     'save',
//     async function(next) {
//       if (!this.isModified('token')) return next();
//       //const user = this;
//       const hash = await bcrypt.hash(this.token, 10);
//       this.token = hash;
//       next();
//     }
// );

//Check hash with token in db 
// DBRefreshToken.methods.validateToken = async function(token) {
//     const compare = await bcrypt.compare(token, this.token);
//     return compare;
// }
export default mongoose.model('refreshtokens', DBRefreshToken);


