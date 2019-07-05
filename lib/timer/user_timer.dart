import 'dart:async';

import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/enum/timer_state.dart';
import 'package:cube_challenge_timer/model/player_status.dart';
import 'package:cube_challenge_timer/model/util_class.dart';
import 'package:cube_challenge_timer/timer/scramble_widget.dart';
import 'package:cube_challenge_timer/timer/time_widget.dart';
import 'package:cube_challenge_timer/timer/penalty_widget.dart';
import 'package:flutter/material.dart';

class UserTimer extends StatefulWidget {
  UserTimer(this._status, this._utils, this._timerStateCallback,
      this._updateTimeCallback)
      : super(key: _status.key);
  final PlayerStatus _status;
  final UtilClass _utils;
  final Function _timerStateCallback;
  final Function _updateTimeCallback;

  UserTimerState createState() =>
      UserTimerState(_status, _utils, _timerStateCallback, _updateTimeCallback);
}

class UserTimerState extends State<UserTimer> {
  final PlayerStatus _status;
  UtilClass _utils;
  final Function _timerStateCallback;
  final Function _updateTimeCallback;

  int _start;
  int _end;
  int _runningTime;

  UserTimerState(this._status, this._utils, this._timerStateCallback,
      this._updateTimeCallback)
      : _runningTime = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: _status.id == 0 ? 0 : 2,
        child: Listener(
          onPointerDown: (details) => _handleTapDown(),
          onPointerUp: (details) => _handleTapUp(),
          child: Container(
            padding: EdgeInsets.all(8),
            color: _status.canStart
                ? Colors.green
                : _status.isReady ? Colors.yellow[800] : Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ScrambleWidget(_utils, _status.isTiming),
                TimeWidget(_status.isTiming ? _runningTime : _status.time,
                    _status.penalty, _status.isTiming, _utils),
                PenaltyWidget(
                  _penaltyCallback,
                  _status,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _penaltyCallback(Penalty pen) {
    setState(() {
      _status.penalty = pen;
      _updateTimeCallback();
    });
  }

  _handleTapUp() {
    if (_status.canStart) {
      setState(() {
        _start = DateTime.now().millisecondsSinceEpoch;
        _status.startTiming();
        _timerStateCallback(TimerState.Timing);
        if (_utils.showTime) _updateTimeWhenTiming();
        _status.penalty = Penalty.OK;
      });
    } else if (_status.isReady) {
      setState(() {
        _status.setNotReady();
      });
    }
  }

  _handleTapDown() {
    if (_utils.scramble != null) {
      if (_status.isTiming) {
        _end = DateTime.now().millisecondsSinceEpoch;
        if (_end - _start > 100) {
          setState(() {
            _status.setFinished = _end - _start;
            _timerStateCallback(TimerState.Finished);
          });
        }
      } else {
        setState(() {
          _status.setReady();
          _timerStateCallback(TimerState.Ready);
        });
      }
    }
  }

  _updateTimeWhenTiming() {
    Timer.periodic(Duration(milliseconds: 30), (Timer timer) {
      if (_status.isTiming) {
        setState(() {
          _runningTime = DateTime.now().millisecondsSinceEpoch - _start;
        });
      } else {
        timer.cancel();
      }
    });
  }

  allowToStart() {
    setState(() {
      _status.setCanStart();
    });
  }
}
