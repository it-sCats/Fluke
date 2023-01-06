import 'dart:ui';

class Session {
  final String id;
  final String sessionName;
  final String speakerName;
  final String room;
  final DateTime from;
  final DateTime to;

  final Color backgroundcolor;
  Session(this.id, this.sessionName, this.speakerName, this.room, this.from,
      this.to, this.backgroundcolor);
}
