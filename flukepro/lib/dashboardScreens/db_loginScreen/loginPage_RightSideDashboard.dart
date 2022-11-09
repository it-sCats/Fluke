import 'package:flutter/material.dart';

import '../../components/cons.dart';

class LoginPage_R_DB extends StatefulWidget {
  @override
  State<LoginPage_R_DB> createState() => _dbloginScreenState();
}

class _dbloginScreenState extends State<LoginPage_R_DB> {
  final _logFormKey = GlobalKey<FormState>();

  String? AdminUserName;
  String? Adminpassword;
  String? errorMessage;
  bool LogInError = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final _logFormKey = GlobalKey<FormState>();
    return Scaffold(
      body: Expanded(
        child: Form(
          key: _logFormKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(120.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مرحبا بك",
                    style: conHeadingsStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'تسجيل دخول ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: conBlack,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  const Text(
                    " .وجهتك لأفضل إدارة أحداث Fluke ",
                    style: TextStyle(fontSize: 12),
                  ),
                  //---------------------------------------------------------from here
                  SizedBox(
                    width: 290,
                    height: 70,
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                      onChanged: (value) => AdminUserName = value,
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
                        hintText: 'إسم المستخدم',
                        errorStyle: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: conRed,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder: errorBorder,
                        focusedBorder: roundedPasswordFeild,
                      ),
                    ),
                  ),
                  //---------------------------------------------------------till here
                  SizedBox(
                    width: 290,
                    height: 50,
                    child: TextFormField(
                        style: TextStyle(
                            fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                        onChanged: (value) => Adminpassword = value,
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
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: conRed),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 25),
                            hintStyle: conTxtFeildHint,
                            enabledBorder: roundedTxtFeild,
                            errorBorder: errorBorder,
                            focusedBorder: roundedPasswordFeild)),
                  ),
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
                ], //children
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
// SizedBox(
// height: 21,
// ),
// if (isLoading)
// CircularProgressIndicator()
// else
// CTA( txt: 'تسجيل دخول',isFullwidth:  true,onTap: () async {
// if (_logFormKey.currentState!.validate()) {
// setState(() {
// isLoading = true;
//
// });
