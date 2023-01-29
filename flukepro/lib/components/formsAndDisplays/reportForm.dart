import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';

class reportForm extends StatelessWidget {
  String userId;
  String reporterName;
  String eventOrganizerID;
  String eventID;
  String eventName;
  reportForm(
      {required this.userId,
      required this.reporterName,
      required this.eventID,
      required this.eventName,
      required this.eventOrganizerID});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  )),
              Text(
                'الإبلاغ عن الحدث',
                style: conHeadingsStyle.copyWith(fontSize: 20),
              )
            ],
          ),
          Divider(),
          Text(
            'ما سبب البلاغ الذي تقدمه؟',
            style: conLittelTxt12,
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      enableDrag: true,
                      elevation: 0,
                      context: context,
                      builder: (context) => verifiyReport(
                          'يدعو للفساد أو التخريب ',
                          userId,
                          eventID,
                          eventName,
                          reporterName,
                          eventOrganizerID));
                },
                child: Text(
                  'يدعو للفساد أو التخريب ',
                  style: conHeadingsStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      enableDrag: true,
                      elevation: 0,
                      context: context,
                      builder: (context) => verifiyReport(
                          'يحوي على كلام بذيء أو غير لائق',
                          userId,
                          eventID,
                          eventName,
                          reporterName,
                          eventOrganizerID));
                },
                child: Text(
                  'يحوي على كلام بذيء أو غير لائق',
                  style: conHeadingsStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      enableDrag: true,
                      elevation: 0,
                      context: context,
                      builder: (context) => verifiyReport(
                          'حدث وهمي لاوجود له',
                          userId,
                          eventID,
                          eventName,
                          reporterName,
                          eventOrganizerID));
                },
                child: Text(
                  'حدث وهمي لاوجود له',
                  style: conHeadingsStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      enableDrag: true,
                      elevation: 0,
                      context: context,
                      builder: (context) => verifiyReport(
                          'حدث غير أخلاقي أو عنصري',
                          userId,
                          eventID,
                          eventName,
                          reporterName,
                          eventOrganizerID));
                },
                child: Text(
                  'حدث غير أخلاقي أو عنصري',
                  style: conHeadingsStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class verifiyReport extends StatefulWidget {
  String reportReason;
  String userId;
  String reporterName;
  String eventOrganizerID;
  String eventID;
  String eventName;

  verifiyReport(this.reportReason, this.userId, this.eventID, this.eventName,
      this.reporterName, this.eventOrganizerID);

  @override
  State<verifiyReport> createState() => _verifiyReportState();
}

class _verifiyReportState extends State<verifiyReport> {
  bool isDone = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/reportVer.png',
              width: 190,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'شكراً على إبلاغنا',
              style: conHeadingsStyle,
            ),
            Text(
              textAlign: TextAlign.right,
              ':سنقوم بالتالي ',
              style: conlabelsTxt,
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'سيقوم فريقنا بمراجعة الحدث للتأكد من صحة\n البلاغ و الكشف عن أي مخالفة لسياستنا',
                      style: conlabelsTxt.copyWith(
                          color: conBlack.withOpacity(.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.mark_chat_read,
                      size: 25,
                      color: conORange.withOpacity(.8),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'في حال كان الحدث مخالف سيتم حذفه ولن يظهر \nلأحد مجدداً وسيتم تنبيه المخالف',
                      style: conlabelsTxt.copyWith(
                          color: conBlack.withOpacity(.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.delete_forever,
                      size: 30,
                      color: conORange.withOpacity(.8),
                    ),
                  ],
                ),
              ],
            ),
            Align(
                child: Visibility(
              visible: isDone,
              child: Icon(
                Icons.done,
                size: 30,
                color: Colors.green,
              ),
            )),
            lessEdgeCTA(
                txt: 'تقديم البلاغ',
                onTap: () async {
                  final prevRequest = await FirebaseFirestore.instance
                      .collection('reports')
                      .where('reporterID', isEqualTo: widget.userId)
                      .where('eventID', isEqualTo: widget.eventID)
                      .get();
                  if (prevRequest.docs.isEmpty) {
                    FirebaseFirestore.instance.collection('reports').add({
                      'reportReason': widget.reportReason,
                      'eventID': widget.eventID,
                      'eventName': widget.eventName,
                      'OrganizerID': widget.eventOrganizerID,
                      'reporterID': widget.userId,
                      'reporterName': widget.reporterName
                    }).whenComplete(() {
                      setState(() {
                        isDone = true;
                      });
                    });
                  } else {
                    showDialog(
                        //save to drafts dialog
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'لقد أبلغت مسبقأً!',
                              textAlign: TextAlign.center,
                              style: conHeadingsStyle.copyWith(fontSize: 15),
                            ),
                            content: Text(
                              'سيصلك اشعار فور حصول أي تحديثات فيما يتعلق ببلاغك',
                              textAlign: TextAlign.center,
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                            actions: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    color: conORange,
                                    borderRadius: BorderRadius.circular(10)),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'حسناً',
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
                  }
                })
          ],
        ),
      ),
    );
  }
}
