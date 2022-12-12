import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

import '../../../components/eventsList.dart';
import '../../../utils/fireStoreQueries.dart';

class dashboardSection extends StatelessWidget {
  //here is the section that is displayed in Organizer dashboard
  dashboardSection(this.txt, this.eventToDisplay);//كونستركتور ياخذ عنوان يتعرض فوق القسم, وياخذ دالة تجيب حاجة من الداتابيز
  final String txt;
  Future<dynamic> eventToDisplay;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              txt,
              textAlign: TextAlign.right,
              style: conHeadingsStyle.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffD9D9D9).withOpacity(.14),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.5,
              child: eventList(eventToDisplay),
            ))
      ],
    );
  }
}
