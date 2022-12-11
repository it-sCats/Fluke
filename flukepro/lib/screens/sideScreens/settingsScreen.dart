import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

import '../../utils/authentication.dart';

class settingScreen extends StatelessWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'الإعدادات',
                      style: conHeadingsStyle.copyWith(fontSize: 20),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: new Divider(
                    color: conBlack.withOpacity(.6),
                    height: 4,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'personalInfo');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text(
                          'معلومات شخصية',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w100),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: new Divider(
                    color: conBlack.withOpacity(.6),
                    height: 4,
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Text(
                          'تسجيل خروج',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        onTap: () async {
                          await Authentication.signOut(context: context);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 0,
                        ),
                        child: new VerticalDivider(
                          color: conBlack.withOpacity(.6),
                          thickness: .5,
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'حذف الحساب',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: conRed),
                        ),
                        onTap: () async {
                          await Authentication().deleteUser();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
