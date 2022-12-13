import 'package:flutter/material.dart';

import '../../components/bottomNav.dart';
import '../../components/cons.dart';

class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
  }
}
