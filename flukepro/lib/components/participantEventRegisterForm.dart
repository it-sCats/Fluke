import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/components/creatingEventsForm.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/mainScreens/userInfoScreen.dart';
import '../utils/notificationProvider.dart';
import 'cons.dart';
import 'eventDisplay.dart';

final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

final _particiTypeFormKey = GlobalKey<FormState>();

class ParticiEventPrev extends StatefulWidget {
  String eventId;
  String eventTitle;
  String creatorId;

  ParticiEventPrev(this.eventId, this.eventTitle, this.creatorId);
  @override
  State<ParticiEventPrev> createState() => _ParticiEventPrevState();
}

class _ParticiEventPrevState extends State<ParticiEventPrev> {
  var participantType = [
    'راعي ذهبي',
    'راعي فضي ',
    'راعي بلاتينيوم',
    'عارض',
  ];
  TextEditingController _participantTypeCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: _particiTypeFormKey,
          child: Column(
            children: [
              Text(
                "نموذج المشاركة",
                style: conHeadingsStyle,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${Provider.of<siggning>(context, listen: false).userInfoDocument!['name']} ",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                    Text(
                      " :شركة",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${Provider.of<siggning>(context, listen: false).userInfoDocument!['interests']}",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                    Text(
                      " :المجال",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${Provider.of<siggning>(context, listen: false).userInfoDocument!['phone']}",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                    Text(
                      " :رقم الهاتف",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                  ],
                  // ${userInfoDoc!['name']}
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${user!.email}:الإيميل",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      ":إختر نوع المشاركة",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF000000)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField(
                    validator: ((value) {
                      if (value == null) {
                        return 'يجب أن تختار نوع المشاركة';
                      }
                    }),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        hintText: 'نوع المشاركة',
                        hintStyle: conTxtFeildHint,
                        filled: true,
                        fillColor: Color(0xffF1F1F1),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    style: conTxtFeildHint.copyWith(color: conBlack),
                    items: participantType.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                            items), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                      );
                    }).toList(),
                    onChanged: (value) {
                      _participantTypeCont.text = value.toString();
                    },
                  ),
                ),
              ),
              CTA(
                  txt: "تقديم الطلب",
                  isFullwidth: true,
                  onTap: () async {
                    if (_particiTypeFormKey.currentState!.validate()) {
                      var ref = await siggning().addJoinRequest(
                          eventId: widget.eventId,
                          eventName: widget.eventTitle,
                          userId: user!.uid,
                          name: Provider.of<siggning>(context, listen: false)
                              .userInfoDocument!['name'],
                          field: Provider.of<siggning>(context, listen: false)
                              .userInfoDocument!['interests'],
                          userPic: Provider.of<siggning>(context, listen: false)
                              .userInfoDocument!['profilePic'],
                          phone: Provider.of<siggning>(context, listen: false)
                              .userInfoDocument!['phone'],
                          email: user!.email,
                          joinType: _participantTypeCont.text,
                          context: context);

                      if (ref != 0) {
                        sendPushToOrgnaizerNotification(
                            ' شركة ${Provider.of<siggning>(context, listen: false).userInfoDocument!['name']} ترغب بالمشاركة في ${widget.eventTitle} الذي تنظمه كـ${_participantTypeCont.text}',
                            'طلب مشاركة',
                            Provider.of<siggning>(context, listen: false)
                                .userInfoDocument!['field'],
                            widget.eventId,
                            widget.creatorId);
                      }

                      //here we modifiy for request send request ID
                      //todo fix the notification by grouping the devices
                    }
                    // showDialog(
                    //     //save to drafts dialog
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         title: Text(
                    //           '!تم تقديم طلبك',
                    //           textAlign: TextAlign.center,
                    //           style: conHeadingsStyle.copyWith(fontSize: 15),
                    //         ),
                    //         content: Text(
                    //           'سيصلك اشعار فور قبول الطلب',
                    //           textAlign: TextAlign.center,
                    //           style: conHeadingsStyle.copyWith(
                    //               fontSize: 14, fontWeight: FontWeight.normal),
                    //         ),
                    //         actions: [
                    //           Container(
                    //             padding: EdgeInsets.symmetric(
                    //                 horizontal: 20, vertical: 10),
                    //             decoration: BoxDecoration(
                    //                 color: conORange,
                    //                 borderRadius: BorderRadius.circular(10)),
                    //             child: InkWell(
                    //                 onTap: () {
                    //                   Navigator.pushNamed(context, 'OHome');
                    //                 },
                    //                 child: Text(
                    //                   'حسناً',
                    //                   textAlign: TextAlign.center,
                    //                   style: conHeadingsStyle.copyWith(
                    //                       color: Colors.white,
                    //                       fontSize: 17,
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //           ),
                    //         ],
                    //         buttonPadding: EdgeInsets.all(20),
                    //         actionsAlignment: MainAxisAlignment.spaceAround,
                    //         contentPadding: EdgeInsets.symmetric(
                    //             vertical: 10, horizontal: 100),
                    //       );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "يمكنك تعديل بياناتك من خلال صفحتك الشخصية",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 10, color: Color(0xFF605A5A)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
