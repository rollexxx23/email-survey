const keys = require('../config/keys') ;
const stripe = require('stripe')(keys.stripeSecretKey);
const requieLogin = require('../middlewares/requireLogin') ;

module.exports = (app) => {
    app.post('/api/payment',requieLogin, async (req,res) => {
        
      
        req.user.credits += 1 ;
        const user = await req.user.save() ;
        res.send(user)
        

    })
}