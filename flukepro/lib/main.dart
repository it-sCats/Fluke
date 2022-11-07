import 'package:firebase_core/firebase_core.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/screens/dashboardscreens/adminWelcomeScreen.dart';
import 'package:flukepro/screens/loginScreen.dart';
import 'package:flukepro/screens/mainScreens/home.dart';


import 'package:flukepro/screens/mainScreens/userInfoScreen.dart';

import 'package:flukepro/screens/regestrationScreens/intersetsScreen.dart';

import 'package:flukepro/screens/regestrationScreens/ORganizersRegestration.dart';

import 'package:flukepro/screens/regestrationScreens/regestrationType.dart';
import 'package:flukepro/screens/regestrationScreens/visitorRegestrationScreen.dart';
import 'package:flukepro/screens/resetPassScreen.dart';
import 'package:flukepro/screens/updatePasswordScreen.dart';

import 'package:flutter/material.dart';




import 'package:flutter/material.dart';
import 'package:flukepro/components/cons.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(   options:    DefaultFirebaseOptions.currentPlatform,);
  // runApp(MyApp());
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home:DashBoard(),
      debugShowCheckedModeBanner:
          false, //to remove debugging banner at the top of the screen

      routes: {
        '/log': ((context) => loginScreen()),

        VisitorRegistration.routeName: (context) => VisitorRegistration(),
        '/reset': (context) => resetPass(),
        '/OrganizSign': ((context) => organizersRegistrationScreen()),
        '/UserType': ((context) => regestrationTypeScreen()),
        '/interests': ((context) => interestsSelection()),
        '/home': ((context) => HomeScreen()),
        '/updatepass': ((context) => updatePass()),




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

        '/home': ((context) => HomeScreen()),

        '/home': ((context) => HomeScreen()),
        'personalInfo':((context) => userInfoScreen())


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
        scaffoldBackgroundColor: Colors.white,
      ),
      home: welcomescreen(),
    );
  }
}
