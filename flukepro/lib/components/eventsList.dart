import 'package:flukepro/components/events.dart';
import 'package:flutter/material.dart';

class eventList extends StatelessWidget {
  Future<dynamic> EventQuery;
  eventList(this.EventQuery);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: FutureBuilder(
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
                return ListView.builder(itemBuilder: (context, index) {
                  final eventData = snapshot.data![index];
                  return event(
                      title: eventData['title'],
                      image: eventData['image'],
                      description: eventData[' description'],
                      starterDate: eventData['starterDate'],
                      endDate: eventData['endDate'],
                      starterTime: eventData[' starterTime'],
                      endTime: eventData['endTime'],
                      creationDate: eventData[' creationDate'],
                      acceptsParticapants: eventData['acceptsParticapants'],
                      eventVisibilty: eventData[' eventVisibilty']);
                });
              }
            }
          }),
    );
  }
}
