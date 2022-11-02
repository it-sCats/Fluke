import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    // this size Provide us total height and width of the screen
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
           
            child: Image(image: ('images/ُEventmanaging.png'),
          )
        ],
      ),
    );
  }
}
