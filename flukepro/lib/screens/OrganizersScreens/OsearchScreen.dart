import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

import '../mainScreens/explorePage.dart';

class OsearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: ExploreScreen(),
          ),
          IconButton(
              padding: EdgeInsets.only(top: 60, left: 23),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 35,
                color: conBlack.withOpacity(.8),
              ))
        ],
      ),
    );
  }
}
