import 'package:flukepro/components/cons.dart';
import 'package:flukepro/screens/mainScreens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mainScreens/profile.dart';
import 'Notifications.dart';
import 'ODashboard.dart';
import 'Oevents.dart';
import 'Oprofile.dart';

final _auth = FirebaseAuth.instance;

//صفحة الهوم متاع المنظم
class Ohome extends StatefulWidget {
  const Ohome({Key? key}) : super(key: key);

  @override
  State<Ohome> createState() => _OhomeState();
}

class _OhomeState extends State<Ohome> with SingleTickerProviderStateMixin {
  SharedPreferences? _selectedPage;
  int currentIndexOfNav = 2;
  static List<Widget> _pages = [
    //هنا نتحكمو بالويدجيتس الي حينعرضو
    Odashboard(), //لوحة التحكم
    Oevents(), //الاحداث التي نظمها المنظم
    notifaction(), //الاشعارات
    Oprofile() //الملف الشخصي متاعه
  ];
  int? pageIndex = 2; //متغير نغيرو بيه الويدجيتس

  bool isCollapsed = defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform ==
              TargetPlatform
                  .macOS //هنا الشرط حيتحكم بإن النافيقيشن سايد بار يقعد مفتوح في حال كنا فاتحينه علة ويندوز ولا ماك
      ? false
      : true;
  double? screenWidth, ScreenHeigth;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.8,
    ).animate(_controller!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    ScreenHeigth = size.height;
    return Scaffold(
      backgroundColor: conBlue,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [menu(context), Dashboard(context)],
        ),
      ),
    );
  }

  Widget menu(context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      //Avatar
                      backgroundColor: Color(0xff).withOpacity(0),
                      radius: 50,
                      child: Image.asset(
                        'images/avatar.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            // _auth.currentUser != null
                            //     ? _auth.currentUser!.email
                            //         .toString()
                            //         .split('@')
                            //         .first
                            //     :
                            'You',
                            style: conHeadingsStyle.copyWith(
                                fontSize: 16, color: Colors.white)),
                        SizedBox(width: 10),
                      ],
                    ),
                    Text(
                      //Email
                      // _auth.currentUser!.email.toString(),
                      'email',
                      style: conHeadingsStyle.copyWith(
                          fontSize: 14, color: Colors.white.withOpacity(0.8)),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 90,
          ),
          menuNavs(Icons.dashboard, 'لوحة التحكم', () {
            setState(() {
              pageIndex = 0; //لتغيير الويدجيتس
            });
          }, '/Odash', context),
          menuNavs(Icons.event, 'أحداثك', () {
            setState(() {
              pageIndex = 1;
            });
          }, '/Oevent', context),
          menuNavs(Icons.notifications, 'إشعارات ', () {
            setState(() {
              pageIndex = 2;
            });
          }, '/Onotification', context),
          menuNavs(Icons.person, 'الملف شخصي ', () {
            setState(() {
              pageIndex = 3;
            });
          }, '/Oprofile', context),
          SizedBox(
            height: 220,
          ),
          Row(
            children: [
              SizedBox(
                width: 40,
              ),
              IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.white,
                  onPressed: () {}),
              Text(
                '|',
                style: conOnboardingText,
              ),
              IconButton(
                  icon: Icon(Icons.logout_rounded),
                  color: Colors.white,
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, '/task');
                  })
            ],
          )
        ],
      ),
    );
  }

  Widget menuNavs(IconData icon, String text, Function callback,
      String currentPath, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0, top: 30),
      child: InkWell(
          onTap: () => callback(),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: ModalRoute.of(context)!.settings.name == currentPath
                    ? Colors.white
                    : Colors.white.withOpacity(.5),
              ),
              SizedBox(width: 30),
              Text(
                text,
                style: conHeadingsStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ModalRoute.of(context)!.settings.name == currentPath
                        ? Colors.white
                        : Colors.white.withOpacity(.5)),
              )
            ],
          )),
    );
  }

  Widget Dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.2 * screenWidth!,
      right: isCollapsed ? 0 : 0 * screenWidth!,
      child: ScaleTransition(
        scale: _scaleAnimation!,
        child: SafeArea(
          child: GestureDetector(
            onHorizontalDragEnd: (value) {
              defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS
                  ? setState(() {
                      isCollapsed
                          ? _controller!.forward()
                          : _controller!.reverse();
                      isCollapsed = !isCollapsed;
                    })
                  : null;
            },
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        defaultTargetPlatform == TargetPlatform.android ||
                                defaultTargetPlatform == TargetPlatform.iOS
                            ? IconButton(
                                padding: EdgeInsets.only(left: 0),
                                icon: Icon(Icons.menu_rounded),
                                color: Colors.white,
                                iconSize: 35,
                                onPressed: () {
                                  setState(() {
                                    isCollapsed
                                        ? _controller!.forward()
                                        : _controller!.reverse();
                                    isCollapsed = !isCollapsed;
                                  });
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        child: _pages.elementAt(pageIndex!)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
