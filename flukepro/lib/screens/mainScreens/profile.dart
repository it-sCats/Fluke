import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/screens/mainScreens/userInfoScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/QrCodeWidget.dart';
import '../../components/visitorEventprev.dart';
import '../../utils/fireStoreQueries.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
String? userId;
Map<String, dynamic>? userInfo;

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid;
    getUser();
  }

  getUser() async {
    final user =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    userInfo = user.data();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // reverse: true,
        child: Container(
          //backround starts the screen
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: conBlue,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            //الأساسي

            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'settings');
                  },
                  padding: EdgeInsets.all(20),
                  icon: Icon(
                    Icons.settings,
                    color: Color.fromARGB(156, 255, 255, 255),
                    size: 30,
                  )),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            "أحداثك",
                            style: conHeadingsStyle.copyWith(
                                color: Color(0xFFffffff), fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Text(
                            " 5",
                            style: conHeadingsStyle.copyWith(
                                color: Color(0xFFffffff).withOpacity(0.50),
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            // _auth.currentUser!.displayName.toString(),
                            "الاسم",
                            textAlign: TextAlign.center,
                            style: conHeadingsStyle.copyWith(
                                color: Color(0xFFffffff), fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "حساب زائر",
                            style: conHeadingsStyle.copyWith(
                                color: Color(0xFFffffff).withOpacity(0.50),
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 30),
                  // color: Color.fromARGB(255, 255, 255, 255),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: FutureBuilder(

                      //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
                      future: getUserReegiteredEvents(userId.toString()),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          //في حال لم يتم الاتصال يتم إظهار علامة تحميل
                          return CircularProgressIndicator();
                        } else {
                          if (!snapshot.hasData || snapshot.data.length == 0) {
                            return Center(
                              child: Image.asset(
                                  'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                            );
                            //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
                          } else {
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              reverse: false,
                              itemBuilder: (context, index) {
                                var eventData = snapshot.data![index];

                                return visitorEventPrev(
                                    eventData['id'],
                                    eventData['title'],
                                    userInfo!['name'],
                                    userInfo!['phone'],
                                    QrImage(
                                        padding: EdgeInsets.all(1),
                                        size: 60,
                                        data: '${userInfo!['name']},\n' +
                                            '${userInfo!['phone']}\n' +
                                            '${eventData!['title']}\n'));
                              },
                              itemCount: snapshot.data?.length,
                            );
                          }
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
