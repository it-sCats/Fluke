import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'cons.dart';

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
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
