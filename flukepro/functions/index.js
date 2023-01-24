const functions = require("firebase-functions");


var {google} = require("googleapis");

// Load the service account key JSON file.


// Define the required scopes.
var scopes = [
  "https://www.googleapis.com/auth/firebase.messaging",

];
var express=require('express');
var app =express();

var bodyParser=require('body-parser');
var router=express.Router();
var request=require('request');

app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());
// Authenticate a JWT client with the service account.
router.post('/send',function(req,res){
getAccessToken().then(function(access_token){
var title=req.body.title;
var body=req.body.body;
var token=req.body.token;

request.post({
headers:{
Authorization:'Bearer '+access_token
},url:"https://fcm.googleapis.com/v1/projects/fluke-db/messages:send",
body: JSON.stringify(
{
  "message":{
    "token" :token,
    "notification" : {
      "title" : title,
      "body" : body
    }

  }
}
)
},function(error,response,body){
res.end(body);
console.log(body);
})
});
});
app.use('/api',router);


function getAccessToken(){
return new Promise(function(resolve,reject){
var key=require("./fluke-db-firebase-adminsdk-b5tjy-15157f1bf0.json");
var jwtClient = new google.auth.JWT(
  key.client_email,
  null,
  key.private_key,
  scopes
);
jwtClient.authorize(function(error, tokens) {
  if (error) {
  reject(error);
  return;
  } else if (tokens.access_token === null) {
    console.log("Provided service account does not have permission to generate access tokens");
  } else {
//    var accessToken = tokens.access_token;
resolve(tokens.access_token)
console.log(tokens.access_token)
    // See the "Using the access token" section below for information
    // on how to use the access token to send authenticated requests to
    // the Realtime Database REST API.
  }
});
}) }
// Use the JWT client to generate an access token.



 exports.api = functions.https.onRequest(app);
