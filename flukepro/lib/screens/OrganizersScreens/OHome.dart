import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' as intl;
import 'Notifications.dart';
import 'ODashboard.dart';
import 'Oevents.dart';
import 'Oprofile.dart';
import 'package:intl/intl.dart' as intl;

//الصفحة هذه هي أساس لوحة التحكم متاع المنظم
final _auth = FirebaseAuth.instance;
bool showCreating = false;

//صفحة الهوم متاع المنظم
class Ohome extends StatefulWidget {
  const Ohome({Key? key}) : super(key: key);

  @override
  State<Ohome> createState() => _OhomeState();
}

class _OhomeState extends State<Ohome> with SingleTickerProviderStateMixin {
  static List<Widget> _pages = [
    //بدل ما يتم توجيه المستخدم لصفحات مختلفة, بالطريقة هذه حيكون عندي ويدجيتس يتم التغيير بيناتهم عن طريق النافيقيشن سايد
    //هنا نتحكمو بالويدجيتس الي حينعرضو
    Odashboard(), //لوحة التحكم
    Oevents(), //الاحداث التي نظمها المنظم
    notifaction(), //الاشعارات
    Oprofile() //الملف الشخصي متاعه
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
  // void showCreation() {
  //   setState(() {
  //     showCreating ? showCreating = false : showCreating = true;
  //     print(showCreating);
  //   });
  // }

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
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
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
                child: AddEventButton(
                  txt: "إنشاء حدث",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => creatingEvent(),
                    );

                    setState(() {});
                  },
                ),
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
                      onTap: () {},
                    ),
                  ),
                ),
              ) //TODO edit the add button
            ], // جزئين رئيسيين والي هما المينيو الجانبية و"الداش بورد" مقصود بيها الصفحة البيضا الي نحطو عليها في المكونات التانية
          ),
        ),
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
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
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
              pageIndex = 0; //تغير الإندكس الي يتحكم بالويدجيت المعروضة
              defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform ==
                              TargetPlatform
                                  .iOS && //شرط يتحكم بإغلاق السايد مينو عند الضغط على الخيار هذا منها
                          !isCollapsed
                  ? _controller!.reverse()
                  : _controller!.forward();
              isCollapsed = !isCollapsed;
            });
          }, '/Odash', context),
          menuNavs(Icons.event, 'أحداثك', () {
            setState(() {
              pageIndex = 1;
              defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS &&
                          !isCollapsed
                  ? _controller!.reverse()
                  : _controller!.forward();
              isCollapsed = !isCollapsed;
            });
          }, '/Oevent', context),
          menuNavs(Icons.notifications, 'إشعارات ', () {
            setState(() {
              pageIndex = 2;
              defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS &&
                          !isCollapsed
                  ? _controller!.reverse()
                  : _controller!.forward();
              isCollapsed = !isCollapsed;
            });
          }, '/Onotification', context),
          menuNavs(Icons.person, 'الملف شخصي ', () {
            setState(() {
              pageIndex = 3;
              defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS &&
                          !isCollapsed
                  ? _controller!.reverse()
                  : _controller!.forward();
              isCollapsed = !isCollapsed;
            });
          }, '/Oprofile', context),
          SizedBox(
            height: 220,
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
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
          left: MediaQuery.of(context).size.width * .03, top: 30),
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
                ? size.height * 0.0800
                : size.height * 0.090,
            horizontal: defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS
                ? size.height * 0.0990
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
          color: conORange.withOpacity(.9),
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

class creatingEvent extends StatefulWidget {
  @override
  State<creatingEvent> createState() => _creatingEventState();
}

class _creatingEventState extends State<creatingEvent> {
  var eventTypes = [
    'ورشة عمل',
    'معرض',
    'محاضرة',
    'ملتقى',
    'إجتماع',
  ];
  TextEditingController endDate = TextEditingController();
  TextEditingController starterDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(color: Colors.white60),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Image.asset(
                    'images/teemu-paananen-bzdhc5b3Bxs-unsplash.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffd9d9d9),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 50,
                    width: 150,
                    child: InkWell(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera, size: 25),
                        Text(
                          'تغيير الصورة ',
                          style: conTxtFeildHint,
                        ),
                      ],
                    )),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          hintText: 'إسم الحدث',
                          hintStyle: conTxtFeildHint,
                          filled: true,
                          fillColor: Color(0xffF1F1F1),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            hintText: 'نوع الحدث',
                            hintStyle: conTxtFeildHint,
                            filled: true,
                            fillColor: Color(0xffF1F1F1),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                        style: conTxtFeildHint.copyWith(color: conBlack),
                        items: eventTypes.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                                items), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                          );
                        }).toList(),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8),
                    child: Text(
                      'تاريخ الحدث:',
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: endDate,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    intl.DateFormat('yyyy-MM-dd')
                                        .format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  endDate.text = formattedDate
                                      .toString(); //set output date to TextField value.
                                });
                              }
                            },
                            readOnly: true,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                hintText: 'إلى',
                                hintStyle: conTxtFeildHint,
                                filled: true,
                                fillColor: Color(0xffF1F1F1),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: 24,
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              child: TextFormField(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(
                                          2000), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101));
                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        intl.DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    //you can implement different kind of Date Format here according to your requirement

                                    setState(() {
                                      endDate.text = formattedDate
                                          .toString(); //set output date to TextField value.
                                    });
                                  }
                                },
                                readOnly: true,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    hintText: 'من',
                                    hintStyle: conTxtFeildHint,
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
