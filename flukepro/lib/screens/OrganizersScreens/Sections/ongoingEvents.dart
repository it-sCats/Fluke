import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

import '../../../components/eventsList.dart';
import '../../../utils/fireStoreQueries.dart';

class ongoingEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'أحداث تقام الآن',
            style: conHeadingsStyle.copyWith(
                fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Container(
            color: conBlue,
            child: eventList(getOngoing()),
          )
        ],
      ),
    );
  }
}
