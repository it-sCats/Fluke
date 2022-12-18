import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======

import '../../components/customWidgets.dart';
//trying some thing
// class Visibility_ extends StatelessWidget {
>>>>>>> Stashed changes

class notifiScreen extends StatelessWidget {
  const notifiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Container();
=======
    return SafeArea(
      child: Container(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "إشعارات",
                      style: conHeadingsStyle,
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color(0xffB2C6E4),
                    color: Color(0xffffffff),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "معرض التقنية",
                              style: conHeadingsStyle,
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              "سيقام معرض التقنية  بتاريخ 14-11-2022",
                              style: conLittelTxt12,
                              textAlign: TextAlign.right,
                            ),
                            // Row(
                            //   children: [
                            halfCTA(txt: "عرض الحدث", onTap: () {}),
                            //     SizedBox(width: 10),
                            //     halfCTA(txt: "عرض الحدث", onTap: () {}),
                            //   ],
                            // ),
                            Text(
                              "منذ عشرة من الدقائق",
                              style: conLittelTxt12.copyWith(
                                  fontSize: 10, color: Colors.black38),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      // Visibility(child: child),
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          //Avatar
                          backgroundColor: Color(0xff).withOpacity(0),
                          radius: 50,
                          child: Image.asset(
                            'images/avatar.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
>>>>>>> Stashed changes
  }
}
