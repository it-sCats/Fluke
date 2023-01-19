import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart' as intl;

import '../../../components/cons.dart';
import '../../../components/customWidgets.dart';
import '../../../components/session.dart';
import '../../../utils/fireStoreQueries.dart';

TextEditingController _eventsessionCont = TextEditingController();
TextEditingController _sessionSpeakerCont = TextEditingController();
TextEditingController _txtTimeController = TextEditingController();
TextEditingController _eventsessionDay = TextEditingController();
TextEditingController _sessionRoomCon = TextEditingController();
TextEditingController eventDayCon = TextEditingController();
TextEditingController endTimeCon = TextEditingController();
TextEditingController starterTimeCon = TextEditingController();
final _sessionEditFormKey = GlobalKey<FormState>();
bool isLoading = false;

class sessionInfoEditing extends StatefulWidget {
  final String sessionid;
  final List args;
  sessionInfoEditing({required this.args, required this.sessionid});

  @override
  State<sessionInfoEditing> createState() => _sessionInfoEditingState();
}

class _sessionInfoEditingState extends State<sessionInfoEditing> {
  late DateTime fromDate;
  late DateTime toDate;
  late DateTime sessionDay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDate = DateTime.fromMicrosecondsSinceEpoch(
        widget.args[0].microsecondsSinceEpoch);
    toDate = DateTime.fromMicrosecondsSinceEpoch(
            widget.args[0].microsecondsSinceEpoch)
        .add(Duration(hours: 2));
    sessionDay = DateTime.fromMicrosecondsSinceEpoch(
        widget.args[0].microsecondsSinceEpoch);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fromDate = DateTime.fromMicrosecondsSinceEpoch(
        widget.args[0].microsecondsSinceEpoch);
    toDate = DateTime.fromMicrosecondsSinceEpoch(
            widget.args[0].microsecondsSinceEpoch)
        .add(Duration(hours: 2));
    sessionDay = DateTime.fromMicrosecondsSinceEpoch(
        widget.args[0].microsecondsSinceEpoch);
    _eventsessionCont.clear();
    eventDayCon.clear();
    endTimeCon.clear();
    _sessionSpeakerCont.clear();
    _sessionRoomCon.clear();
    starterTimeCon.clear();
  }

  @override
  Widget build(BuildContext context) {
    List days = List.generate(
        DateTime.fromMicrosecondsSinceEpoch(
                        widget.args[1].microsecondsSinceEpoch)
                    .difference(DateTime.fromMicrosecondsSinceEpoch(
                        widget.args[0].microsecondsSinceEpoch))
                    .inDays <
                1
            ? 1
            : DateTime.fromMicrosecondsSinceEpoch(
                    widget.args[1].microsecondsSinceEpoch)
                .difference(DateTime.fromMicrosecondsSinceEpoch(
                    widget.args[0].microsecondsSinceEpoch))
                .inDays,
        (index) => 'اليوم ${index++}');
    return Container(
      child: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>?>?>(
          future: getSessionInfo(widget.sessionid, widget.args[2]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic>? info = snapshot.data?.data();

              TimeOfDay fromTime = TimeOfDay.fromDateTime(fromDate);
              TimeOfDay toTime = TimeOfDay.fromDateTime(toDate);
              return Form(
                key: _sessionEditFormKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              size: 40,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      'تعديل جلسة',
                      style: conHeadingsStyle.copyWith(fontSize: 17),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        controller: _eventsessionCont,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            hintText: info!['sessionName'],
                            hintStyle: conTxtFeildHint,
                            errorStyle: conErorTxtStyle,
                            filled: true,
                            fillColor: Color(0xffF1F1F1),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: TextFormField(
                        controller: _sessionSpeakerCont,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            hintText: info!['speakerName'],
                            hintStyle: conTxtFeildHint,
                            errorStyle: conErorTxtStyle,
                            filled: true,
                            fillColor: Color(0xffF1F1F1),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: eventDayCon,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.fromMicrosecondsSinceEpoch(
                                  widget.args[0].microsecondsSinceEpoch),
                              firstDate: DateTime.fromMicrosecondsSinceEpoch(widget
                                  .args[0]
                                  .microsecondsSinceEpoch), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime.fromMicrosecondsSinceEpoch(
                                  widget.args[1].microsecondsSinceEpoch));
                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = intl.DateFormat('yyyy-MM-dd')
                                .format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              sessionDay =
                                  pickedDate; //set output date to TextField value.
                              eventDayCon.text = formattedDate
                                  .toString(); //set output date to TextField value.
                            });
                          }
                        },
                        readOnly: true,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            hintText: intl.DateFormat('yyyy-MM-dd')
                                .format(sessionDay),
                            hintStyle: conTxtFeildHint,
                            errorStyle: conErorTxtStyle,
                            filled: true,
                            fillColor: Color(0xffF1F1F1),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 100,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              margin: EdgeInsets.only(left: 18),
                              child: TextFormField(
                                controller: endTimeCon,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay(hour: 12, minute: 00),
                                  );
                                  //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement
                                  if (pickedTime != null) {
                                    setState(() {
                                      endTimeCon.text =
                                          pickedTime.format(context).toString();

                                      toDate = sessionDay!.add(Duration(
                                          hours: pickedTime!.hour,
                                          minutes: pickedTime!.minute));
                                      print(toDate);
                                      if (toDate!.isBefore(fromDate!)) {
                                        print('error');
                                      }
                                      //set output date to TextField value.
                                    });
                                  }
                                },
                                readOnly: true,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    hintText: toTime.format(context).toString(),
                                    hintStyle: conTxtFeildHint,
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 24,
                            )),
                        Expanded(
                          flex: 100,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            margin: EdgeInsets.only(right: 18),
                            child: InkWell(
                              child: TextFormField(
                                controller: starterTimeCon,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay(hour: 12, minute: 00),
                                  );

                                  //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement
                                  if (pickedTime != null) {
                                    setState(() {
                                      starterTimeCon.text =
                                          pickedTime.format(context).toString();

                                      fromDate = sessionDay!.add(Duration(
                                          hours: pickedTime!.hour,
                                          minutes: pickedTime!.minute));
                                      print(fromDate);
                                      //set output date to TextField value.
                                    });
                                  }
                                  //set output date to TextField value.
//set output date to TextField value.
                                },
                                readOnly: true,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    hintText:
                                        fromTime.format(context).toString(),
                                    hintStyle: conTxtFeildHint,
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                          ),
                        )
                      ],
                    )

                    // Container(the former implementation
                    //   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    //   child: Directionality(
                    //     textDirection: TextDirection.rtl,
                    //     child: DropdownButtonFormField(
                    //       validator: (value) {
                    //         if (value == null) {
                    //           return 'يجب تحديد يوم الجلسة';
                    //         }
                    //         return null;
                    //       },
                    //       decoration: InputDecoration(
                    //           contentPadding:
                    //               EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    //           hintText: 'حدد اليوم الذي تقام فيه الجلسة',
                    //           hintStyle: conTxtFeildHint,
                    //           filled: true,
                    //           fillColor: Color(0xffF1F1F1),
                    //           errorStyle: conErorTxtStyle,
                    //           border: OutlineInputBorder(
                    //               borderSide: BorderSide.none,
                    //               borderRadius: BorderRadius.circular(10))),
                    //       style: conTxtFeildHint.copyWith(color: conBlack),
                    //       items: days.map((items) {
                    //         return DropdownMenuItem(
                    //           value: items,
                    //           child: Text(items
                    //               .toString()), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                    //         );
                    //       }).toList(),
                    //       onChanged: (value) {
                    //         _eventsessionDay.text = value.toString();
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 10),
                    //   margin: EdgeInsets.symmetric(horizontal: 50),
                    //   child: TextFormField(
                    //     validator: (value) {
                    //       if (value == null || _eventsessionCont.text == '') {
                    //         return 'يجب تحديد مدة الجلسة';
                    //       }
                    //       return null;
                    //     },
                    //     inputFormatters: <TextInputFormatter>[
                    //       TimeTextInputFormatter()
                    //     ],
                    //     controller: _txtTimeController,
                    //     textDirection: TextDirection.rtl,
                    //     textAlign: TextAlign.right,
                    //     decoration: InputDecoration(
                    //         contentPadding:
                    //             EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    //         hintText: 'أدخل مدة الجلسة: 00ث:00د:00س',
                    //         hintStyle: conTxtFeildHint,
                    //         errorStyle: conErorTxtStyle,
                    //         filled: true,
                    //         fillColor: Color(0xffF1F1F1),
                    //         border: OutlineInputBorder(
                    //             borderSide: BorderSide.none,
                    //             borderRadius: BorderRadius.circular(10))),
                    //   ),
                    // ),
                    ,
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              hintText: 'حدد القاعة الخاصة بالجلسة',
                              hintStyle: conTxtFeildHint,
                              filled: true,
                              fillColor: Color(0xffF1F1F1),
                              errorStyle: conErorTxtStyle,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                          style: conTxtFeildHint.copyWith(color: conBlack),
                          items: days.map((items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items
                                  .toString()), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                            );
                          }).toList(),
                          onChanged: (value) {
                            _sessionRoomCon.text = value.toString();
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 65,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 45.0),
                              child: Text(
                                'إلغاء الجلسة',
                                style: conTxtFeildHint.copyWith(
                                    color: Colors.blueGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        isLoading
                            ? CircularProgressIndicator()
                            : lessEdgeCTA(
                                width: 180,
                                txt: 'إضافة الجلسة',
                                onTap: () {
                                  isLoading = true;

                                  if (_eventsessionCont.text == null &&
                                      _sessionSpeakerCont.text == null &&
                                      eventDayCon.text == null &&
                                      starterTimeCon.text == null &&
                                      endTimeCon.text == null) {}
                                  if (_sessionEditFormKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection('events')
                                          .doc(widget.args[2]!.trim())
                                          .collection('agenda')
                                          .doc(widget.sessionid)
                                          .set({
                                        'sessionName':
                                            _eventsessionCont.text.isEmpty
                                                ? info!['sessionName']
                                                : _eventsessionCont.text,
                                        'speakerName':
                                            _sessionSpeakerCont.text.isEmpty
                                                ? info!['speakerName']
                                                : _sessionSpeakerCont.text,
                                        'room': _sessionRoomCon.text.isEmpty
                                            ? info!['room']
                                            : _sessionRoomCon.text == ' ',
                                        'fromTime': starterTimeCon.text.isEmpty
                                            ? info!['fromTime']
                                            : fromDate,
                                        'toTime': endTimeCon.text.isEmpty
                                            ? info!['toTime']
                                            : toDate,
                                        'eventId': widget.args[2],
                                        'creationDate': DateTime.now()
                                      }).whenComplete(
                                              () => {isLoading = false});
                                      isLoading = false;
                                      // final session = Session(
                                      //     '',
                                      //     _eventsessionCont.text,
                                      //     _sessionSpeakerCont.text,
                                      //     _sessionRoomCon.text,
                                      //     fromDate,
                                      //     toDate,
                                      //     conBlue.withOpacity(.5));
                                      // final provider = Provider.of<eventInfoHolder>(
                                      //     context,
                                      //     listen: false);
                                      // print(session.speakerName);
                                      // print(provider.sessios.length);
                                      // Provider.of<eventInfoHolder>(context,
                                      //         listen: false)
                                      //     .addSession(session);
                                      isLoading = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                          'تمت إضافة الجلسة بنجاح',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Cairo',
                                          ),
                                        )),
                                      );
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    isLoading = false;
                                  }
                                }),
                      ],
                    ),
                  ],
                ),
              );
            } else
              return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
