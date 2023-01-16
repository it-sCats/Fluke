import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../components/cons.dart';
import '../../components/customWidgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../components/formsAndDisplays/participationRequest.dart';
import '../../components/participantEventRegisterForm.dart';
import '../../utils/SigningProvider.dart';

class OnotifiScreen extends StatefulWidget {
  @override
  State<OnotifiScreen> createState() => _OnotifiScreenState();
}

class _OnotifiScreenState extends State<OnotifiScreen> {
  List _request = [];
  List<int> tapItemIndex = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _request.add(message);
        // _notification = [..._notification, message];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isVisible = false;

    bool clicked = false;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Text(
              "إشعارات",
              style: conHeadingsStyle,
              // textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('joinRequest')
                      .where('requestStatus', isEqualTo: 'pending')
                      .where('EventcreatorID',
                          isEqualTo:
                              Provider.of<siggning>(context).loggedUser!.uid)
                      .orderBy('creationDate', descending: true)
                      // .where('EventcreatorID',
                      //     isEqualTo:
                      //         Provider.of<siggning>(context).loggedUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    // print(snapshot.data);
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 20,
                                  child: Image.asset('images/Hands Phone.png')),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                  flex: 20,
                                  child: Text(
                                    'لا يوجد أي إشعارات حتى الآن',
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 17,
                                        color: conBlack.withOpacity(.7)),
                                  ))
                            ],
                          ),
                        ), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                      );
                    } else {
                      _request.add(snapshot.data);
                      final requests = snapshot.data!.docs;
                      List<requesta> notificatinat = [];
                      for (QueryDocumentSnapshot notifi in requests) {
                        final participantsName = notifi['participantsName'];
                        final eventTitle = notifi['eventName'];
                        final notifibody = notifi['joinType'];
                        final notifiCreation = notifi['creationDate'];
                        final image = notifi['image'];

                        notificatinat.add(requesta(
                            notifi['reqID'],
                            notifi['eventId'],
                            eventTitle,
                            participantsName,
                            notifi['email'],
                            notifi['particpantphone'],
                            notifi['userId'],
                            notifi['EventcreatorID'],
                            notifibody,
                            notifiCreation,
                            image,
                            notifi['joinType'],
                            notifi['field']));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          children: notificatinat,
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class requesta extends StatefulWidget {
  String reqID;
  String title;
  String participantsName;
  String participantsId;
  String particpantEmail;
  String particpantphone;
  String creatorId;
  String body;
  String image;
  String joinType;
  List<dynamic> field;

  String eventId;
  Timestamp timeOfsend;
  requesta(
      this.reqID,
      this.eventId,
      this.title,
      this.participantsName,
      this.particpantEmail,
      this.particpantphone,
      this.participantsId,
      this.creatorId,
      this.body,
      this.timeOfsend,
      this.image,
      this.joinType,
      this.field);

  @override
  State<requesta> createState() => _requestaState();
}

class _requestaState extends State<requesta> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          height: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // height: 150,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: conBlack.withOpacity(.1), width: 2)),
            // color: Color(0xffB2C6E4),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Wrap(children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            ' ${widget.participantsName} يريد المشاركة في ${widget.title} الذي تنظمه كـ ${widget.body}',
                            style: conHeadingsStyle.copyWith(
                                fontSize: 15, color: conBlack.withOpacity(.9)),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                      // Text(
                      //   widget.body.toString(),
                      //   style: conHeadingsStyle.copyWith(
                      //       fontSize: 14, fontWeight: FontWeight.w500),
                      //   textAlign: TextAlign.right,
                      // ),
                      //this row is for the event name pic and title
                      //this row is for the heddin btns
                      Text(
                        '    ${timeago.format(DateTime.fromMicrosecondsSinceEpoch(widget.timeOfsend.microsecondsSinceEpoch))} ',
                        style: conLittelTxt12.copyWith(
                            color: Color(0xff676767), fontSize: 10),
                      ) //this row for date
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: CircleAvatar(
                      //Avatar
                      backgroundColor: Color(0xff).withOpacity(0),
                      radius: 70,
                      backgroundImage: NetworkImage(
                        widget.image,
                      ),
                    ),
                  ))
            ],
          ),
        ),
        onTap: () {
          showModalBottomSheet(
            //todo remove this to display the request so oganizer can accept or decline
            isScrollControlled: true,
            elevation: 100,
            context: context,
            builder: (context) => ParticiRequsetPrev(
                widget.reqID,
                widget.participantsName,
                widget.particpantEmail,
                widget.particpantphone,
                widget.participantsId,
                widget.image,
                widget
                    .eventId, //change th constructor in the upper widget to send the whole info down
                widget.title,
                widget.joinType,
                widget.field,
                widget.creatorId),
          );
          // showModalBottomSheet(
          //     isScrollControlled: true,
          //     elevation: 100,
          //     context: context,
          //     builder: (context) => eventDisplay(
          //         wholePage: false,
          //         justDisplay: false,
          //         id: eventData['id'],
          //         title:
          //             eventData['title'],
          //         description: eventData[
          //             'description'],
          //         starterDate: eventData[
          //             'starterDate'],
          //         location: eventData[
          //             'location'],
          //         image:
          //             eventData['image'],
          //         endDate: eventData[
          //             'endDate'],
          //         starterTime: eventData[
          //             'starterTime'],
          //         endTime: eventData[
          //             'endTime'],
          //         creationDate: eventData[
          //             'creationDate'],
          //         city: eventData[
          //             'eventCity'],
          //         acceptsParticapants:
          //             eventData[
          //                 'acceptsParticapants'],
          //         eventVisibilty: eventData[
          //             'eventVisibility']));

          //   if (tapItemIndex.contains(index)) {
          //     tapItemIndex.remove(index);
          //   } else {
          //     tapItemIndex.add(index);
          //   }
          //   setState(() {});
          // },
        });
  }
}

//     return SafeArea(
//       child: Column(
//         //alla
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   "إشعارات",
//                   style: conHeadingsStyle,
//                   // textAlign: TextAlign.right,
//                 ),
//               ],
//             ),
//           ),
//           VisitorNotifi(),
//         ],
//       ),
//     );
//   }
// }

class VisitorNotifi extends StatefulWidget {
  // String eventId;

  // VisitorNotifi(this.eventId);

  @override
  State<VisitorNotifi> createState() => _VisitorNotifiState();
}

class _VisitorNotifiState extends State<VisitorNotifi> {
  bool isVisible = false;

  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: isVisible ? 200 : 150,
        padding: EdgeInsets.symmetric(vertical: 10),
        // height: 150,
        decoration: BoxDecoration(
          // color: Color(0xffB2C6E4),
          color:
              clicked ? Color(0xffffffff) : Color(0xffB2C6E4).withOpacity(.70),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "معرض التقنية ",
                  style: conHeadingsStyle.copyWith(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                Padding(
                  padding: isVisible
                      ? const EdgeInsets.only(bottom: 0)
                      : EdgeInsets.only(bottom: 10),
                  child: Text(
                    "سيقام معرض التقنية  بتاريخ 14-11-2022",
                    style: conHeadingsStyle.copyWith(fontSize: 15),
                    textAlign: TextAlign.right,
                  ),
                ), //this row is for the event name pic and title
                Visibility(
                  visible: isVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CTAsdelEvent(
                        txt: "حذف",
                        isFullwidth: false,
                        onTap: () {},
                      ),
                      SizedBox(width: 30),
                      CTAshowEvent(
                        txt: "عرض حدث",
                        isFullwidth: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ), //this row is for the heddin btns
                Row(
                  children: [
                    Text(
                      "منذ عشرة دقائق",
                      style: conLittelTxt12.copyWith(
                          color: Color(0xff676767), fontSize: 10),
                    )
                  ],
                ), //this row for date
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CircleAvatar(
                //Avatar
                backgroundColor: Color(0xff).withOpacity(0),
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          isVisible = !isVisible;
          clicked = true;
        });
      },
    );
  }
}

class OrganizerNotifi extends StatefulWidget {
  // String eventId;

  // VisitorNotifi(this.eventId);

  @override
  State<VisitorNotifi> createState() => _VisitorNotifiState();
}

class _OrganizerNotifiState extends State<VisitorNotifi> {
  bool isVisible = false;

  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: isVisible ? 200 : 150,
        padding: EdgeInsets.symmetric(vertical: 10),
        // height: 150,
        decoration: BoxDecoration(
          // color: Color(0xffB2C6E4),
          color:
              clicked ? Color(0xffffffff) : Color(0xffB2C6E4).withOpacity(.70),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "معرض التقنية ",
                  style: conHeadingsStyle.copyWith(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                Padding(
                  padding: isVisible
                      ? const EdgeInsets.only(bottom: 0)
                      : EdgeInsets.only(bottom: 10),
                  child: Text(
                    "سيقام معرض التقنية  بتاريخ 14-11-2022",
                    style: conHeadingsStyle.copyWith(fontSize: 15),
                    textAlign: TextAlign.right,
                  ),
                ), //this row is for the event name pic and title
                Visibility(
                  visible: isVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CTAsdelEvent(
                        txt: "حذف",
                        isFullwidth: false,
                        onTap: () {},
                      ),
                      SizedBox(width: 30),
                      CTAshowEvent(
                        txt: "عرض حدث",
                        isFullwidth: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ), //this row is for the heddin btns
                Row(
                  children: [
                    Text(
                      "منذ عشرة دقائق",
                      style: conLittelTxt12.copyWith(
                          color: Color(0xff676767), fontSize: 10),
                    )
                  ],
                ), //this row for date
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CircleAvatar(
                //Avatar
                backgroundColor: Color(0xff).withOpacity(0),
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          isVisible = !isVisible;
          clicked = true;
        });
      },
    );
  }
}
