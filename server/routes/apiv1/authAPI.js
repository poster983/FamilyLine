import express from 'express';
var router = express.Router();
import {exchangeRefreshToken} from "../../lib/authUtils.js"
import DBUser from "../../lib/mongoose/DBUser.js"
import DBRefreshToken from "../../lib/mongoose/DBRefreshToken.js"

import {error} from "../../lib/errorUtils.js"




// not in group

/**
 * Logs the user in and provides refreshtoken
 * @apiBody {String} email - The user's email
 * @apiBody {String} password - The user's password
 * @apiSuccess {String} refreshToken - A JWT Long lived refresh token
 */
router.post("/login", async (req,res,next) => {
    if(!req.body.email || !req.body.password) {
        return next(error("'email' and 'password' required in json body"), 400);
    }

    // find account
    let user;
    try {
        user = await DBUser.findOne({email: req.body.email })
    } catch(e) {
        console.log(e);
        return next(error("Invalid Username or Password", 401))
    }
    if(!user) {
        console.log("Invalid Username or Password");
        return next(error("Invalid Username or Password", 401))
    }
    if(await user.validatePassword(req.body.password)) {
        //is valid
        
        //generate refresh token
        let _refreshToken = new DBRefreshToken({
            userID: user._id,
            device: {
                ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress,
                ua: req.get('User-Agent')
            }
        })
        let token = _refreshToken.generateToken();
        try{
            await _refreshToken.save()
        } catch(e) {
            console.error(e);
            return next(error("Could not create token", 500))
        }
        res.status(200);
        return res.json({refreshToken: token})
    } else {
        //invlaid
        console.log("Invalid Username or Password");
        return next(error("Invalid Username or Password", 401))
    }
    


});


/**
 * Exchanges a long lived Refresh Token for a short lived access token
 * @apiBody {String} refreshToken - The user's refreshtoken
 */
router.post("/exchange", async (req,res,next) => {
    console.log(req.body)
    if(!req.body.refreshToken) {
        return next(error("'refreshToken' required in json body"), 400);
    }
    try {
        const tokens = await exchangeRefreshToken(req.body.refreshToken)
        res.status(200);
        return res.json(tokens)
    } catch(e) {
        return next(e);
    }
    
})



export default router;