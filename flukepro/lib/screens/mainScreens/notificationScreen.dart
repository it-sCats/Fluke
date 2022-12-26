import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../components/cons.dart';
import '../../components/customWidgets.dart';
import '../../components/eventDisplay.dart';
import '../../utils/SigningProvider.dart';

class notifiScreen extends StatefulWidget {
  @override
  State<notifiScreen> createState() => _notifiScreenState();
}

class _notifiScreenState extends State<notifiScreen> {
  List _notification = [];
  List<int> tapItemIndex = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _notification.add(message);
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
            padding: const EdgeInsets.all(30),
            child: Text(
              "إشعارات",
              style: conHeadingsStyle,
              // textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(siggning().loggedUser!.uid)
                      .collection('notification')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 5),
                          child: Image.asset('images/Hands Phone.png'),
                        ), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                      );
                    } else {
                      _notification.add(snapshot.data);
                      final notifications = snapshot.data!.docs;
                      List<notificationa> notificatinat = [];
                      for (QueryDocumentSnapshot notifi in notifications) {
                        final notifiTitle = notifi['title'];
                        final notifibody = notifi['date'];
                        final notifiCreation = notifi['creationDate'];

                        notificatinat.add(notificationa(
                            notifiTitle, notifibody, notifiCreation));
                      }
                      return ListView(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        children: notificatinat,
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

class notificationa extends StatefulWidget {
  String title;
  String body;
  Timestamp timeOfsend;
  notificationa(this.title, this.body, this.timeOfsend);

  @override
  State<notificationa> createState() => _notificationaState();
}

class _notificationaState extends State<notificationa> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          height: 170,
          padding: EdgeInsets.symmetric(vertical: 5),
          // height: 150,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: conBlack.withOpacity(.1), width: 2)),
            // color: Color(0xffB2C6E4),
            color: Color(0xffffffff),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.title.toString(),
                    style: conHeadingsStyle.copyWith(fontSize: 18),
                    textAlign: TextAlign.right,
                  ),
                  //this row is for the event name pic and title
                  //this row is for the heddin btns
                  Text(
                    ' منذ   ${DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timeOfsend.microsecondsSinceEpoch)).inMinutes} دقيقة',
                    style: conLittelTxt12.copyWith(
                        color: Color(0xff676767), fontSize: 10),
                  ) //this row for date
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
