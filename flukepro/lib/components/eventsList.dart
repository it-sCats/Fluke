import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class eventList extends StatelessWidget {
  Future<dynamic> EventQuery;

  eventList(
    this.EventQuery,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FutureBuilder(

          //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
          future: EventQuery,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //في حال لم يتم الاتصال يتم إظهار علامة تحميل
              return CircularProgressIndicator();
            } else {
              if (!snapshot.hasData || snapshot.data.length == 0) {
                return Center(
                  child: Image.asset(
                      'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                );
                //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
              } else {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  reverse: defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform ==
                              TargetPlatform
                                  .iOS //خاصية يحتاجها الموبايل ليعرض الليستة بشكل صحيح

                      ? true
                      : false,
                  scrollDirection:
                      defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform ==
                                  TargetPlatform
                                      .iOS //حتى يتم التمرير بالجنب في الموبايل

                          ? Axis.horizontal
                          : Axis.vertical,
                  itemBuilder: (context, index) {
                    var eventData = snapshot.data![index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: eventHorizCard(
                          //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                          title: eventData['title'],
                          image: eventData['image'],
                          description: eventData['description'],
                          field: eventData['field'],
                          location: eventData['location'],
                          city: eventData['eventCity'],
                          starterDate: eventData['starterDate'],
                          endDate: eventData['endDate'],
                          starterTime: eventData['starterTime'],
                          endTime: eventData['endTime'],
                          eventType: eventData['eventType'],
                          creationDate: eventData['creationDate'],
                          acceptsParticapants: eventData['acceptsParticapants'],
                          eventVisibilty: eventData['eventVisibility']),
                    );
                  },
                  itemCount: snapshot.data?.length,
                );
              }
            }
          }),
    );
  }
}

class VisitorVerticalEventList extends StatelessWidget {
  Future<dynamic> EventQuery;

  VisitorVerticalEventList(
    this.EventQuery,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: double.infinity,
      child: FutureBuilder(

          //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
          future: EventQuery,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //في حال لم يتم الاتصال يتم إظهار علامة تحميل
              return Container(
                  width: 100, height: 100, child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData || snapshot.data.length == 0) {
                return Center(
                  child: Image.asset(
                      'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                );
                //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var eventData = snapshot.data![index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: eventVertiCard(
                          //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                          title: eventData['title'],
                          image: eventData['image'],
                          description: eventData['description'],
                          field: eventData['field'],
                          location: eventData['location'],
                          city: eventData['eventCity'],
                          starterDate: eventData['starterDate'],
                          endDate: eventData['endDate'],
                          starterTime: eventData['starterTime'],
                          endTime: eventData['endTime'],
                          eventType: eventData['eventType'],
                          creationDate: eventData['creationDate'],
                          acceptsParticapants: eventData['acceptsParticapants'],
                          eventVisibilty: eventData['eventVisibility']),
                    );
                  },
                  itemCount: snapshot.data?.length,
                );
              }
            }
          }),
    );
  }
}
