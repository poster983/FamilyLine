import mongoose from "mongoose";
import bcrypt from "bcrypt"

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
 * @property {String} password - hashed password
 * @property {Date} joined - Date joined
 */
 const DBUser = new mongoose.Schema({
    groupIDs: {type: [mongoose.Schema.ObjectId], validate: v => Array.isArray(v) && v.length > 0},
    active: {type: Boolean, default: true},
    name: {
        given: {type: String, trim: true, required: true},
        family: {type: String, trim: true, required: true}
    },
    email: {
        type: String, 
        trim: true,
        lowercase: true,
        unique: true,
        required: true,
        index: true,
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
export default mongoose.model('User', DBUser);



