const { default: mongoose } = require('mongoose');
const passport = require('passport') ;
const passportGoogleStrategy = require('passport-google-oauth20').Strategy ; 
const keys = require('../config/keys.js') ;

require('../models/User')
const User = mongoose.model('users') ;

passport.serializeUser((user,done) => {
    done(null,user.id) ;
}) ;

passport.deserializeUser((id, done) => {
    User.findById(id).then((user) => {
        done(null,user);
    })
}) ;

passport.use(new passportGoogleStrategy({
    clientID : keys.googleClientID,
    clientSecret : keys.googleClientSecret,
    callbackURL : "/auth/google/callback"
}, (accessToken, refreshToken, profile, done) => {
    console.log(accessToken,refreshToken,profile,done) ;
   User.findOne({googleId : profile.id}).then((userVal) => {
       if(userVal) {
           // sign in logic
           console.log("WELCOME BACK") ;
           done(null,userVal) ;
       } else {
           // sign up logic
           console.log("WELCOME WELCOME WELCOME")
           new User({googleId : profile.id}).save().then((user) => {
                done(null, user) ;
           })
       }
   })
   
}
)) ;


