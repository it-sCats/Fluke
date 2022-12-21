import 'package:firebase_core/firebase_core.dart';
import 'package:flukepro/screens/OrganizersScreens/Notifications.dart';
import 'package:flukepro/screens/OrganizersScreens/ODashboard.dart';
import 'package:flukepro/screens/OrganizersScreens/Oevents.dart';
import 'package:flukepro/screens/OrganizersScreens/Oprofile.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flukepro/utils/fireStoreQueries.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flukepro/screens/OrganizersScreens/OHome.dart';
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
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  await getOngoing();
  runApp(MyApp());
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider( providers: [

      ChangeNotifierProvider(create: (context) => siggning())//كيف حطيت البروفايدر وماخدمتاش
    ],
      child: MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(child,
            maxWidth: 3000,
            minWidth: 1000,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Color(0xFFF5F5F5))),

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
          //routes of Organizers Screens
          'OHome': ((context) => Ohome()),
          '/Odash': ((context) => Odashboard()),
          '/Oevent': ((context) => Oevents()),
          '/Onotification': ((context) => notifaction()),
          '/Oprofile': ((context) => Oprofile())
        }, //routes are to ease the navigation btween pages
        //we give every page a name then when we want to navigate we just call that name
      ),
    );
  }
}
