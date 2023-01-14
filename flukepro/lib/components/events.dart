import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/screens/OrganizersScreens/OHome.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class eventHorizCard extends StatefulWidget {
  //الكارد الي تطلع للزائر في الاحداث الاكثر تداولا
  String id;
  String title;
  String? image;
  String? eventType;
  Timestamp starterDate;
  Timestamp endDate;
  bool isLiked;
  String starterTime;
  String endTime;
  var field;
  String description;
  Timestamp creationDate;
  List<String>? room;
  String? location;
  String? city;
  bool acceptsParticapants;
  List<String>? targetedAudiance;
  bool eventVisibilty;
  int? visitorsNum;

  eventHorizCard({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.eventType,
    required this.starterDate,
    required this.endDate,
    required this.starterTime,
    required this.endTime,
    required this.isLiked,
    this.field,
    required this.creationDate,
    this.location,
    this.city,
    required this.acceptsParticapants,
    required this.eventVisibilty,
    this.room,
    this.targetedAudiance,
    this.visitorsNum,
  });

  @override
  State<eventHorizCard> createState() => _eventHorizCardState();
}

class _eventHorizCardState extends State<eventHorizCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      width: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 350 //الطول العرض بناء على نوع المنصة التي يستخدمها المستخدم
          : 300,
      height: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 200
          : 200,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            widget.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      widget.image!,
                      fit: BoxFit.cover,
                    ))
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(
                          fontSize: 17, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Row(
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
                                  widget.city.toString(),
                                  style:
                                      conOnboardingText.copyWith(fontSize: 11),
                                )
                              ],
                            )),
                        Expanded(
                            //نحي  الاكسباندد وحطس التاريخ قبل اللوكيشن
                            flex: 3,
                            child: Text(
                              widget.starterDate
                                  .toDate()
                                  .toString()
                                  .split(' ')
                                  .first,
                              textAlign: TextAlign.right,
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class rectangleEvent extends StatelessWidget {
  //الكارد الي تطلع للزائر في الاحداث الاكثر تداولا
  String title;
  String? image;
  String? eventType;
  Timestamp starterDate;
  Timestamp endDate;
  String starterTime;
  String endTime;
  var field;
  String description;
  Timestamp creationDate;
  List<String>? room;
  String? location;
  String? city;
  bool acceptsParticapants;
  List<String>? targetedAudiance;
  bool eventVisibilty;
  int? visitorsNum;

  rectangleEvent({
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
    this.visitorsNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      width: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 450 //الطول العرض بناء على نوع المنصة التي يستخدمها المستخدم
          : 300,
      height: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 300
          : 200,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      image!,
                      fit: BoxFit.fill,
                    ))
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(
                          fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Row(
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
                                  style:
                                      conOnboardingText.copyWith(fontSize: 13),
                                )
                              ],
                            )),
                        Expanded(
                            //نحي  الاكسباندد وحطس التاريخ قبل اللوكيشن
                            flex: 3,
                            child: Text(
                              starterDate.toDate().toString().split(' ').first,
                              textAlign: TextAlign.right,
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ))
                      ],
                    ),
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

class eventVertiCard extends StatelessWidget {
  //الكارد الي تطلع للزائر في الاحداث الاكثر تداولا
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

  eventVertiCard({
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
      width: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 200 //الطول العرض بناء على نوع المنصة التي يستخدمها المستخدم
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(
                          fontSize: 23, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Row(
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
                                  style:
                                      conOnboardingText.copyWith(fontSize: 15),
                                )
                              ],
                            )),
                        Expanded(
                            flex: 4,
                            child: Text(
                              starterDate.toDate().toString().split(' ').first,
                              textAlign: TextAlign.right,
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ))
                      ],
                    ),
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

class OrganizerEventPreview extends StatelessWidget {
  //الكارد الي تطلع للمنظم  في الاحداث متاعه
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

  OrganizerEventPreview({
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
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      width: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 200 //الطول العرض بناء على نوع المنصة التي يستخدمها المستخدم
          : 300,
      height: defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS
          ? 200
          : 200,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                image.toString(),
                fit: BoxFit.cover,
              ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(
                          fontSize: 17, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              starterDate.toDate().toString().split(' ').first,
                              textAlign: TextAlign.right,
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
