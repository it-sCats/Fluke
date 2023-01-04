import 'dart:ui';

class Session {
  final String sessionName;
  final String speakerName;
  final DateTime from;
  final DateTime to;

  final Color backgroundcolor;
  Session(this.sessionName, this.speakerName, this.from, this.to,
      this.backgroundcolor);
}
