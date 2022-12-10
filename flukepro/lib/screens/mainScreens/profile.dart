import 'package:flutter/material.dart';

import '../../components/bottomNav.dart';

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
                InkWell(
                  child: Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  onTap: () {
                    print('should navigate');
                    Navigator.pushNamed(context, 'settings');
                  },
                ),
              ],
            )));
  }
}
