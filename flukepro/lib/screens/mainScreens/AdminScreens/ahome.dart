import 'package:flukepro/screens/mainScreens/AdminScreens/main_screen.dart';
import 'package:flutter/material.dart';

import '../../../components/cons.dart';

class Ahome extends StatefulWidget {
  const Ahome({super.key});

  @override
  State<Ahome> createState() => _AhomeState();
}

class _AhomeState extends State<Ahome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: primaryColor,
        canvasColor: conBlue,
      ),
      home: MainScreen(),
    );
  }
}
