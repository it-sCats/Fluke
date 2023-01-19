import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'session.dart';
import 'package:flutter/material.dart';

class sessionDataSource extends CalendarDataSource {
  sessionDataSource(List<Session> appointmantss) {
    this.appointments = appointmantss;
  }

  Session getSession(int index) => appointments![index] as Session;
  @override
  String? getLocation(int index) => getSession(index).speakerName;
  @override
  DateTime getStartTime(int index) => getSession(index).from;

  @override
  DateTime getEndTime(int index) => getSession(index).to;

  @override
  String getSubject(int index) => getSession(index).sessionName;

  @override
  String? getNotes(int index) => getSession(index).speakerName;
  @override
  Color getColor(int index) => getSession(index).backgroundcolor;

  @override
  List<Appointment> getVisibleAppointments(
      DateTime startDate, String calendarTimeZone,
      [DateTime? endDate]) {
    // TODO: implement getVisibleAppointments
    return super.getVisibleAppointments(startDate, calendarTimeZone, endDate);
  }
}
