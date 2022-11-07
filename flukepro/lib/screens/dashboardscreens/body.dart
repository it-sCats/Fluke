import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';

import '../../components/cons.dart';
import '../../components/dashboardbg.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //this size to provide total height and width
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "WellcomeFluke!",
            style: conHeadingsStyle,
          ),
          Image.asset(
            'images/Eventmanaging.png',
            height: size.height * 0.3,
          ),
          CTA("سجل الدخول", () {}),
          CTA2("الدخول لحسابك", () {}),
        ],
      ),
    );
  }
}
