import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/OrganizersRequests/OraginzersRequest.dart';
import 'package:flutter/material.dart';

import 'EventReports.dart';

Future getReports() async {
  QuerySnapshot qn =
      await FirebaseFirestore.instance.collection('reports').get();

  return qn.docs;
}

class EventReportsList extends StatelessWidget {
  const EventReportsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(),

      child: FutureBuilder(
        //بناء الدكيومنتس التي تم إحضارها من قاعدة البياانات
        future: getReports(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //في حال لم يتم الاتصال يتم إظهار علامة تحميل
            return CircularProgressIndicator();
          } else {
            if (!snapshot.hasData || snapshot.data.length == 0) {
              return Center(
                child: Image.asset('images/Hands Phone.png',
                    width: 200), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
              );
              //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
            } else {
              return ListView.builder(
                itemCount:
                    snapshot.data.length, //عدد الدكيومنتس التي تم إحضارها
                itemBuilder: (context, index) {
                  final reporta = snapshot.data![index];

                  return eventReport(
                    reportID: reporta.id,
                    //هنا يتم إرجاع الطلب ووضعه في الويدجيت وبناء عدد من الطلبات على عدد الدكيومنتس التي تم إحضارها
                    eventID: reporta['eventID'],
                    eventName: reporta['eventName'],
                    OrganizerID: reporta['OrganizerID'],
                    reportReason: reporta['reportReason'],
                    reporterID: reporta['reporterID'],
                    reporterName: reporta['reporterName'],
                  );
                },
              );
            }
          }
        },
      ),

      // child:  ListView.builder(itemBuilder: itemBuilder)
    );
  }
}
