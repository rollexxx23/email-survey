const mongoose = require('mongoose') ;

const {Schema} = mongoose ;

const RecipientSchema = new Schema({
    email : String,
    clicked: {type :Boolean, default : false},
    
});

module.exports = RecipientSchema;