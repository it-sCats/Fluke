import 'package:flukepro/utils/fireStoreQueries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Sections/VisitorFeedSection.dart';
import 'Sections/ongoingEvents.dart';

class Odashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 25.0),
      child: GridView.count(
        //حيعطينا التقسيمة للشاشة
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 20,
        crossAxisSpacing: 50,
        crossAxisCount: defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform ==
                    TargetPlatform
                        .iOS //في حال استخدام الموبايل يتم عرض حدث واحد ف كل صف
            ? 1
            : 2, //في حال إستخدام الديسكتوب يتم عرض 2 أحداث فس الصف الواحد
        children: [
          dashboardSection('الأحداث الحالية ', getAllEvents()),
          VisitorFeedSection('أحداث قادمة ', getOngoing()),
        ],
      ),
    );
  }
}
