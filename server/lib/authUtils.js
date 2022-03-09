
// import passport from "passport"



// //MARK: LOCAL STRATEGY
// passport.use(new LocalStrategy(
//     function(username, password, done) {
//       User.findOne({ username: username }, function (err, user) {
//         if (err) { return done(err); }
//         if (!user) { return done(null, false); }
//         if (!user.verifyPassword(password)) { return done(null, false); }
//         return done(null, user);
//       });
//     }
//   ));


// //MARK: LOCAL STRATEGY
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