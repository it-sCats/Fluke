import 'package:flukepro/components/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class eventList extends StatelessWidget {
  Future<dynamic> EventQuery;

  eventList(this.EventQuery);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: FutureBuilder(

          //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
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

                    //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                    return event(
                        //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها

                        title: eventData['title'],
                        image: eventData['image'],
                        description: eventData['description'],
                        field: eventData['field'],
                        starterDate: eventData['starterDate'],
                        endDate: eventData['endDate'],
                        starterTime: eventData['starterTime'],
                        endTime: eventData['endTime'],
                        eventType: eventData['eventType'],
                        creationDate: eventData['creationDate'],
                        acceptsParticapants: eventData['acceptsParticapants'],
                        eventVisibilty: eventData['eventVisibility']);
                  },
                  itemCount: snapshot.data?.length,
                );
              }
            }
          }),
    );
  }
}
