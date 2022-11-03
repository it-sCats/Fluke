import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //this size to provide total height and width
    return Container(
      height: size.height,
      width: double.infinity,
    );
  }
}
