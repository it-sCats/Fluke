import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/screens/mainScreens/explorePage.dart';
import 'package:flukepro/screens/mainScreens/home.dart';
import 'package:flukepro/screens/mainScreens/notificationScreen.dart';
import 'package:flukepro/screens/mainScreens/profile.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flukepro/utils/notificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/cons.dart';

final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

class base extends StatefulWidget {
  base({this.onNotificationTap});
  final int? onNotificationTap;
  @override
  State<base> createState() => _baseState();
}

class _baseState extends State<base> {
  SharedPreferences? _selectedPage;
  int? currentIndexOfNav =
      base().onNotificationTap == null ? 3 : base().onNotificationTap;
  int? pageIndex =
      base().onNotificationTap == null ? 3 : base().onNotificationTap;
  static List<Widget> _pages = [
    profile(),
    notifiScreen(),
    ExploreScreen(),
    HomeScreen(),
  ];

  @override
  void initState() {
    super.initState();
    user != null
        ? Provider.of<siggning>(context, listen: false).getCurrentUsertype(
            Provider.of<siggning>(context, listen: false).loggedUser!.uid)
        : null; //  هذه تتغير بحسب البيانات اللي نبيها
    print('-----------${siggning().userType}');
    notificationPRovider().initInfo(context);
    print(widget.onNotificationTap);
    print('the base argument');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          //as type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFfcfcfc),
          selectedItemColor: conBlue,
          currentIndex: widget.onNotificationTap == null
              ? currentIndexOfNav!
              : widget.onNotificationTap!,
          unselectedItemColor: Color(0xffd3c8c7),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedFontSize: 12,
          onTap: (value) {
            setState(() {
              print(value);
              currentIndexOfNav = value;
              pageIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: 'الملف الشخصي',
              icon: Icon(Icons.person),
            ),
            BottomNavigationBarItem(
                label: 'إشعارات', icon: Icon(Icons.notifications)),
            BottomNavigationBarItem(
                label: 'اكتشف أحداث', icon: Icon(Icons.search)),
            BottomNavigationBarItem(
              label: 'الرئيسية',
              icon: Icon(Icons.home),
            ),
          ],
        ),
      ),
      body: Center(
        child: _pages.elementAt(pageIndex!),
      ),
    );
  }
}
