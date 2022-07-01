const keys = require('../config/keys') ;
const mailGunPrivateKey= require('stripe')(keys.mailGunPrivateKey);
const mailgun = require("mailgun-js")({
    apiKey: "e948264e2c687862bfadc91f10f23d55-27a562f9-2e6b5fc9",
    domain: 'sandboxb7be5db3f5174327a30d0a0a050b6b82.mailgun.org'
  });

  class MailgunMailer {
    // constructor -> get data from surveyRoute
    constructor({subject, recipients},content) {
     
        this.data = {
            from: "no-reply@arinchatterjee.com",
            to: this.formatRecipients(recipients),
            subject: subject,
            html: content
          };
    }

    // format the adddress from array of object

    formatRecipients(recipients) {
      console.log(JSON.stringify(recipients));
        return recipients.map(({ email }) => email).join(",");
    }
    // send email

    async send() {
      console.log(this.data) ;
        const res = await mailgun.messages().send(this.data, (err, res) => {
          if(err) console.log(err)
          else console.log(res);
        });
        console.log(res);
        return res;
    }
    
  }

  module.exports = MailgunMailer;