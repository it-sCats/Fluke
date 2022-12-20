import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'QrCodeWidget.dart';
import 'creatingEventsForm.dart';

class visitorEventPrev extends StatelessWidget {
  visitorEventPrev(this.id, this.title, this.name, this.phone, this.Qr);

  String id;
  String title;
  String name;
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
                  child: InkWell(
                    child: Qr,
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        elevation: 100,
                        context: context,
                        builder: (context) => QrwidgetProfile(
                          id,
                          name,
                          phone,
                          title,
                        ),
                      );
                    },
                  ),
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
    );
  }
}

class QrwidgetProfile extends StatelessWidget {
  QrwidgetProfile(this.id, this.name, this.phone, this.eventName);

  String id;
  String name;
  String phone;
  String eventName;
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
