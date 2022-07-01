const passport = require('passport') ;
const baseMiddleware = require("../middlewares/baseMiddleware") ;
module.exports = (app) => {

app.get('/auth/google', passport.authenticate('google', {'scope' : ['profile', 'email']}));

app.get('/auth/google/callback',passport.authenticate('google' ),
  (req,res) => {
    res.redirect('http://localhost:5555/#/') ;
  }
);

app.get('/api/current_user',  (req, res) => {
    res.json(req.user);
  });

app.get('/api/logout', (req,res) => {
    req.logout() ;
  //  res.send(req.user) ;
    res.redirect('http://localhost:5555/#/') ; 
})
}