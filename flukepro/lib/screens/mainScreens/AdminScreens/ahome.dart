import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../../components/creatingEventsForm.dart';
import '../../../../utils/SigningProvider.dart';
import 'aDashboard.dart';
// import 'Notifications.dart';
// import 'ODashboard.dart';
// import 'Oevents.dart';
// import 'Oprofile.dart';
// import 'package:intl/intl.dart' as intl;

//الصفحة هذه هي أساس لوحة التحكم متاع المنظم
final _auth = FirebaseAuth.instance;
//كائن من الفاير بيز ايث2

bool showCreating = false;

//صفحة الهوم متاع المنظم
class Ahome extends StatefulWidget {
  const Ahome({super.key});
  @override
  State<Ahome> createState() => _AhomeState();
}

class _AhomeState extends State<Ahome> with SingleTickerProviderStateMixin {
  static List<Widget> _pages = [
    //بدل ما يتم توجيه المستخدم لصفحات مختلفة, بالطريقة هذه حيكون عندي ويدجيتس يتم التغيير بيناتهم عن طريق النافيقيشن سايد
    //هنا نتحكمو بالويدجيتس الي حينعرضو
    Adashboard(), //لوحة التحكم
    // Oevents(), //الاحداث التي نظمها المنظم
    // notifaction(), //الاشعارات
    // Oprofile() //الملف الشخصي متاعه
  ];
  int? pageIndex = 0; //متغير نغيرو بيه الويدجيتس
  //controls the visibility of creating agenda and crating events button
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
    super.initState();
    print('++++++++++++++');
    Provider.of<siggning>(context, listen: false).getCurrentUsertype();

    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.8,
    ).animate(_controller!);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    ScreenHeigth = size.height;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Row(
            children: [
              menu(context),
              Dashboard(context),
            ],
          ),
        ));
  }

  Widget menu(context) {
    return SafeArea(
        child: Container(
      width: 250,
      decoration: BoxDecoration(
        // color: Color(0xffB2C6E4),
        color: conBlue.withOpacity(.70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xff).withOpacity(0),
                        radius: 30,
                        child: Image.asset(
                          'images/fluke horizontal-13-modified.png',
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          // _auth.currentUser != null
                          //     ? _auth.currentUser!.email
                          //         .toString()
                          //         .split('@')
                          //         .first
                          //     :
                          'Fluke admin pannel',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 16, color: Colors.white)),
                      Text('You',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 10, color: Colors.white)),
                    ],
                  )
                ],
              ),
            ), //part1
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                menuNavs(Icons.dashboard, ' لوحة التحكم', () {
                  setState(() {
                    pageIndex = 0; //تغير الإندكس الي يتحكم بالويدجيت المعروضة
                    // defaultTargetPlatform == TargetPlatform.android ||
                    //         defaultTargetPlatform ==
                    //                 TargetPlatform
                    //                     .iOS && //شرط يتحكم بإغلاق السايد مينو عند الضغط على الخيار هذا منها
                    //             !isCollapsed
                    //     ? {_controller!.reverse(), isCollapsed = !isCollapsed}
                    //     : null;
                  });
                }, '/Adash', context),
                SizedBox(height: 30),
                menuNavs(Icons.event, 'أحداثك', () {
                  setState(() {
                    pageIndex = 1;
                    // defaultTargetPlatform == TargetPlatform.android ||
                    //         defaultTargetPlatform == TargetPlatform.iOS &&
                    //             !isCollapsed
                    //     ? {_controller!.reverse(), isCollapsed = !isCollapsed}
                    //     : null;
                  });
                }, '/Oevent', context),
                SizedBox(height: 30),
                menuNavs(Icons.notifications, 'إشعارات ', () {
                  setState(() {
                    pageIndex = 2;
                    defaultTargetPlatform == TargetPlatform.android ||
                            defaultTargetPlatform == TargetPlatform.iOS &&
                                !isCollapsed
                        ? {_controller!.reverse(), isCollapsed = !isCollapsed}
                        : null;
                  });
                }, '/Onotification', context),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      color: Color.fromARGB(255, 194, 8, 8),
                      onPressed: () {
                        // _auth.signOut();
                        // Navigator.pushNamed(context, '/log');
                        showDialog(
                          //save to drafts dialog
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'هل أنت متأكد من تسجيل الخروج؟ ',
                                textAlign: TextAlign.center,
                                style: conHeadingsStyle.copyWith(fontSize: 15),
                              ),
                              content: Text(
                                'بياناتك ستكون محفوظة وستجدها عند تسجل الدخول مرة أخرى',
                                textAlign: TextAlign.center,
                                style: conHeadingsStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              actions: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      ' الرجوع',
                                      textAlign: TextAlign.center,
                                      style: conHeadingsStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    )),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: conRed,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                    onTap: () async {
                                      _auth.signOut();
                                      Navigator.pushNamed(context, '/log');
                                    },
                                    child: Text(
                                      'تسجيل الخروج ',
                                      textAlign: TextAlign.center,
                                      style: conHeadingsStyle.copyWith(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                              buttonPadding: EdgeInsets.all(20),
                              actionsAlignment: MainAxisAlignment.spaceAround,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 100),
                            );
                          },
                        );
                      })
                ],
              ))
        ],
      ),
    ));
  }

  Widget menuNavs(IconData icon, String text, Function callback,
      String currentPath, BuildContext context) {
    //ويدجيت خاصة بعناصر المينو
    return Padding(
      padding: EdgeInsets.only(left: 30),
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
      bottom: -100,
      left: isCollapsed
          ? 0
          : !isCollapsed && defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform ==
                      TargetPlatform
                          .iOS //شرط يتحكم بكمية إزاحة الداش بورد الجانبية على المينيو لما تنفتح
              ? 0.1 * screenWidth!
              : 0.2 * screenWidth!,
      right: isCollapsed
          ? 0
          : !isCollapsed && defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS
              ? -4 * screenWidth!
              : 0 * screenWidth!, //for mobile
      child: ScaleTransition(
        scale: _scaleAnimation!,
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform ==
                                  TargetPlatform
                                      .iOS //في حال كان المستخدم يستخدم موبايل حيتم إظهار ايقونة المينيو
                          ? IconButton(
                              padding: EdgeInsets.only(left: 10, top: 20),
                              icon: Icon(
                                Icons.menu_rounded,
                                size: 40,
                              ),
                              color: conBlack,
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
                      height: double.infinity,
                      child: _pages.elementAt(pageIndex!)), //يتم عرض الصفحات
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
