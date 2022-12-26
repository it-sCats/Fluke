importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBT5U-euIQWu-lbUHWuC9c8zv_wWEw0MN0",
  authDomain: "fluke-db.firebaseapp.com",

  projectId: "fluke-db",
  storageBucket: "fluke-db.appspot.com",
  messagingSenderId: "141070963911",
  appId: "1:141070963911:web:124341cd74a88ca4cb5ae2",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
