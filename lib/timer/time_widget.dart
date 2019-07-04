import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:flutter/material.dart';
import 'package:cube_challenge_timer/util/timeformatter.dart';

class TimeWidget extends StatelessWidget {
  TimeWidget(this._time, this._penalty);

  /*
    time == 0 => ready
    time > 0 => timing/there is a time
  */
  final int _time;
  final Penalty _penalty;

  @override
  Widget build(BuildContext context) {
    String timeString = _generateText();
    return Text(
      timeString,
      style: TextStyle(fontSize: 48),
    );
  }

  String _generateText() {
    final t = _time;
    if (t == 0) return "Ready";
    if (_penalty == Penalty.DNF) return "DNF";
    if (_penalty == Penalty.PLUSTWO) return "${formatTime(_time + 2000)}+";
    return "${formatTime(_time)}";
  }
}
