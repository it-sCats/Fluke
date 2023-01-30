import 'package:flutter/material.dart';

import '../../../OrganizersRequests/requestsList.dart';
import 'EventReportsList.dart';

class display extends StatelessWidget {
  const display({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(width: 400, child: EventReportsList()),
    );
  }
}
