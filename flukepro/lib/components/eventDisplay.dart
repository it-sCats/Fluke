import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/QrCodeWidget.dart';
import 'package:flukepro/components/eventEdit.dart';
import 'package:flukepro/components/participantEventRegisterForm.dart';
import 'package:flukepro/components/session.dart';
import 'package:flukepro/components/sessionDataSource.dart';
import 'package:flukepro/components/visitorEventprev.dart';
import 'package:flukepro/screens/OrganizersScreens/OHome.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:url_launcher/url_launcher.dart';
import '../screens/OrganizersScreens/Oprofile.dart';
import '../screens/OrganizersScreens/Sections/timeLine.dart';
import '../screens/mainScreens/userInfoScreen.dart';
import '../utils/SigningProvider.dart';
import '../utils/SigningProvider.dart';
import 'cons.dart';
import 'customWidgets.dart';

sessionDataSource? sessiondatasource;
final _firestore = FirebaseFirestore.instance;
//كائن من الداتابيز 1
final _auth = FirebaseAuth.instance;
final user = _auth!.currentUser;
var userType;
bool isLoading = false;
String? creatorName;
registerVisitor(eventID, context, userId, title, typeOfParticipation) async {
  //visitor registration function
  Map<String, dynamic>? userInfoDoc;
  userInfoDoc = Provider.of<siggning>(context, listen: false).userInfoDocument;
  final vistors = await _firestore //checks if user aleadry registered
      .collection('users')
      .doc(userId)
      .collection('tickets')
      .doc(eventID)
      .get();

  if (!vistors.exists) {
    //in case no documents were returned which means user is not registered then register user
    _firestore
        .collection('users')
        .doc(user!.uid.trim())
        .collection('tickets')
        .doc(eventID.trim())
        .set({
      'eventTitle': title,
      'email': user!.email,
      'phone': userInfoDoc!['phone'],
      'name': userInfoDoc!['name'],
      'participationType': typeOfParticipation
    }).then((value) => showModalBottomSheet(
              //تعرض كيو آر بعد تسجيل الزائر
              isScrollControlled: true,
              elevation: 100,
              context: context,
              builder: (context) => Qrwidget(userInfoDoc!['name'],
                  userInfoDoc!['phone'], title, typeOfParticipation),
            ));
  } else {
    showModalBottomSheet(
      //تعرض كيو آر في حالل كان مشجل مسبقاً
      isScrollControlled: true,
      elevation: 100,
      context: context,
      builder: (context) => Qrwidget(userInfoDoc!['name'],
          userInfoDoc!['phone'], title, typeOfParticipation),
    );
    // showQr();
  }
}

class eventDisplay extends StatefulWidget {
  bool wholePage;
  String id;
  String title;
  String? image;
  String? eventType;
  Timestamp starterDate;
  Timestamp endDate;
  int starterTime;
  int endTime;
  var field;
  String description;
  Timestamp creationDate;
  List<String>? room;
  String? location;
  String? city;
  bool acceptsParticapants;
  bool eventVisibilty;
  bool justDisplay;
  int? visitorsNum;
  String creatorID;
  String creatorName;

  eventDisplay(
      {required this.wholePage,
      required this.justDisplay,
      required this.id,
      required this.title,
      required this.description,
      this.image,
      this.eventType,
      required this.starterDate,
      required this.endDate,
      required this.starterTime,
      required this.endTime,
      this.field,
      required this.creationDate,
      this.location,
      this.city,
      required this.acceptsParticapants,
      required this.eventVisibilty,
      this.room,
      this.visitorsNum,
      required this.creatorID,
      required this.creatorName});
  getORganizerInfo() async {
    DocumentSnapshot<Map<String, dynamic>> creator =
        await _firestore.collection('users').doc(creatorID.trim()).get();

    creatorName = creator.get('name');
  }

  @override
  State<eventDisplay> createState() => _eventDisplayState();
}

class _eventDisplayState extends State<eventDisplay>
    with AutomaticKeepAliveClientMixin<eventDisplay> {
  @override // هذه انطلاقة الشاشة 3
  void initState() {
    super.initState();
    // visi();
    widget.getORganizerInfo();

    Provider.of<siggning>(context, listen: false)
        .getUserInfoDoc(FirebaseAuth.instance.currentUser!.uid);
  } //todo جيبي الاحداث متاع المنظم

  getUsertype() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Provider.of<siggning>(context, listen: false).getUserInfoDoc(user.uid);
      //
      // int userT = await Provider.of<siggning>(context, listen: false)
      //     .getCurrentUsertype();
      DocumentSnapshot<Map<String, dynamic>> userInfo =
          await _firestore.collection('users').doc(user!.uid).get();

      Map<String, dynamic>? userInfoDoc = userInfo.data();
      return userInfoDoc!['userType'];
    }
  }

  Widget bodyOfEvent() {
    // widget.getORganizerInfo();

    userType = Provider.of<siggning>(context).getUserType();

    if (user != null) {
      Provider.of<siggning>(context, listen: false).getCurrentUsertype(
          Provider.of<siggning>(context, listen: false).loggedUser!.uid);
    }

    return DefaultTabController(
        //this layout guarantees that the scroll works properly
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              SliverList(
                  delegate: SliverChildListDelegate([
                Stack(
                  //the top part of the Screen above the tabs
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: widget.image == null
                          ? Image.asset(
                              'images/emptyIamge.jpg',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black12.withOpacity(.4),
                              Colors.black12.withOpacity(.9),
                            ]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 260),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              //place this in Column
                              widget.eventType.toString(),
                              textAlign: TextAlign.right,
                              style: conOnboardingText.copyWith(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              //place this in Column
                              widget.title, textAlign: TextAlign.right,
                              style: conOnboardingText.copyWith(fontSize: 30),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.city.toString(),
                                      style: conOnboardingText.copyWith(
                                          fontSize: 15, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.watch_later_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.starterTime! <= 12
                                          ? '${widget.starterTime} صباحاً- '
                                          : '${widget.starterTime}مساءً- ',
                                      style: conOnboardingText.copyWith(
                                          fontSize: 14),
                                    ),
                                    Text(
                                      widget.endTime! <= 12
                                          ? ' ${widget.endTime.toString()} صباحاً '
                                          : ' ${widget.endTime.toString()} مساءً ',
                                      style: conOnboardingText.copyWith(
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      DateTime.fromMicrosecondsSinceEpoch(widget
                                              .starterDate
                                              .microsecondsSinceEpoch)
                                          .toString()
                                          .split(' ')
                                          .first,
                                      style: conOnboardingText,
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 30),
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: 40,
                                color: Colors.white,
                              )),
                          Provider.of<siggning>(context, listen: false)
                                      .loggedUser!
                                      .uid ==
                                  widget
                                      .creatorID //هذا الشرط يعني بإظهار أزرار الحذف والتعديل في حال كان عارض الحدث هو المنشء
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.only(
                                          top: 50, bottom: 20, right: 30),
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  editEvent(eventId: widget.id),
                                            ));
                                      },
                                    ),
                                    IconButton(
                                      //هنا يتم حذف الحدث بعد أخد التاكيد من اليوزر
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 30),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                            //save to drafts dialog
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'هل أنت متأكد من رغبتك في حذف هذا الحدث؟ ',
                                                  textAlign: TextAlign.center,
                                                  style: conHeadingsStyle
                                                      .copyWith(fontSize: 15),
                                                ),
                                                content: Text(
                                                  'هذه الخطوة نهائية لا يمكن التارجع عنها',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      conHeadingsStyle.copyWith(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                                actions: [
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        ' إالغاء الحذف',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: conHeadingsStyle
                                                            .copyWith(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      )),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color: conRed,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: InkWell(
                                                        onTap: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'events')
                                                              .doc(widget.id
                                                                  .trim())
                                                              .delete()
                                                              .whenComplete(
                                                                //بعد إنهاء عملية الحدث يقوم بإعادة التوجيه للصفحة الرئيسية
                                                                () => Navigator
                                                                    .pushNamed(
                                                                        context,
                                                                        'OHome'),
                                                              );
                                                        },
                                                        child: Text(
                                                          'حدف الحدث',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: conHeadingsStyle
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )),
                                                  ),
                                                ],
                                                buttonPadding:
                                                    EdgeInsets.all(20),
                                                actionsAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 100),
                                              );
                                            });
                                      },
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ]))
            ];
          }),
          body: Column(
            //the bottom part of the screen
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                unselectedLabelStyle: conLittelTxt12.copyWith(fontSize: 15),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                labelStyle: conLittelTxt12,
                indicator: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(width: 3, color: conBlue))),
                tabs: [
                  Tab(
                    child: Text(
                      'معلومات الحدث',
                      style: conLittelTxt12.copyWith(fontSize: 15),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'الأجندة',
                      style: conLittelTxt12.copyWith(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 6,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        widget.justDisplay ||
                                widget.creatorID ==
                                    Provider.of<siggning>(context,
                                            listen: false)
                                        .loggedUser!
                                        .uid
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          color: conORange.withOpacity(.8),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            ' ${DateTime.fromMicrosecondsSinceEpoch(widget.endDate.microsecondsSinceEpoch).toString().split(' ').first.split('-').last}/'),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                              ' ${DateTime.fromMicrosecondsSinceEpoch(widget.starterDate.microsecondsSinceEpoch).toString().split(' ').first}'),
                                        ),
                                      ],
                                    ),
                                    widget.field != null
                                        ? Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.work,
                                                  color:
                                                      conORange.withOpacity(.8),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(widget.field.toString(),
                                                    style: conHeadingsStyle
                                                        .copyWith(
                                                            fontSize: 16,
                                                            color: conBlack,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    overflow:
                                                        TextOverflow.visible),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.people_alt_rounded,
                                    //       color: conBlack.withOpacity(.5),
                                    //     ),
                                    //     SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     Text(
                                    //         widget.visitorsNum
                                    //             .toString(), //visitors number
                                    //         style: conHeadingsStyle.copyWith(
                                    //             fontSize: 18,
                                    //             color: conBlack,
                                    //             fontWeight: FontWeight.w400)),
                                    //     Text('  شخص سيزور هذا الحدث',
                                    //         style: conHeadingsStyle.copyWith(
                                    //             fontSize: 13,
                                    //             color: conBlack.withOpacity(.7),
                                    //             fontWeight: FontWeight.w400))
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      'عن الحدث:',
                                      style: conHeadingsStyle.copyWith(
                                          fontSize: 18,
                                          color: conBlack.withOpacity(.8),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(widget.description,
                                          style: conHeadingsStyle.copyWith(
                                              fontSize: 17,
                                              color: conBlack.withOpacity(.6),
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      // margin: const EdgeInsets.only(left: 5, right: 15),
                                      child: new Divider(
                                        color: conBlack.withOpacity(.6),
                                        height: 4,
                                      ),
                                    ),
                                    widget.location!.isNotEmpty
                                        ? Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'موقع الحدث على الخرائط:',
                                                  style:
                                                      conHeadingsStyle.copyWith(
                                                          fontSize: 18,
                                                          color: conBlack
                                                              .withOpacity(.8),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await launchUrl(Uri.parse(
                                                          widget.location
                                                              .toString()));
                                                    },
                                                    child: Text(
                                                        widget.location
                                                            .toString(),
                                                        style: conHeadingsStyle
                                                            .copyWith(
                                                                fontSize: 16,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                color: conBlue
                                                                    .withOpacity(
                                                                        .6),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      // margin: const EdgeInsets.only(left: 5, right: 15),
                                      child: new Divider(
                                        color: conBlack.withOpacity(.6),
                                        height: 4,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'منظم الحدث:',
                                                style:
                                                    conHeadingsStyle.copyWith(
                                                        fontSize: 18,
                                                        color: conBlack
                                                            .withOpacity(.8),
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  if (widget.creatorID !=
                                                      Provider.of<siggning>(
                                                              context,
                                                              listen: false)
                                                          .loggedUser!
                                                          .uid) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Oprofile(
                                                                      OrganizerToDisplayID: widget
                                                                          .creatorID
                                                                          .trim(),
                                                                    )));
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: CircleAvatar(
                                                        //Avatar
                                                        backgroundColor:
                                                            conORange
                                                                .withOpacity(0),
                                                        radius: 50,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      widget.creatorName,
                                                      style: conHeadingsStyle
                                                          .copyWith(
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: conBlack),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                            : Provider.of<siggning>(context).getUserType() ==
                                        2 &&
                                    widget.acceptsParticapants
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month_rounded,
                                              color: conORange.withOpacity(.8),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                ' ${DateTime.fromMicrosecondsSinceEpoch(widget.endDate.microsecondsSinceEpoch).toString().split(' ').first.split('-').last}/'),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Text(
                                                  ' ${DateTime.fromMicrosecondsSinceEpoch(widget.starterDate.microsecondsSinceEpoch).toString().split(' ').first}'),
                                            ),
                                          ],
                                        ),
                                        widget.field != null
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.work,
                                                      color: conORange
                                                          .withOpacity(.8),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        widget.field.toString(),
                                                        style: conHeadingsStyle
                                                            .copyWith(
                                                                fontSize: 16,
                                                                color: conBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        overflow: TextOverflow
                                                            .visible),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        // Row(
                                        //   children: [
                                        //     Icon(
                                        //       Icons.people_alt_rounded,
                                        //       color: conBlack.withOpacity(.5),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 5,
                                        //     ),
                                        //     Text(
                                        //         widget.visitorsNum
                                        //             .toString(), //visitors number
                                        //         style: conHeadingsStyle.copyWith(
                                        //             fontSize: 18,
                                        //             color: conBlack,
                                        //             fontWeight: FontWeight.w400)),
                                        //     Text('  شخص سيزور هذا الحدث',
                                        //         style: conHeadingsStyle.copyWith(
                                        //             fontSize: 13,
                                        //             color: conBlack.withOpacity(.7),
                                        //             fontWeight: FontWeight.w400))
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          'عن الحدث:',
                                          style: conHeadingsStyle.copyWith(
                                              fontSize: 18,
                                              color: conBlack.withOpacity(.8),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(widget.description,
                                              style: conHeadingsStyle.copyWith(
                                                  fontSize: 17,
                                                  color:
                                                      conBlack.withOpacity(.6),
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          // margin: const EdgeInsets.only(left: 5, right: 15),
                                          child: new Divider(
                                            color: conBlack.withOpacity(.6),
                                            height: 4,
                                          ),
                                        ),
                                        widget.location!.isNotEmpty
                                            ? Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'موقع الحدث على الخرائط:',
                                                      style: conHeadingsStyle
                                                          .copyWith(
                                                              fontSize: 18,
                                                              color: conBlack
                                                                  .withOpacity(
                                                                      .8),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await launchUrl(
                                                              Uri.parse(widget
                                                                  .location
                                                                  .toString()));
                                                        },
                                                        child: Text(
                                                            widget.location
                                                                .toString(),
                                                            style: conHeadingsStyle.copyWith(
                                                                fontSize: 16,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                color: conBlue
                                                                    .withOpacity(
                                                                        .6),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          // margin: const EdgeInsets.only(left: 5, right: 15),
                                          child: new Divider(
                                            color: conBlack.withOpacity(.6),
                                            height: 4,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'منظم الحدث:',
                                                    style: conHeadingsStyle
                                                        .copyWith(
                                                            fontSize: 18,
                                                            color: conBlack
                                                                .withOpacity(
                                                                    .8),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (widget.creatorID !=
                                                          Provider.of<siggning>(
                                                                  context)
                                                              .loggedUser!
                                                              .uid) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Oprofile(
                                                                          OrganizerToDisplayID: widget
                                                                              .creatorID
                                                                              .trim(),
                                                                        )));
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: CircleAvatar(
                                                            //Avatar
                                                            backgroundColor:
                                                                conORange
                                                                    .withOpacity(
                                                                        0),
                                                            radius: 50,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          widget.creatorName,
                                                          style: conHeadingsStyle
                                                              .copyWith(
                                                                  fontSize: 19,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      conBlack),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  width: 200,
                                                  height: 60,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: conBlue
                                                              .withOpacity(.5),
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Text(
                                                    ' التسجيل كمشارك',
                                                    textAlign: TextAlign.center,
                                                    style: conTxtFeildHint
                                                        .copyWith(
                                                            color: conBlue
                                                                .withOpacity(
                                                                    .7),
                                                            fontSize: 18),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  if (widget.endDate.compareTo(
                                                          Timestamp.now()) >=
                                                      0) {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      elevation: 100,
                                                      context: context,
                                                      builder: (context) =>
                                                          ParticiEventPrev(
                                                        widget.id,
                                                        widget.title,
                                                        widget.creatorID,
                                                      ),
                                                    );
                                                  } else {
                                                    showDialog(
                                                        //save to drafts dialog
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              'لا يمكنك التسجيل في هذا الحدث\n لانه منتهي',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: conHeadingsStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                            actions: [
                                                              InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    ' حسناً',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: conHeadingsStyle.copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  )),
                                                            ],
                                                            buttonPadding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            actionsAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        100),
                                                          );
                                                        });
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              halfCTA(
                                                  txt: ' التسجيل كزائر',
                                                  onTap: () async {
                                                    if (widget.endDate
                                                            .compareTo(Timestamp
                                                                .now()) >=
                                                        0) {
                                                      await registerVisitor(
                                                          widget.id,
                                                          context,
                                                          user!.uid,
                                                          widget.title,
                                                          'زائر');
                                                    } else {
                                                      showDialog(
                                                          //save to drafts dialog
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                'لا يمكنك التسجيل في هذا الحدث\n لانه منتهي',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: conHeadingsStyle
                                                                    .copyWith(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                              actions: [
                                                                InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      ' حسناً',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: conHeadingsStyle.copyWith(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    )),
                                                              ],
                                                              buttonPadding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              actionsAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          100),
                                                            );
                                                          });
                                                    }
                                                  }),
                                            ],
                                          ),
                                        )
                                      ],
                                    ))
                                : Container(
                                    //for visitors
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month_rounded,
                                              color: conORange.withOpacity(.8),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                ' ${DateTime.fromMicrosecondsSinceEpoch(widget.endDate.microsecondsSinceEpoch).toString().split(' ').first.split('-').last}/'),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Text(
                                                  ' ${DateTime.fromMicrosecondsSinceEpoch(widget.starterDate.microsecondsSinceEpoch).toString().split(' ').first}'),
                                            ),
                                          ],
                                        ),
                                        widget.field != null
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.work,
                                                      color: conORange
                                                          .withOpacity(.8),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        widget.field.toString(),
                                                        style: conHeadingsStyle
                                                            .copyWith(
                                                                fontSize: 16,
                                                                color: conBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        overflow: TextOverflow
                                                            .visible),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        // Row(
                                        //   children: [
                                        //     Icon(
                                        //       Icons.people_alt_rounded,
                                        //       color: conBlack.withOpacity(.5),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 5,
                                        //     ),
                                        //     Text(
                                        //         widget.visitorsNum
                                        //             .toString(), //visitors number
                                        //         style: conHeadingsStyle.copyWith(
                                        //             fontSize: 18,
                                        //             color: conBlack,
                                        //             fontWeight: FontWeight.w400)),
                                        //     Text('  شخص سيزور هذا الحدث',
                                        //         style: conHeadingsStyle.copyWith(
                                        //             fontSize: 13,
                                        //             color: conBlack.withOpacity(.7),
                                        //             fontWeight: FontWeight.w400))
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          'عن الحدث:',
                                          style: conHeadingsStyle.copyWith(
                                              fontSize: 18,
                                              color: conBlack.withOpacity(.8),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(widget.description,
                                              style: conHeadingsStyle.copyWith(
                                                  fontSize: 17,
                                                  color:
                                                      conBlack.withOpacity(.6),
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          // margin: const EdgeInsets.only(left: 5, right: 15),
                                          child: new Divider(
                                            color: conBlack.withOpacity(.6),
                                            height: 4,
                                          ),
                                        ),
                                        widget.location!.isNotEmpty
                                            ? Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'موقع الحدث على الخرائط:',
                                                      style: conHeadingsStyle
                                                          .copyWith(
                                                              fontSize: 18,
                                                              color: conBlack
                                                                  .withOpacity(
                                                                      .8),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await launchUrl(
                                                              Uri.parse(widget
                                                                  .location
                                                                  .toString()));
                                                        },
                                                        child: Text(
                                                            widget.location
                                                                .toString(),
                                                            style: conHeadingsStyle.copyWith(
                                                                fontSize: 16,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                color: conBlue
                                                                    .withOpacity(
                                                                        .6),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          // margin: const EdgeInsets.only(left: 5, right: 15),
                                          child: new Divider(
                                            color: conBlack.withOpacity(.6),
                                            height: 4,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'منظم الحدث:',
                                                    style: conHeadingsStyle
                                                        .copyWith(
                                                            fontSize: 18,
                                                            color: conBlack
                                                                .withOpacity(
                                                                    .8),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (widget.creatorID !=
                                                          Provider.of<siggning>(
                                                                  context)
                                                              .loggedUser!
                                                              .uid) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Oprofile(
                                                                          OrganizerToDisplayID: widget
                                                                              .creatorID
                                                                              .trim(),
                                                                        )));
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: CircleAvatar(
                                                            //Avatar
                                                            backgroundColor:
                                                                conORange
                                                                    .withOpacity(
                                                                        0),
                                                            radius: 50,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          widget.creatorName,
                                                          style: conHeadingsStyle
                                                              .copyWith(
                                                                  fontSize: 19,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      conBlack),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Center(
                                            child: halfCTA(
                                                txt: ' التسجيل كزائر',
                                                onTap: () async {
                                                  if (widget.endDate.compareTo(
                                                          Timestamp.now()) >=
                                                      0) {
                                                    await registerVisitor(
                                                        widget.id,
                                                        context,
                                                        user!.uid,
                                                        widget.title,
                                                        'زائر');
                                                  } else {
                                                    showDialog(
                                                        //save to drafts dialog
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              'لا يمكنك التسجيل في هذا الحدث\n لانه منتهي',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: conHeadingsStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                            actions: [
                                                              InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    ' حسناً',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: conHeadingsStyle.copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  )),
                                                            ],
                                                            buttonPadding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            actionsAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        100),
                                                          );
                                                        });
                                                  }
                                                }),
                                          ),
                                        )
                                      ],
                                    )), //todo خلي الشرط هنا واعرضي زوز ويدجيت مختلفاتا للشاشة كلها
                        eventTimeline(
                            eventID: widget.id,
                            creatorID: widget.creatorID,
                            startDate: widget.starterDate,
                            endDate: widget.endDate),
                      ]),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    user != null
        ? Provider.of<siggning>(context, listen: false).getCurrentUsertype(
            Provider.of<siggning>(context, listen: false).loggedUser!.uid)
        : null;

    return widget.wholePage
        ? Scaffold(
            body: bodyOfEvent(),
          )
        : bodyOfEvent();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class EventInfo extends StatelessWidget {
  const EventInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [],
    ));
  }
}
