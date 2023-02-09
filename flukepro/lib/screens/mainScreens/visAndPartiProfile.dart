import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/eventDisplay.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/cons.dart';
import '../../components/events.dart';
import '../../components/visitorEventprev.dart';
import '../../utils/fireStoreQueries.dart';

final _auth = FirebaseAuth.instance;

String userIn = '';
var userInfo;
String? userId;
File? image;
String? imagePath;
// getTicketNum() async {
//   //todo fetch the num of the tickets
//   ticketsLength = await getUserTicketsEvents(userId.toString());
//
//   return ticketsLength;
// }

class Vprofile extends StatefulWidget {
  String? OrganizerToDisplayID;
  Vprofile({this.OrganizerToDisplayID});

  @override
  State<Vprofile> createState() => _VprofileState();
}

class _VprofileState extends State<Vprofile> with TickerProviderStateMixin {
  @override
  void initState() {
    // getTicketNum();

    // TODO: implement initState
    super.initState();

    //  getParticipantsEvents(widget.OrganizerToDisplayID);
    userId = _auth.currentUser!.uid;
    Provider.of<siggning>(context, listen: false).getUserTicketsEvents(
        Provider.of<siggning>(context, listen: false).loggedUser!.uid);
    Provider.of<siggning>(context, listen: false).getUserLikedEvents(
        Provider.of<siggning>(context, listen: false).loggedUser!.uid);
    userInfo = Provider.of<siggning>(context, listen: false).getUserInfoDoc(
        widget.OrganizerToDisplayID == null
            ? Provider.of<siggning>(context, listen: false).loggedUser!.uid
            : widget.OrganizerToDisplayID);

    // getTicketNum();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState

    super.setState(fn);

    // ticketsLength = getTicketNum();
  }

  // getInterstsNum() async {
  //   //todo fetch the num of the intersts
  //   ticketsLength = await getUserTicketsEvents(userId.toString());
  //
  //   return ticketsLength;
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<siggning>(context, listen: false)
        .getUserTicketsEvents(FirebaseAuth.instance.currentUser!.uid);
    Provider.of<siggning>(context, listen: false)
        .getUserInfoDoc(FirebaseAuth.instance.currentUser!.uid);

    TabController _tabCont = TabController(
        length: widget.OrganizerToDisplayID == null ? 2 : 1, vsync: this);

    return //if from outside
        widget.OrganizerToDisplayID == null
            ? SafeArea(
                child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, bool) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'settings');
                                  },
                                  padding: EdgeInsets.all(20),
                                  icon: Icon(
                                    Icons.settings,
                                    color: conBlack,
                                    size: 30,
                                  )),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 0.0, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            Provider.of<siggning>(context,
                                                    listen: false)
                                                .userInfoDocument!['name'],
                                            style: conHeadingsStyle.copyWith(
                                                color: conBlack, fontSize: 15),
                                          ),
                                          Text(
                                            Provider.of<siggning>(context,
                                                                listen: false)
                                                            .userInfoDocument![
                                                        'userType'] ==
                                                    0
                                                ? "حساب زائر"
                                                : Provider.of<siggning>(context,
                                                                    listen: false)
                                                                .userInfoDocument![
                                                            'userType'] ==
                                                        2
                                                    ? "حساب مشارك"
                                                    : "حساب منظم",
                                            style: conHeadingsStyle.copyWith(
                                                color:
                                                    conBlack.withOpacity(0.50),
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: CircleAvatar(
                                        //Avatar
                                        backgroundColor:
                                            conBlue.withOpacity(.5),
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            'https://p.kindpng.com/picc/s/272-2720630_grey-user-hd-png-download.png'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Text(
                                            "تذكارك",
                                            style: conHeadingsStyle.copyWith(
                                                color:
                                                    conBlack.withOpacity(0.50),
                                                fontSize: 14),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            Provider.of<siggning>(context,
                                                    listen: false)
                                                .userTickets
                                                .toString(),
                                            style: conHeadingsStyle.copyWith(
                                                color: conBlack.withOpacity(.7),
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Text(
                                            " أحداث مهتم بها",
                                            style: conHeadingsStyle.copyWith(
                                                color:
                                                    conBlack.withOpacity(0.50),
                                                fontSize: 13),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            // _auth.currentUser!.displayName.toString(),
                                            Provider.of<siggning>(context,
                                                    listen: false)
                                                .userLiked
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: conHeadingsStyle.copyWith(
                                                color: conBlack.withOpacity(.7),
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ]),
                      ),
                    ];
                  },
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    //الأساسي

                    children: [
                      TabBar(
                        unselectedLabelStyle:
                            conLittelTxt12.copyWith(fontSize: 15),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        labelStyle: conLittelTxt12,
                        indicator: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(width: 3, color: conBlue))),
                        controller: _tabCont,
                        tabs: [
                          Tab(
                            child: Text(
                              'تذاكرك',
                              style: conLittelTxt12.copyWith(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'المفضلة',
                              style: conLittelTxt12.copyWith(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        // color: Color.fromARGB(255, 255, 255, 255),

                        child: TabBarView(
                          controller: _tabCont,
                          children: [
                            StreamBuilder<QuerySnapshot>(

                                //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
                                stream:
                                    getUserReegiteredEvents(userId.toString()),
                                builder: (context, AsyncSnapshot snapshot) {
                                  List<Widget> tiketsWidget = [];

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    //في حال لم يتم الاتصال يتم إظهار علامة تحميل
                                    return CircularProgressIndicator();
                                  } else {
                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                'images/Hands Phone.png'),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'عند تسجيلك في أي حدث ستظهر تذاكر دخولك هنا',
                                              style: conHeadingsStyle.copyWith(
                                                  fontSize: 14,
                                                  color:
                                                      conBlack.withOpacity(.7)),
                                            )
                                          ],
                                        ), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                                      );
                                      //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
                                    } else {
                                      final tickets = snapshot.data!.docs;

                                      for (var ticket in tickets) {
                                        tiketsWidget.add(visitorEventPrev(
                                            //هنا نجيب في كل دكيومنت ونعرض البيانات الي فيه ككارد عليها كيو آر
                                            ticket.id, //event id
                                            ticket['eventTitle'],
                                            ticket['name'],
                                            ticket!['phone'] == null
                                                ? ' '
                                                : ticket!['phone'],
                                            ticket!['participationType'],
                                            QrImage(
                                                padding: EdgeInsets.all(1),
                                                size: 60,
                                                data: '${Provider.of<siggning>(context, listen: false).userInfoDocument!['name']},\n' +
                                                    '${Provider.of<siggning>(context, listen: false).userInfoDocument!['phone']}\n' +
                                                    '${ticket!['eventTitle']}\n' +
                                                    '${ticket!['participationType']},\n')));
                                      }
                                      return ListView(
                                        physics: BouncingScrollPhysics(),
                                        reverse: false,
                                        children: tiketsWidget.isEmpty
                                            ? [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 60,
                                                    ),
                                                    Center(
                                                      child: Image.asset(
                                                          'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      'لم تقم بالتسجيل في أي حدث بعد',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: conLittelTxt12
                                                          .copyWith(
                                                              fontSize: 14),
                                                    )
                                                  ],
                                                )
                                              ]
                                            : tiketsWidget,
                                      );
                                    }
                                  }
                                }),
                            visiPartiInterests()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))
            : Scaffold(
                body: SafeArea(
                    child: DefaultTabController(
                        length: 1,
                        child: NestedScrollView(
                            headerSliverBuilder: (context, bool) {
                              return [
                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: IconButton(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 20),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(
                                                Icons.arrow_back,
                                                size: 40,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0.0, top: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      Provider.of<siggning>(
                                                                  context,
                                                                  listen: false)
                                                              .userInfoDocument![
                                                          'name'],
                                                      style: conHeadingsStyle
                                                          .copyWith(
                                                              color: conBlack,
                                                              fontSize: 15),
                                                    ),
                                                    Text(
                                                      "حساب مشارك",
                                                      style: conHeadingsStyle
                                                          .copyWith(
                                                              color: conBlack
                                                                  .withOpacity(
                                                                      0.50),
                                                              fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: CircleAvatar(
                                                  //Avatar
                                                  backgroundColor:
                                                      conBlue.withOpacity(.5),
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                      'https://p.kindpng.com/picc/s/272-2720630_grey-user-hd-png-download.png'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              ];
                            },
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              //الأساسي

                              children: [
                                TabBar(
                                  unselectedLabelStyle:
                                      conLittelTxt12.copyWith(fontSize: 15),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  labelStyle: conLittelTxt12,
                                  indicator: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 3, color: conBlue))),
                                  controller: _tabCont,
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        'الاحداث المشارك فيها',
                                        style: conLittelTxt12.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  // color: Color.fromARGB(255, 255, 255, 255),

                                  child: TabBarView(
                                    controller: _tabCont,
                                    children: [
                                      FutureBuilder(
                                          //todo change this to streambuilder
                                          //الايفينتس متاع المنظم

                                          //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
                                          future: getParticipantsEvents(
                                              widget.OrganizerToDisplayID),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              //في حال لم يتم الاتصال يتم إظهار علامة تحميل
                                              return CircularProgressIndicator();
                                            } else {
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: Image.asset(
                                                      'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                                                );
                                                //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
                                              } else {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 0),
                                                  child: GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                                            maxCrossAxisExtent:
                                                                300,
                                                            childAspectRatio:
                                                                4 / 5,
                                                            crossAxisSpacing: 0,
                                                            mainAxisSpacing: 5),
                                                    itemBuilder:
                                                        (context, index) {
                                                      var eventData =
                                                          snapshot.data![index];

                                                      return GestureDetector(
                                                        child:
                                                            OrganizerEventPreview(
                                                                //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                                                                title: eventData[
                                                                    'title'],
                                                                image: eventData[
                                                                    'image'],
                                                                description:
                                                                    eventData[
                                                                        'description'],
                                                                field: eventData[
                                                                    'field'],
                                                                location: eventData[
                                                                    'location'],
                                                                city: eventData[
                                                                    'eventCity'],
                                                                starterDate:
                                                                    eventData[
                                                                        'starterDate'],
                                                                endDate: eventData[
                                                                    'endDate'],
                                                                starterTime:
                                                                    eventData[
                                                                        'starterTime'],
                                                                endTime: eventData[
                                                                    'endTime'],
                                                                eventType:
                                                                    eventData[
                                                                        'eventType'],
                                                                creationDate:
                                                                    eventData[
                                                                        'creationDate'],
                                                                acceptsParticapants:
                                                                    eventData[
                                                                        'acceptsParticapants'],
                                                                eventVisibilty:
                                                                    eventData[
                                                                        'eventVisibility']),
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              elevation: 100,
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      eventDisplay(
                                                                        wholePage:
                                                                            false,
                                                                        justDisplay:
                                                                            true,
                                                                        id: eventData[
                                                                            'id'],
                                                                        title: eventData[
                                                                            'title'],
                                                                        description:
                                                                            eventData['description'],
                                                                        starterDate:
                                                                            eventData['starterDate'],
                                                                        location:
                                                                            eventData['location'],
                                                                        image: eventData[
                                                                            'image'],
                                                                        endDate:
                                                                            eventData['endDate'],
                                                                        starterTime:
                                                                            eventData['starterTime'],
                                                                        endTime:
                                                                            eventData['endTime'],
                                                                        creationDate:
                                                                            eventData['creationDate'],
                                                                        city: eventData[
                                                                            'eventCity'],
                                                                        acceptsParticapants:
                                                                            eventData['acceptsParticapants'],
                                                                        eventVisibilty:
                                                                            eventData['eventVisibility'],
                                                                        visitorsNum:
                                                                            visitorsNum,
                                                                        creatorID:
                                                                            eventData['creatorID'],
                                                                        creatorName:
                                                                            eventData['creatorName'],
                                                                        likes: eventData['likes']
                                                                            .length,
                                                                      ));
                                                        },
                                                      );
                                                    },
                                                    itemCount:
                                                        snapshot.data?.length,
                                                  ),
                                                );
                                              }
                                            }
                                          })
                                    ],
                                  ),
                                )
                              ],
                            )))));
  }
}

class visiPartiInterests extends StatelessWidget {
  const visiPartiInterests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //todo change this to streambuilder
        //الايفينتس متاع المنظم

        //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
        future: getLikedEvents(context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //في حال لم يتم الاتصال يتم إظهار علامة تحميل
            return CircularProgressIndicator();
          } else {
            if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                        'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'لم تقم بحفظ أي أحداث بعد',
                    textAlign: TextAlign.center,
                    style: conLittelTxt12.copyWith(fontSize: 14),
                  )
                ],
              );
              //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
            } else {
              return Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 4 / 5,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    var eventData = snapshot.data!.docs[index];

                    return GestureDetector(
                      child: OrganizerEventPreview(
                          //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                          title: eventData['title'],
                          image: eventData['image'],
                          description: eventData['description'],
                          field: eventData['field'],
                          location: eventData['location'],
                          city: eventData['eventCity'],
                          starterDate: eventData['starterDate'],
                          endDate: eventData['endDate'],
                          starterTime: eventData['starterTime'],
                          endTime: eventData['endTime'],
                          eventType: eventData['eventType'],
                          creationDate: eventData['creationDate'],
                          acceptsParticapants: eventData['acceptsParticapants'],
                          eventVisibilty: eventData['eventVisibility']),
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            elevation: 100,
                            context: context,
                            builder: (context) => eventDisplay(
                                  wholePage: false,
                                  justDisplay: true,
                                  id: eventData['id'],
                                  title: eventData['title'],
                                  description: eventData['description'],
                                  starterDate: eventData['starterDate'],
                                  location: eventData['location'],
                                  image: eventData['image'],
                                  endDate: eventData['endDate'],
                                  starterTime: eventData['starterTime'],
                                  endTime: eventData['endTime'],
                                  creationDate: eventData['creationDate'],
                                  city: eventData['eventCity'],
                                  acceptsParticapants:
                                      eventData['acceptsParticapants'],
                                  likes: eventData['likes'].length,
                                  eventVisibilty: eventData['eventVisibility'],
                                  visitorsNum: visitorsNum,
                                  creatorID: eventData['creatorID'],
                                  creatorName: eventData['creatorName'],
                                ));
                      },
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                ),
              );
            }
          }
        });
  }
}

class eventDrafts extends StatelessWidget {
  const eventDrafts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(

        //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('creatorID',
                isEqualTo: Provider.of<siggning>(context).loggedUser!.uid)
            .where('eventVisibility', isEqualTo: false)
            .orderBy('creationDate', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //في حال لم يتم الاتصال يتم إظهار علامة تحميل
            return CircularProgressIndicator();
          } else {
            if (!snapshot.hasData || snapshot.data == null) {
              print('${snapshot.data} the data of eventsss');
              return Center(
                child: Image.asset(
                    'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
              );
              //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
            } else {
              print('${snapshot.data!.docs} the data of eventsss');
              final events = snapshot.data!.docs;

              List<Widget> eventWidget = [];
              for (var eventa in events) {
                Timestamp strat = eventa['starterDate'];
                Timestamp end = eventa['endDate'];
                // print(DateTime.fromMicrosecondsSinceEpoch(
                //     strat.microsecondsSinceEpoch));
                // print(DateTime.fromMicrosecondsSinceEpoch(
                //     end.microsecondsSinceEpoch)); //testing
                {
                  eventWidget.add(Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: GestureDetector(
                      child: OrganizerEventPreview(
                        //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                        title: eventa['title'],
                        image: eventa['image'],
                        description: eventa['description'],
                        field: eventa['field'],
                        location: eventa['location'],
                        city: eventa['eventCity'],
                        starterDate: eventa['starterDate'],
                        endDate: eventa['endDate'],
                        starterTime: eventa['starterTime'],
                        endTime: eventa['endTime'],
                        eventType: eventa['eventType'],
                        creationDate: eventa['creationDate'],
                        acceptsParticapants: eventa['acceptsParticapants'],
                        eventVisibilty: eventa['eventVisibility'],
                      ),
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            elevation: 100,
                            context: context,
                            builder: (context) => eventDisplay(
                                  wholePage: false,
                                  justDisplay: false,
                                  id: eventa['id'],
                                  title: eventa['title'],
                                  description: eventa['description'],
                                  starterDate: eventa['starterDate'],
                                  location: eventa['location'],
                                  image: eventa['image'],
                                  endDate: eventa['endDate'],
                                  starterTime: eventa['starterTime'],
                                  eventType: eventa['eventType'],
                                  endTime: eventa['endTime'],
                                  field: eventa['field'],
                                  creationDate: eventa['creationDate'],
                                  city: eventa['eventCity'],
                                  likes: eventa['likes'].length,
                                  acceptsParticapants:
                                      eventa['acceptsParticapants'],
                                  eventVisibilty: eventa['eventVisibility'],
                                  visitorsNum: visitorsNum,
                                  creatorID: eventa['creatorID'],
                                  creatorName: eventa['creatorName'],
                                ));
                      },
                    ),
                  ));
                }
              }
              return GridView.custom(
                padding: EdgeInsets.symmetric(vertical: 10),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 4 / 5,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 5),
                childrenDelegate: SliverChildListDelegate(eventWidget),
              );
            }
          }
        });
  }
}
