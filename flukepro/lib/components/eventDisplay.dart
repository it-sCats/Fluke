import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/visitorEventprev.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cons.dart';
import 'customWidgets.dart';

final _firestore = FirebaseFirestore.instance;
final _Auth = FirebaseAuth.instance;
bool isLoading = false;

class eventDisplay extends StatefulWidget {
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
  List<String>? targetedAudiance;
  bool eventVisibilty;

  eventDisplay({
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
    this.targetedAudiance,
  });

  @override
  State<eventDisplay> createState() => _eventDisplayState();
}

class _eventDisplayState extends State<eventDisplay>
    with TickerProviderStateMixin {
  registerVisitor(eventID, context, title) async {
    User? user = await _Auth.currentUser;

    final userInfo = await _firestore.collection('users').doc(user!.uid).get();

    final userInfoDoc = userInfo.data();

    final vistors = _firestore //checks if user aleadry registered
        .collection('events')
        .doc(eventID.toString().trim())
        .collection('visitors')
        .doc(user!.uid)
        .get();
    if (vistors == null) {
      //in case no documents were returned which means user is not registered then register user
      final vistors0 = _firestore
          .collection('events')
          .doc(eventID.toString().trim())
          .collection('visitors')
          .doc(user!.uid)
          .set({
        'email': user.email,
        'phone': userInfoDoc!['phone'],
        'name': userInfoDoc!['name']
      }).whenComplete(() {
        setState(() {
          isLoading = true;
        });
        showModalBottomSheet(
          isScrollControlled: true,
          elevation: 100,
          context: context,
          builder: (context) => Qrwidget(
            userInfoDoc!['name'],
            userInfoDoc!['phone'],
            title,
          ),
        ).whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      });
    } else {
      showModalBottomSheet(
        isScrollControlled: true,
        elevation: 100,
        context: context,
        builder: (context) =>
            Qrwidget(userInfoDoc!['name'], userInfoDoc!['phone'], title),
      );
      // showQr();

    }
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabCont = TabController(length: 2, vsync: this);
    return (SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 400,
                child: widget.image == null
                    ? Image.asset('images/emptyIamge.jpg')
                    : Image.file(File(widget.image!)),
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
                                widget.starterTime <= 12
                                    ? widget.starterTime.toString() + 'صباحاً-'
                                    : 'مساءاً-',
                                style: conOnboardingText.copyWith(fontSize: 14),
                              ),
                              Text(
                                widget.endTime <= 12
                                    ? widget.endTime.toString() + 'صباحاً'
                                    : 'مساءاً',
                                style: conOnboardingText.copyWith(fontSize: 14),
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
                                        .starterDate.microsecondsSinceEpoch)
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
                child: IconButton(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    child: TabBar(
                  unselectedLabelStyle: conLittelTxt12.copyWith(fontSize: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  labelStyle: conLittelTxt12,
                  indicator: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 3, color: conBlue))),
                  controller: _tabCont,
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
                )),
                Container(
                  width: double.maxFinite,
                  height: 450,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TabBarView(controller: _tabCont, children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.people_alt_rounded,
                                  color: conBlack.withOpacity(.5),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('150', //visitors number
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 18,
                                        color: conBlack,
                                        fontWeight: FontWeight.w400)),
                                Text('  شخص سيزور هذا الحدث',
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 13,
                                        color: conBlack.withOpacity(.7),
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'عن الحدث:',
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 18,
                                  color: conBlack.withOpacity(.8),
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(widget.description,
                                style: conHeadingsStyle.copyWith(
                                    fontSize: 16,
                                    color: conBlack.withOpacity(.6),
                                    fontWeight: FontWeight.w400)),
                            SizedBox(
                              height: 20,
                            ),
                            widget.location!.isNotEmpty
                                ? Text(
                                    'موقع الحدث على الخرائط:',
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 18,
                                        color: conBlack.withOpacity(.8),
                                        fontWeight: FontWeight.w400),
                                  )
                                : Container(),
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(
                                    Uri.parse(widget.location.toString()));
                              },
                              child: Text(widget.location.toString(),
                                  style: conHeadingsStyle.copyWith(
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      color: conBlue.withOpacity(.6),
                                      fontWeight: FontWeight.w400)),
                            )
                          ],
                        ),
                      ),
                      eventTimeline(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: conBlue.withOpacity(.5), width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          ' التسجيل كمشارك',
                          style: conTxtFeildHint.copyWith(
                              color: conBlue.withOpacity(.7), fontSize: 18),
                        ),
                      ),
                      onTap: () async {},
                    ),
                    halfCTA(
                        txt: ' التسجيل كزائر',
                        onTap: () async {
                          await registerVisitor(
                              widget.id, context, widget.title);
                        }),
                  ],
                )
        ],
      ),
    ));
  }
}

class eventTimeline extends StatelessWidget {
  const eventTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
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

class Qrwidget extends StatelessWidget {
  String name;
  String phone;
  String eventName;
  Qrwidget(this.name, this.phone, this.eventName);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QrImage(
                data: '$eventName\n' + '$name \n' + '$phone\n',
                padding: EdgeInsets.all(50)),
            Text(
              "أظهر هذا الرمز يوم المعرض",
              style: conHeadingsStyle.copyWith(fontSize: 15),
            ),
            CTA(
              txt: "عرض الحدث",
              isFullwidth: false,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
