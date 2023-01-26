import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../components/cons.dart';
import '../../../components/session.dart';
import '../../../components/sessionDataSource.dart';
import '../../../utils/notificationProvider.dart';
import 'editSessionInfo.dart';

class eventTimeline extends StatefulWidget {
  String eventID;
  var args;
  String creatorID;
  Timestamp startDate;
  Timestamp endDate;
  eventTimeline(
      {this.args,
      required this.eventID,
      required this.creatorID,
      required this.startDate,
      required this.endDate});

  @override
  State<eventTimeline> createState() => _eventTimelineState();
}

class _eventTimelineState extends State<eventTimeline> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventID)
            .collection('agenda')
            .snapshots(),
        builder: (context, snapshot) {
          List<Session> sessionat = [];
          if (snapshot.hasData) {
            final sessions = snapshot.data!.docs;
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done)
              for (QueryDocumentSnapshot session in sessions) {
                String sessionID = session.id;
                Timestamp start = session['fromTime'];
                Timestamp end = session['toTime'];
                DateTime FromDate = DateTime.fromMicrosecondsSinceEpoch(
                    start.microsecondsSinceEpoch);
                DateTime toDate = DateTime.fromMicrosecondsSinceEpoch(
                    end.microsecondsSinceEpoch);
                sessionat.add(Session(
                    sessionID,
                    session['sessionName'],
                    session['speakerName'],
                    session['room'],
                    FromDate,
                    toDate,
                    Colors.white70));

                Provider.of<notificationPRovider>(context).sessiondatasource =
                    sessionDataSource(sessionat);
              }
            //this takes the list of session to sessionDataSource

            return SfCalendar(
              //the ui doesnt update when adding event
              todayHighlightColor: conORange,
              showNavigationArrow: true,
              headerHeight: 100,
              headerStyle: CalendarHeaderStyle(backgroundColor: Colors.white70),
              appointmentTextStyle: conLittelTxt12,
              backgroundColor: conBlue.withOpacity(.16),
              allowAppointmentResize: true,
//todo delete still not working

              appointmentBuilder: (context, calendarAppointmentDetails) {
                Session session = calendarAppointmentDetails.appointments.first;
                return GestureDetector(
                  onTapDown: Provider.of<siggning>(context, listen: false)
                              .loggedUser!
                              .uid ==
                          widget.creatorID
                      ? (details) {
                          showMenu<String>(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                                    .copyWith(topRight: Radius.circular(0))),
                            position: RelativeRect.fromLTRB(
                              details.globalPosition.dx + 10,
                              details.globalPosition.dy + 70,
                              details.globalPosition.dx,
                              details.globalPosition.dy + 10,
                            ), //position where you want to show the menu on screen
                            items: [
                              PopupMenuItem(
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(seconds: 0),
                                        () => showModalBottomSheet(
                                            elevation: 50,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) =>
                                                sessionInfoEditing(
                                                  args: widget.args,
                                                  sessionid: session.id.trim(),
                                                )));
                                  },
                                  value: 'edit',
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.black45,
                                      ),
                                      Divider()
                                    ],
                                  )),
                              PopupMenuItem(
                                  onTap: () async {
                                    print(
                                        'event id ${widget.eventID.trim()} session ID ${session.id.trim()}');
                                    await FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(widget.eventID.trim())
                                        .collection('agenda')
                                        .doc(session.id.trim())
                                        .delete()
                                        .whenComplete(
                                            //بعد إنهاء عملية الحدث يقوم بإعادة التوجيه للصفحة الرئيسية
                                            () {
                                      sessionDataSource? sd;

                                      if (sessionat.length <= 1) {
                                        Provider.of<notificationPRovider>(
                                                context,
                                                listen: false)
                                            .sessiondatasource!
                                            .notifyListeners(
                                                CalendarDataSourceAction.remove,
                                                sessionat);
                                      }
                                      // Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                          'تم حذف الجلسة بنجاح',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily:
                                                'Cairo', //update ui when delete K try to move everything to provider
                                          ),
                                        )),
                                      );
                                    });
                                    Provider.of<notificationPRovider>(context,
                                            listen: false)
                                        .sessiondatasource;
                                    // Future.delayed(
                                    //     const Duration(seconds: 0),
                                    //     () => showDialog(
                                    //         //save to drafts dialog
                                    //         context: context,
                                    //         builder: (context) {
                                    //           return AlertDialog(
                                    //             icon: Icon(
                                    //               Icons.warning,
                                    //               color: conRed.withOpacity(.9),
                                    //               size: 50,
                                    //             ),
                                    //             title: Text(
                                    //               'سيتم حذف الجلسة',
                                    //               textAlign: TextAlign.center,
                                    //               style: conHeadingsStyle.copyWith(
                                    //                   fontSize: 15),
                                    //             ),
                                    //             alignment: Alignment.center,
                                    //             actionsOverflowAlignment:
                                    //                 OverflowBarAlignment.center,
                                    //             actionsOverflowButtonSpacing: 15,
                                    //             actions: [
                                    //               Container(
                                    //                 padding: EdgeInsets.symmetric(
                                    //                     horizontal: 20, vertical: 10),
                                    //                 decoration: BoxDecoration(
                                    //                     color: conRed.withOpacity(.9),
                                    //                     borderRadius:
                                    //                         BorderRadius.circular(
                                    //                             10)),
                                    //                 child: InkWell(
                                    //                     onTap: () async {
                                    //
                                    //                     },
                                    //                     child: Center(
                                    //                       child: Text(
                                    //                         'حدف',
                                    //                         textAlign:
                                    //                             TextAlign.center,
                                    //                         style: conHeadingsStyle
                                    //                             .copyWith(
                                    //                                 color:
                                    //                                     Colors.white,
                                    //                                 fontSize: 17,
                                    //                                 fontWeight:
                                    //                                     FontWeight
                                    //                                         .bold),
                                    //                       ),
                                    //                     )),
                                    //               ),
                                    //               InkWell(
                                    //                   onTap: () {
                                    //                     Navigator.pop(context);
                                    //                   },
                                    //                   child: Text(
                                    //                     ' إالغاء الحذف',
                                    //                     textAlign: TextAlign.center,
                                    //                     style:
                                    //                         conHeadingsStyle.copyWith(
                                    //                             fontSize: 14,
                                    //                             fontWeight: FontWeight
                                    //                                 .normal),
                                    //                   )),
                                    //             ],
                                    //             buttonPadding: EdgeInsets.all(20),
                                    //             actionsAlignment:
                                    //                 MainAxisAlignment.spaceAround,
                                    //             contentPadding: EdgeInsets.symmetric(
                                    //                 vertical: 10, horizontal: 100),
                                    //           );
                                    //         }));
                                  },
                                  value: 'delete',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.black45,
                                      ),
                                      Divider(
                                        color: conBlack.withOpacity(.0),
                                      )
                                    ],
                                  )),
                            ],
                            elevation: 3.0,
                          );
                        }
                      : null,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: conBlack.withOpacity(.1), blurRadius: 7),
                        ]),
                    width: calendarAppointmentDetails.bounds.width,
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            session.sessionName,
                            style: conLittelTxt12.copyWith(
                                fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                            child: Text(
                          session.speakerName,
                          style: conLittelTxt12.copyWith(
                              fontSize: 10, color: conBlack.withOpacity(.8)),
                        )),
                        Expanded(
                            child: Text(
                          ' القاعة: ${session.room}',
                          style: conLittelTxt12.copyWith(
                              fontSize: 10, color: conBlack.withOpacity(.8)),
                        ))
                      ],
                    ),
                  ),
                );
              },
              resourceViewSettings: ResourceViewSettings(),
              monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  appointmentDisplayCount: 100,
                  showAgenda: true,
                  agendaItemHeight: 200),
              dataSource:
                  Provider.of<notificationPRovider>(context, listen: false)
                      .sessiondatasource,
              view: CalendarView.timelineDay,
              scheduleViewSettings: ScheduleViewSettings(
                  dayHeaderSettings: DayHeaderSettings(width: 100)),
              maxDate: DateTime.fromMicrosecondsSinceEpoch(
                      widget.endDate.microsecondsSinceEpoch)
                  .add(Duration(days: 1)),
              minDate: DateTime.fromMicrosecondsSinceEpoch(
                  widget.startDate.microsecondsSinceEpoch),
              firstDayOfWeek: DateTime.fromMicrosecondsSinceEpoch(
                              widget.endDate.microsecondsSinceEpoch)
                          .difference(DateTime.fromMicrosecondsSinceEpoch(
                              widget.startDate.microsecondsSinceEpoch))
                          .inDays <
                      1
                  ? 1
                  : DateTime.fromMicrosecondsSinceEpoch(widget.endDate.microsecondsSinceEpoch)
                              .difference(DateTime.fromMicrosecondsSinceEpoch(
                                  widget.startDate.microsecondsSinceEpoch))
                              .inDays >
                          7
                      ? 7
                      : DateTime.fromMicrosecondsSinceEpoch(
                              widget.endDate.microsecondsSinceEpoch)
                          .difference(DateTime.fromMicrosecondsSinceEpoch(
                              widget.startDate.microsecondsSinceEpoch))
                          .inDays,
              initialDisplayDate: DateTime.fromMicrosecondsSinceEpoch(
                      widget.startDate.microsecondsSinceEpoch)
                  .add(Duration(hours: 2)),
              initialSelectedDate: DateTime.fromMicrosecondsSinceEpoch(
                      widget.startDate.microsecondsSinceEpoch)
                  .add(Duration(hours: 4)),
            );
          } else
            return CircularProgressIndicator();
        });
  }
}
