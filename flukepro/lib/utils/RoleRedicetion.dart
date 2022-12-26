import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base.dart';
import '../screens/OrganizersScreens/OHome.dart';
import '../screens/loginScreen.dart';
import 'SigningProvider.dart';

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

    print('initiating redirict');

    _checkRole(); //الدالة الي اتدير تشك على الرول الخاص بالمستخدم يتم إستعدعاءها خلال عملية انشاء الصفحة بحيث يتم إعادة التوجيه مباشرة
  }

  void _checkRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      int userT = await Provider.of<siggning>(context, listen: false)
          .getCurrentUsertype();
      print('from role redirection');
      print(userT);
      user == null
          ? NavigateNext('log')
          : userT == 0 || userT == 2
              ? NavigateNext('base')
              : userT == 1
                  ? {
                      await FirebaseMessaging.instance
                          .subscribeToTopic('Organizers'),
                      NavigateNext('OHome')
                    }
                  : NavigateNext('/log');
    } else
      NavigateNext('/log');
  }

  void NavigateNext(String RouteName) {
    print('navigating>>>>');
    //دالة الانتقال
    Timer(Duration(milliseconds: 200), () {
      //بعد مدة 500 ملي ثانية يتم الانتقال للصفحة المطلوبة
      Navigator.pushNamed(context, RouteName);
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
