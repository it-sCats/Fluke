// import 'package:flukepro/screens/mainScreens/AdminScreens/my__files.dart';
// import 'package:flutter/material.dart';

// import '../../../components/cons.dart';
// import '../../../components/responsive.dart';
// import 'header.dart';
// import 'loadData.dart';

// class displaydataDashboardScreen extends StatefulWidget {
//   const displaydataDashboardScreen({super.key});

//   @override
//   State<displaydataDashboardScreen> createState() =>
//       _displaydataDashboardScreenState();
// }

// class _displaydataDashboardScreenState
//     extends State<displaydataDashboardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           // padding: EdgeInsets.all(defaultPadding),
//           child: Column(
//             children: [
//               Header(),
//               SizedBox(height: default_Padding),
//               Padding(
//                 padding: EdgeInsets.all(default_Padding),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 5,
//                       child: Column(
//                         children: [
//                           LoadVisistorData(),
//                         ],
//                       ),
//                     ),
//                     if (!Responsive.isMobile(context))
//                       SizedBox(width: default_Padding),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
