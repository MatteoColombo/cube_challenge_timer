import 'dart:async';

import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/timer/scramble_widget.dart';
import 'package:cube_challenge_timer/timer/time_widget.dart';
import 'package:cube_challenge_timer/timer/penalty_widget.dart';
import 'package:flutter/material.dart';

class UserTimer extends StatefulWidget {
  UserTimer(
      key,
      this.uid,
      this.scramble,
      this.playerReadyCallback,
      this.playerNotReadyCallback,
      this.playerTimingCallback,
      this.playerFinishedCallback,
      this.updateTimeCallback)
      : super(key: key);
  final int uid;
  final String scramble;
  final Function playerReadyCallback;
  final Function playerNotReadyCallback;
  final Function playerTimingCallback;
  final Function playerFinishedCallback;
  final Function updateTimeCallback;

  UserTimerState createState() => UserTimerState(
      uid,
      playerReadyCallback,
      playerNotReadyCallback,
      playerTimingCallback,
      playerFinishedCallback,
      updateTimeCallback);
}

class UserTimerState extends State<UserTimer> {
  final int _uid;
  final Function _playerReadyCallback;
  final Function _playerNotReadyCallback;
  final Function _playerTimingCallback;
  final Function _playerFinishedCallback;
  final Function _updateTimeCallback;

  int _time;
  int _start;
  int _end;
  int _runningTime;

  Penalty _penalty;

  bool _ready;
  bool _timing;
  bool _canStart;

  UserTimerState(
      this._uid,
      this._playerReadyCallback,
      this._playerNotReadyCallback,
      this._playerTimingCallback,
      this._playerFinishedCallback,
      this._updateTimeCallback)
      : _timing = false,
        _ready = false,
        _canStart = false,
        _time = 0,
        _runningTime = 0,
        _penalty = Penalty.OK;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: _uid == 0 ? 0 : 2,
        child: Listener(
          onPointerDown: (details) => _handleTapDown(),
          onPointerUp: (details) => _handleTapUp(),
          child: Container(
            padding: EdgeInsets.all(8),
            color: _canStart
                ? Colors.green
                : _ready ? Colors.yellow : Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ScrambleWidget(widget.scramble, _timing),
                TimeWidget(_timing ? _runningTime : _time, _penalty),
                PenaltyWidget(
                  _penaltyCallback,
                  !_timing && _time != 0,
                  _penalty,
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
      if (pen == Penalty.OK) {
        _penalty = Penalty.OK;
        _updateTimeCallback(_time, _uid);
      } else if (pen == Penalty.PLUSTWO) {
        _penalty = Penalty.PLUSTWO;
        _updateTimeCallback(_time + 2000, _uid);
      } else if (pen == Penalty.DNF) {
        _penalty = Penalty.DNF;
        _updateTimeCallback(-1, _uid);
      }
    });
  }

  _handleTapUp() {
    if (_canStart) {
      setState(() {
        _start = DateTime.now().millisecondsSinceEpoch;
        _timing = true;
        _canStart = false;
        _ready = false;
        _playerTimingCallback(_uid);
        _updateTimeWhenTiming();
        _penalty = Penalty.OK;
      });
    } else if (_ready) {
      setState(() {
        _ready = false;
        _playerNotReadyCallback(_uid);
      });
    }
  }

  _handleTapDown() {
    if (_timing) {
      _end = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        _time = _end - _start;
        _timing = false;
        _playerFinishedCallback(_time, _uid);
      });
    } else {
      setState(() {
        _ready = true;
        _playerReadyCallback(_uid);
      });
    }
  }

  _updateTimeWhenTiming() {
    Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
      if (_timing) {
        setState(() {
          _runningTime = DateTime.now().millisecondsSinceEpoch - _start;
        });
      } else {
        timer.cancel();
      }
    });
  }

  reset() {
    setState(() {
      _time = 0;
      _penalty = Penalty.OK;
    });
  }

  allowStart() {
    setState(() {
      _canStart = true;
    });
  }
}
