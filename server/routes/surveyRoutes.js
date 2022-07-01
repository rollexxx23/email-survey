const requireLogin = require('../middlewares/requireLogin');
const requireCredits = require('../middlewares/requireCredits');
const mongoose = require('mongoose') ;
const surveyTemplate = require('../services/emailTemplate');
const Survey = mongoose.model('surveys')
const MailgunMailer = require("../services/mailer");
const Path = require("path-parser");



module.exports = app => {   


    // update choice(yes/no) counter

    app.get("/api/survey/:surveyId/:choice", (req, res) => {
        const p = new Path("/api/survey/:surveyId/:choice");
        var url = req.url ;
        const match = p.test(url);
        if(match) {
            console.log(match.surveyId) ;
            console.log(match.choice) ;
        }
        Survey.updateOne({
            _id : match.surveyId, },
           {
            $inc : { [match.choice] : 1},
            lastResponded : new Date() 
           }
    ).exec();
        res.send("Thanks for voting!");
      });

      // create a survey and send email
    app.post("/api/surveys", requireLogin, requireCredits,async(req,res) => {
        const {title, subject, body, recipients} = req.body ;
        console.log(req) ;
        const survey = new Survey({
            title,
            subject,
            body,
            recipients : recipients.split(',').map(email =>  ({email : email.trim()})),
            publishDate : Date.now() ,
            _user : req.user.id,
            

        })

        // send email
        try {

        const mailer = new MailgunMailer(survey, surveyTemplate(survey));
        await mailer.send() ;
        await survey.save() ;
        req.user.credits -= 1 ;
        const user = await req.user.save() ;
        console.log(user) ;
        res.send(user) ;
        } catch (err) {
            res.status(422).send(err) ;
        }
    });
    // get list of all surveys created by current-user
    app.get("/api/survey-list",requireLogin,  async (req,res) =>{
       const surveys = await Survey.find({_user : req.user.id}).select({recipients : false}) ;
       res.send(surveys) ;
    }) ;

    // webhook
    app.post("/api/survey/webhooks", (req, res) => {
        console.log("WEBHOOK",req.body) ;
        res.send({}) ;
      });

};