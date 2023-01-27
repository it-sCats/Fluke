import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/eventDisplay.dart';
import 'package:flukepro/components/events.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/fireStoreQueries.dart';

int? visitorsNum;

class eventList extends StatefulWidget {
  bool isVisitorVertical;
  bool isOngoing;
  bool isUpcoming;
  Stream<QuerySnapshot<Object?>> EventQuery;

  eventList(
      this.EventQuery, this.isVisitorVertical, this.isOngoing, this.isUpcoming);

  @override
  State<eventList> createState() => _eventListState();
}

class _eventListState extends State<eventList> {
  List _events = [];

  waitingFunction(eventId) async {
    visitorsNum = await gettingNumberOfEventVisitors(eventId);
  }

  eventsStream() async {}
  @override
  Widget build(BuildContext context) {
    List<Widget> eventWidget = [];
    return Container(
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(

          //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
          stream: widget.EventQuery,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Image.asset('images/Hands - PhoneCrying.png');
              //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
            } else {
              final events = snapshot.data!.docs;
              // print(events);
              for (var eventa in events) {
                Timestamp strat = eventa['starterDate'];
                Timestamp end = eventa['endDate'];
                bool isLiked = eventa['likes']
                            [Provider.of<siggning>(context).loggedUser!.uid] !=
                        null
                    ? eventa['likes']
                        [Provider.of<siggning>(context).loggedUser!.uid]
                    : false;
                // print(DateTime.fromMicrosecondsSinceEpoch(
                //     strat.microsecondsSinceEpoch));
                // print(DateTime.fromMicrosecondsSinceEpoch(
                //     end.microsecondsSinceEpoch)); //testing

                // print((DateTime.fromMicrosecondsSinceEpoch(
                //             strat.microsecondsSinceEpoch)
                //         .isBefore(DateTime.now()) ||
                //     DateTime.fromMicrosecondsSinceEpoch(
                //             strat.microsecondsSinceEpoch)
                //         .isAtSameMomentAs(DateTime.now())));
                Map likes = eventa['likes'];

                if (widget.isOngoing
                    ? ((DateTime.fromMicrosecondsSinceEpoch(
                                    strat.microsecondsSinceEpoch)
                                .isBefore(DateTime.now()) ||
                            DateTime.fromMicrosecondsSinceEpoch(
                                    strat.microsecondsSinceEpoch)
                                .isAtSameMomentAs(DateTime.now())) &&
                        (DateTime.fromMicrosecondsSinceEpoch(
                                    end.microsecondsSinceEpoch)
                                .isAfter(DateTime.now()) ||
                            DateTime.fromMicrosecondsSinceEpoch(
                                    end.microsecondsSinceEpoch)
                                .isAtSameMomentAs(DateTime.now())))
                    : DateTime.fromMicrosecondsSinceEpoch(strat.microsecondsSinceEpoch)
                        .isAfter(DateTime.now())) {
                  print(eventa['title']);
                  eventWidget.add(Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: widget.isVisitorVertical ? 0 : 0),
                    child: Stack(children: [
                      GestureDetector(
                        child: eventHorizCard(
                          //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                          title: eventa['title'],
                          image: eventa['image'],
                          description: eventa['description'],
                          field: eventa['field'],
                          id: eventa['id'],
                          isLiked: isLiked,
                          location: eventa['location'],
                          city: eventa['eventCity'],
                          starterDate: eventa['starterDate'],
                          endDate: eventa['endDate'],
                          starterTime: eventa['starterTime'].toString(),
                          endTime: eventa['endTime'].toString(),
                          eventType: eventa['eventType'],
                          creationDate: eventa['creationDate'],
                          acceptsParticapants: eventa['acceptsParticapants'],
                          eventVisibilty: eventa['eventVisibility'],
                          visitorsNum: visitorsNum,
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
                                    acceptsParticapants:
                                        eventa['acceptsParticapants'],
                                    eventVisibilty: eventa['eventVisibility'],
                                    visitorsNum: visitorsNum,
                                    creatorID: eventa['creatorID'],
                                    creatorName: eventa['creatorName'],
                                  ));
                        },
                      ),
                      Provider.of<siggning>(context, listen: false)
                                  .userInfoDocument!['userType'] !=
                              1
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  bool _isLiked = eventa['likes'][
                                          Provider.of<siggning>(context,
                                                  listen: false)
                                              .loggedUser!
                                              .uid] ==
                                      true;
                                  if (_isLiked) {
                                    FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(eventa['id'])
                                        .update({
                                      'likes': {
                                        Provider.of<siggning>(context,
                                                listen: false)
                                            .loggedUser!
                                            .uid: false
                                      }
                                    });
                                    setState(() {
                                      isLiked = false;
                                    });
                                  } else if (!_isLiked) {
                                    FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(eventa['id'])
                                        .update({
                                      'likes': {
                                        Provider.of<siggning>(context,
                                                listen: false)
                                            .loggedUser!
                                            .uid: true
                                      }
                                    });
                                    setState(() {
                                      isLiked = true;
                                    });
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.all(25),
                                    child: !isLiked
                                        ? Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                            size: 30,
                                          )
                                        : Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 30,
                                          )),
                              ),
                            )
                          : Container()
                    ]),
                  ));
                }
              }
              return ListView(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                physics: BouncingScrollPhysics(),
                reverse: widget.isVisitorVertical
                    ? false
                    : defaultTargetPlatform == TargetPlatform.android ||
                            defaultTargetPlatform ==
                                TargetPlatform
                                    .iOS //خاصية يحتاجها الموبايل ليعرض الليستة بشكل صحيح

                        ? true
                        : false,
                scrollDirection: widget.isVisitorVertical
                    ? Axis.vertical
                    : defaultTargetPlatform == TargetPlatform.android ||
                            defaultTargetPlatform ==
                                TargetPlatform
                                    .iOS //حتى يتم التمرير بالجنب في الموبايل

                        ? Axis.horizontal
                        : Axis.vertical,
                children: (eventWidget.isEmpty)
                    ? [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/no events.png', width: 180),
                                Text(
                                  'لا توجد أحداث حالية ',
                                  style: conLittelTxt12,
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                          ),
                        )
                      ]
                    :
                    //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
                    eventWidget,
              );
            }
            //في حال لم يتم الاتصال يتم إظهار علامة تحميل
          }),
    );
  }
}

class VisitorVerticalEventList extends StatefulWidget {
  bool isVisitorVertical;
  bool isOngoing;
  bool isUpcoming;
  Stream<QuerySnapshot<Object?>> EventQuery;

  VisitorVerticalEventList(
      this.EventQuery, this.isVisitorVertical, this.isOngoing, this.isUpcoming);

  @override
  State<VisitorVerticalEventList> createState() =>
      _VisitorVerticalEventListState();
}

class _VisitorVerticalEventListState extends State<VisitorVerticalEventList> {
  List _events = [];
  waitingFunction(eventId) async {
    visitorsNum = await gettingNumberOfEventVisitors(eventId);
  }

  eventsStream() async {}
  @override
  Widget build(BuildContext context) {
    List<Widget> eventWidget = [];
    return Container(
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(

          //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
          stream: widget.EventQuery,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Image.asset(
                    'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
              );
              //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
            } else {
              final events = snapshot.data!.docs;

              for (var eventa in events) {
                Timestamp strat = eventa['starterDate'];
                Timestamp end = eventa['endDate'];
                bool isLiked = eventa['likes']
                            [Provider.of<siggning>(context).loggedUser!.uid] !=
                        null
                    ? eventa['likes']
                        [Provider.of<siggning>(context).loggedUser!.uid]
                    : false;
                // print(DateTime.fromMicrosecondsSinceEpoch(
                //     strat.microsecondsSinceEpoch));
                // print(DateTime.fromMicrosecondsSinceEpoch(
                //     end.microsecondsSinceEpoch)); //testing

                if (widget.isOngoing
                    ? ((DateTime.fromMicrosecondsSinceEpoch(
                                    strat.microsecondsSinceEpoch)
                                .isBefore(DateTime.now()) ||
                            DateTime.fromMicrosecondsSinceEpoch(
                                    strat.microsecondsSinceEpoch)
                                .isAtSameMomentAs(DateTime.now())) &&
                        (DateTime.fromMicrosecondsSinceEpoch(
                                    end.microsecondsSinceEpoch)
                                .isAfter(DateTime.now()) ||
                            DateTime.fromMicrosecondsSinceEpoch(
                                    end.microsecondsSinceEpoch)
                                .isAtSameMomentAs(DateTime.now())))
                    : widget.isUpcoming
                        ? DateTime.fromMicrosecondsSinceEpoch(
                                strat.microsecondsSinceEpoch)
                            .isAfter(DateTime.now())
                        : true) {
                  eventWidget.add(Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Stack(children: [
                      GestureDetector(
                        child: rectangleEvent(
                          //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                          title: eventa['title'],
                          image: eventa['image'],
                          description: eventa['description'],
                          field: eventa['field'],
                          location: eventa['location'],
                          city: eventa['eventCity'],
                          starterDate: eventa['starterDate'],
                          endDate: eventa['endDate'],
                          starterTime: eventa['starterTime'].toString(),
                          endTime: eventa['endTime'].toString(),
                          eventType: eventa['eventType'],
                          creationDate: eventa['creationDate'],
                          acceptsParticapants: eventa['acceptsParticapants'],
                          eventVisibilty: eventa['eventVisibility'],
                          visitorsNum: visitorsNum,
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
                                    acceptsParticapants:
                                        eventa['acceptsParticapants'],
                                    eventVisibilty: eventa['eventVisibility'],
                                    visitorsNum: visitorsNum,
                                    creatorID: eventa['creatorID'],
                                    creatorName:
                                        eventa['creatorName'], //يوم المرأة
                                  ));
                        },
                      ),
                      Provider.of<siggning>(context, listen: false)
                                  .userInfoDocument!['userType'] !=
                              1
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  bool _isLiked = eventa['likes'][
                                          Provider.of<siggning>(context,
                                                  listen: false)
                                              .loggedUser!
                                              .uid] ==
                                      true;
                                  if (_isLiked) {
                                    FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(eventa['id'])
                                        .update({
                                      'likes': {
                                        Provider.of<siggning>(context,
                                                listen: false)
                                            .loggedUser!
                                            .uid: false
                                      }
                                    });
                                    setState(() {
                                      isLiked = false;
                                    });
                                  } else if (!_isLiked) {
                                    FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(eventa['id'])
                                        .update({
                                      'likes': {
                                        Provider.of<siggning>(context,
                                                listen: false)
                                            .loggedUser!
                                            .uid: true
                                      }
                                    });
                                    setState(() {
                                      isLiked = true;
                                    });
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.all(25),
                                    child: !isLiked
                                        ? Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                            size: 30,
                                          )
                                        : Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 30,
                                          )),
                              ),
                            )
                          : Container()
                    ]),
                  ));
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  physics: BouncingScrollPhysics(),
                  reverse: widget.isVisitorVertical
                      ? false
                      : defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform ==
                                  TargetPlatform
                                      .iOS //خاصية يحتاجها الموبايل ليعرض الليستة بشكل صحيح

                          ? true
                          : false,
                  scrollDirection: widget.isVisitorVertical
                      ? Axis.vertical
                      : defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform ==
                                  TargetPlatform
                                      .iOS //حتى يتم التمرير بالجنب في الموبايل

                          ? Axis.horizontal
                          : Axis.vertical,
                  children: (eventWidget.isEmpty)
                      ? [
                          Center(
                            child: Image.asset(
                                'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                          )
                        ]
                      :
                      //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
                      eventWidget,
                ),
              );
            }
            //في حال لم يتم الاتصال يتم إظهار علامة تحميل
          }),
    );
  }
}

// class VisitorVerticalEventList extends StatelessWidget {
//   Future<dynamic> EventQuery;
//
//   VisitorVerticalEventList(
//     this.EventQuery,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 30),
//       height: double.infinity,
//       child: FutureBuilder(
//
//           //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
//           future: EventQuery,
//           builder: (context, AsyncSnapshot snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               //في حال لم يتم الاتصال يتم إظهار علامة تحميل
//               return Container(
//                   width: 100, height: 100, child: CircularProgressIndicator());
//             } else {
//               if (!snapshot.hasData || snapshot.data.length == 0) {
//                 return Center(
//                   child: Image.asset(
//                       'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
//                 );
//                 //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
//               } else {
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (context, index) {
//                     var eventData = snapshot.data![index];
//
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 18.0),
//                       child: eventVertiCard(
//                           //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
//                           title: eventData['title'],
//                           image: eventData['image'],
//                           description: eventData['description'],
//                           field: eventData['field'],
//                           location: eventData['location'],
//                           city: eventData['eventCity'],
//                           starterDate: eventData['starterDate'],
//                           endDate: eventData['endDate'],
//                           starterTime: eventData['starterTime'],
//                           endTime: eventData['endTime'],
//                           eventType: eventData['eventType'],
//                           creationDate: eventData['creationDate'],
//                           acceptsParticapants: eventData['acceptsParticapants'],
//                           eventVisibilty: eventData['eventVisibility']),
//                     );
//                   },
//                   itemCount: snapshot.data?.length,
//                 );
//               }
//             }
//           }),
//     );
//   }
// }
