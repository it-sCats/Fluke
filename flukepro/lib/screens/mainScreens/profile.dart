import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';
import '../../components/bottomNav.dart';
<<<<<<< Updated upstream
import '../../components/cons.dart';
=======
import '../../components/visitorEventprev.dart';
import '../../utils/fireStoreQueries.dart';
import '../OrganizersScreens/Sections/ongoingEvents.dart';
>>>>>>> Stashed changes

class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
<<<<<<< Updated upstream
        child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  //Avatar
                  backgroundColor: Color(0xff).withOpacity(0),
                  radius: 50,
                  child: Image.asset(
                    'images/avatar.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            // _auth.currentUser != null
                            //     ? _auth.currentUser!.email
                            //         .toString()
                            //         .split('@')
                            //         .first
                            //     :
                            'الإسم',
                            style: conHeadingsStyle.copyWith(
                                fontSize: 16, color: Color(0xFF9ec5e9))),
                        SizedBox(width: 10),
                      ],
                    ),
                    Text(
                      //Email
                      // _auth.currentUser!.email.toString(),
                      'نوع لاحساب',
                      style: conHeadingsStyle.copyWith(
                        fontSize: 14,
                        color: Color(0xFF9ec5e9).withOpacity(0.8),
                      ),
                    )
                  ],
                )
              ],
            )));
=======
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
                    Navigator.pushNamed(context, 'personalInfo');
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
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            "  عبد السلام المقلش",
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
                  // color: Color.fromARGB(255, 255, 255, 255),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      visitorEventPrev("uytuy", ""),
                      visitorEventPrev("uytuy", ""),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
>>>>>>> Stashed changes
  }
}
