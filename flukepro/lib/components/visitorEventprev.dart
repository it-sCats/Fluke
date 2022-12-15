import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'creatingEventsForm.dart';

class visitorEventPrev extends StatelessWidget {
  visitorEventPrev(this.title, this.Qr);
  String title;
  String Qr;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
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
                    child: Image.asset(
                      'images/qrcode.png',
                      width: 50,
                      height: 50,
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        elevation: 100,
                        context: context,
                        builder: (context) => QrImage(),
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
                  "معرض القهوة",
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

class QrImage extends StatelessWidget {
  const QrImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/qrcode.png',
              height: 300,
              width: 300,
            ),
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
