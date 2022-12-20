import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/cons.dart';
import '../../components/customWidgets.dart';

class notifaction extends StatefulWidget {
  const notifaction({Key? key}) : super(key: key);

  @override
  State<notifaction> createState() => _notifactionState();
}

class _notifactionState extends State<notifaction> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        //alla
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "إشعارات",
                  style: conHeadingsStyle,
                  // textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          // VisitorNotifi(),
          OrganizerNotifi(),
        ],
      ),
    );
  }
}

class OrganizerNotifi extends StatefulWidget {
  const OrganizerNotifi({super.key});

  @override
  State<OrganizerNotifi> createState() => _OrganizerNotifiState();
}

class _OrganizerNotifiState extends State<OrganizerNotifi> {
  bool isVisible = false;

  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: isVisible ? 200 : 150,
        padding: EdgeInsets.symmetric(vertical: 10),
        // height: 150,
        decoration: BoxDecoration(
          // color: Color(0xffB2C6E4),
          color:
              clicked ? Color(0xffffffff) : Color(0xffB2C6E4).withOpacity(.70),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "شركة Tech-W تريد المشاركة في المؤتمر السنوي\n للتقنية الذي تنظمه كراعي ذهبي",
                  style: conHeadingsStyle.copyWith(fontSize: 15),
                  textAlign: TextAlign.right,
                ),
                // Padding(
                //   padding: isVisible
                //       ? const EdgeInsets.only(bottom: 0)
                //       : EdgeInsets.only(bottom: 10),
                //   child: Text(
                //     "سيقام معرض التقنية  بتاريخ 14-11-2022",
                //     style: conHeadingsStyle.copyWith(fontSize: 15),
                //     textAlign: TextAlign.right,
                //   ),
                // ), //this row is for the event name pic and title
                Visibility(
                  visible: isVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CTAsdelEvent(
                        txt: "حذف",
                        isFullwidth: false,
                        onTap: () {},
                      ),
                      SizedBox(width: 30),
                      CTAshowEvent(
                        txt: "عرض الطلب",
                        isFullwidth: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ), //this row is for the heddin btns
                Row(
                  children: [
                    Text(
                      "منذ عشرة دقائق",
                      style: conLittelTxt12.copyWith(
                          color: Color(0xff676767), fontSize: 10),
                    )
                  ],
                ), //this row for date
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CircleAvatar(
                //Avatar
                backgroundColor: Color(0xff).withOpacity(0),
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          isVisible = !isVisible;
          clicked = true;
        });
      },
    );
  }
}
