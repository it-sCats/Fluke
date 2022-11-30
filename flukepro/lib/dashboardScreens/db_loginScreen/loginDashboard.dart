import 'package:flukepro/dashboardScreens/db_loginScreen/loginPage_LeftSideDashboard.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD:fluke_dashboard/lib/loginscreens/loginScreen.dart
class LogInScreen extends StatelessWidget {
=======
import 'loginPage_RightSideDashboard.dart';

class LoginDashboard extends StatelessWidget {
  LoginDashboard({Key? key}) : super(key: key);

>>>>>>> parent of 02f419b (Merge branch 'main' of https://github.com/it-sCats/Fluke):flukepro/lib/dashboardScreens/db_loginScreen/loginDashboard.dart
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
<<<<<<< HEAD:fluke_dashboard/lib/loginscreens/loginScreen.dart
            //  child: Row(
            //   children: [
            //     const LoginPageLeftSide(),
            //     if (MediaQuery.of(context).size.width > 900)
            //       const LoginPageRightSide(),
            //   ],
            // ),
=======
            child: Row(
              children: [
                LoginPage_R_DB(),
                if (MediaQuery.of(context).size.width > 900)
                  const LoginPage_L_DB(),
              ],
            ),
>>>>>>> parent of 02f419b (Merge branch 'main' of https://github.com/it-sCats/Fluke):flukepro/lib/dashboardScreens/db_loginScreen/loginDashboard.dart
          ),
        ),
      ),
    );
  }
}
