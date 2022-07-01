const express = require('express');
require('./services/passport');
require('./models/User');
require('./models/survey');
const keys = require('./config/keys');
const mongoose = require('mongoose');
const authRoutes = require('./routes/authRoutes');
const paymentRoutes = require('./routes/paymentRoutes');
const surveyRoutes = require('./routes/surveyRoutes');
const cookieSession = require('cookie-session');
const passport = require('passport');
const bodyParser = require('body-parser')
const cors = require("cors");

mongoose.connect(keys.mongoURI);
const app = express();
app.use(bodyParser.json());
app.use(
    cookieSession({
        maxAge: 30 * 24 * 60 * 60 * 1000,
        keys: [keys.cookieKey]
    })
)

app.use(passport.initialize());
app.use(passport.session());
app.get("/", (req,res) => {
    res.send({"message": "test-successful"}) ;
});
app.use(cors({
    origin:['http://localhost:5555','http://127.0.0.1:4200'],
    credentials:true
}));

app.use(function (req, res, next) {

  res.header('Access-Control-Allow-Origin', "http://localhost:5555");
  res.header('Access-Control-Allow-Headers', true);
 // res.header('Access-Control-Allow-Credentials', 'Content-Type');
  res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
  next();
});
authRoutes(app);
paymentRoutes(app);
surveyRoutes(app);




const port = process.env.PORT || 5000 ;
app.listen(port, () => {
    console.log(`Running on->${port}`)
});



