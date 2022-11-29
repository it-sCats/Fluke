import 'package:flutter/material.dart';

import 'loginscreens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Pannel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LogInScreen(),
    );
  }
}
