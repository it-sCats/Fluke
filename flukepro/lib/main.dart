import 'package:firebase_core/firebase_core.dart';
import 'package:flukepro/dashboardScreens/mainDashboard.dart';
import 'package:flukepro/screens/loginScreen.dart';
import 'package:flukepro/screens/mainScreens/explorePage.dart';
import 'package:flukepro/screens/mainScreens/home.dart';
import 'package:flukepro/screens/mainScreens/notificationScreen.dart';
import 'package:flukepro/screens/mainScreens/profile.dart';
import 'package:flukepro/screens/mainScreens/userInfoScreen.dart';
import 'package:flukepro/screens/regestrationScreens/ORganizersRegestration.dart';
import 'package:flukepro/screens/regestrationScreens/intersetsScreen.dart';
import 'package:flukepro/screens/regestrationScreens/regestrationType.dart';
import 'package:flukepro/screens/regestrationScreens/visitorRegestrationScreen.dart';
import 'package:flukepro/screens/resetPassScreen.dart';
import 'package:flukepro/screens/sideScreens/settingsScreen.dart';
import 'package:flukepro/screens/updatePasswordScreen.dart';
import 'package:flukepro/utils/RoleRedicetion.dart';
import 'package:flutter/material.dart';
import 'package:flukepro/OrganizersRequests/OraginzersRequest.dart';
import 'base.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
  // runApp(MyApp());
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
        VisitorRegistration.routeName: (context) => VisitorRegistration(),
        '/reset': (context) => resetPass(),
        '/OrganizSign': ((context) => organizersRegistrationScreen()),
        '/UserType': ((context) => regestrationTypeScreen()),
        '/interests': ((context) => interestsSelection()),
        'base': ((context) => base()),
        '3': ((context) => HomeScreen()),
        '4': ((context) => ExploreScreen()),
        '1': ((context) => notifiScreen()),
        '0': ((context) => profile()),
        'settings': ((context) => settingScreen()),
        '/updatepass': ((context) => updatePass()),
        '/reset': (context) => resetPass(),
        '/requests': ((context) => OrgRequest()),
        'personalInfo': ((context) => userInfoScreen()),
        '/redirect': ((context) => recdirectRole()),
        'personalInfo': ((context) => userInfoScreen()),
      }, //routes are to ease the navigation btween pages
      //we give every page a name then when we want to navigate we just call that name
    );
  }
}
