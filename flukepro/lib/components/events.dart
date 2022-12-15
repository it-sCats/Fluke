import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class event extends StatelessWidget {
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

  event({
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      margin: EdgeInsets.all(20),
      width: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 350 //الطول العرض بناء على نوع المنصة التي يستخدمها المستخدم
          : 300,
      height: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 350
          : 200,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.file(
                      fit: BoxFit.fill,
                      File(image.toString()),
                    ),
                  )
                : Image.asset(
                    'images/The Little Things Working.png',
                    fit: BoxFit.fill,
                  ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black12.withOpacity(.4),
                        Colors.black12.withOpacity(.9),
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: conHeadingsStyle.copyWith(
                        fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    description.toString().substring(0, 70) +
                        '\n أظهار المزيد..',
                    textAlign: TextAlign.right,
                    style: conHeadingsStyle.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        city.toString(),
                        style: conOnboardingText.copyWith(fontSize: 13),
                      )
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
