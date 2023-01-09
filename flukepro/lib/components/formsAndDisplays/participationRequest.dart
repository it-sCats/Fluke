import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/components/creatingEventsForm.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notificationProvider.dart';
import '../cons.dart';

final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

final _particiTypeFormKey = GlobalKey<FormState>();

class ParticiRequsetPrev extends StatefulWidget {
  String reqID;
  String eventId;
  String participantsName;
  String participantsId;
  String particpantphone;
  String eventTitle;
  List<dynamic> field;
  String joinType;
  String particpantEmail;

  String creatorId;

  ParticiRequsetPrev(
      this.reqID,
      this.participantsName,
      this.particpantEmail,
      this.particpantphone,
      this.participantsId,
      this.eventId,
      this.eventTitle,
      this.joinType,
      this.field,
      this.creatorId);
  @override
  State<ParticiRequsetPrev> createState() => _ParticiRequsetPrevState();
}

class _ParticiRequsetPrevState extends State<ParticiRequsetPrev> {
  TextEditingController _participantTypeCont = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //fetch the participants email

    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: _particiTypeFormKey,
          child: Column(
            children: [
              Text(
                "طلب مشاركة",
                style: conHeadingsStyle,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${widget.participantsName} ",
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
                      "${widget.field}",
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
                      "${widget.particpantphone}",
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
                      "${widget.particpantEmail}:الإيميل",
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
                      "${widget.joinType}",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                    Text(
                      " :نوع المشاركة",
                      style: conHeadingsStyle.copyWith(
                          fontSize: 16, color: Color(0xFF605A5A)),
                    ),
                  ],
                  // ${userInfoDoc!['name']}
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CancleButton(
                      txt: 'رفض الطلب',
                      ontap: () {
                        FirebaseFirestore.instance
                            .collection('events')
                            .doc(widget.eventId.trim())
                            .collection('joinRequest')
                            .doc(widget.reqID.trim())
                            .update({'requestStatus': 'rejected'}).then(
                                (value) => Navigator.pop(context));
                      }), //change this to custom
                  SizedBox(
                    width: 50,
                  ),
                  lessEdgeCTA(
                    txt: 'قبول الطلب',
                    width: 180,
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('events')
                          .doc(widget.eventId.trim())
                          .collection('joinRequest')
                          .doc(widget.reqID.trim())
                          .update({'requestStatus': 'accepted'}).then(
                              (value) => Navigator.pop(context));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
