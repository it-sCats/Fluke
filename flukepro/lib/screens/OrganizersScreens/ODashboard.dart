import 'package:flukepro/utils/fireStoreQueries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Sections/ongoingEvents.dart';

class Odashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.0),
      margin: EdgeInsets.only(bottom: 100),
      child: GridView.count(
        //حيعطينا التقسيمة للشاشة
        shrinkWrap: true,
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
          dashboardSection('أحداث قادمة ', getOngoing()),
          dashboardSection('زوار أحداثك', getOngoing()),
          dashboardSection("المشاركين في أحداث", getOngoing())
        ],
      ),
    );
  }
}
