import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';
import '../../components/cons.dart';
import '../../components/customWidgets.dart';

class notifiScreen extends StatefulWidget {
  @override
  State<notifiScreen> createState() => _notifiScreenState();
}

class _notifiScreenState extends State<notifiScreen> {
  bool isVisible = false;

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
          InkWell(
            child: Container(
              height: isVisible ? 180 : 110,
              padding: EdgeInsets.symmetric(vertical: 10),
              // height: 150,
              decoration: BoxDecoration(
                // color: Color(0xffB2C6E4),
                color: isVisible
                    ? Color(0xffffffff)
                    : Color(0xffB2C6E4).withOpacity(.70),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "معرض التقنية ",
                        style: conHeadingsStyle.copyWith(fontSize: 18),
                        textAlign: TextAlign.right,
                      ),
                      Padding(
                        padding: isVisible
                            ? const EdgeInsets.only(bottom: 0)
                            : EdgeInsets.only(bottom: 10),
                        child: Text(
                          "سيقام معرض التقنية  بتاريخ 14-11-2022",
                          style: conHeadingsStyle.copyWith(fontSize: 15),
                          textAlign: TextAlign.right,
                        ),
                      ), //this row is for the event name pic and title
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
                              txt: "عرض حدث",
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
                                color: Color(0xff676767), fontSize: 8),
                          )
                        ],
                      ), //this row for date
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: CircleAvatar(
                      //Avatar
                      backgroundColor: Color(0xff).withOpacity(0),
                      radius: 70,
                      child: Image.asset(
                        'images/TechEventCo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
          ),
        ],
      ),
    );
  }
}

//  child: Container(
          // child: Column(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(30),
          //       child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(
              //         "إشعارات",
              //         style: conHeadingsStyle,
              //         textAlign: TextAlign.right,
              //       )
              //     ],
              //   ),
              // ),
              // InkWell(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       // color: Color(0xffB2C6E4),
              //       color: Color(0xffffffff),
              //     ),
              //     child: Row(
              //       children: [
              //         Expanded(
              //           flex: 3,
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.end,
              //             children: [
              //               Text(
                            //   "معرض التقنية",
                            //   style: conHeadingsStyle,
                            //   textAlign: TextAlign.right,
                            // ),
                            // Text(
                            //   "سيقام معرض التقنية  بتاريخ 14-11-2022",
                            //   style: conLittelTxt12,
                            //   textAlign: TextAlign.right,
                            // ),
                            // // Row(
                            // //   children: [
                            // // halfCTA(txt: "عرض الحدث", onTap: () {}),
                            // //     SizedBox(width: 10),
                            // //     halfCTA(txt: "عرض الحدث", onTap: () {}),
                            // //   ],
                            // // ),
                            // Text(
                            //   "منذ عشرة من الدقائق",
                            //   style: conLittelTxt12.copyWith(
                            //       fontSize: 10, color: Colors.black38),
                            //   textAlign: TextAlign.right,
                            // ),
                            // SizedBox(height: 10),
      //                     ],
      //                   ),
      //                 ),
      //                 // Visibility(child: child),
      //                 Expanded(
      //                   flex: 1,
      //                   child: CircleAvatar(
      //                     //Avatar
      //                     backgroundColor: Color(0xff).withOpacity(0),
      //                     radius: 50,
      //                     child: Image.asset(
      //                       'images/avatar.png',
      //                       fit: BoxFit.contain,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           onTap: () {},
      //         ),
      //       ],
      //     ),
      //   ),
      // ),