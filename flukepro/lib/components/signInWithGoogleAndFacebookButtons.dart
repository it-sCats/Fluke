import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/screens/regestrationScreens/intersetsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/authentication.dart';
import '../utils/fireStoreQueries.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class GoogleAndFacebookButtons extends StatefulWidget {
  GoogleAndFacebookButtons({this.userType});
  final int? userType;
  String? docID;

  SharedPreferences? userTypeShared;
  @override
  State<GoogleAndFacebookButtons> createState() =>
      _GoogleAndFacebookButtonsState();
}

class _GoogleAndFacebookButtonsState extends State<GoogleAndFacebookButtons> {
  final _firestore = FirebaseFirestore.instance;
  String? _userType;
  DocumentReference? docID;
  SharedPreferences? userTypeShared;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            final userID = await Authentication().signInWithFacebook();
            userTypeShared = await SharedPreferences.getInstance();
            _userType = userTypeShared?.getString("userType");
            if (userID != null) {
              //if Sign in is successful check the user type if he is a visitor or participant
              if (_userType == '2') {
                //if particepant
                //2 is for participants
                if (await isUniqueID('paticipants', 'paticipant', userID)) {
                  await _firestore
                      .collection('users')
                      .doc('paticipants')
                      .collection('paticipant')
                      .doc(userID);
                  Navigator.pushNamed(
                    context,
                    interestsSelection.routeName,
                    arguments: {2},
                  );
                } else {
                  Navigator.pushNamed(context, '/home');
                }
              } else if (_userType == '0') {
                //0 stands for visitors //if the argument that was passed to the screen is 0 that means its a visitorf
                if (await isUniqueID('visitors', 'visitor', userID)) {
                  //check if userID already exists

                  docID = await _firestore
                      .collection('users')
                      .doc('visitors')
                      .collection('visitor')
                      .doc(userID);
                  print('register user');

                  // .then((value) => )
                  Navigator.pushNamed(
                    context,
                    interestsSelection.routeName,
                    arguments: {0},
                  );
                } else {
                  Navigator.pushNamed(context, '/home');
                }
              }
              if (_userType == null &&
                  (await isUniqueID('visitors', 'visitor', userID) ||
                      await isUniqueID('paticipants', 'paticipant', userID))) {
                docID = await _firestore
                    .collection('users')
                    .doc('visitors')
                    .collection('visitor')
                    .doc(userID);
                print('register user');

                // .then((value) => )
                Navigator.pushNamed(
                  context,
                  interestsSelection.routeName,
                  arguments: {0},
                );
              } else {
                Navigator.pushNamed(context, '/home');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                  'حدث خطأ في عملية التسجيل.. أعد المحاولة',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                )),
              );
            }
          },
          child: Container(
            height: 55,
            width: 51,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff383838),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                )),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(1),
              backgroundImage: AssetImage('images/image 1.png'),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        InkWell(
            onTap: () async {
              User? user =
                  await Authentication.signInWithGoogle(context: context);
              //check if user ID already exists in the database
              if (user != null) {
                //if Sign in is successful check the user type if he is a visitor or participant
                if (_userType == '2') {
                  //if particepant
                  //2 is for participants
                  if (await isUniqueID('paticipants', 'paticipant', user.uid)) {
                    await _firestore
                        .collection('users')
                        .doc('paticipants')
                        .collection('paticipant')
                        .doc(user!.uid)
                        .set({
                      "email": user.email,
                      "name": user.displayName,
                      "phone": user.phoneNumber
                    });
                    Navigator.pushNamed(
                      context,
                      interestsSelection.routeName,
                      arguments: {2},
                    );
                  } else {
                    Navigator.pushNamed(context, '/home');
                  }
                } else if (_userType == '0') {
                  //0 stands for visitors //if the argument that was passed to the screen is 0 that means its a visitorf
                  if (await isUniqueID('visitors', 'visitor', user.uid)) {
                    //check if userID already exists

                    await _firestore
                            .collection('users')
                            .doc('visitors')
                            .collection('visitor')
                            .doc(user!.uid)
                            .set({
                      "email": user.email,
                      "name": user.displayName,
                      "phone": user.phoneNumber
                    }) //TODO create documentID with userID
                        ;
                    // .then((value) => )
                    Navigator.pushNamed(
                      context,
                      interestsSelection.routeName,
                      arguments: {0},
                    );
                  } else {
                    Navigator.pushNamed(context, '/home');
                  }
                }
                if (_userType == null &&
                    (await isUniqueID('visitors', 'visitor', user!.uid) &&
                        await isUniqueID(
                            'paticipants', 'paticipant', user!.uid))) {
                  //ي حالة تم التسجيل عن طريق قوقل وفيس بوك لن يوجد يوزر تايب لذلك هنا يتم التعامل مع هذه الحالة التي لا يوجد فيها المستخدم في أي من المجموعات الموجودة في قاعدة البيانات
                  print("no user type is unique");
                  await _firestore
                          .collection('users')
                          .doc('visitors')
                          .collection('visitor')
                          .doc(user!.uid)
                          .set({
                    "email": user.email,
                    "name": user.displayName,
                    "phone": user.phoneNumber,
                    "role": 'user'
                  }) //TODO create documentID with userID
                      ;
                  userTypeShared = await SharedPreferences.getInstance();
                  userTypeShared?.setString("userType", '0');
                  print('userType assigned');

                  // .then((value) => )
                  Navigator.pushNamed(
                    context,
                    interestsSelection.routeName,
                    arguments: {0},
                  );
                } else {
                  Navigator.pushNamed(context, '/home');
                }
              } else {
                //Error in sign in
              }
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  color: Color(0xff3F72BE).withOpacity(.9),
                  border: Border.all(
                    color: Color(0xff383838),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 17),
                    child: Text(
                      'سجل دخول بإستخدام قوقل',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 55,
                    width: 51,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xff383838),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(23),
                        )),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withOpacity(1),
                      backgroundImage: AssetImage('images/google-tile 1.png'),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }
}
