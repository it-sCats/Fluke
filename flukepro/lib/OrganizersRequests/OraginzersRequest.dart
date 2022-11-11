import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/errorsHandling/AuthExceptionHandler.dart';
import 'package:flukepro/utils/authentication.dart';
import 'package:flutter/material.dart';

import '../components/cons.dart';
import '../components/customWidgets.dart';

class OrgRequest extends StatefulWidget {
  OrgRequest(
      {this.name, //name of the company
      this.eventsType, //types of events they are specilized in
      this.brief,
      this.email,
      this.phoneNum,
      this.docId}); //the documentId of requests so we can update the status of the request
  String? name;
  String? brief;
  String? phoneNum;
  String? email;
  String? eventsType;
  String? docId;

  @override
  State<OrgRequest> createState() => _OrgRequestState();
}

class _OrgRequestState extends State<OrgRequest> {
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
        padding:
            const EdgeInsets.only(left: 18.0, right: 30, top: 18, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, //محاذاة لليمين
          children: [
            Text(
              widget.name.toString(), //هنا يعرض الإسم المدخل للكونستركتر
              textAlign: TextAlign.center,
              style: conLittelTxt12.copyWith(fontSize: 20),
            ),
            Text(
              widget.eventsType.toString(),
              textAlign: TextAlign.center,
              style: conTxtFeildHint.copyWith(fontSize: 14),
            ),
            conRequestDivider(), //الخط الفاصل بين المعلومات
            Wrap(children: [
              //تمت إضافة راب ويدجيت لإجبار النص على النزول سطر في حال فات المساحة المحدودة
              Container(
                width: 430,
                child: Text(
                  widget.brief.toString(),
                  textAlign: TextAlign.right,
                  style: conTxtFeildHint.copyWith(fontSize: 14),
                ),
              ),
            ]),
            conRequestDivider(), //خظ فاصل
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              //last Row
              children: [
                Expanded(
                  //this will make the buttons algined right
                  child: Row(
                    children: [
                      CancleButton(
                        txt: 'رفض الطلب',
                        ontap: () {
                          //الدالة التي ترفض الطلبات
                          setState(() {
                            updatingRequesStatus(widget.docId,
                                'rejected'); //هنا سيتم تحديث حالة الطلب إلى مرفوض
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                      //ثم يتم إظهار نافذة تنبيه نؤكد رفض الطلب
                                      title: Text(
                                    'تم رفض الطلب',
                                    textAlign: TextAlign.center,
                                    style: conTxtFeildHint,
                                  ));
                                });
                          });
                          // //what happens when rejecting request
                          //
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        //من هنا يبدا زر القبول
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                10), //نعطي بادينق بدل من تحديد عرض للزر لمنع الأخطاء الناتجة عند تغيير حجم الشاشة
                        height: 30,
                        decoration: conCTADecoration.copyWith(
                            borderRadius: BorderRadius.circular(9)),
                        child: InkWell(
                          onTap: () async {
                            //دالة قبول طلب الشركة المنظمة
                            final result = await Authentication().signUp(
                                widget.email.toString(),
                                '123456'); //اولا يتم إنشاء حساب للشركة
                            result.when(
                                //تعيد دالة التسجيل نتيجة قد تكون خطأ في هذه الحالة يتم عرض الخطأ في سناك بار
                                (error) => setState(() {
                                      String massege = AuthExceptionHandler
                                          .generateErrorMessage(
                                              AuthExceptionHandler
                                                  .handleAuthException(error));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                          massege,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Cairo',
                                          ),
                                        )),
                                      );
                                    }), (success) {
                              //وعندما تكون النتيجة نجاح فإنها ترجع قيمة تحوي المستخدم التي من خلالها بإمكاننا ان نصل للإيميل
                              _auth.sendPasswordResetEmail(
                                  //ثم يتم إرسال إيميل لأعادة تعيين كلمة مرور
                                  email: widget.email.toString());

                              setState(() {
                                buttonText =
                                    'تم تأكيد الطلب'; //يتم إظهار رمز يوضح أن عملية التأكيد تمت
                                isVerfied = true;
                              });
                              addingOrganizer(
                                  //وهنا يتم إضافة المنظم لقاعدة البيانات بالمعلومات الموجودة
                                  //here we Added the Organizer to the database
                                  success!,
                                  widget.name.toString(),
                                  widget.eventsType.toString(),
                                  widget.phoneNum.toString());
                            });
                            updatingRequesStatus(widget.docId,
                                'accepted'); //changing the status of request
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
                                buttonText,
                                textAlign: TextAlign.center,
                                style: conCTATxt.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.email.toString(),
                  textAlign: TextAlign.right,
                  style: conTxtFeildHint.copyWith(fontSize: 14),
                ),
                Container(
                  height: 15,
                  child: new VerticalDivider(
                    color: Color(0xff282828).withOpacity(.5),
                    width: 20,
                    thickness: 1,
                  ),
                ),
                Text(
                  widget.phoneNum.toString(),
                  textAlign: TextAlign.right,
                  style: conTxtFeildHint.copyWith(fontSize: 14),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//دالة إضافة المنظم لقاعدة البيانات
addingOrganizer(
  User user,
  String name,
  String eventsTypes,
  String phone,
) async {
  final _firestore = FirebaseFirestore.instance;
  //2 is for participants
  await _firestore
      .collection('users')
      .doc('organizingAgens')
      .collection('organizingAgen')
      .doc(user.uid)
      .set({
    "email": user.email,
    "name": name,
    "eventsTypes": eventsTypes,
    "phone": phone
  });
}

//دالة تحديث حالة الطلب
updatingRequesStatus(docId, status) async {
  final _firestore = FirebaseFirestore.instance;
  await _firestore.collection('requests').doc(docId).update({'status': status});
}
