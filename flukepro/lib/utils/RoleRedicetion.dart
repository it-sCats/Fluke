import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _checkRole(); //الدالة الي اتدير تشك على الرول الخاص بالمستخدم يتم إستعدعاءها خلال عملية انشاء الصفحة بحيث يتم إعادة التوجيه مباشرة
  }

  void _checkRole() async {
    final _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap;
    snap = await _firestore.collection('users').doc(user!.uid).get();

    if (snap!['userType'] == 1) {
      Navigator.pushNamed(context, 'OHome');
    } else {
      Navigator.pushNamed(context, '3');
    }
  }

  void NavigateNext(String RouteName) {
    //دالة الانتقال
    Timer(Duration(milliseconds: 500), () {
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
