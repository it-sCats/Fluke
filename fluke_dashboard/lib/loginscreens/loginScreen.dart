import 'package:flutter/material.dart';

import 'leftLoginScreen.dart';
import 'rightLoginScreen.dart';

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 640,
            width: 1080,
            margin: EdgeInsets.symmetric(horizontal: 24),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Color.fromARGB(255, 245, 167, 114),
            ),
            child: Row(
              children: [
                Rghit_LoginScreen(),
                if (MediaQuery.of(context).size.width > 900)
                  const Left_LoginScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
