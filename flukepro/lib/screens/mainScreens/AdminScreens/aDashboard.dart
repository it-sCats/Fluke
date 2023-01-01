import 'package:flukepro/components/cons.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flukepro/utils/fireStoreQueries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flukepro/screens/OrganizersScreens/Sections/ongoingEvents.dart';
import 'package:flukepro/screens/OrganizersScreens/Sections/VisitorFeedSection.dart';

class Adashboard extends StatelessWidget {
  const Adashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 25.0),
      color: conRed,
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
          dashboardSection('الأحداث الحالية ', siggning().getAllEvents()),
          VisitorFeedSection('أحداث قادمة ', getOngoing()),
        ],
      ),
    );
  }
}
