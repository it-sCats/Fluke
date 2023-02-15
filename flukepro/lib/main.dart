import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flukepro/screens/OrganizersScreens/Notifications.dart';
import 'package:flukepro/screens/OrganizersScreens/ODashboard.dart';
import 'package:flukepro/screens/OrganizersScreens/Oprofile.dart';
import 'package:flukepro/screens/OrganizersScreens/OsearchScreen.dart';
import 'package:flukepro/screens/OrganizersScreens/Sections/timeTableScreen.dart';
import 'package:flukepro/screens/mainScreens/AdminScreens/dashboard_screen.dart';
// import 'package:flukepro/screens/mainScreens/AdminScreens/displayDataPrev.dart';
import 'package:flukepro/screens/mainScreens/AdminScreens/loadData.dart';
import 'package:flukepro/screens/mainScreens/AdminScreens/main_screen.dart';
import 'package:flukepro/screens/mainScreens/AdminScreens/testForReport.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flukepro/utils/eventProvider.dart';
import 'package:flukepro/utils/fireStoreQueries.dart';
import 'package:flukepro/utils/getAccessToken.dart';
import 'package:flukepro/utils/notificationProvider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'components/eventEdit.dart';
import 'components/formsAndDisplays/comments.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/mainScreens/AdminScreens/ahome.dart';

final user = FirebaseAuth.instance.currentUser;
final _firestore = FirebaseFirestore.instance;
GlobalKey<NavigatorState>? navigatorKey;

// getuserinMAin() async {
//   final userInfo = await _firestore.collection('users').doc(user!.uid).get();
//
//   final userInfoDoc = userInfo.data();
//   mainUserType = userInfoDoc!['userType'];
//   print('the user type inside functoin');
//   print(userInfoDoc!['userType']);
// }

Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      //this settings for handling the notifications when the app is in the foreground
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true);
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          'high_importance_channel', 'high_importance_channel',
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.max,
          playSound: false);
  NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: DarwinNotificationDetails());
  var flutterLocalNotificationsPlugin;
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
      message.notification!.body, notificationDetails,
      payload: message.data['body']);
  if (message != null) {
    navigatorKey?.currentState!.push(MaterialPageRoute(
      builder: (context) => base(
        onNotificationTap: 1,
      ),
    ));
  }
}

// handlingBackground(message) {
//   navigatorKey?.currentState!.push(MaterialPageRoute(
//     builder: (context) => base(
//       onNotificationTap: 1,
//     ),
//   ));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // getAccessToken();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );
  // await FirebaseMessaging.instance.getInitialMessage();
  notificationPRovider().requiesPremission();

  // setUpBackgroundInteraction();
  navigatorKey = GlobalKey(debugLabel: "base");
  await getOngoing();

  runApp(MyApp());
  // runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user != null ? siggning().setupToken() : null;
    user != null
        ? siggning().getCurrentUsertype(siggning().loggedUser!.uid)
        : null;
    // getuserinMAin();

    //
    // notificationPRovider().initInfo(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => siggning()),
        ChangeNotifierProvider(
          create: (context) => notificationPRovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => eventInfoHolder(),
        ) //كيف حطيت البروفايدر وماخدمتاش
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        builder: (context, child) => ResponsiveWrapper.builder(child,
            maxWidth: 2000,
            minWidth: 1000,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Color(0xFFF5F5F5))),

        //  home: Ahome(),
        // home: Ahome(),
        home: recdirectRole(),

        debugShowCheckedModeBanner:
            false, //to remove debugging banner at the top of the screen
//todo جيبي الهاندل متاع النوتيفيكسشن للماين بحيث يفتحله طول وابعتي الارقيومنت الي يفتح صفحة الفونتيفيكشن لما نفتحو النوتيفيكيشن
        routes: {
          'log': ((context) => loginScreen()),
          VisitorRegistration.routeName: (context) => VisitorRegistration(),
          '/reset': (context) => resetPass(),
          '/OrganizSign': ((context) => organizersRegistrationScreen()),
          '/UserType': ((context) => regestrationTypeScreen()),
          '/interests': ((context) => interestsSelection()),
          'base': ((context) => base()),
          '3': ((context) => HomeScreen()),
          '4': ((context) => ExploreScreen()),
          '1': ((context) => notifiScreen()),
          // '0': ((context) => profile()),
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
          '/Osearch': ((context) => OsearchScreen()),
          '/Onotification': ((context) => OnotifiScreen()),
          '/Oprofile': ((context) => Oprofile()),
          'editEvent': ((context) => editEvent()),
          'timeTable': ((context) => timeTable()),
          '/Oprofile': ((context) => Oprofile()),
          '/Adash': ((context) => Ahome()),
          '/testReport': ((context) => display()),

          //routes of Admin Screens
        }, //routes are to ease the navigation btween pages
        //we give every page a name then when we want to navigate we just call that name
      ),
    );
  }
}
