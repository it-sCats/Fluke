import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/components/eventsList.dart';
import 'package:flukepro/screens/OrganizersScreens/Sections/ongoingEvents.dart';
import 'package:flukepro/utils/fireStoreQueries.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../OrganizersRequests/requestsList.dart';
import '../../components/bottomNav.dart';
import '../../utils/authentication.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      User LoggedinUser;
      if (user != null) {
        LoggedinUser = user;
        print(LoggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                textAlign: TextAlign.right,
                decoration: new InputDecoration(
                  hintText: "...ابحث عن أحداث",
                  hintStyle: conTxtFeildHint,
                  prefixIcon: new Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "الأحداث الأكثر تداولا",
                  textAlign: TextAlign.right,
                  style: conHeadingsStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // eventList(evento)
              SizedBox(
                height: 10,
              ),

              Container(
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.only(bottom: 10),
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30,
                    children: [
                      dashboardSection('الأحداث الأكثر تداولا ', getOngoing()),
                      dashboardSection('لأحداث الأكثر تداول', getOngoing()),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
