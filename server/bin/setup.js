import "../env.js"
import mongoose from "mongoose";
import "../lib/mongoose/DBConnect.js"
import { error } from "../lib/errorUtils.js";
import DBGroup from "../lib/mongoose/DBGroup.js"
import DBUser from "../lib/mongoose/DBUser.js"



async function createNewGroup(user) {
    let results;
    const session = await mongoose.startSession();
    await session.withTransaction(async () => {

        let _user;
        if (typeof user === 'string') { // user already exists
            //DBUser
        } else {
            _user = new DBUser({
                name: user.name,
                email: user.email,
                password: user.password,
            });

        }
        let _group = new DBGroup({
            ownedBy: _user._id
        })
        console.log(_user)

        _user.groupIDs.push(_group._id);

        try {
            await Promise.all([_user.validate(), _group.validate()]);
        } catch (e) {
            await session.abortTransaction();
            throw error(e, 500)
        }
        try {
            await Promise.all([_user.save(), _group.save()]);
        } catch (e) {
            await session.abortTransaction();
            throw error(e, 500) // TODO: Revert to previous state
        }

        results = {
            user: _user._id,
            group: _group._id
        }
    });

    session.endSession();
    return results;
}


createNewGroup({
    name: {
        given: "First",
        family: "last",
        lalal: "plz break"
    },
    email: "junk@google.com",
    password: 123456
})