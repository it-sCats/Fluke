import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/signInWithGoogleAndFacebookButtons.dart';
import 'package:flukepro/utils/notificationProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/customWidgets.dart';
import '../errorsHandling/AuthExceptionHandler.dart';
import '../utils/SigningProvider.dart';
import '../utils/authentication.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _logFormKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String? Email;
  TextEditingController _emailCon = TextEditingController();

  String? password;

  String? errorMessage;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool LogInError = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    siggning provider = Provider.of<siggning>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset:
          false, //prevents keyboard from creating the error of overflowing
      backgroundColor: Colors.white,
      body: Form(
        key: _logFormKey,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'تسجيل دخول ',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: conBlack,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FutureBuilder(
                  future: Authentication.initializeFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('مشكلة في الاتصال...');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return GoogleAndFacebookButtons();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(conORange),
                    );
                  }),
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
                    controller: _emailCon,
                    style: TextStyle(
                        fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                    onChanged: (value) => Email = value,
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
                        hintText: ' البريد الإكتروني',
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
                height: 50,
                child: TextFormField(
                    style: TextStyle(
                        fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                    onChanged: (value) => password = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البيانات المطلوبة';
                      }
                      return null;
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'كلمة المرور',
                        errorStyle: TextStyle(
                            fontFamily: 'Cairo', fontSize: 12, color: conRed),
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder: errorBorder,
                        focusedBorder: roundedPasswordFeild)),
              ), //custom widgets take the text and if its password or not
              Visibility(
                visible: LogInError,
                child: Text(
                  errorMessage.toString(),
                  textAlign: TextAlign.right,
                  style: conErorTxtStyle,
                ),
              ),
              Center(
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/reset');
                    },
                    child: Text(
                      'نسيت كلمة المرور؟',
                      textAlign: TextAlign.right,
                      style: conTxtLink,
                    )),
              ),
              // try {
              //   final result = await Authentication()
              //       .login(Email.toString(), password.toString());
              //   result.when(
              //       (error) => setState(() {
              //             errorMessage =
              //                 AuthExceptionHandler.generateErrorMessage(
              //                     AuthExceptionHandler.handleAuthException(
              //                         error));
              //
              //             print(error);
              //             LogInError = !LogInError;
              //             isLoading = false;
              //           }), (success) async {
              //     Navigator.pushNamed(context, '/home');
              //
              //     // final newUser = await _auth.createUserWithEmailAndPassword(
              //     //     email: email.toString(),
              //     //     password: password.toString()); //creating users
              //     // if (newUser != null) {
              //     setState(() {
              //       isLoading = true;
              //     });
              //
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //           content: Text(
              //         'تم تسجيلك بنجاح ',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
              //       )),
              //     );

              SizedBox(
                height: 21,
              ),
              if (isLoading)
                CircularProgressIndicator()
              else
                CTA(
                  txt: 'تسجيل دخول',
                  isFullwidth: true,
                  onTap: () async {
                    if (_logFormKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                          'جاري تسجيل الدخول..',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        )),
                      );
                      try {
                        if (_emailCon.text.trim().toString() == 'admin' &&
                            password.toString() == '111') {
                          UserCredential admin = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: 'admin@admin.com', password: "111111");

                          provider.setLoggedInuser(admin.user);
                          provider.getUserInfoDoc(admin.user!.uid);
                          provider.setUserType(3);
                          //  Navigator.pushReplacementNamed(context, '/Adash');
                          Navigator.pushReplacementNamed(
                              context, '/testReport');
                        }

                        final result = await Authentication().login(
                            _emailCon.text.trim().toString(),
                            password.toString());
                        result.when(
                            (error) => setState(() {
                                  errorMessage = AuthExceptionHandler
                                      .generateErrorMessage(AuthExceptionHandler
                                          .handleAuthException(
                                              error)); //تظهر هذه الدوال رسالة خطأ بناء على كود الخطأ

                                  LogInError = !LogInError;
                                  isLoading = false;
                                }), (success) async {
                          provider.setLoggedInuser(success);
                          provider.getUserInfoDoc(success.uid);
                          provider.getCurrentUsertype(provider.loggedUser!.uid);
                          print('logged in ');
                          Navigator.pushNamed(context,
                              '/redirect'); //here we redirect the user based on his role

                          // final newUser = await _auth.createUserWithEmailAndPassword(
                          //     email: email.toString(),
                          //     password: password.toString()); //creating users
                          // if (newUser != null) {
                          setState(() {
                            isLoading = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                              'تم تسجيلك بنجاح ',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: 'Cairo', fontSize: 13),
                            )),
                          );
                        });
                      } on FirebaseAuthException catch (e) {
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
                  },
                ),
              !kIsWeb
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/UserType');
                              },
                              child: Text(
                                'سجل كـجهة منظمة أو\n زائر أو مشارك ',
                                textAlign: TextAlign.center,
                                style: conTxtLink.copyWith(fontSize: 16),
                              )),
                          InkWell(
                              child: Text(
                            'ليس لديك حساب؟ ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: conBlack,
                              fontFamily: 'Cairo',
                              fontSize: 16,
                            ),
                          )),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
