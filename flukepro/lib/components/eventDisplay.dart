import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'cons.dart';
import 'customWidgets.dart';

class eventDisplay extends StatelessWidget {
  String title;
  String? image;
  String? eventType;
  Timestamp starterDate;
  Timestamp endDate;
  int starterTime;
  int endTime;
  var field;
  String description;
  Timestamp creationDate;
  List<String>? room;
  String? location;
  String? city;
  bool acceptsParticapants;
  List<String>? targetedAudiance;
  bool eventVisibilty;

  eventDisplay({
    required this.title,
    required this.description,
    this.image,
    this.eventType,
    required this.starterDate,
    required this.endDate,
    required this.starterTime,
    required this.endTime,
    this.field,
    required this.creationDate,
    this.location,
    this.city,
    required this.acceptsParticapants,
    required this.eventVisibilty,
    this.room,
    this.targetedAudiance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 40,
                )),
            SizedBox(
              width: double.infinity,
              height: 400,
              child: image == null
                  ? Image.asset('images/emptyIamge.jpg')
                  : Image.file(File(image!)),
            ),
            Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8),
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        eventType.toString(),
                        style: conTxtFeildHint.copyWith(color: conBlack),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8),
                    child: Text(
                      DateTime.fromMicrosecondsSinceEpoch(
                              starterDate.microsecondsSinceEpoch)
                          .toString()
                          .split(' ')
                          .first,
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8),
                    child: Text(
                      'وقت الحدث:',
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            endTime.toString(),
                            style: conTxtFeildHint,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: 24,
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              child: Text(
                                starterTime.toString(),
                                style: conTxtFeildHint,
                              ),
                            ),
                          ))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        city.toString(),
                        style: conTxtFeildHint,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      location.toString(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: conTxtFeildHint,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        field.toString(),
                        style: conTxtFeildHint.copyWith(color: conBlack),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      description.toString(),
                      style: conTxtFeildHint,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Text(
                          'حفظ كمسودة',
                          style: conTxtFeildHint.copyWith(
                              color: Colors.blueGrey, fontSize: 18),
                        ),
                        onTap: () {},
                      ),
                      halfCTA(txt: 'نشر الحدث', onTap: () async {}),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
