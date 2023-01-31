import 'package:flukepro/OrganizersRequests/requestsList.dart';
import 'package:flukepro/screens/mainScreens/AdminScreens/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/cons.dart';
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

class Eventmainscreen extends StatelessWidget {
  const Eventmainscreen({super.key});

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
            // Expanded(
            //   // It takes 5/6 part of the screen
            //   flex: 5,
            //   // child: ddscreen(),
            //   // child: displaydataDashboardScreen(),
            //   // child: LoadEventData(),
            // ),
          ],
        ),
      ),
    );
  }
}

class OrganizerMainScreen extends StatefulWidget {
  const OrganizerMainScreen({super.key});

  @override
  State<OrganizerMainScreen> createState() => _OrganizerMainScreenState();
}

class _OrganizerMainScreenState extends State<OrganizerMainScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TabController _tabCont = TabController(length: 2, vsync: this);

    TabController _tabCont = TabController(length: 2, vsync: this);
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 1,
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                    headerSliverBuilder: (context, bool) {
                      return [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Header(),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 50),
                                child: Text(
                                  "بيانات المنظمين",
                                  style:
                                      conHeadingsStyle.copyWith(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 50),
                                child: SearchField(),
                              ),
                              SizedBox(
                                height: 25,
                              )
                            ],
                          ),
                        ]))
                      ];
                    },
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TabBar(
                          unselectedLabelStyle:
                              conLittelTxt12.copyWith(fontSize: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          labelStyle: conLittelTxt12,
                          indicator: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(width: 3, color: conBlue))),
                          controller: _tabCont,
                          tabs: [
                            Tab(
                              child: Text(
                                'المنظمين',
                                style: conLittelTxt12.copyWith(fontSize: 15),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'طلبات التسجيل',
                                style: conLittelTxt12.copyWith(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: TabBarView(controller: _tabCont, children: [
                          Container(width: 400, child: LoadOrganizerData()),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * .02),
                              child: requestsList()),
                        ]))
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
