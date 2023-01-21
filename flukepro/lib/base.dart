import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/screens/mainScreens/explorePage.dart';
import 'package:flukepro/screens/mainScreens/home.dart';
import 'package:flukepro/screens/mainScreens/notificationScreen.dart';
import 'package:flukepro/screens/mainScreens/profile.dart';
import 'package:flukepro/screens/mainScreens/visAndPartiProfile.dart';
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

  @override
  void initState() {
    super.initState();
    user != null
        ? Provider.of<siggning>(context, listen: false).getCurrentUsertype(
            Provider.of<siggning>(context, listen: false).loggedUser!.uid)
        : null; //  هذه تتغير بحسب البيانات اللي نبيها
    print('-----------${siggning().userType}');
    //here we called the provider so it settes the value of the ticket and likes num before going to profile screen
    Provider.of<siggning>(context, listen: false)
        .getUserTicketsEvents(FirebaseAuth.instance.currentUser!.uid);
    Provider.of<siggning>(context, listen: false)
        .getUserLikedEvents(FirebaseAuth.instance.currentUser!.uid);
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
              ? Provider.of<notificationPRovider>(context, listen: false)
                  .currentIndexOfNav!
              : widget.onNotificationTap!,
          unselectedItemColor: Color(0xffd3c8c7),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedFontSize: 12,
          onTap: (value) {
            setState(() {
              print(value);
              Provider.of<notificationPRovider>(context, listen: false)
                  .updatePage(value);
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
        child: Provider.of<notificationPRovider>(context, listen: false)
            .pageToDisplay(),
      ),
    );
  }
}
