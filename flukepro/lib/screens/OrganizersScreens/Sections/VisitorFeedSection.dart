import 'package:flutter/material.dart';

import '../../../components/cons.dart';
import '../../../components/eventsList.dart';

class VisitorFeedSection extends StatelessWidget {
  //here is the section that is displayed in Organizer dashboard
  VisitorFeedSection(this.txt,
      this.eventToDisplay); //كونستركتور ياخذ عنوان يتعرض فوق القسم, وياخذ دالة تجيب حاجة من الداتابيز
  final String txt;
  Future<dynamic> eventToDisplay;
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
        Expanded(
            child: VisitorVerticalEventList(
                eventToDisplay)), //حطيتها في اكسباندد باش مااتديرش ايرور وتاخذ قداش تحتاج مساحة
      ],
    );
  }
}
