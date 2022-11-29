import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../OrganizersRequests/requestsList.dart';
import '../../utils/authentication.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      User LoggedinUser;
      if (user != null) {
        LoggedinUser = user;
        print(LoggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 500,
                  child: requestsList()), //هنا يتم عرض قائمة الطلبات قابلة
              Text('lo'),
              CTA(
                  txt: 'sign out',
                  isFullwidth: false,
                  onTap: () async {
                    await Authentication.signOut(context: context);
                  }),
              CTA(
                  txt: 'delete user',
                  isFullwidth: false,
                  onTap: () async {
                    await Authentication().deleteUser();
                  }),
              CTA(
                  txt: ' user info',
                  isFullwidth: false,
                  onTap: () async {
                    Navigator.pushNamed(context, 'personalInfo');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
