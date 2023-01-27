import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/screens/OrganizersScreens/OHome.dart';
import 'package:flukepro/screens/OrganizersScreens/Sections/timeLine.dart';
import 'package:flukepro/utils/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../components/cons.dart';
import '../../../components/session.dart';
import '../../../components/sessionDataSource.dart';
import '../../../utils/notificationProvider.dart';

sessionDataSource? sessiondatasource;
TextEditingController _eventsessionCont = TextEditingController();
TextEditingController _sessionSpeakerCont = TextEditingController();
TextEditingController _txtTimeController = TextEditingController();
TextEditingController _eventsessionDay = TextEditingController();
TextEditingController _sessionRoomCon = TextEditingController();
TextEditingController eventDayCon = TextEditingController();
TextEditingController endTimeCon = TextEditingController();
TextEditingController starterTimeCon = TextEditingController();
AssetImage? image;
final _sessionFormKey = GlobalKey<FormState>();

// Future<Map<String, dynamic>?> getEventInfoForTimetable(eventID, context) async {
//   final eventdoc =
//       await FirebaseFirestore.instance.collection('events').doc(eventID).get();
//   Provider.of<eventInfoHolder>(context, listen: false).docOfEvent =
//       eventdoc.data();
//
//   return eventdoc.data();
// }

// getStaterDAte(eventID) {
//   getEventInfoForTimetable(eventID);
// }
List<Tab> daysTabs = [];
bool isLoading = false;

class timeTable extends StatefulWidget {
  const timeTable({Key? key}) : super(key: key);

  @override
  State<timeTable> createState() => _timeTableState();
}

class _timeTableState extends State<timeTable> with TickerProviderStateMixin {
  @override
  void initState() {
    // getDataFromFireStore().then((results) {
    //   SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
    //     setState(() {});
    //   });
    // });
    // TODO: implement initState
    super.initState();
  }

  List ssison = [];

  // getDataFromFireStore() async {
  //   Stream<QueryDocumentSnapshot<Map<String, dynamic>>> snapShotsValue =
  //        FirebaseFirestore.instance
  //           .collection('events')
  //           .doc(eventId)
  //           .collection('agenda')
  //           .snapshots();
  //   return snapShotsValue;
  // List list = snapShotsValue.data.map((e) {
  //   Session(
  //       e.data()['sessionName'],
  //       e.data()['speakerName'],
  //       e.data()['room'],
  //       e.data()['fromTime'],
  //       e.data()['toTime'],
  //       Colors.white70);
  // }).toList();
  //
  // setState(() {
  //   events = sessionDataSource(list as List<Session>);
  // });

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventDayCon.clear();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List;

    // List days = List.filled(
    //     DateTime.fromMicrosecondsSinceEpoch(args[1].microsecondsSinceEpoch)
    //         .difference(DateTime.fromMicrosecondsSinceEpoch(
    //             args[0].microsecondsSinceEpoch))
    //         .inDays,
    //     null, //the list doesn't work cancle the function and calculalte days here
    //     growable: true);
    // //calculate the different between starter date and end date0
    // TabController _tabCont = TabController(length: 2, vsync: this);
    // int eventDays = 0;
    // days.forEach((element) {
    //   while (eventDays <
    //       DateTime.fromMicrosecondsSinceEpoch(args[1].microsecondsSinceEpoch)
    //           .difference(DateTime.fromMicrosecondsSinceEpoch(
    //               args[0].microsecondsSinceEpoch))
    //           .inDays)
    //     daysTabs.add(Tab(
    //       height: 100,
    //       text: 'اليوم $eventDays',
    //     ));
    //   eventDays++;
    // });
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40,
                    )),
                IconButton(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    onPressed: () {
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
                                'سيتم حذف كل الجلسات في هذه الاجندة',
                                textAlign: TextAlign.center,
                                style: conHeadingsStyle.copyWith(fontSize: 15),
                              ),
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
                                      borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                      onTap: () async {
                                        sessionDataSource? sd;
                                        Provider.of<notificationPRovider>(
                                                context,
                                                listen: false)
                                            .setSessionDataSource(sd);
                                        print('eventId ${args[2]}');
                                        //todo test the delete function
                                        await FirebaseFirestore.instance
                                            .collection('events')
                                            .doc(args[2].trim())
                                            .collection('agenda')
                                            .get()
                                            .then((snapshot) async {
                                          for (DocumentSnapshot ds
                                              in snapshot.docs) {
                                            ds.reference.delete();
                                          }

                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                              'تم حذف الجلسات بنجاح',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                              ),
                                            )),
                                          );
                                        });
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
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 40,
                      color: conBlack.withOpacity(.8),
                    ))
              ],
            ),
            Expanded(
              child: Stack(children: [
                eventTimeline(
                  args: args,
                  eventID: args[2],
                  creatorID: args[3],
                  startDate: args[0],
                  endDate: args[1],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 15),
                    child: FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                            elevation: 50,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => sessionEditing(args: args));
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      backgroundColor: conBlue,
                    ),
                  ),
                )
              ]),
              //     DefaultTabController(
              //   length: DateTime.fromMicrosecondsSinceEpoch(args['endDate'])
              //       .difference(
              //           DateTime.fromMicrosecondsSinceEpoch(args['starterDate']))
              //       .inDays,
              //   child: Column(
              //     children: [
              //       TabBar(tabs: daysTabs),
              //       Expanded(
              //           child: TabBarView(
              //         children: [Container(), Container()],
              //       ))
              //     ],
              //   ),
              // )
            ),
          ],
        ),
      ),
    );
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  RegExp? _exp;
  TimeTextInputFormatter() {
    _exp = RegExp(r'^[0-9:]+$');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp!.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftChunk = '';
      String rightChunk = '';

      if (value.length >= 8) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '00:00:';
          rightChunk = value.substring(leftChunk.length + 1, value.length);
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:0';
          rightChunk = value.substring(6, 7) + ":" + value.substring(7);
        } else if (value.substring(0, 4) == '00:0') {
          leftChunk = '00:';
          rightChunk = value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        } else if (value.substring(0, 3) == '00:') {
          leftChunk = '0';
          rightChunk = value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7, 8) +
              value.substring(8);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else if (value.length == 7) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '';
          rightChunk = '';
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:00:0';
          rightChunk = value.substring(6, 7);
        } else if (value.substring(0, 1) == '0') {
          leftChunk = '00:';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else {
        leftChunk = '00:00:0';
        rightChunk = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 7) {
          return oldValue;
        } else {
          leftChunk = '0';
          rightChunk = value.substring(0, 1) +
              ":" +
              value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        }
      }

      newText = leftChunk + rightChunk;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return oldValue;
  }
}

class sessionEditing extends StatefulWidget {
  final Session? session;
  final List args;
  sessionEditing({required this.args, this.session});

  @override
  State<sessionEditing> createState() => _sessionEditingState();
}

class _sessionEditingState extends State<sessionEditing> {
  late DateTime fromDate;
  late DateTime toDate;
  late DateTime sessionDay;
  late List rooms;
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
    rooms = widget.args[4] == null ? [] : widget.args[4];
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
        child: Form(
          key: _sessionFormKey,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                'اضافة جلسة',
                style: conHeadingsStyle.copyWith(fontSize: 17),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || _eventsessionCont.text == '') {
                      return 'يجب كتابة اسم الجلسة';
                    }
                    return null;
                  },
                  controller: _eventsessionCont,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      hintText: 'إسم الجلسة',
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
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || _sessionSpeakerCont.text == '') {
                      return 'يجب كتابة اسم المتحدث';
                    }
                    return null;
                  },
                  controller: _sessionSpeakerCont,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      hintText: 'إسم المتحدث في الجلسة',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تحديد يوم الحدث';
                    }
                    // } else if (starterDate.compareTo(endDate) >=
                    //     0) {
                    //   return 'تأ:د من صحة تاريخ النهاية';
                    // }

                    return null;
                  },
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
                      String formattedDate =
                          intl.DateFormat('yyyy-MM-dd').format(pickedDate);
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      hintText: 'يوم الجلسة',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        margin: EdgeInsets.only(left: 18),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return ' أدخل وقت انتهاء الحدث';
                            }
                            return null;
                          },
                          controller: endTimeCon,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 12, minute: 00),
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
                              hintText: 'وقت نهاية الجلسة',
                              hintStyle: conTxtFeildHint,
                              filled: true,
                              fillColor: Color(0xffF1F1F1),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      margin: EdgeInsets.only(right: 18),
                      child: InkWell(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return ' أدخل وقت بداية الحدث';
                            }
                            return null;
                          },
                          controller: starterTimeCon,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 12, minute: 00),
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
                              hintText: 'وقت بداية الجلسة ',
                              hintStyle: conTxtFeildHint,
                              filled: true,
                              fillColor: Color(0xffF1F1F1),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
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
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        hintText: 'حدد القاعة الخاصة بالجلسة',
                        hintStyle: conTxtFeildHint,
                        filled: true,
                        fillColor: Color(0xffF1F1F1),
                        errorStyle: conErorTxtStyle,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    style: conTxtFeildHint.copyWith(color: conBlack),
                    items: rooms.map((items) {
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
                            if (_sessionFormKey.currentState!.validate()) {
                              setState(() {
                                FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(widget.args[2]!.trim())
                                    .collection('agenda')
                                    .add({
                                  'sessionName': _eventsessionCont.text,
                                  'speakerName': _sessionSpeakerCont.text,
                                  'room': _sessionRoomCon.text,
                                  'fromTime': fromDate,
                                  'toTime': toDate,
                                  'eventId': widget.args[2],
                                  'creationDate': DateTime.now()
                                }).whenComplete(() => {isLoading = false});
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
                                ScaffoldMessenger.of(context).showSnackBar(
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
                              print('$eventId==========');
                            } else {
                              isLoading = false;
                            }
                          }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}
