import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/OrganizersRequests/OraginzersRequest.dart';
import 'package:flutter/material.dart';

class requestsList extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  Future getRequests() async {
    //دالة لإحضار الطلبات التي تحمل حالة الانتظار
    QuerySnapshot qn = await _firestore
        .collection('requests')
        .where('status', isEqualTo: "waiting")
        .get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(),
      child: FutureBuilder(
        //بناء الدكيومنتس التي تم إحضارها من قاعدة البياانات
        future: getRequests(),
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
                itemCount:
                    snapshot.data.length, //عدد الدكيومنتس التي تم إحضارها
                itemBuilder: (context, index) {
                  final requests = snapshot.data![index];

                  return OrgRequest(
                      //هنا يتم إرجاع الطلب ووضعه في الويدجيت وبناء عدد من الطلبات على عدد الدكيومنتس التي تم إحضارها
                      name: requests['name'],
                      eventsType: requests['eventsType'],
                      email: requests['email'],
                      phoneNum: requests['phone'],
                      brief: requests['brief'],
                      docId: requests.id);
                },
              );
            }
          }
        },
      ),
    );
  }
}
