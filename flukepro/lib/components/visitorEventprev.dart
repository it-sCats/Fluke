import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/components/eventDisplay.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/SigningProvider.dart';
import '../utils/fireStoreQueries.dart';
import 'QrCodeWidget.dart';
import 'creatingEventsForm.dart';

int? visitorsNum;
final _firebase = FirebaseFirestore.instance;
waitingFunction(eventId) async {
  visitorsNum = await gettingNumberOfEventVisitors(eventId);
}

class visitorEventPrev extends StatelessWidget {
  visitorEventPrev(this.id, this.title, this.name, this.participationType,
      this.phone, this.Qr);

  String id;
  String title;
  String name;
  String participationType;
  String phone;
  Widget Qr;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black.withOpacity(.2)),
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            elevation: 100,
            context: context,
            builder: (context) =>
                QrwidgetProfile(id, name, phone, title, participationType),
          );
        },
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Qr,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    title,
                    style: conHeadingsStyle.copyWith(fontSize: 15),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QrwidgetProfile extends StatelessWidget {
  QrwidgetProfile(
      this.id, this.name, this.phone, this.eventName, this.participationType);

  String id;
  String name;
  String phone;
  String eventName;
  String participationType;
  getEvent() {}

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
                data: '$eventName\n' +
                    '$name \n' +
                    '$phone\n' +
                    '$participationType\n',
                padding: EdgeInsets.all(50)),
            Text(
              "أظهر هذا الرمز يوم المعرض",
              style: conHeadingsStyle.copyWith(fontSize: 15),
            ),
            CTA(
              txt: "عرض الحدث",
              isFullwidth: false,
              onTap: () async {
                final event = await _firebase
                    .collection('events')
                    .doc(id.trim().toString())
                    .get();
                final eventInfo = event.data();

                if (eventInfo != null) {
                  var creatorNametoSend = await siggning()
                      .getORganizerInfo(eventInfo!['creatorID']);
                  print('${eventInfo!.length}eventInfo');
                  waitingFunction(eventInfo['id']);
                  showModalBottomSheet(
                    isScrollControlled: true,
                    elevation: 100,
                    context: context,
                    builder: (context) => eventDisplay(
                        wholePage: false,
                        justDisplay: true,
                        id: eventInfo!['id'],
                        title: eventInfo['title'],
                        description: eventInfo['description'],
                        starterDate: eventInfo['starterDate'],
                        location: eventInfo['location'],
                        image: eventInfo['image'],
                        endDate: eventInfo['endDate'],
                        eventType: eventInfo['eventType'],
                        starterTime: eventInfo!['starterTime'],
                        endTime: eventInfo!['endTime'],
                        creationDate: eventInfo!['creationDate'],
                        city: eventInfo!['eventCity'],
                        acceptsParticapants: eventInfo!['acceptsParticapants'],
                        eventVisibilty: eventInfo!['eventVisibility'],
                        visitorsNum: visitorsNum,
                        creatorID: eventInfo['creatorID'],
                        creatorName: creatorNametoSend),
                  );
                } else {
                  showDialog(
                      //save to drafts dialog
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'يبدو أن هذا الحدث محدوف ',
                            textAlign: TextAlign.center,
                            style: conHeadingsStyle.copyWith(fontSize: 15),
                          ),
                          actions: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  ' حسناً',
                                  textAlign: TextAlign.center,
                                  style: conHeadingsStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                          buttonPadding: EdgeInsets.all(20),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 100),
                        );
                      });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
