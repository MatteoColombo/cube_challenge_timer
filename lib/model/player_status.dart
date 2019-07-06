import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/timer/user_timer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerStatus {
  PlayerStatus(this.id)
      : isReady = false,
        canStart = false,
        isTiming = false,
        hasFinished = false,
        penalty = Penalty.OK,
        _points = 0,
        time = 0,
        key = GlobalKey();

  final int id;
  final GlobalKey<UserTimerState> key;

  bool isReady;
  bool canStart;
  bool isTiming;
  bool hasFinished;

  Penalty penalty;

  int _points;
  int time;

  int get points => _points;

  set points(int inc) {
    _points += inc;
    _savePoints();
  }

  _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('p$id', _points);
  }

  bool get readyToStart => isReady && !canStart;

  bool get notTimingCanStart => !canStart && !isTiming && time != 0;

  void setNotReady() => isReady = false;

  void setReady() => isReady = true;

  void setCanStart() {
    hasFinished = false;
    canStart = true;
  }

  void canNotStart() => canStart = false;

  startTiming() {
    isTiming = true;
    canStart = false;
    isReady = false;
  }

  set setFinished(int time) {
    this.time = time;
    hasFinished = true;
    isTiming = false;
  }

  reset() {
    isReady = false;
    canStart = false;
    isTiming = false;
    hasFinished = false;
    penalty = Penalty.OK;
    _points = 0;
    time = 0;
    _savePoints();
  }

  void allowToStart() {
    key.currentState.allowToStart();
  }
}
