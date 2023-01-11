import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../components/cons.dart';
import '../../../components/session.dart';
import '../../../components/sessionDataSource.dart';

sessionDataSource? sessiondatasource;

class eventTimeline extends StatelessWidget {
  String eventID;
  Timestamp startDate;
  Timestamp endDate;
  eventTimeline(this.eventID, this.startDate, this.endDate);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(eventID)
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
                sessiondatasource = sessionDataSource(sessionat);
              } //needs testing

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

              appointmentBuilder: (context, calendarAppointmentDetails) {
                Session session = calendarAppointmentDetails.appointments.first;
                return GestureDetector(
                  onTap: () {},
                  onLongPress: () {
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
                              'سيتم حذف الجلسة',
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
                                      //todo test the delete function
                                      await FirebaseFirestore.instance
                                          .collection('events')
                                          .doc(eventID.trim())
                                          .collection('agenda')
                                          .doc(session.id)
                                          .delete()
                                          .whenComplete(
                                              //بعد إنهاء عملية الحدث يقوم بإعادة التوجيه للصفحة الرئيسية
                                              () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                            'تم حذف الجلسة بنجاح',
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
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                            child: Text(
                          session.speakerName,
                          style: conLittelTxt12.copyWith(
                              fontSize: 10, color: conBlack.withOpacity(.8)),
                        )),
                        // Expanded(
                        //     child: Text(
                        //   session.room,
                        //   style: conLittelTxt12.copyWith(
                        //       fontSize: 10, color: conBlack.withOpacity(.8)),
                        // ))
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
              dataSource: sessiondatasource,
              view: CalendarView.timelineDay,
              scheduleViewSettings: ScheduleViewSettings(
                  dayHeaderSettings: DayHeaderSettings(width: 100)),
              maxDate: DateTime.fromMicrosecondsSinceEpoch(
                      endDate.microsecondsSinceEpoch)
                  .add(Duration(days: 1)),
              minDate: DateTime.fromMicrosecondsSinceEpoch(
                  startDate.microsecondsSinceEpoch),
              firstDayOfWeek: DateTime.fromMicrosecondsSinceEpoch(
                              endDate.microsecondsSinceEpoch)
                          .difference(DateTime.fromMicrosecondsSinceEpoch(
                              startDate.microsecondsSinceEpoch))
                          .inDays <
                      1
                  ? 1
                  : DateTime.fromMicrosecondsSinceEpoch(
                                  endDate.microsecondsSinceEpoch)
                              .difference(DateTime.fromMicrosecondsSinceEpoch(
                                  startDate.microsecondsSinceEpoch))
                              .inDays >
                          7
                      ? 7
                      : DateTime.fromMicrosecondsSinceEpoch(
                              endDate.microsecondsSinceEpoch)
                          .difference(DateTime.fromMicrosecondsSinceEpoch(
                              startDate.microsecondsSinceEpoch))
                          .inDays,
              initialDisplayDate: DateTime.fromMicrosecondsSinceEpoch(
                      startDate.microsecondsSinceEpoch)
                  .add(Duration(hours: 2)),
              initialSelectedDate: DateTime.fromMicrosecondsSinceEpoch(
                      startDate.microsecondsSinceEpoch)
                  .add(Duration(hours: 4)),
            );
          } else
            return CircularProgressIndicator();
        });
  }
}
