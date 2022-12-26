// Node.js e.g via a Firebase Cloud Function
const express=require('express');
const functions =require('firebase-functions');
// const app=express();
const admin = require("firebase-admin");

// var serviceAccount = require("flukepro/fluke-db-firebase-adminsdk-b5tjy-f1c2110dc4.json");
admin.initializeApp();
//   credential: admin.credential.cert(serviceAccount)
// app.post('/sendNotificationForVisitors',(req,res)=>{
// const notification=req.body.notification;
// const topic=req.body.topic;
// const message={
// notification:notification
// }
// admin.messaging().sendToTopic('visitors',message).then((response)=>{console.log('Notification was sent successfully:',response);}).catch((error)=>{
//                                                   console.log('failed to send notifi:',error);});
// });

// this function meant to send notification whenever creating new event in firebase
exports.sendEventNotification=functions.firestore.document('events/{id}').onCreate((snapshot)=>{
//getsthe event data
var event=snapshot.data();

//send notification to all users
const payload ={

notification:{
title:`${event.title}`,
body:
`سيقام ${event.title} \n بتاريخ ${event.starterDate}`,
clickAction:'FLUTTER_NOTIFICATION_CLICK'
 },
 data:{
 eventId:`${event.id}`,
 createrId:`${event.creater}`,
 }

};
return
admin.messaging().sendToTopic('visitors',payload).then((response)=>{console.log('Notification was sent successfully:',response);}).catch((error)=>{
console.log('failed to send notifi:',error);});


});
//async function onCreatingEvent(ownerId, userId, picture) {
//
//  // Get the owners details
//  const owner = admin.firestore().collection("users").doc(ownerId).get();
//
//  // Get the users details
//  const user = admin.firestore().collection("users").doc(userId).get();
//
//  await admin.messaging().sendToDevice(
//    owner.tokens, // ['token_1', 'token_2', ...]
//    {
//      data: {
//        owner: JSON.stringify(owner),
//        user: JSON.stringify(user),
//        picture: JSON.stringify(picture),
//      },
//    },
//    {
//      // Required for background/quit data-only messages on iOS
//      contentAvailable: true,
//      // Required for background/quit data-only messages on Android
//      priority: "high",
//    }
//  );
//}
//
//function sendNotificationToVisitors(eventID,title,body,eventPic){
//const message = {
// notification: {
//    title:JSON.stringify(title),
//    body: JSON.stringify(body),
//    imageUrl:JSON.stringify(eventPic),
//  },
//  data: {
//eventId:JSON.stringify(eventID)
//
//  },
//  topic: "visitors",
//};}