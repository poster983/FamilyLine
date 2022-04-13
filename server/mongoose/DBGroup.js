import mongoose from "mongoose";

// MARK: GROUPS
/**
 * Database Group schema
 * @typedef {Object} DBGroup
 * @property {ObjectId} _id - Group id
 * @property {Object} settings 
 * @property {Boolean} [settings.keepOriginals=false] - Will always keep the Original file uploaded so the user can download it later.  If false it will only keep the compressed files
 * @property {Boolean} [settings.compatibilityMode=true] - Will encode and save multiple versions of various files to ensure support on all platforms. (for example if false videos on Safari on ios will not play)
 * @property {Date} created - date created
 * @property {ObjectId} ownedBy - The user account that created this group
*/
 const DBGroup = new mongoose.Schema({
    settings: {
        keepOriginals: {type: Boolean, default: false},
        compatibilityMode: {type: Boolean, default: true}
    },
    date: {type: Date, default: Date.now},
    ownedBy: {type: mongoose.Schema.ObjectId, required: true}
})
export default mongoose.model('Groups', DBGroup);
