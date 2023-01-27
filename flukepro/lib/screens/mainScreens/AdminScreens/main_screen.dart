import 'package:flutter/material.dart';

import '../../../components/responsive.dart';
import 'dashboard_screen.dart';
import 'displayDataPrev.dart';

import 'loadData.dart';
import 'sidde_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
              // child: displaydataDashboardScreen(),
              // child: LoadVisitorData(),
            ),
          ],
        ),
      ),
    );
  }
}

class Visitormainscreen extends StatefulWidget {
  const Visitormainscreen({super.key});

  @override
  State<Visitormainscreen> createState() => _VisitormainscreenState();
}

class _VisitormainscreenState extends State<Visitormainscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              // child: ddscreen(),
              // child: displaydataDashboardScreen(),
              child: LoadVisistorData(),
            ),
          ],
        ),
      ),
    );
  }
}

class Particimainscreen extends StatefulWidget {
  const Particimainscreen({super.key});

  @override
  State<Particimainscreen> createState() => _ParticimainscreenState();
}

class _ParticimainscreenState extends State<Particimainscreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
