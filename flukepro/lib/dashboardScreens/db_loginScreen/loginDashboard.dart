import 'package:flukepro/dashboardScreens/db_loginScreen/loginPage_LeftSideDashboard.dart';

import 'package:flutter/material.dart';

<<<<<<< HEAD:flukepro/lib/dashboardScreens/db_loginScreen/loginDashboard.dart
import 'loginPage_RightSideDashboard.dart';

class LoginDashboard extends StatelessWidget {
  LoginDashboard({Key? key}) : super(key: key);

=======
import 'leftLoginScreen.dart';
import 'rightLoginScreen.dart';

class LogInScreen extends StatelessWidget {
>>>>>>> parent of f4aadef (Revert "."):fluke_dashboard/lib/loginscreens/loginScreen.dart
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
<<<<<<< HEAD:flukepro/lib/dashboardScreens/db_loginScreen/loginDashboard.dart
            //  child: Row(
            //   children: [
            //     const LoginPageLeftSide(),
            //     if (MediaQuery.of(context).size.width > 900)
            //       const LoginPageRightSide(),
            //   ],
            //
            child: Row(
              children: [
                LoginPage_R_DB(),
                if (MediaQuery.of(context).size.width > 900) LoginPage_L_DB(),
=======
            child: Row(
              children: [
                Rghit_LoginScreen(),
                if (MediaQuery.of(context).size.width > 900)
                  const Left_LoginScreen(),
>>>>>>> parent of f4aadef (Revert "."):fluke_dashboard/lib/loginscreens/loginScreen.dart
              ],
            ),
          ),
        ),
      ),
    );
  }
}
