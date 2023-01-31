import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../utils/authentication.dart';

class settingScreen extends StatelessWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'الإعدادات',
                      style: conHeadingsStyle.copyWith(fontSize: 20),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: new Divider(
                    color: conBlack.withOpacity(.6),
                    height: 4,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'personalInfo');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text(
                          'معلومات شخصية',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w100),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: new Divider(
                    color: conBlack.withOpacity(.6),
                    height: 5,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          //save to drafts dialog
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              icon: Icon(
                                Icons.warning,
                                color: conRed,
                                size: 50,
                              ),
                              title: Text(
                                'سيتم إرسال رابط تغيير كلمة المرور لبريك الالكتروني، سيتم تسجيل خروجك و سيتطلب الامر إعادة تسجيل الدخول بكلمة المرور الجديدة',
                                textAlign: TextAlign.center,
                                style: conHeadingsStyle.copyWith(fontSize: 15),
                              ),
                              actions: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      ' تراجع ',
                                      textAlign: TextAlign.center,
                                      style: conHeadingsStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    )),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: conRed,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                      onTap: () async {
                                        var email = Provider.of<siggning>(
                                                context,
                                                listen: false)
                                            .loggedUser!
                                            .email
                                            .toString();
                                        FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: email)
                                            .whenComplete(() {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                              'تفقد بريدك وأعد تسجيل الدخول بكلمة المرور الجديدة',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                              ),
                                            )),
                                          );
                                          Navigator.pushNamed(context, '/log');
                                        });
                                      },
                                      child: Text(
                                        'إعادة تعيين كلمة مرور',
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
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 100),
                            );
                          });

                      //implement an ALERT dailog to to ask user if they are sure about changing thier password
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text(
                          'تغيير كلمة المرور ',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w100),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: new Divider(
                    color: conBlack.withOpacity(.6),
                    height: 4,
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Text(
                          'تسجيل خروج',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          await GoogleSignIn().signOut();
                          Navigator.pushNamed(context, '/log');
                          // await Authentication.signOut(context: context);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 0,
                        ),
                        child: new VerticalDivider(
                          color: conBlack.withOpacity(.6),
                          thickness: .5,
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'حذف الحساب',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: conRed),
                        ),
                        onTap: () async {
                          showDialog(
                              //save to drafts dialog
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'هل أنت متأكد من رغبتك في حذف الحساب؟ ',
                                    textAlign: TextAlign.center,
                                    style:
                                        conHeadingsStyle.copyWith(fontSize: 15),
                                  ),
                                  content: Text(
                                    'هذه الخطوة نهائية لا يمكن التارجع عنها وستحتاج لإعادة التسجيل مرة أخرى في حالة رغبتك في الدخول مرة أخرى',
                                    textAlign: TextAlign.center,
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  actions: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          ' إالغاء الحذف',
                                          textAlign: TextAlign.center,
                                          style: conHeadingsStyle.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: conRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: InkWell(
                                          onTap: () async {
                                            await Authentication().deleteUser();

                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                                context, '/log');
                                          },
                                          child: Text(
                                            'حدف الحساب',
                                            textAlign: TextAlign.center,
                                            style: conHeadingsStyle.copyWith(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                  buttonPadding: EdgeInsets.all(20),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 100),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
