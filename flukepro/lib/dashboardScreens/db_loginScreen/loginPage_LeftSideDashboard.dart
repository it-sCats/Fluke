import 'package:flutter/material.dart';

class LoginPage_L_DB extends StatelessWidget {
  const LoginPage_L_DB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('image/Eventmanaging.png'),
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
