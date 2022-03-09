import passport from "passport"
import {Strategy as LocalStrategy } from "passport-local";
import {Strategy as BearerStrategy} from "passport-http-bearer";
import jwt from "jsonwebtoken";
import { schemas } from '../mongoose.js';
import util from "util";
const DBUser = schemas.User;
const DBRefreshToken = schemas.RefreshToken
//const jwtVerify = util.promisify(jwt.verify);

// export function hash(string) {

// }


//MARK: LOCAL STRATEGY
// passport.use(
//     'login',
//     new LocalStrategy(
//       {
//         usernameField: 'email',
//         passwordField: 'password'
//       },
//       async (email, password, done) => {
//         try {
//           const user = await DBUser.findOne({ email });
  
//           if (!user) {
//             return done(null, false, { message: 'Incorrect username or password' });
//           }
          
//           const validate = await user.validatePassword(password);
  
//           if (!validate) {
//             return done(null, false, { message: 'Incorrect username or password' });
//           }
  
//           return done(null, user, { message: 'Logged in Successfully' });
//         } catch (error) {
//           return done(error);
//         }
//       }
//     )
//   );

// MARK: Bearer Strategy Auth (refresh token)
/**
 * Given a refresh token, 
 * @param {*} refreshtoken 
 */
// export async function exchangeRefreshToken(refreshtoken) {
//     try {
//         const token = jwt.verify(refreshtoken, process.env.AUTH_JWT_PRIVATE_KEY)
//         const tdb = await DBRefreshToken.findById(token.jti);
//         validateToken
//         const newRefresh = tdb.generateToken()
//         const saveProm = tdb.save();
//         const accessToken = jwt.sign({
//             type: "access",
//             userID: token.userID,
//             groupIDs: tdb
//         }, , )

//         await saveProm;
//         return {refreshToken: newRefresh, accessToken: accessToken};
//     } catch(e) {
//         console.log(e)
//         throw error(e, 403);
//     }
    
//     // DBRefreshToken
// }
// console.log(await exchangeRefreshToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiI2MjI4ZjcxM2M2NDgzNTJlNjQ4Zjg5N2MiLCJnZW5lcmF0aW9uSUQiOiJlODc1MWQ5NC0zZGY3LTQwNWItOTk2OC04NGQ4Yjc1YjhlOGIiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTY0Njg1MTg2NywiZXhwIjoxNjQ2ODU1NDY3LCJqdGkiOiI2MjI4ZjcxM2M2NDgzNTJlNjQ4Zjg5N2QifQ.Ptr_IYwNtyBu2AsRO136c7XjxRE7FQ4tlxnnuOQC2zQ"))





//MARK: LOCAL STRATEGY
// passport.use(
//     'signup',
//     new localStrategy(
//       {
//         usernameField: 'email',
//         passwordField: 'password'
//       },
//       async (email, password, done) => {
//         try {
//           const user = await UserModel.create({ email, password });
  
//           return done(null, user);
//         } catch (error) {
//           done(error);
//         }
//       }
//     )
//   );