import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/utils/authentication.dart';
import 'package:flutter/material.dart ';

import '../errorsHandling/AuthExceptionHandler.dart';

enum AuthMode {
  forgot,
  verify
} //لإختصار الواجهات وتقليل الانتقالات حيكون في حالتين للصفحة هذي

//الاولى وهي نسيان كلمة المرور الي حيدخل فيها المستحدم الايميل والثانية الي حيطلعله حقل يدخل فيه الكود الي انبعتله
//باش يأكده
class resetPass extends StatefulWidget {
  @override
  State<resetPass> createState() => _resetPassState();
}

class _resetPassState extends State<resetPass> {
  final _resetFormKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? resetEmail;
  AuthMode _authMode = AuthMode.forgot;
  final _authin = Authentication();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  EmailAuth emailAuth = new EmailAuth(sessionName: "Fluke");
  bool LogInError = false;
  bool submitValid = false;
  String? errorMessage;
  AuthStatus? _status;
  void sendOtp() async {
    try {
      _auth
          .sendPasswordResetEmail(email: _emailController.text)
          .whenComplete(() {
        Navigator.pushNamed(context, '/log');
      });
    } on FirebaseAuthException catch (e) {
      errorMessage = AuthExceptionHandler.generateErrorMessage(
          AuthExceptionHandler.handleAuthException(e));
      LogInError = !LogInError;
      print(e.message);
    }
    //sends the code to verify email
//Email Auth package
    // bool result =
    //     await emailAuth.sendOtp(recipientMail: _emailController.value.text);
    // if (result) {
    //   setState(() {
    //     submitValid = true;
    //   });
    // }
    //firebase Auth package
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.forgot) {
      setState(() {
        _authMode = AuthMode.verify;
      });
    } else {
      setState(() {
        _authMode = AuthMode.forgot;
      });
    }
  }

  //firebase auth
  Future<void> verify() async {
    await _auth
        .confirmPasswordReset(
            code: _otpController.text, newPassword: _emailController.text)
        .whenComplete(() {
      setState(() {
        submitValid = !submitValid;
      });
    });
  }
  //Email Auth package
  // bool verify() {
  //   return emailAuth.validateOtp(
  //       recipientMail: _emailController.value.text,
  //       userOtp: _otpController.value.text);
  // }

  @override
  Widget build(BuildContext context) {
    //to reach the arguments that will be passed to the constructor

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _resetFormKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 55.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'إعادة تعيين كلمة مرور',
                            textAlign: TextAlign.right,
                            style: conHeadingsStyle,
                          ),
                          Text(
                            '  أدخل بريدك الإلكيروني لنرسل لك إيميل\n إعادة تعيين كلمة مرور تفقد بريدك \nالإلكتروني',
                            textAlign: TextAlign.right,
                            style: conOnboardingText.copyWith(color: conBlack),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 290,
                    height: 70,
                    child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                            fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                        onChanged: (value) => resetEmail = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يجب أن تدخل البريد الالكتروني';
                          }
                          return null;
                        },
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'أدخل بريدك اللإلكتروني',
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: conRed),
                                borderRadius: BorderRadius.circular(25)),
                            errorStyle: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: conRed),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 25),
                            hintStyle: conTxtFeildHint,
                            enabledBorder: roundedTxtFeild,
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: conRed),
                                borderRadius: BorderRadius.circular(25)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: conBlack),
                                borderRadius: BorderRadius.circular(25)))),
                  ),
                  if (_authMode == AuthMode.verify)
                    SizedBox(
                      width: 290,
                      height: 80,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _otpController,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Cairo',
                                  color: conBlack),
                              onChanged: (value) => resetEmail = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يجب أن تدخل البريد الالكتروني';
                                }
                                return null;
                              },
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'أدخل رمز التأكيد ',
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 2, color: conRed),
                                      borderRadius: BorderRadius.circular(25)),
                                  errorStyle: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      color: conRed),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 25),
                                  hintStyle: conTxtFeildHint,
                                  enabledBorder: roundedTxtFeild,
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 2, color: conRed),
                                      borderRadius: BorderRadius.circular(25)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 1, color: conBlack),
                                      borderRadius:
                                          BorderRadius.circular(25)))),
                          Text(
                            'تفقد بريدك اللإلتروني لقد قمنا بإرسال رمز تأكيد',
                            style: conLittelTxt12,
                          )
                        ],
                      ),
                    )
                  else
                    Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: LogInError,
                    child: Text(
                      errorMessage.toString(),
                      textAlign: TextAlign.right,
                      style: conErorTxtStyle,
                    ),
                  ),
                  CTA(
                      txt: _authMode == AuthMode.verify
                          ? 'إرسال رمز تأكيد'
                          : 'تأكيد',
                      isFullwidth: true,
                      onTap: () async {
                        if (_resetFormKey.currentState!.validate()) {
                          try {
                            //this commented code calls reset pass function which sends an email to rest password
                            //the problem is you can't reset password in the application in that way, a batter way is throw
                            //EmailAuth package
                            //  _status = await _authin.resetPassword(
                            //     email: _emailController.text.trim());
                            // print(_status);
                            // if (_status == AuthStatus.successful) {
                            //   Navigator.pushNamed(context, '/log');
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         content: Text(
                            //           'تفقد بريدك وأعد تسجيل الدخول بكلمة المرور الجديدة',
                            //           style: TextStyle(
                            //             fontSize: 12,
                            //             fontFamily: 'Cairo',
                            //           ),
                            //         )),
                            //   );
                            // }
                            //}

                            if (_authMode == AuthMode.forgot) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                  'جاري إرسال التأكيد..',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cairo',
                                  ),
                                )),
                              );

                              sendOtp();
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              errorMessage =
                                  AuthExceptionHandler.generateErrorMessage(
                                      _status);
                              LogInError = !LogInError;
                            });
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
