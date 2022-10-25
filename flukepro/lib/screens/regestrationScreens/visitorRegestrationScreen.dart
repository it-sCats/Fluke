import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/errorsHandling/AuthExceptionHandler.dart';
import 'package:flutter/material.dart';

import '../../components/customWidgets.dart';
import '../../components/signInWithGoogleAndFacebookButtons.dart';
import '../../utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorRegistration extends StatefulWidget {
  static const routeName = '/registring';
  @override
  State<VisitorRegistration> createState() => _VisitorRegistrationState();
}

class _VisitorRegistrationState extends State<VisitorRegistration> {
  final _visitorFormKey = GlobalKey<FormState>();
  //sign in vars
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? email;
  String? password;

  late String _password;

  double _strength = 0;

  RegExp numReg = RegExp(r".*[0-9].*");

  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String _displayText = 'كلمة المرور يجب أن تكون قوية ';

  String? errorMessage = 'مشكلة في الباس';

  bool LogInError=false;

  FocusNode toSetLabel = new FocusNode();
//to set label for password it creates a var to see where is the focus
  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'أدخل كلمة المرور';
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'كلمة المرور قصيرة جداً';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'كلمة المرور مقبولة ولكن ليست قوية';
      });
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 3 / 4;
          _displayText = 'كلمة المرور قوية';
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'كلمة مرورك ممتازة';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as Set; //to reach the arguments that will be passed to the constructor
    return Scaffold(
      resizeToAvoidBottomInset:
          true, //prevents keyboard from creating the error of overflowing
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: _visitorFormKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 65),
                  child: Text(
                    args.contains(0)
                        ? ' سجل كـ زائر '
                        : args.contains(1)
                            ? ' سجل كـ جهة منظمة'
                            : ' سجل كـ مشارك',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: conBlack,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GoogleAndFacebookButtons(
                userType: args.elementAt(0),
              ) //نبو نبعتو نوع المستخدم للودجت هذي باش يتم تسجيله في الفايرستور

              ,
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 55, right: 15),
                      child: new Divider(
                        color: conBlack.withOpacity(.6),
                        height: 4,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'أو',
                        style: TextStyle(
                            fontFamily: 'Cairo', fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 50),
                      child: new Divider(
                        color: conBlack.withOpacity(.6),
                        height: 4,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 290,
                height: 70,
                child: TextFormField(
                    style: TextStyle(
                        fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                    onChanged: (value) => email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البيانات المطلوبة';
                      }
                      return null;
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'أدخل البريد الإكتروني',
                        errorStyle: TextStyle(
                            fontFamily: 'Cairo', fontSize: 12, color: conRed),
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder: errorBorder,
                        focusedBorder: roundedPasswordFeild)),
              ),
              SizedBox(
                width: 290,
                height: 70,
                child: TextFormField(
                    style: TextStyle(
                        fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                    focusNode: toSetLabel,
                    onChanged: (value) {
                      _checkPassword(value);
                      password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البيانات المطلوبة';
                      } else if (_strength < 3 / 4) {
                        return 'الرجاء إدخال كلمة مرور أقوى';
                      }
                      return null;
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    obscureText: true,
                    decoration: InputDecoration(
                        label: toSetLabel.hasFocus
                            ? Text(
                                _displayText,
                                style: conTxtFeildHint,
                              )
                            : null,
                        labelStyle: conTxtFeildHint,
                        hintText: 'أدخل كلمة المرور',
                        errorStyle: TextStyle(
                            fontFamily: 'Cairo', fontSize: 12, color: conRed),
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: _strength <= 1 / 4
                                    ? Colors.red
                                    : _strength == 2 / 4
                                        ? Colors.yellow
                                        : _strength == 3 / 4
                                            ? Colors.blue
                                            : Colors.green),
                            borderRadius: BorderRadius.circular(25)))),
              ),Visibility(visible: LogInError,
                child: Text(
                  errorMessage.toString(),
                  textAlign: TextAlign.right,
                  style: conErorTxtStyle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CTA('تسجيل ', () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_visitorFormKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email.toString(),
                        password: password.toString()); //creating users
                    if (newUser != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                          'تم تسجيلك بنجاح ',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                        )),
                      );
                      if (args.contains(0)) {
                        //0 stands for visitors //if the argument that was passed to the screen is 0 that means its a visitorf
                        _firestore
                            .collection('visitors')
                            .add({'UserID': newUser.user?.uid});
                      } else if (args.contains(1)) {
                        //1 means user clicked on the Organizers card
                        _firestore
                            .collection('organizingAgen')
                            .add({'UserID': newUser.user?.uid});
                      } else if (args.contains(2)) {
                        //2 is for participants
                        _firestore
                            .collection('paticipants')
                            .add({'UserID': newUser.user?.uid});
                      }

                      Navigator.pushNamed(context, '/interests');
                    }
                  } on FirebaseAuthException catch (e) {
                    setState(() {

                      errorMessage= AuthExceptionHandler.generateErrorMessage(  AuthExceptionHandler.handleAuthException(e));
                      LogInError=!LogInError;

                    });


                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                            e.message.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            ),
                          )),
                    );
                    print('Failed with error code: ${e.code}');
                    print(e.message);
                  }
                }
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/log');
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 5, top: 5),
                          child: Text(
                            'قم بتسجيل دخول',
                            textAlign: TextAlign.right,
                            style: conTxtLink,
                          ))),
                  Container(
                      margin: EdgeInsets.only(right: 100, top: 10),
                      child: Text(
                        ' لديك حساب؟ ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: conBlack,
                          fontFamily: 'Cairo',
                          fontSize: 12,
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
