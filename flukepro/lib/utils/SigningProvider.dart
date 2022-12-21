import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int? userType;
  Map<String, dynamic>? userInfoDocument;
  final eventRef = _firestore.collection('events');

  final authCredential =
      AuthCredential(providerId: 'google.com', signInMethod: 'Google');
  late User? loggedUser = auth.currentUser;
  addJoinRequest(
      eventId, userId, name, field, phone, email, joinType, context) {
    final prevRequest = eventRef
        .doc(eventId)
        .collection('joinRequest')
        .where('userId', isEqualTo: userId)
        .where('requestStatus', isEqualTo: 'pending');
    if (prevRequest == null) {
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
                      color: conORange,
                      borderRadius: BorderRadius.circular(10)),
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 100),
            );
          }));
    } else {
      showDialog(
          //save to drafts dialog
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'لقد أرسلت طلب مسبقاً!',
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
                      color: conORange,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 100),
            );
          });
    }
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

  void getCurrentUsertype() async {
    final userInfo =
        await _firestore.collection('users').doc(loggedUser!.uid).get();

    final userInfoDoc = userInfo.data();
    userType = userInfoDoc!['userType'];
    notifyListeners();

    print('from provider $userType');
    // return userType;
  }

  void getUserInfoDoc() async {
    final userInfo =
        await _firestore.collection('users').doc(auth.currentUser!.uid).get();

    userInfoDocument = userInfo.data();
    print('user Document from provider $userInfoDocument');
    notifyListeners();
  }
}
