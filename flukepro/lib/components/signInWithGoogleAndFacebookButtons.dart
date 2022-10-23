import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/authentication.dart';

class GoogleAndFacebookButtons extends StatefulWidget {
  GoogleAndFacebookButtons({this.userType});
  final int? userType;

  @override
  State<GoogleAndFacebookButtons> createState() =>
      _GoogleAndFacebookButtonsState();
}

class _GoogleAndFacebookButtonsState extends State<GoogleAndFacebookButtons> {
  final _firestore =FirebaseFirestore.instance;
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
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
              if (user != null) {
              if (widget.userType==0) {
                //0 stands for visitors //if the argument that was passed to the screen is 0 that means its a visitorf
                _firestore
                    .collection('visitors')
                    .add({'UserID': user?.uid});
              } else if (widget.userType==1) {
                //1 means user clicked on the Organizers card
                _firestore
                    .collection('organizingAgen')
                    .add({'UserID': user?.uid});
              } else if (widget.userType==2) {
                //2 is for participants
                _firestore
                    .collection('paticipants')
                    .add({'UserID': user?.uid});
              }


                Navigator.pushNamed(context, '/home');
              } else {

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
