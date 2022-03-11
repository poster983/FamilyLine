import jwt from "jsonwebtoken";
import DBUser from "./mongoose/DBUser.js"
import DBRefreshToken from "./mongoose/DBRefreshToken.js"
import util from "util";
import { error } from "./errorUtils.js";
import { v4 as uuidv4 } from 'uuid';
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

//MARK: Middleware

/**
 * Express Middleware - Verifies the access token without querying db for user
 * Sets req.authorization to the token
 * @param {*} req 
 * @param {*} res 
 * @param {*} next 
 */
export function verifyAccessToken(req, res, next) {
    const authHeader = req.headers['authorization'];
   let token;
   if (authHeader?.startsWith("Bearer ")){
        token = authHeader.substring(7, authHeader.length);
    } else {
        return next(error("Make sure your access token is provided in the `Authorization` header prefixed with `Bearer ` ", 401));
    }
    let decoded;
    try {
        decoded = jwt.verify(token, process.env.AUTH_JWT_PRIVATE_KEY)
        if(decoded.type !== 'access') {
            return next(error("Please provide an access token.  Remember to exchange your refresh token.", 401));
        }
        req.authorization = decoded;
        next();
    } catch(e) {
        console.log(e)
        return  next(error("Invalid Token", 403));
    }
}

/**
 * Middleware to check if the provided group id matched the authorization.
 * @param {*} req 
 * @param {*} res 
 * @param {*} next 
 */
 export function checkGroup(req,res,next) {
    if(req.authorization?.groupIDs.includes(req.params['groupID'])) {
      return next();
    } else {
      return next(error("Not permitted to access this group.", 403));
    }
  }

// MARK: Bearer Strategy Auth (refresh token)
/**
 * Given a refresh token, 
 * @param {*} refreshtoken 
 * @returns new refreshToken and accessToken
 */
export async function exchangeRefreshToken(refreshtoken) {
    let result;
    let token;
    try {
        token = jwt.verify(refreshtoken, process.env.AUTH_JWT_PRIVATE_KEY)
        if(token.type !== 'refresh') {
            throw error("Invalid Token", 401);
        }
        result = await Promise.all([DBRefreshToken.findById(token.jti), DBUser.findById(token.userID)])
    } catch(e) {
        console.log(e)
        throw error("Invalid Token", 403);
    }
        const tdb = result[0];
        const udb = result[1];
        if(!tdb) {
            throw error("Invalid Token", 401);
        }
        // if(await tdb.validateToken(refreshtoken)) {
        //     throw error("Invalid Token", 401);
        // }
        if(!udb) {
            throw error("User not found", 401);
        }
        try {
            const newRefresh = tdb.generateToken()
            const saveProm = tdb.save();
            const accessToken = jwt.sign({
                type: "access",
                userID: token.userID,
                groupIDs: udb.groupIDs,
                generationID: tdb.generationID,
                exp: Math.floor(Date.now() / 1000)+parseInt(process.env.AUTH_ACCESS_TOKEN_TIMEOUT) 
            }, process.env.AUTH_JWT_PRIVATE_KEY, {jwtid: token.jti} )
            
       
            await saveProm;
            return {refreshToken: newRefresh, accessToken: accessToken};
        } catch(e) {
            console.error(e)
            throw error("Could not generate new keys", 500);
        }
        
        

    
    // DBRefreshToken
}
//console.log(await exchangeRefreshToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiI2MjI5MzY5MjBjYjI3YzI3MzkxYWMzOWIiLCJnZW5lcmF0aW9uSUQiOiJkMTFjMGViOS05ODI0LTRhOWUtODFhNy0zOTk3NDAxZjE4ODYiLCJ0eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Njg3MTcxNCwiaWF0IjoxNjQ2ODY4MTE0LCJqdGkiOiI2MjI5MzY5MjBjYjI3YzI3MzkxYWMzOWMifQ.gM0YP6Iy9sbQC1MENzBp7rhHeDQQ1Prz4tKqe6yK5MY"))





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