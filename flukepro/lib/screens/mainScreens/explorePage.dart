import 'package:flutter/material.dart';

import '../../components/cons.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextFormField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: "...ابحث عن أحداث",
              hintStyle: conTxtFeildHint,
              prefixIcon: new Icon(Icons.search),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Color.fromARGB(255, 155, 5, 33)),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
