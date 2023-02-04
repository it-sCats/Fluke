import 'package:cloud_firestore/cloud_firestore.dart';
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
  String eventImage;
  // String? userPic;

  ParticiEventPrev(
      this.eventId, this.eventTitle, this.creatorId, this.eventImage);
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
                padding: EdgeInsets.only(bottom: 10.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      " :المجال",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                    Text(
                      "${Provider.of<siggning>(context, listen: false).userInfoDocument!['interests']}",
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
                      "${Provider.of<siggning>(context, listen: false).userInfoDocument!['phone'] == null ? ' ' : Provider.of<siggning>(context, listen: false).userInfoDocument!['phone']}",
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
                      "${Provider.of<siggning>(context, listen: false).userInfoDocument!['email']}:الإيميل",
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
                      Provider.of<siggning>(context, listen: false)
                          .getUserInfoDoc(_auth.currentUser!.uid);
                      var ref = await siggning().addJoinRequest(
                          eventId: widget.eventId,
                          eventName: widget.eventTitle,
                          userId: _auth.currentUser!.uid,
                          eventCreatorId: widget.creatorId,
                          eventImage: widget.eventImage,
                          userPic:
                              'https://t3.ftcdn.net/jpg/01/18/01/98/360_F_118019822_6CKXP6rXmVhDOzbXZlLqEM2ya4HhYzSV.jpg',
                          name: Provider.of<siggning>(context, listen: false)
                              .userInfoDocument!['name'],
                          field: Provider.of<siggning>(context, listen: false)
                              .userInfoDocument!['interests'],
                          // userPic: Provider.of<siggning>(context, listen: false)
                          //     .userInfoDocument!['profilePic'],
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
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.creatorId)
                            .collection('notification')
                            .doc(widget.eventId)
                            .set({
                          'title': '',
                          'date':
                              ' شركة ${Provider.of<siggning>(context, listen: false).userInfoDocument!['name']} ترغب بالمشاركة في ${widget.eventTitle} الذي تنظمه كـ${_participantTypeCont.text}',
                          'creatorID': siggning().loggedUser!.uid,
                          'creationDate': Timestamp.now()
                        });
                      }

                      //here we modifiy for request send request ID
                      //todo fix the notification by grouping the devices
                    }
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
