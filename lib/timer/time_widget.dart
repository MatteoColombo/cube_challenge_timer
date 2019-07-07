import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:flutter/material.dart';
import 'package:cube_challenge_timer/util/timeformatter.dart';

class TimeWidget extends StatelessWidget {
  TimeWidget(
      {@required this.time,
      @required this.penalty,
      @required this.timing,
      this.timeSize,
      this.showTime});

  final int time;
  final Penalty penalty;
  final bool timing;
  //At the moment this is not used
  final double timeSize;
  final bool showTime;
  @override
  Widget build(BuildContext context) {

    double dp = MediaQuery.of(context).size.width;

    String timeString = _generateText();
    return Text(
      timeString,
      style: TextStyle(fontSize: dp >= 600? 72 : 48),
    );
  }

  String _generateText() {
    if (timing) {
      if (showTime) return "${formatTime(time)}";
      return "Solving";
    } else {
      if (time == 0) return "Ready";
      if (penalty == Penalty.DNF) return "DNF";
      if (penalty == Penalty.PLUSTWO) return "${formatTime(time + 2000)}+";
      return "${formatTime(time)}";
    }
  }
}
