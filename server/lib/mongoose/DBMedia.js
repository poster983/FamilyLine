import mongoose from "mongoose";
import mongoosePaginate from "mongoose-paginate-v2";

//MARK: Point (GeoJSON)

/**
 * Database GEO Point schema
 * @typedef {Object} DBPoint
 * @property {String} [type=Point] - Must be 'Point' 
 * @property {[Number]} coordinates - The coordinates of the point in the form [longitude, latitude]
 **/
const DBPoint = new mongoose.Schema({
    type: {
      type: String,
      enum: ['Point'],
      default: "Point"
    },
    coordinates: {
      type: [Number],
      required: true
    }
  });


// MARK: MEDIA
/**
 * Database Media schema
 * @typedef {Object} DBMedia
 * @property {ObjectId} _id - media id
 * @property {ObjectId} groupID - The group that this media belongs to. 
 * @property {String} type - can be 'video', 'audio', 'image', document'
 * @property {Date} uploaded - Upload date
 * @property {Date} updatedAt - Last modified date
 * @property {Date} creationDate - Day to sort tis against the other photos in th UT (day photo was taken for instance)
 * @property {Object|null} encoding - can be null if the object does not need processing
 * @property {Number} encoding.progress - 0 to 1
 * @property {String} encoding.link - the link in s3 for the file to be processing 
 * @property {Date|null} encoding.finished
 * @property {Date|null} encoding.started 
 * @property {Object} metadata
 * @property {String} metadata.filename - The OG filename
 * @property {String|null} metadata.title - User Defined Title for media
 * @property {DBPoint|null} metadata.location
 * @property {String|null} metadata.gpsAltitude - number with units (sometimes with "above/below sea level")
 * @property {Number|null} metadata.mediaFramerate - Video Only
 * @property {Number|null} metadata.mediaDuration - Video & Audio Only
 * @property {Number|null} metadata.mediaWidth - Image & Video Only
 * @property {Number|null} metadata.mediaHeight - Image & Video Only
 * @property {String|null} metadata.mediaVideoBitrate - Video Only | Average Bitrate
 * @property {Number|null} metadata.mediaAudioSampleRate - Audio & Video Only | Average Bitrate
 * @property {Number|String|null} metadata.osVersion
 * @property {String|null} metadata.cameraMake - Image & Video Only
 * @property {String|null} metadata.cameraModel - Image & Video Only
 * @property {Number|null} metadata.cameraMegapixels - Image & (maybe)Video Only
 * @property {Number|null} metadata.cameraFstop - Image Only 
 * @property {String|null} metadata.cameraFocalLength - With units (mm)
 * @property {Number|null} metadata.cameraISO - Image Only
 * @property {Number|null} metadata.cameraRotation
 * @property {String|null} metadata.cameraShutterSpeed - 1/x
 * @property {String|null} metadata.dtOffset - Time offset from UTC
 * @property {Number} totalSize - The total size that this object takes up.
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
    // uploaded: {type: Date, default: Date.now},
    // updatedAt: {type: Date, default: Date.now},
    creationDate: {type: Date, default: Date.now, index: -1},
    encoding: {  
        progress: Number,
        link: String,
        finished: Date,
        started: Date,
        //jobQueueID: mongoose.Schema.ObjectId
    },
    totalSize: {type: Number, default: 0},
    metadata: {
        filename: {type: String, required: true},
        title: String,
         //gps
         location: DBPoint,
         gpsAltitude:   String,
         //media 
         mediaFramerate: Number,
         mediaDuration: Number,
         mediaWidth: Number,
         mediaHeight: Number,
         mediaVideoBitrate: String,
         mediaAudioSampleRate: Number,

         //device 
         cameraMake: String,
         cameraModel: String,
         osVersion: String,

         //camera
         cameraMegapixels: Number,
         cameraFstop: Number,
         cameraFocalLength: String,
         cameraISO: Number,
         cameraRotation: Number,
         cameraShutterSpeed: String,
         
         dtOffset: String
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
}, { timestamps: { createdAt: 'uploaded' }})
DBMedia.plugin(mongoosePaginate); // add pagenate features to media


export default mongoose.model('Media', DBMedia);
