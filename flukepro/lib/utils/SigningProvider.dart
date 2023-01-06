import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../components/cons.dart';

final auth = FirebaseAuth.instance;

final _firestore = FirebaseFirestore.instance;

class siggning extends ChangeNotifier {
  String? email;
  String? userName;
  String? password;

  Map<String, dynamic>? userInfoDocument;
  setUserInfoDoc(userInfoData) => this.userInfoDocument = userInfoData;
  final eventRef = _firestore.collection('events');

  final authCredential =
      AuthCredential(providerId: 'google.com', signInMethod: 'Google');
  User? loggedUser = auth.currentUser;
  int? userType;
  setUserType(userType) => this.userType = userType;
  getLoggedInuser() => loggedUser;
  setLoggedInuser(user) => this.loggedUser = user;
  addJoinRequest(
      {eventId, userId, name, field, phone, email, joinType, context}) {
    final prevRequest = eventRef
        .doc(eventId)
        .collection('joinRequest')
        .where('userId', isEqualTo: userId)
        .where('requestStatus', isEqualTo: 'pending');
    print('-------------$eventId');
    eventRef.doc(eventId.toString().trim()).collection('joinRequest').add({
      'userId': userId,
      'eventId': eventId,
      'field': field,
      'email': email,
      'joinType': joinType,
      'requestStatus': 'pending'
    }).whenComplete(() => showDialog(
        //save to drafts dialog
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '!تم تقديم طلبك',
              textAlign: TextAlign.center,
              style: conHeadingsStyle.copyWith(fontSize: 15),
            ),
            content: Text(
              'سيصلك اشعار فور قبول الطلب',
              textAlign: TextAlign.center,
              style: conHeadingsStyle.copyWith(
                  fontSize: 14, fontWeight: FontWeight.normal),
            ),
            actions: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: conORange, borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'base');
                    },
                    child: Text(
                      'حسناً',
                      textAlign: TextAlign.center,
                      style: conHeadingsStyle.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
            buttonPadding: EdgeInsets.all(20),
            actionsAlignment: MainAxisAlignment.spaceAround,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
          );
        }));
    // } else {
    //   showDialog(
    //       //save to drafts dialog
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           title: Text(
    //             'لقد أرسلت طلب مسبقاً!',
    //             textAlign: TextAlign.center,
    //             style: conHeadingsStyle.copyWith(fontSize: 15),
    //           ),
    //           content: Text(
    //             'سيصلك اشعار فور قبول الطلب',
    //             textAlign: TextAlign.center,
    //             style: conHeadingsStyle.copyWith(
    //                 fontSize: 14, fontWeight: FontWeight.normal),
    //           ),
    //           actions: [
    //             Container(
    //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //               decoration: BoxDecoration(
    //                   color: conORange,
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: InkWell(
    //                   onTap: () {
    //                     Navigator.pop(context);
    //                   },
    //                   child: Text(
    //                     'حسناً',
    //                     textAlign: TextAlign.center,
    //                     style: conHeadingsStyle.copyWith(
    //                         color: Colors.white,
    //                         fontSize: 17,
    //                         fontWeight: FontWeight.bold),
    //                   )),
    //             ),
    //           ],
    //           buttonPadding: EdgeInsets.all(20),
    //           actionsAlignment: MainAxisAlignment.spaceAround,
    //           contentPadding:
    //               EdgeInsets.symmetric(vertical: 10, horizontal: 100),
    //         );
    //       });
    // }
  }

  saveTokenToDatabase(token) async {
    loggedUser != null
        ? await FirebaseFirestore.instance
            .collection('users')
            .doc(loggedUser!.uid)
            .update({
            'tokens': FieldValue.arrayUnion([
              token
            ]), //It is important to remember a user can have many tokens (from multiple devices, or token refreshes), therefore we use FieldValue.arrayUnion to store new tokens. When a message is sent via an admin SDK, invalid/expired tokens will throw an error allowing you to then remove them from the database.
          })
        : null;
    notifyListeners();
  }

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  void setUsername(var value) {
    userName = value;

    notifyListeners();
  }

  void setEmail(var value) {
    email = value;

    notifyListeners();
  }

  void setpasswprd(var value) {
    password = value;
    notifyListeners();
  }

  getCurrentUsertype(userID) async {
    DocumentSnapshot<Map<String, dynamic>> userInfo =
        await _firestore.collection('users').doc(userID).get();

    Map<String, dynamic>? userInfoDoc = userInfo.data();
    this.setUserType(userInfoDoc!['userType']);

    notifyListeners();
  }

  Future<Map<String, dynamic>?> getUserInfoDoc(userID) async {
    DocumentSnapshot<Map<String, dynamic>> userInfo =
        await _firestore.collection('users').doc(userID).get();

    userInfoDocument = userInfo.data();
    setUserInfoDoc(userInfo.data());
    notifyListeners();
    return userInfo.data();
  }

  //firebase
  getAllEvents() {
    Stream<QuerySnapshot> AllEvents = _firestore
        .collection('events')
        .orderBy('creationDate', descending: true)
        .where('eventVisibility', isEqualTo: true)
        .snapshots();
    notifyListeners();
    return AllEvents;
  }
}
