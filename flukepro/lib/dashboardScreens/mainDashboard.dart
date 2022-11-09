import 'package:flutter/material.dart';

import 'db_loginScreen/loginDashboard.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Admin Pannel",
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const LoginDashboard(),
    );
  }
}
