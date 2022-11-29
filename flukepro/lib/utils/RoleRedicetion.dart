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
    String? _userType; //هنا سنضع نوع المستخدم سواء كان زائر أو مشارك أو منظم
    final _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot? snap;
    SharedPreferences userTypeShared =
        await SharedPreferences //عند تسجيل المستخدم يتم حفظ نوعه في قاعدة البيانات المحلية هذه
            .getInstance(); //for now im using shared preferences but we'll change it

    _userType = userTypeShared?.getString("userType");
    if (_userType == '0') {
      //هنا يتم طلب بيانات المستخدم المسجل لنصل للدور الخاص به
      snap = await _firestore
          .collection('users')
          .doc('visitors')
          .collection('visitor')
          .doc(user!.uid)
          .get();
    } else if (_userType == '2') {
      snap = await _firestore
          .collection('users')
          .doc('paticipants')
          .collection('paticipant')
          .doc(user!.uid)
          .get();
    } else if (_userType == '1') {
      snap = await _firestore
          .collection('users')
          .doc('organizingAgens')
          .collection('organizingAgen')
          .doc(user?.uid)
          .get();
    } else {
      snap = await _firestore
          .collection('users')
          .doc('visitors')
          .collection('visitor')
          .doc(user!.uid)
          .get();
    }
    setState(() {
      role = 'user';
      // snap![
      //     'role']; //هنا نقوم بإسناد قيمة الحقل للمتغير الذي قمنا بإنشاءه في البداية
    });
    if (role == 'user') {
      //المستخدم العادي يتم توجيهه للصفحة الرئيسية
      NavigateNext('/home'); //دالة تقوم تأخذ إسم الروت وتنقل المستخد له

    } else if (role == 'admin') {
      //والأدمن يتم توجييه للداشبورد
      NavigateNext('/dashboard');
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
