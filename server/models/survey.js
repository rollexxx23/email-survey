const mongoose = require('mongoose') ;
const RecipientSchema = require('./recipient');

const {Schema} = mongoose ;

const SurveySchema = new Schema({
    title : String,
    body : String,
    subject: String,
    yes : {type :Number, default: 0},
    no : {type :Number, default: 0},
    recipients: [RecipientSchema],
    publishDate : Date,
    lastResponded : Date,
    _user : {type : Schema.Types.ObjectId , ref : 'users'} 
})

mongoose.model('surveys', SurveySchema);