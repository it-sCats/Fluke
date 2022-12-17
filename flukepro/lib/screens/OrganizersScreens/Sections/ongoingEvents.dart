import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

import '../../../components/eventsList.dart';
import '../../../utils/fireStoreQueries.dart';

class dashboardSection extends StatelessWidget {
  //here is the section that is displayed in Organizer dashboard
  dashboardSection(this.txt,
      this.eventToDisplay); //كونستركتور ياخذ عنوان يتعرض فوق القسم, وياخذ دالة تجيب حاجة من الداتابيز
  final String txt;
  Future<dynamic> eventToDisplay;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(right: 35.0, top: 10),
            child: Text(
              txt,
              textAlign: TextAlign.right,
              style: conHeadingsStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 20,
          ),
        ),
        Expanded(
            flex: 15,
            child: Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: eventList(eventToDisplay),
            )),
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10),
          // margin: const EdgeInsets.only(left: 5, right: 15),
          child: new Divider(
            color: conBlack.withOpacity(.6),
            height: 4,
          ),
        ),
      ],
    );
  }
}
