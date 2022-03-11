import mongoose from "mongoose";
import mongoosePaginate from "mongoose-paginate-v2";

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
 * @property {Number} metadata.totalSize - The total size that this object takes up.
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
    groupID: {type: mongoose.Schema.ObjectId, required: true, index: true},
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
        filename: {type: String, required: true},
        totalSize: {type: Number, default: 0}
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
DBMedia.plugin(mongoosePaginate); // add pagenate features to media


export default mongoose.model('Media', DBMedia);
