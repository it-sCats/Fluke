import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/screens/OrganizersScreens/OdashoardImproved.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../components/creatingEventsForm.dart';
import '../../components/session.dart';
import '../../utils/SigningProvider.dart';
import '../../utils/eventProvider.dart';
import '../../utils/fireStoreQueries.dart';
import '../../utils/notificationProvider.dart';
import '../mainScreens/profile.dart';
import 'Notifications.dart';
import 'ODashboard.dart';
import 'Oprofile.dart';
import 'package:intl/intl.dart' as intl;

//الصفحة هذه هي أساس لوحة التحكم متاع المنظم
final _auth = FirebaseAuth.instance;
TextEditingController _eventTypeCont = TextEditingController();
final _eventChooseFormKey = GlobalKey<FormState>();
Session? session;
int? pageIndex = 0;
bool isCollapsed = defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform ==
            TargetPlatform
                .macOS //هنا الشرط حيتحكم بإن النافيقيشن سايد بار يقعد مفتوح في حال كنا فاتحينه علة ويندوز ولا ماك
    ? false
    : true;
AnimationController? controller;

//
//كائن من الفاير بيز ايث2

bool showCreating = false;
String? eventId;
String? creatorId;
Timestamp? starterDate;
Timestamp? endDate;
List? rooms;

//صفحة الهوم متاع المنظم
class Ohome extends StatefulWidget {
  const Ohome({Key? key}) : super(key: key);

  @override
  State<Ohome> createState() => _OhomeState();
}

class _OhomeState extends State<Ohome> with TickerProviderStateMixin {
  static List<Widget> _pages = [
    //بدل ما يتم توجيه المستخدم لصفحات مختلفة, بالطريقة هذه حيكون عندي ويدجيتس يتم التغيير بيناتهم عن طريق النافيقيشن سايد
    //هنا نتحكمو بالويدجيتس الي حينعرضو
    OdashboardImproved(), //لوحة التحكم
    Oprofile(), //الاحداث التي نظمها المنظم
    OnotifiScreen(), //الاشعارات
    //الملف الشخصي متاعه
  ];
  //متغير نغيرو بيه الويدجيتس
  //controls the visibility of creating agenda and crating events button
  double? screenWidth, ScreenHeigth;
  final Duration duration = const Duration(milliseconds: 300);
  Animation<double>? _scaleAnimation;
  // void showCreation() {
  //   setState(() {
  //     showCreating ? showCreating = false : showCreating = true;
  //     print(showCreating);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    print('++++++++++++++');

    Provider.of<siggning>(context, listen: false).getCurrentUsertype(
        Provider.of<siggning>(context, listen: false).loggedUser!.uid);
    Provider.of<siggning>(context, listen: false).getUserInfoDoc(
        Provider.of<siggning>(context, listen: false).loggedUser!.uid);
    // Provider.of<siggning>(context, listen: false).getUserInfoDoc();

    controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.8,
    ).animate(controller!);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<siggning>(context, listen: false).getCurrentUsertype(
        Provider.of<siggning>(context, listen: false).loggedUser!.uid);

    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    ScreenHeigth = size.height;
    return Scaffold(
      backgroundColor: conBlue,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          menu(context),
          Dashboard(context),
          AddButton(
            txt: '+',
            onTap: () {
              setState(() {
                showCreating = !showCreating;
                print(showCreating);
              });

              // showCreation();
            },
          ),
          Visibility(
            visible: showCreating,
            child: Transform.translate(
              offset: Offset(20, 0),
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: size.height * 0.07,
                ),
                child: AddEventButton(
                  txt: "إنشاء أجندة",
                  onTap: () {
                    showModalBottomSheet(
                        elevation: 0,
                        context: context,
                        builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Form(
                                key: _eventChooseFormKey,
                                child: Column(
                                  children: [
                                    Text(
                                      'إختر الحدث الذي تريد إنشاء\n أجندة له',
                                      textAlign: TextAlign.center,
                                      style: conHeadingsStyle.copyWith(
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 80),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('events')
                                                .where('creatorID',
                                                    isEqualTo:
                                                        Provider.of<siggning>(
                                                                context,
                                                                listen: false)
                                                            .loggedUser!
                                                            .uid
                                                            .trim())
                                                .where('endDate',
                                                    isGreaterThanOrEqualTo:
                                                        Timestamp.now())
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else {
                                                var events =
                                                    snapshot.data!.docs;
                                                return DropdownButtonFormField(
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'يجب تحديد حدث';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 20),
                                                      hintText: 'أحداثك',
                                                      hintStyle:
                                                          conTxtFeildHint,
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xffF1F1F1),
                                                      errorStyle:
                                                          conErorTxtStyle,
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  style:
                                                      conTxtFeildHint.copyWith(
                                                          color: conBlack),
                                                  items: snapshot.data!.docs
                                                      .map((DocumentSnapshot
                                                          items) {
                                                    eventId = items['id'];
                                                    return DropdownMenuItem(
                                                      value: [
                                                        items['title'],
                                                        items['id'],
                                                        items['creatorID'],
                                                        items['starterDate'],
                                                        items['endDate'],
                                                        items['rooms'],
                                                      ],
                                                      child: Text(items[
                                                          'title']), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                                                    );
                                                  }).toList(),
                                                  onChanged: (dynamic value) {
                                                    _eventTypeCont.text = value[
                                                            0]
                                                        .toString(); //the event name
                                                    creatorId = value[2];
                                                    eventId = value[1];
                                                    //the event id
                                                    starterDate = value[3];
                                                    endDate = value[4];
                                                    rooms = value[5];
                                                    print(value[0]);
                                                    print(value[1]);
                                                    print(value[2]);
                                                  },
                                                );
                                              }
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    lessEdgeCTA(
                                        txt: 'إنشاء أجندة الحدث',
                                        onTap: () async {
                                          // Provider.of<eventInfoHolder>(context,
                                          //         listen: false)
                                          //     .getEventInfoForTimetable(
                                          //         eventId, context);
                                          if (_eventChooseFormKey.currentState!
                                              .validate()) {
                                            if (_eventTypeCont.text != '') {
                                              Navigator.pushNamed(
                                                  //send event Id and name to the time table screen
                                                  context,
                                                  'timeTable',
                                                  arguments: [
                                                    starterDate,
                                                    endDate,
                                                    eventId,
                                                    creatorId,
                                                    rooms
                                                  ]);
                                            }
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: showCreating,
            child: AddEventButton(
              txt: "إنشاء حدث",
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  elevation: 100,
                  context: context,
                  builder: (context) => creatingEvent(),
                );

                setState(() {});
              },
            ),
          ),
        ], // جزئين رئيسيين والي هما المينيو الجانبية و"الداش بورد" مقصود بيها الصفحة البيضا الي نحطو عليها في المكونات التانية
      ),
    );
  }

  Widget menu(context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
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
                            Provider.of<siggning>(context, listen: false)
                                .loggedUser!
                                .email
                                .toString(),
                            style: conHeadingsStyle.copyWith(
                                fontSize: 14, color: Colors.white)),
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
              pageIndex = 0; //تغير الإندكس الي يتحكم بالويدجيت المعروضة
              defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform ==
                              TargetPlatform
                                  .iOS && //شرط يتحكم بإغلاق السايد مينو عند الضغط على الخيار هذا منها
                          !isCollapsed
                  ? {controller!.reverse(), isCollapsed = !isCollapsed}
                  : null;
            });
          }, '/Odash', context),
          menuNavs(Icons.event, 'أحداثك', () {
            setState(() {
              pageIndex = 1;
              defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS &&
                          !isCollapsed
                  ? {controller!.reverse(), isCollapsed = !isCollapsed}
                  : null;
            });
          }, '/Oprofile', context),
          menuNavs(Icons.notifications, 'إشعارات ', () {
            setState(() {
              pageIndex = 2;
              defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS &&
                          !isCollapsed
                  ? {controller!.reverse(), isCollapsed = !isCollapsed}
                  : null;
            });
          }, '/Onotification', context),
          SizedBox(
            height: 220,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                IconButton(
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, 'settings');
                    }),
                Text(
                  '|',
                  style: conOnboardingText,
                ),
                IconButton(
                    icon: Icon(Icons.logout_rounded),
                    color: Colors.white,
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                      Navigator.pushNamed(context, '/redirect');
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget menuNavs(IconData icon, String text, Function callback,
      String currentPath, BuildContext context) {
    //ويدجيت خاصة بعناصر المينو
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * .07, top: 30),
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
              ? 0.3 * screenWidth!
              : 0.25 * screenWidth!,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      ? controller!.forward()
                                      : controller!.reverse();
                                  isCollapsed = !isCollapsed;
                                });
                              },
                            )
                          : Container(),
                      IconButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 23, horizontal: 30),
                          onPressed: () {
                            Navigator.pushNamed(context, '/Osearch');
                          },
                          icon: Icon(
                            Icons.search,
                            color: conBlack.withOpacity(.9),
                            size: 40,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex: 20,
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

class AddEventButton extends StatefulWidget {
  //
  AddEventButton({
    required this.txt,
    required this.onTap,
  });
  final String txt;
  Function onTap;

  @override
  State<AddEventButton> createState() => _AddEventButtonState();
}

class _AddEventButtonState extends State<AddEventButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS
            ? 140
            : 150,
        height: defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS
            ? 50
            : 40,
        padding: EdgeInsets.symmetric(vertical: 7),
        margin: EdgeInsets.symmetric(
            vertical: defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS
                ? size.height * 0.0700
                : size.height * 0.090,
            horizontal: defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS
                ? size.height * 0.0900
                : size.width * 0.080),
        child: InkWell(
          onTap: () => widget.onTap(),
          child: Text(
            widget.txt,
            textAlign: TextAlign.center,
            style:
                conCTATxt.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        decoration: BoxDecoration(
          color: conORange,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
