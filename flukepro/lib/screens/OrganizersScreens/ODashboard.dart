import 'package:flutter/material.dart';

import 'Sections/ongoingEvents.dart';

class Odashboard extends StatelessWidget {
  const Odashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 4,
      children: [ongoingEvents()],
    );
  }
}
