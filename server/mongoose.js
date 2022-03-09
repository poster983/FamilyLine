
import mongoose from "mongoose";
import mongoDbQueue from "mongodb-queue-up"
export let connection = await mongoose.connect(process.env.MONGODB_CONNECTION_STRING); // TODO: a
import util from "util"
import bcrypt from "bcrypt"
import jwt from "jsonwebtoken"
const jwtSign = util.promisify(jwt.sign);
import { v4 as uuidv4 } from 'uuid';


//MARK: Setup Queues

export let queue = {}
queue.encoder = {}
queue.encoder.raw = mongoDbQueue(mongoose.connection.db, 'encoder-queue')
queue.encoder.add = util.promisify(queue.encoder.raw.add.bind(queue.encoder.raw))
queue.encoder.ack = util.promisify(queue.encoder.raw.ack.bind(queue.encoder.raw))
// queue.encoder.raw.add({
//     mediaID: new ObjectId("6227c763840e546cd5763ad7"),
//     processingPath: 'usermedia/original/6227c763840e546cd5763ad7'
//   }, (err, val) => {console.log(val);})


// console.log(instanceof mongoose.Types.ObjectId())


// const Kitten = mongoose.model('Kitten', new mongoose.Schema({
//     name: String,
// }));

// let cb = new Kitten({name: "Cat Bastard"});
// console.log(cb)

// cb.save();

// MARK: DEFINE SCHEMAS

export let schemas = {};


// MARK: MEDIA
/**
 * Database Media schema
 * @typedef {Object} DBMedia
 * @property {ObjectId} _id - media id
 * @property {ObjectId} groupID - The group that this media belongs to. 
 * @property {String} type - can be 'video', 'audio', 'image', document'
 * @property {Date} uploaded - Upload date
 * @property {Date} lastModified - Last modified date
 * @property {Date} sortDate - Day to sort tis against the other photos in th UT (day photo was taken for instance)
 * @property {Object|null} encoding - can be null if the object does not need processing
 * @property {Number} encoding.progress - 0 to 1
 * @property {String} encoding.link - the link in s3 for the file to be processing 
 * @property {Date|null} encoding.finished
 * @property {Date|null} encoding.started 
 * @property {ObjectId} encoding.jobQueueID - the id of the job in the queue
 * @property {Object} metadata
 * @property {String} metadata.filename - The OG filename
 * @property {String} notes - user defined notes.
 * @property {String} blurhash - Blurhash string to show the user before the actual picture loads
 * @property {Object} files - Holds info about the different types of files that make up this Media
 * @property {Object|null} files.original - The original and unmodified file for archival | if null then we didnt save it
 * @property {Number} files.original.size - size in bytes
 * @property {String} files.original.mimetype - the original mimetype 
 * @property {[Object]|null} files.display - The displays version.  index 0 is preferred over index 1 and so on.
 * @property {Number} files.display.size - size in bytes
 * @property {String} files.display.mimetype - the  mimetype 
 * @property {String} files.display.versionID - A unique postfix id for the storage bucket
 * @property {Object} files.thumbnail - The file's thumbnail.
 * @property {Number} files.thumbnail.size - size in bytes
 */
const DBMedia = new mongoose.Schema({
    groupID: {type: mongoose.Schema.ObjectId, required: true},
    type: {type: String, required: true, enum: ['IMAGE', 'VIDEO', 'AUDIO', 'DOCUMENT']},
    // storageID: {type: String, required: true},
    uploaded: {type: Date, default: Date.now},
    lastModified: {type: Date, default: Date.now},
    sortDate: {type: Date, default: Date.now},
    encoding: {  
        progress: Number,
        link: String,
        finished: Date,
        started: Date,
        jobQueueID: mongoose.Schema.ObjectId
    },
    metadata: {
        filename: {type: String, required: true}
    },
    notes: String,
    blurhash: String,
    files: {
        original: {
            size: Number,
            mimetype: String,
            
        },
        thumbnail: {
            size: Number,
            mimetype: String
        },
        display: [{size: Number, mimetype: String, versionID: String}]
    }

    //[{type: {type: String, required: true}, size: Number, mimetype: String}]
})
schemas.Media = mongoose.model('Media', DBMedia);



// MARK: USER

/**
 * Database User schema
 * @typedef {Object} DBUser
 * @property {ObjectId} _id - User id
 * @property {[ObjectId]} groupIDs - an array of groups this user belongs to 
 * @property {Boolean} active - is the account active
 * @property {Object} name
 * @property {String} name.given - First name (given name)
 * @property {String} name.family - Family Name (last name)
 * @property {String} email - User's email address
 * @property {String} hashedPass - hashed password
 * @property {Date} joined - Date joined
 */
 const DBUser = new mongoose.Schema({
    groupIDs: {type: [mongoose.Schema.ObjectId], validate: v => Array.isArray(v) && v.length > 0},
    active: {type: Boolean, default: true},
    name: {
        given: {type: String, required: true},
        family: {type: String, required: true}
    },
    email: {
        type: String, 
        trim: true,
        lowercase: true,
        unique: true,
        required: true,
        match: [/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, 'Please fill a valid email address'] //TODO: Improve email regex
    },
    password: {type: String, required: true, },
    joined: {type: Date, default: Date.now}
    //[{type: {type: String, required: true}, size: Number, mimetype: String}]
})

//Hashes the password before saving 
DBUser.pre(
    'save',
    async function(next) {
    if (!this.isModified('password')) return next();
      //const user = this;
      const hash = await bcrypt.hash(this.password, 10);
  
      this.password = hash;
      next();
    }
  );
//Check hash with passowrd in db 
DBUser.methods.validatePassword = async function(password) {
    const user = this;
    const compare = await bcrypt.compare(password, user.password);

    return compare;
}
schemas.User = mongoose.model('User', DBUser);


//MARK: Long Lived  Refresh Bearer Tokens
const expireSeconds = process.env.AUTH_REFRESH_TOKEN_TIMEOUT; // 1 hour 
/**
 * Long lived refresh bearer token to be exchanged for access tokens
 * @typedef {Object} DBRefreshToken
 * @property {ObjectId} _id - Token Primary Key (unused)
 * @property {ObjectId} userID - The user this token authenticates 
//* @property {Date} expire_at - The time this token will no longer work and gets deleted from the db
 * @property {Date} created - Date token created
 * @property {String} [device=unknown] - String that identifies the device that this request came from
 * @property {String} token - The primary key and hashed bearer token
 */
const DBRefreshToken = new mongoose.Schema({
    // expire_at: {type: Date, default: Date.now, }, // 2hours = 7200
    userID: {type: mongoose.Schema.ObjectId, required: true},
    created: {type: Date, default: Date.now},
    lastRefreshed: {type: Date, default: Date.now, expires: expireSeconds},
    device: {type: String, default: "UNKNOWN"},
    token: {type: String, unique: true, required: true}
    //[{type: {type: String, required: true}, size: Number, mimetype: String}]
})


/**
 * creates a new token to be saved in the db
 * @returns {String} New Bearer Token
 */
 DBRefreshToken.methods.generateToken = async function() {
    const expireEPH = Date.now()
    //this.expire_at = expireEPH;
    this.lastRefreshed = expireEPH;
    this.token = jwt.sign({
        userID: this.userID.valueOf(),
        generationID: uuidv4(),
        type: 'refresh'
    }, process.env.AUTH_JWT_PRIVATE_KEY, { expiresIn: expireSeconds, jwtid: this._id.valueOf()});
    return this.token;
}

//Hashes the token before saving 
DBRefreshToken.pre(
    'save',
    async function(next) {
      if (!this.isModified('token')) return next();
      //const user = this;
      const hash = await bcrypt.hash(this.token, 10);
      this.password = hash;
      next();
    }
);

//Check hash with token in db 
DBRefreshToken.methods.validateToken = async function(token) {
    const compare = await bcrypt.compare(token, this.token);
    return compare;
}
schemas.RefreshToken = mongoose.model('refreshtokens', DBRefreshToken);

const bt = new schemas.RefreshToken({
    userID: mongoose.Types.ObjectId(),
    device: "testing"
})
const bt2 = new schemas.RefreshToken({
    userID: mongoose.Types.ObjectId(),
    device: "testing"
})
console.log(bt)
bt.generateToken()
bt.save();

bt2.generateToken()
bt2.save();

setTimeout(async () => {
    const fbt = await schemas.RefreshToken.findById(bt._id)
    fbt.generateToken()
    fbt.save();
}, 1000*8)

// const pp = new schemas.DBMedia({
//     groupID: mongoose.Types.ObjectId(),
//     type: "image",
//     metadata: {filename: "Penis.jpg"},
//     notes: "haha",
//     blurhash: "LDHta+?03D,^}uxv$*sA2moGjCRh",
//     files: {
//         original: {
//             size: 32,
//             mimetype: "image/jpeg"
//         },
//         compressed: [{size: 429, mimetype: "image/webp"},{size: 30, mimetype: "image/tiff"}],
//         thumbnail: {
//             bla: 34,
//             size: 3232,
//             mimetype: "image/webp"
//         }
//     }
//     // files: [
//     //     {type: "original", size: 42069, mimetype: "image/jpeg"},
//     //     {type: "compressed", size: 420, mimetype: "image/webp"},
//     //     {type: "thumbnail", size: 69, mimetype: "image/webp"},
//     // ]
// })


//  pp.save()



