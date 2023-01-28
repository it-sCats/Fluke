import 'package:flukepro/screens/mainScreens/AdminScreens/my__files.dart';
import 'package:flutter/material.dart';

import '../../../components/cons.dart';
import '../../../components/responsive.dart';
// import 'displayDataPrev.dart';
import 'header.dart';
import 'loadData.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  static List<Widget> _pagges = [
    LoadVisistorData(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        // padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: default_Padding),
            Padding(
              padding: EdgeInsets.all(default_Padding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        MyFiles(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: default_Padding),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
