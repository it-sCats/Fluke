var {google} = require("googleapis");

// Load the service account key JSON file.


// Define the required scopes.
var scopes = [
  "https://www.googleapis.com/auth/firebase.messaging",

];
var http=require('http');

// Authenticate a JWT client with the service account.

function getAccessToken(){
return new Promise(function(resolve,reject){
var key=require("./fluke-db-firebase-adminsdk-b5tjy-57d2779c68.json");
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
    // See the "Using the access token" section below for information
    // on how to use the access token to send authenticated requests to
    // the Realtime Database REST API.
  }
});
}) }
// Use the JWT client to generate an access token.

var server=http.createServer(function(req,res){
getAccessToken().then(function(access_token){
res.end(access_token)
});
});server.listen(3000,function(){
console.log('server started');
});