import 'dart:async';

import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/util/timeformatter.dart';
import 'package:flutter/material.dart';
import 'package:cube_challenge_timer/generated/i18n.dart';

class TimeWidget extends StatefulWidget {
  TimeWidget(
      {@required Key key,
      @required this.isTiming,
      @required this.showTime,
      this.time,
      this.start,
      this.penalty})
      : super(key: key);

  final bool isTiming;
  final bool showTime;
  final int time;
  final int start;
  final Penalty penalty;

  TimeWidgetState createState() => TimeWidgetState();
}

class TimeWidgetState extends State<TimeWidget> with WidgetsBindingObserver {
  TimeWidgetState() {
    _runningTime = 0;
    _appVisible = true;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      setState(() {
        _appVisible = false;
      });
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _appVisible = true;
      });
      if (widget.isTiming && widget.showTime) {
        updateTimeWhenTiming();
      }
    }
  }

  bool _appVisible;
  int _runningTime;

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width >= 600 ? 72 : 48;

    return Text(
      _doChecksAndGetText(context),
      style: TextStyle(fontSize: fontSize),
    );
  }

  String _doChecksAndGetText(BuildContext context) {
    if (widget.isTiming) {
      if (widget.showTime) {
        return "${formatTime(_runningTime)}";
      }
      return S.of(context).solving;
    } else {
      if (_runningTime != 0) _runningTime = 0;
      if (widget.time == 0) return S.of(context).ready;
      if (widget.penalty == Penalty.DNF) return S.of(context).dnf;
      if (widget.penalty == Penalty.PLUSTWO)
        return "${formatTime(widget.time + 2000)}+";
      return "${formatTime(widget.time)}";
    }
  }

  updateTimeWhenTiming() {
    Timer.periodic(Duration(milliseconds: 40), (Timer timer) {
      if (widget.isTiming && _appVisible) {
        setState(() {
          _runningTime = DateTime.now().millisecondsSinceEpoch - widget.start;
        });
      } else {
        timer.cancel();
      }
    });
  }
}
