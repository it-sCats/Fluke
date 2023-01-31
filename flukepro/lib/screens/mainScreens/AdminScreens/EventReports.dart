import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/errorsHandling/AuthExceptionHandler.dart';
import 'package:flukepro/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import '../../../components/cons.dart';
import '../../../components/customWidgets.dart';
import '../../../components/eventDisplay.dart';
import '../../../utils/SigningProvider.dart';
import '../../../utils/notificationProvider.dart';

class eventReport extends StatefulWidget {
  eventReport(
      {this.reportID,
      this.eventID, //name of the company
      this.eventName, //types of events they are specilized in
      this.reportReason,
      this.OrganizerID,
      this.reporterID,
      this.reporterName}); //the documentId of requests so we can update the status of the request
  String? reportID;
  String? eventName;
  String? eventID;
  String? reportReason;
  String? reporterName;
  String? reporterID;
  String? OrganizerID;

  @override
  State<eventReport> createState() => _eventReportState();
}

class _eventReportState extends State<eventReport> {
  final _auth = FirebaseAuth.instance;

  String buttonText = 'قبول الطلب';
  bool isVerfied = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      //هذا البوردر الخارجي
      margin: EdgeInsets.all(5), //لإعطاء مساحة بين كل طلب
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Color(0xff282828).withOpacity(.5))),
      child: Padding(
        //المساحة بين المحتوى والبوردر
        padding: EdgeInsets.only(left: 18.0, right: 30, top: 18, bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, //محاذاة لليمين
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                "تم التبليغ عن حدث " +
                    widget.eventName.toString() +
                    " بأنه " +
                    widget.reportReason
                        .toString(), //هنا يعرض الإسم المدخل للكونستركتر
                textAlign: TextAlign.right,
                style: conLittelTxt12.copyWith(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CancleButton(
                  txt: 'رفض البلاغ',
                  ontap: () {
                    FirebaseFirestore.instance
                        .collection('reports')
                        .doc(widget.reportID)
                        .delete();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  //من هنا يبدا زر delete
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          10), //نعطي بادينق بدل من تحديد عرض للزر لمنع الأخطاء الناتجة عند تغيير حجم الشاشة
                  height: 40,
                  decoration: conCTADecoration.copyWith(
                      borderRadius: BorderRadius.circular(9),
                      color: conRed.withOpacity(.9)),
                  child: InkWell(
                    onTap: () async {
                      var inf = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.OrganizerID)
                          .get();
                      int reportNum = inf['reports'];

                      if (inf['reports'] < 3) {
                        showDialog(
                            //save to drafts dialog
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                icon: Icon(
                                  Icons.warning,
                                  color: conRed,
                                  size: 50,
                                ),
                                title: Text(
                                  'هل قمت براجعة الحدث بشكل دقيق؟',
                                  textAlign: TextAlign.center,
                                  style:
                                      conHeadingsStyle.copyWith(fontSize: 15),
                                ),
                                content: Text(
                                    'سيتم حذف الحدث بشكل نهائي مع إنذار المنظم',
                                    textAlign: TextAlign.center,
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 15)),
                                actions: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        ' إالغاء الحذف',
                                        textAlign: TextAlign.center,
                                        style: conHeadingsStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      )),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: conRed,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: InkWell(
                                        onTap: () async {
                                          //send notification to organizer
                                          FirebaseFirestore.instance
                                              .collection('events')
                                              .doc(widget.eventID)
                                              .delete()
                                              .whenComplete(() {
                                            setState(() {
                                              isVerfied = true;
                                            });
                                          });
                                          FirebaseFirestore.instance
                                              .collection('reports')
                                              .doc(widget.reportID)
                                              .delete();
                                          //add one to reports in user doc
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.OrganizerID)
                                              .update({
                                            'reports': FieldValue.increment(1)
                                          });
                                          //add notification
                                          sendPushToOrgnaizerNotification(
                                              "لمخالفته سياسات تطبيقاتناً",
                                              'لقد تم حذف حدث ${widget.eventName}',
                                              '',
                                              widget.eventID,
                                              widget.OrganizerID);
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.OrganizerID)
                                              .collection('notification')
                                              .add({
                                            'title': '',
                                            'date': 'لقد تم حدف حدث ${widget.eventName}' +
                                                "لمخالفته سياسات تطبيقنا, في حال تكررت المخالفة سيتم حذف حسابك نهائياً ",
                                            'creatorID':
                                                siggning().loggedUser!.uid,
                                            'creationDate': Timestamp.now()
                                          });
                                          //امسح البلاغ
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                              'تم حذف الحدث بنجاح',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                              ),
                                            )),
                                          );
                                        },
                                        child: Text(
                                          'حدف',
                                          textAlign: TextAlign.center,
                                          style: conHeadingsStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ],
                                buttonPadding: EdgeInsets.all(20),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 100),
                              );
                            });
                      } else {
                        if (inf['reports'] == 3) {
                          //delete ORganizer
                          //delete all events
                          showDialog(
                              //save to drafts dialog
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  icon: Icon(
                                    Icons.warning,
                                    color: conRed,
                                    size: 50,
                                  ),
                                  title: Text(
                                    'هذا ثالث حدث يتم حذفه لهذا المنظم!',
                                    textAlign: TextAlign.center,
                                    style:
                                        conHeadingsStyle.copyWith(fontSize: 15),
                                  ),
                                  content: Text(
                                      'سيتم حذف حساب منظم الحدث وحدف كل أحداثه في حال حدف هذا الحدث',
                                      textAlign: TextAlign.center,
                                      style: conHeadingsStyle.copyWith(
                                          fontSize: 15)),
                                  actions: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          ' إالغاء الحذف',
                                          textAlign: TextAlign.center,
                                          style: conHeadingsStyle.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: conRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: InkWell(
                                          onTap: () async {
                                            //send notification to organizer
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(widget.OrganizerID)
                                                .delete()
                                                .whenComplete(() {
                                              setState(() {
                                                isVerfied = true;
                                              });
                                            });
                                            //here we fetch all events that the Organizer did
                                            var events = await FirebaseFirestore
                                                .instance
                                                .collection('events')
                                                .where('creatorID',
                                                    isEqualTo:
                                                        widget.OrganizerID)
                                                .get(); //and we delete all of them
                                            for (var event in events.docs) {
                                              FirebaseFirestore.instance
                                                  .collection('event')
                                                  .doc(event.id)
                                                  .delete();
                                            }
                                            //add one to reports in user doc

                                            //امسح البلاغ
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                'تم حذف الحدث بنجاح',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Cairo',
                                                ),
                                              )),
                                            );
                                          },
                                          child: Text(
                                            'حدف',
                                            textAlign: TextAlign.center,
                                            style: conHeadingsStyle.copyWith(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                  buttonPadding: EdgeInsets.all(20),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 100),
                                );
                              });
                          //send email to inform about the deletion
                          final Email email = Email(
                            body:
                                'لقد تم حذف حسابك نهائياً من تطبيق fluke مخالفة قواعد وسياسات التطبيق عدة مرات، ',
                            subject: 'حذف حسابك لدى Fluke',
                            recipients: [widget.OrganizerID.toString()],
                            isHTML: false,
                          );

                          await FlutterEmailSender.send(email);
                        }
                      }

                      //add the delete verification
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: isVerfied,
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          " حدف الحدث",
                          textAlign: TextAlign.center,
                          style: conCTATxt.copyWith(
                              fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  //من هنا يبدا زر القبول
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          10), //نعطي بادينق بدل من تحديد عرض للزر لمنع الأخطاء الناتجة عند تغيير حجم الشاشة
                  height: 40,
                  decoration: conCTADecoration.copyWith(
                      borderRadius: BorderRadius.circular(9)),
                  child: InkWell(
                    onTap: () async {
                      DocumentSnapshot<Map<String, dynamic>> eventInfo =
                          await FirebaseFirestore.instance
                              .collection('events')
                              .doc(widget.eventID)
                              .get();
                      var inf = eventInfo.data();
                      showModalBottomSheet(
                          isScrollControlled: true,
                          elevation: 100,
                          context: context,
                          builder: (context) => eventDisplay(
                                //نحي ايقونه الابلاغ لما يستعرضه الادمن وحطي حدف
                                wholePage: false,
                                justDisplay: false,
                                id: inf!['id'],
                                title: inf!['title'],
                                description: inf!['description'],
                                starterDate: inf!['starterDate'],
                                location: inf!['location'],
                                image: inf!['image'],
                                endDate: inf!['endDate'],
                                starterTime: inf!['starterTime'],
                                eventType: inf!['eventType'],
                                endTime: inf!['endTime'],
                                field: inf!['field'],
                                creationDate: inf!['creationDate'],
                                city: inf!['eventCity'],
                                acceptsParticapants:
                                    inf!['acceptsParticapants'],
                                eventVisibilty: inf!['eventVisibility'],

                                creatorID: inf!['creatorID'],
                                creatorName: inf!['creatorName'], //يوم المرأة
                              ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'عرض الحدث',
                          textAlign: TextAlign.center,
                          style: conCTATxt.copyWith(
                              fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//دالة إضافة المنظم لقاعدة البيانات
