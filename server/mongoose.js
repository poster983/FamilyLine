
import mongoose from "mongoose";

export let connection = mongoose.connect('mongodb://localhost:27017/FamilyLine');

// export async function connect() {
//     await 
// }




// const Kitten = mongoose.model('Kitten', new mongoose.Schema({
//     name: String,
// }));

// let cb = new Kitten({name: "Cat Bastard"});
// console.log(cb)

// cb.save();

// MARK: DEFINE SCHEMAS

export let schemas = {};

/**
 * Database Media schema
 * @typedef {Object} DBMedia
 * @property {ObjectId} _id - media id
 * @property {ObjectId} groupID - The group that this media belongs to. 
 * @property {String} type - can be 'video', 'audio', 'image', document'
 * @property {Date} uploaded - Upload date
 * @property {Date} lastModified - Last modified date
 * @property {Date} sortDate - Day to sort tis against the other photos in th UT (day photo was taken for instance)
 * @property {Object|null} processing - can be null if the object does not need processing
 * @property {Number} processing.progress - 0 to 1
 * @property {Date|null} processing.finished
 * @property {Date|null} processing.started 
 * @property {Object} metadata
 * @property {String} metadata.filename - The OG filename
 * @property {String} notes - user defined notes.
 * @property {String} blurhash - Blurhash string to show the user before the actual picture loads
 * @property {Object} files - Holds info about the different types of files that make up this Media
 * @property {Object|null} files.original - The original and unmodified file for archival | if null then we didnt save it
 * @property {Number} files.original.size - size in kb
 * @property {String} files.original.mimetype - the original mimetype 
 * @property {[Object]|null} files.compressed - The compressed version.  index 0 is preferred over index 1 and so on.
 * @property {Number} files.compressed.size - size in kb
 * @property {Object} files.thumbnail - The file's thumbnail.
 * @property {Number} files.thumbnail.size - size in kb
 */
const DBMedia = new mongoose.Schema({
    groupID: {type: mongoose.Schema.ObjectId, required: true},
    type: {type: String, required: true, enum: ['image', 'video', 'audio', 'document']}, // TODO: Create custom type
    uploaded: {type: Date, default: Date.now},
    lastModified: {type: Date, default: Date.now},
    sortDate: {type: Date, default: Date.now},
    processing: {  
        progress: Number,
        finished: Date,
        started: Date,
    },
    metadata: {
        filename: {type: String, required: true}
    },
    notes: String,
    blurhash: String,
    files: {
        original: {
            size: Number,
            mimetype: String
        },
        thumbnail: {
            size: Number,
            mimetype: String
        },
        compressed: [{size: Number, mimetype: String}]
    }

    //[{type: {type: String, required: true}, size: Number, mimetype: String}]
})
schemas.DBMedia = mongoose.model('Media', DBMedia);


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



