import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../base.dart';
import '../screens/OrganizersScreens/OHome.dart';
import '../screens/loginScreen.dart';
import 'SigningProvider.dart';
import 'notificationProvider.dart';

final _firestore = FirebaseFirestore.instance;

//الصفحة هذه لإعادة توجيه المستخدم حسب صلاحياته
class recdirectRole extends StatefulWidget {
  @override
  State<recdirectRole> createState() => _recdirectRoleState();
}

class _recdirectRoleState extends State<recdirectRole> {
  String role = 'user';
  @override
  void initState() {
    super.initState();

    checkRole(); //الدالة الي اتدير تشك على الرول الخاص بالمستخدم يتم إستعدعاءها خلال عملية انشاء الصفحة بحيث يتم إعادة التوجيه مباشرة
  }

  void checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Provider.of<siggning>(context, listen: false).getUserInfoDoc(user.uid);
      //
      // int userT = await Provider.of<siggning>(context, listen: false)
      //     .getCurrentUsertype();
      DocumentSnapshot<Map<String, dynamic>> userInfo =
          await _firestore.collection('users').doc(user!.uid).get();

      Map<String, dynamic>? userInfoDoc = userInfo.data();
      int userT = userInfoDoc!['userType'];

      user == null
          ? NavigateNext('log')
          : userT == 0 || userT == 2
              ? NavigateNext('base')
              : userT == 1
                  ? {
                      if (!kIsWeb)
                        await FirebaseMessaging.instance
                            .subscribeToTopic('Organizers'),
                      NavigateNext('OHome')
                    }
                  : userT == 3
                      ? NavigateNext('/testReport')
                      : NavigateNext('/log');
    } else
      NavigateNext('/log');
  }

  void NavigateNext(String RouteName) {
    //دالة الانتقال
    Timer(Duration(milliseconds: 20), () {
      //بعد مدة 500 ملي ثانية يتم الانتقال للصفحة المطلوبة
      Navigator.pushReplacementNamed(context, RouteName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), //يتم عرض دائرة تحميل في مدة التوجيه
      ),
    );
  }
}
