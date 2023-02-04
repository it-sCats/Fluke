import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/components/creatingEventsForm.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/mainScreens/visAndPartiProfile.dart';
import '../../utils/notificationProvider.dart';
import '../cons.dart';
import '../eventDisplay.dart';

final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
var acessToken =
    'ya29.a0AVvZVsoRtHtv6iV40lWIjxbSo4B0U1yJ1W56BvXoR6ZJgdA6SrDq7Dtrv4tILzXOa7raRD0zDDD8SSGmvXucr4-Pij-HMULVscr0ffXBHt8UxCtwIgoSyUCC6hhsmv2G0AFZ0W6H4gxqDiwyrC3hWB9w2o8VS9saCgYKASgSAQASFQGbdwaIfaiTqjPZqavYJU3WsMtjhg0166';

final _particiTypeFormKey = GlobalKey<FormState>();

class ParticiRequsetPrev extends StatefulWidget {
  String reqID;
  String eventId;
  String participantsName;
  String eventImage;
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
      this.eventImage,
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
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Vprofile(
                                  OrganizerToDisplayID:
                                      widget.participantsId.trim(),
                                )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.participantsName} ",
                        style: conTxtLink.copyWith(
                            fontSize: 17, color: Color(0xFF605A5A)),
                      ),
                      Text(
                        " :شركة",
                        style: conHeadingsStyle.copyWith(
                            fontSize: 16, color: Color(0xFF605A5A)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 0.0, bottom: 10.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    children: [
                      Text(
                        "المجال:",
                        style: conHeadingsStyle.copyWith(
                            fontSize: 16, color: Color(0xFF605A5A)),
                      ),
                      Text(
                        "${widget.field}",
                        style: conHeadingsStyle.copyWith(
                            fontSize: 16, color: Color(0xFF605A5A)),
                      ),
                    ],
                  ),
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
                    onTap: () async {
                      //when request is approved first we update the status to accepted
                      FirebaseFirestore.instance
                          .collection('events')
                          .doc(widget.eventId.trim())
                          .collection('joinRequest')
                          .doc(widget.reqID.trim())
                          .update({'requestStatus': 'accepted'})
                          .whenComplete(
                            () => Navigator.pop(context),
                          )
                          .onError((error, stackTrace) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                  'حدث خطأ ما، لم تتم عملية قبول المشارك ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                )),
                              ));
                      Map<String, dynamic>? userInfoDoc =
                          await Provider.of<siggning>(context, listen: false)
                              .getUserInfoDoc(widget.participantsId);
                      final vistors = await FirebaseFirestore
                          .instance //checks if user aleadry registered
                          .collection('users')
                          .doc(widget.participantsId.trim())
                          .collection('tickets')
                          .doc(widget.eventId)
                          .get();

                      if (!vistors.exists) {
                        FirebaseFirestore.instance
                            .collection('events')
                            .doc(widget.eventId)
                            .collection('participants')
                            .add({
                          'id': widget.participantsId.trim(),
                          'email': userInfoDoc!['email'],
                          'name': userInfoDoc['name'],
                          'phone': userInfoDoc['phone'] == null
                              ? ' '
                              : userInfoDoc['phone'],
                          'interests': userInfoDoc['interests'],
                          'participationType': widget.joinType,
                          'eventID': widget.eventId
                        });
                        //in case no documents were returned which means user is not registered then register user
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.participantsId.trim())
                            .collection('tickets')
                            .doc(widget.eventId.trim())
                            .set({
                          'eventTitle': widget.eventTitle,
                          'email': userInfoDoc['email'],
                          'phone': userInfoDoc!['phone'],
                          'name': userInfoDoc!['name'],
                          'joinType': widget.joinType,
                          'participationType': ' مشارك\n ${widget.joinType} '
                        });
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.participantsId)
                            .collection('notification')
                            .doc(widget.eventId)
                            .set({
                          'title':
                              ' تمت الموافقة على طلبك للمشاركة في حدث ${widget.eventTitle} ',
                          'date': '',
                          'image': widget.eventImage,
                          'creatorID': siggning().loggedUser!.uid,
                          'creationDate': Timestamp.now()
                        });
                      }
                      //secondly we send notifications to the participant
                      participantAcceptanceNotifi(
                          'تم الموافقة على طلبك للمشاركة في حدث',
                          '',
                          widget.joinType,
                          widget.eventId,
                          widget.eventImage,
                          widget.participantsId);

                      //and finally we create a ticket for the participant

                      // registerVisitor(
                      //     widget.eventId,
                      //     context,
                      //     widget.participantsId,
                      //     widget.eventTitle,
                      //     ' مشارك كـ${widget.joinType}');
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
