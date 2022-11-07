import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/utils/authentication.dart';
import 'package:flutter/material.dart ';
import 'package:multiple_result/multiple_result.dart';

import '../errorsHandling/AuthExceptionHandler.dart';


enum AuthMode { forgot, verify }//لإختصار الواجهات وتقليل الانتقالات حيكون في حالتين للصفحة هذي
//الاولى وهي نسيان كلمة المرور الي حيدخل فيها المستحدم الايميل والثانية الي حيطلعله حقل يدخل فيه الكود الي انبعتله
//باش يأكده
class updatePass extends StatefulWidget {
  @override
  State<updatePass> createState() => _updatePassState();
}

class _updatePassState extends State<updatePass> {
  final _resetFormKey = GlobalKey<FormState>();
final _auth=FirebaseAuth.instance;
  final TextEditingController _passController = TextEditingController();

  final TextEditingController _confirmPassController = TextEditingController();
  String? errorMessage;
  bool isErrored=false;
  bool _isLoading=false;


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
    as Set;
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
                          Text(    'أدخل كلمة المرور الجديدة '
                             ,

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
                        controller: _passController,
                        style: TextStyle(
                            fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                        onChanged: (value) {setState(() {
                          _passController.text = value;
                        });},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يجب أن تدخل كلمة المرور';
                          }
                          return null;
                        },
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'أدخل كلمة المرور' ,
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
               SizedBox(
                    width: 290,
                    height:80,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: _confirmPassController,
                            style: TextStyle(
                                fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                            onChanged: (value) {setState(() {
                              _confirmPassController.text = value;
               });},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يجب أن تعيد كتابة كلمة المرور';
                              }
                              return null;
                            },
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'أعد كتابة كلمة المرور ',
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
                        Visibility(visible: isErrored,child: Text(errorMessage.toString(),style: conErorTxtStyle.copyWith(fontSize: 11),))   ],
                    ),
                  ),
                  SizedBox(height: 20,),

                 _isLoading?CircularProgressIndicator(): CTA(txt: 'تأكيد',isFullwidth: true,onTap: () async {
                    if (_resetFormKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                              'تم تغيير كلمة المرور بنجاح..',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Cairo',
                              ),
                            )),
                      );

                    }
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
                      //
                      setState(() {
    _isLoading = true;
    });
    if(_passController.text == _confirmPassController.text)
    { final result=_auth.confirmPasswordReset(code: args.single,newPassword:  _passController.text);}
        else{ errorMessage='كلمة المرور غير متطابقة';}
    setState(() {
    _isLoading = false;
    });
    Navigator.pushNamed(context, '/home');


                    }  catch (e) {
                      setState(() {
                        errorMessage=
                           e.toString();
                        isErrored=!isErrored;
                      });

                    }
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
