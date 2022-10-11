import 'package:flutter/material.dart';

class onBoarding extends StatelessWidget {
  const onBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SafeArea(
          child: Text(
        'SHit',
        style: TextStyle(color: Colors.blueAccent, fontSize: 50),
      )),
    );
  }
}
