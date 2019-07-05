import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/model/util_class.dart';
import 'package:flutter/material.dart';
import 'package:cube_challenge_timer/util/timeformatter.dart';

class TimeWidget extends StatelessWidget {
  TimeWidget(this._time, this._penalty, this._timing, this._utils);

  /*
    time == 0 => ready
    time > 0 => timing/there is a time
  */
  final int _time;
  final Penalty _penalty;
  final bool _timing;
  final UtilClass _utils;

  @override
  Widget build(BuildContext context) {
    String timeString = _generateText();
    return Text(
      timeString,
      style: TextStyle(fontSize: _utils.timeSize),
    );
  }

  String _generateText() {
    if (_timing) {
      if (_utils.showTime) return "${formatTime(_time)}";
      return "Timing";
    } else {
      if (_time == 0) return "Ready";
      if (_penalty == Penalty.DNF) return "DNF";
      if (_penalty == Penalty.PLUSTWO) return "${formatTime(_time + 2000)}+";
      return "${formatTime(_time)}";
    }
  }
}
