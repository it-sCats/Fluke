import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/components/eventsList.dart';
import 'package:flukepro/screens/OrganizersScreens/Sections/ongoingEvents.dart';
import 'package:flukepro/utils/fireStoreQueries.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../OrganizersRequests/requestsList.dart';
import '../../components/bottomNav.dart';
import '../../utils/SigningProvider.dart';
import '../../utils/authentication.dart';
import '../OrganizersScreens/Sections/VisitorFeedSection.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
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
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextFormField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
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
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 155, 5, 33)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 1,
                shrinkWrap: true,
                crossAxisSpacing: 20,
                mainAxisSpacing: 30,
                children: [
                  dashboardSection(
                      'الأحداث الأكثر تداولا ', siggning().getAllEvents()),
                  VisitorFeedSection('أحداث تهمك', siggning().getAllEvents()),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
