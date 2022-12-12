import 'package:flukepro/screens/mainScreens/explorePage.dart';
import 'package:flukepro/screens/mainScreens/home.dart';
import 'package:flukepro/screens/mainScreens/notificationScreen.dart';
import 'package:flukepro/screens/mainScreens/profile.dart';
import 'package:flutter/material.dart';
import 'components/bottomNav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/cons.dart';

class base extends StatefulWidget {
  @override
  State<base> createState() => _baseState();
}

class _baseState extends State<base> {
  SharedPreferences? _selectedPage;
  int currentIndexOfNav = 2;
  static List<Widget> _pages = [
    profile(),
    notifiScreen(),
    ExploreScreen(),
    HomeScreen(),
  ];
  int? pageIndex = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          currentIndex: currentIndexOfNav,
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
