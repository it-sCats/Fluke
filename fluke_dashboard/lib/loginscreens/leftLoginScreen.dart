import 'package:flutter/material.dart';

class Left_LoginScreen extends StatelessWidget {
  const Left_LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/Eventmanaging.png'),
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
