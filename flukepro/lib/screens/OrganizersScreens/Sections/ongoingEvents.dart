import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

import '../../../components/eventsList.dart';
import '../../../utils/fireStoreQueries.dart';

class dashboardSection extends StatelessWidget {
  //here is the section that is displayed in Organizer dashboard
  dashboardSection(this.txt,
      this.eventToDisplay); //كونستركتور ياخذ عنوان يتعرض فوق القسم, وياخذ دالة تجيب حاجة من الداتابيز
  final String txt;
  Stream<QuerySnapshot<dynamic>> eventToDisplay;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 35.0, top: 10),
          child: Text(
            txt,
            textAlign: TextAlign.right,
            style: conHeadingsStyle.copyWith(
                fontWeight: FontWeight.normal, fontSize: 20),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(child: eventList(eventToDisplay, false, true, false)),
      ],
    );
  }
}
