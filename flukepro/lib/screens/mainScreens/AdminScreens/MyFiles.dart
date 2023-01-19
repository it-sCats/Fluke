import 'package:flutter/material.dart';

import '../../../components/cons.dart';

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
    required this.title,
    required this.imaged,
    required this.press,
  }) : super(key: key);

  final String title, imaged;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: Image.asset(
        imaged,
        // height: 100,
      ),
      title: Text(
        title,
        style: conlabelsTxt,
      ),
    );
  }
}

List demoMyCards = [
  Cards(title: "المنظمين", imaged: "images/organizer.png", press: () {}),
  Cards(title: "الزوار", imaged: "images/visitors.png", press: () {}),
  Cards(title: "المشاركين", imaged: "images/Perticipants.png", press: () {}),
  Cards(title: "الأحداث", imaged: "images/calendar.png", press: () {}),
  Cards(title: "البلاغات", imaged: "images/warning.png", press: () {}),
];
