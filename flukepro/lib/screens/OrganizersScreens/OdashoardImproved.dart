import 'package:flukepro/utils/fireStoreQueries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/cons.dart';
import '../../components/eventsList.dart';
import '../../utils/SigningProvider.dart';
import 'Sections/VisitorFeedSection.dart';
import 'Sections/ongoingEvents.dart';

class OdashboardImproved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.only(top: 40), children: [
      Padding(
        padding: EdgeInsets.only(right: 50.0),
        child: Text(
          'الاحداث الحالية',
          textAlign: TextAlign.right,
          style: conHeadingsStyle.copyWith(
              fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
          height: 200,
          child: eventList(siggning().getAllOrganizersVisibleEvents(context),
              false, true, false)),
      SizedBox(
        height: 20,
      ),
      Container(
        margin: const EdgeInsets.only(left: 55, right: 30),
        child: new Divider(
          color: conBlack.withOpacity(.1),
          thickness: 2,
          height: 4,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: EdgeInsets.only(right: 50.0),
        child: Text(
          'الاحداث القادمة',
          textAlign: TextAlign.right,
          style: conHeadingsStyle.copyWith(
              fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      VisitorVerticalEventList(siggning().getAllEvents(), true, false, true),
    ]);
  }
}
