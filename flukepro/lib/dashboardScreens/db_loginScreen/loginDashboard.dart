import 'package:flukepro/dashboardScreens/db_loginScreen/loginPage_LeftSideDashboard.dart';
import 'package:flutter/material.dart';

import 'loginPage_RightSideDashboard.dart';

class LoginDashboard extends StatelessWidget {
  LoginDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 640,
            width: 1080,
            margin: EdgeInsets.symmetric(horizontal: 24),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.blue,
            ),
            child: Row(
              children: [
                LoginPage_R_DB(),
                if (MediaQuery.of(context).size.width > 900)
                  const LoginPage_L_DB(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
