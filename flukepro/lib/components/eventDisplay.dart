// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import 'cons.dart';
//
// class eventDisplay extends StatelessWidget {
//   String title;
//   String? image;
//   String? eventType;
//   Timestamp starterDate;
//   Timestamp endDate;
//   int starterTime;
//   int endTime;
//   var field;
//   String description;
//   Timestamp creationDate;
//   List<String>? room;
//   String? location;
//   String? city;
//   bool acceptsParticapants;
//   List<String>? targetedAudiance;
//   bool eventVisibilty;
//
//   eventDisplay({
//     required this.title,
//     required this.description,
//     this.image,
//     this.eventType,
//     required this.starterDate,
//     required this.endDate,
//     required this.starterTime,
//     required this.endTime,
//     this.field,
//     required this.creationDate,
//     this.location,
//     this.city,
//     required this.acceptsParticapants,
//     required this.eventVisibilty,
//     this.room,
//     this.targetedAudiance,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             IconButton(
//                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Navigator.pop(context);
//                 },
//                 icon: Icon(
//                   Icons.arrow_back,
//                   size: 40,
//                 )),
//             SizedBox(
//               width: double.infinity,
//               height: 400,
//               child: Image.file(File(image!)),
//             ),
//             Container(
//               margin: EdgeInsets.all(20),
//               color: Colors.white,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 8),
//                     child: Text(
//                       title,
//                       textAlign: TextAlign.right,
//                       style: conHeadingsStyle.copyWith(fontSize: 20),
//                       textDirection: TextDirection.rtl,
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: Directionality(
//                       textDirection: TextDirection.rtl,
//                       child: Text(
//                         eventType.toString(),
//                         style: conTxtFeildHint.copyWith(color: conBlack),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 8),
//                     child: Text(
//                       starterDate.toString(),
//                       textAlign: TextAlign.right,
//                       style: conHeadingsStyle.copyWith(fontSize: 20),
//                       textDirection: TextDirection.rtl,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 8),
//                     child: Text(
//                       'وقت الحدث:',
//                       textAlign: TextAlign.right,
//                       style: conHeadingsStyle.copyWith(fontSize: 20),
//                       textDirection: TextDirection.rtl,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           child: Text(
//                             endTime.toString(),
//                             style: conTxtFeildHint,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                           flex: 1,
//                           child: SizedBox(
//                             width: 24,
//                           )),
//                       Expanded(
//                           flex: 3,
//                           child: Container(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             child: InkWell(
//                               child: Text(
//                                 starterTime.toString(),
//                                 style: conTxtFeildHint,
//                               ),
//                             ),
//                           ))
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: Directionality(
//                       textDirection: TextDirection.rtl,
//                       child: Text(
//                         city.toString(),
//                         style: conTxtFeildHint,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: TextFormField(
//                       controller: _eventLocationCont,
//                       textDirection: TextDirection.rtl,
//                       textAlign: TextAlign.right,
//                       decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 20),
//                           hintText: 'رابط مكان الحدث على قوقل مابل',
//                           hintStyle: conTxtFeildHint,
//                           filled: true,
//                           fillColor: Color(0xffF1F1F1),
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(10))),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: Directionality(
//                       textDirection: TextDirection.rtl,
//                       child: DropdownButtonFormField(
//                         decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 20),
//                             hintText: 'المجال',
//                             hintStyle: conTxtFeildHint,
//                             filled: true,
//                             fillColor: Color(0xffF1F1F1),
//                             border: OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius: BorderRadius.circular(10))),
//                         style: conTxtFeildHint.copyWith(color: conBlack),
//                         items: fields.map((String items) {
//                           return DropdownMenuItem(
//                             value: items,
//                             child: Text(
//                                 items), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           _eventFieldCont.text = value.toString();
//                         },
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: TextFormField(
//                       controller: _eventDescriptionCont,
//                       maxLines: 10,
//                       maxLength: 3000,
//                       textDirection: TextDirection.rtl,
//                       textAlign: TextAlign.right,
//                       decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           hintText:
//                               'وصف عن الحدث\n ما الهدف منه وماهي الانشطة التي سيحويها\n ..وما المشاكل التي سيعالجها',
//                           hintStyle: conTxtFeildHint,
//                           filled: true,
//                           fillColor: Color(0xffF1F1F1),
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(10))),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 8),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           'مكان إقامة الحدث:',
//                           textAlign: TextAlign.right,
//                           style: conHeadingsStyle.copyWith(fontSize: 20),
//                           textDirection: TextDirection.rtl,
//                         ),
//                         Text(
//                           'حدد  القاعات أو المساحات او المباني التي ستقام \nفيها الجلسات في حال وجود عدة أماكن.',
//                           textAlign: TextAlign.right,
//                           style: conHeadingsStyle.copyWith(
//                               fontSize: 13, fontWeight: FontWeight.normal),
//                           textDirection: TextDirection.rtl,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       _addTile(),
//                       Container(width: 200, child: roomsFields()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Align(
//                             alignment: Alignment.centerRight,
//                             child: Switch(
//                                 value: acceptsParticipants,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     acceptsParticipants = value;
//                                   });
//                                 })),
//                       ),
//                       Expanded(
//                           flex: 5,
//                           child: Text(
//                             'استقبال طلبات مشاركة',
//                             textAlign: TextAlign.right,
//                             style: conHeadingsStyle.copyWith(fontSize: 20),
//                             textDirection: TextDirection.rtl,
//                           )),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Align(
//                             alignment: Alignment.centerRight,
//                             child: Switch(
//                                 value: sendNotifications,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     sendNotifications = value;
//                                   });
//                                 })),
//                       ),
//                       Expanded(
//                           flex: 5,
//                           child: Text(
//                             'إشعار الفئة المستهدفة',
//                             textAlign: TextAlign.right,
//                             style: conHeadingsStyle.copyWith(fontSize: 20),
//                             textDirection: TextDirection.rtl,
//                           )),
//                     ],
//                   ),
//                   Visibility(
//                       visible: sendNotifications,
//                       child: Container(
//                         margin: EdgeInsets.symmetric(vertical: 10),
//                         child: TextFormField(
//                           textDirection: TextDirection.rtl,
//                           controller: _targetedAudienceCont,
//                           maxLines: 3,
//                           textAlign: TextAlign.right,
//                           decoration: InputDecoration(
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 20),
//                               hintText:
//                                   'مجال الفئة المستهدفة, إفصل بين كل كلمة تعبر\n عن مجالات الفئة المستهدفة بفاصلة ',
//                               hintStyle: conTxtFeildHint,
//                               filled: true,
//                               fillColor: Color(0xffF1F1F1),
//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                   borderRadius: BorderRadius.circular(10))),
//                         ),
//                       )),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       InkWell(
//                         child: Text(
//                           'حفظ كمسودة',
//                           style: conTxtFeildHint.copyWith(
//                               color: Colors.blueGrey, fontSize: 18),
//                         ),
//                         onTap: () {},
//                       ),
//                       halfCTA(
//                           txt: 'نشر الحدث',
//                           onTap: () async {
//                             if (_eventFormKey.currentState!.validate()) {
//                               setState(() {
//                                 isLoading = !isLoading;
//                               });
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text(
//                                   'جاري تحميل الحدث..',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: 'Cairo',
//                                   ),
//                                 )),
//                               );
//
//                               try {
//                                 _controllers.forEach((element) {
//                                   _controllersText.add(element.text);
//                                 });
//                                 final targetedAudience =
//                                     _targetedAudienceCont.text.split(',');
//                                 final event = await eventRef.add({
//                                   'image': imagePath,
//                                   'title': _eventNameCont.text,
//                                   'description': _eventDescriptionCont.text,
//                                   'eventType': _eventTypeCont.text,
//                                   'starterDate': starterDate,
//                                   'endDate': endDate,
//                                   'starterTime': int.parse(starterTime.text),
//                                   'endTime': int.parse(endTime.text),
//                                   'eventCity': _eventCityCont.text,
//                                   'location': _eventLocationCont.text,
//                                   'field': _eventFieldCont.text,
//                                   'rooms':
//                                       FieldValue.arrayUnion(_controllersText),
//                                   'acceptsParticapants': acceptsParticipants,
//                                   'sendNotification': sendNotifications,
//                                   'targetedAudiance':
//                                       FieldValue.arrayUnion(targetedAudience),
//                                   'eventVisibility': true,
//                                   'creationDate': Timestamp.now()
//                                 });
//                                 if (event == null) {
//                                   isLoading = false;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                       'حصل خطأ ما, لم يتم نشر حدثك, أعد المحاولة ..',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontFamily: 'Cairo',
//                                       ),
//                                     )),
//                                   );
//                                 } else {
//                                   isLoading = false;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                       'تم تحميل الحدث بنجاح..',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontFamily: 'Cairo',
//                                       ),
//                                     )),
//                                   );
//                                   Navigator.pushNamed(context, 'OHome');
//                                 }
//                               } on FirebaseAuthException catch (e) {}
//                             }
//                           }),
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
