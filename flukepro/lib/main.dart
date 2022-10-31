import 'package:firebase_core/firebase_core.dart';
import 'package:flukepro/screens/dashboard/dashBoardLoginScreen.dart';
import 'package:flukepro/screens/loginScreen.dart';
import 'package:flukepro/screens/mainScreens/home.dart';
import 'package:flukepro/screens/onBoardingScreen.dart';
import 'package:flukepro/screens/regestrationScreens/intersetsScreen.dart';
import 'package:flukepro/screens/regestrationScreens/ORganizersRegestration.dart';
import 'package:flukepro/screens/regestrationScreens/visitorRegestrationScreen.dart';
import 'package:flukepro/screens/regestrationScreens/regestrationType.dart';

import 'package:flukepro/screens/resetPassScreen.dart';
import 'package:flukepro/screens/updatePasswordScreen.dart';
import 'dart:io';
import 'dashboard.dart';


import 'package:flutter/material.dart';
import 'package:flukepro/components/cons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(MyApp());
  runApp(DashBoard());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loginScreen(),
      debugShowCheckedModeBanner:
          false, //to remove debugging banner at the top of the screen

      routes: {
        '/log': ((context) => loginScreen()),


        VisitorRegistration.routeName: (context) =>
         VisitorRegistration(),
        '/reset':(context) => resetPass(),
    '/OrganizSign':((context) => organizersRegistrationScreen())
        ,'/UserType':((context) => regestrationTypeScreen()),
        '/interests':((context) => interestsSelection()),
        '/home':((context) => HomeScreen()),
        '/updatepass':((context) => updatePass()),

        VisitorRegistration.routeName: (context) => VisitorRegistration(),
        '/OrganizSign': ((context) => organizersRegistrationScreen()),
        '/UserType': ((context) => regestrationTypeScreen()),
        '/interests': ((context) => interestsSelection()),
        '/home': ((context) => HomeScreen())

      }, //routes are to ease the navigation btween pages
      //we give every page a name then when we want to navigate we just call that name
    );
  }
}

//---------------Dashboard
class DashBoard extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primaryColor: kprimaryColor,
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
      ),
      home: WelcomeScreen(),
    );
  }
}
