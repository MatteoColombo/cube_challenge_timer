import 'dart:async';

import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/enum/timer_state.dart';
import 'package:cube_challenge_timer/model/player_status.dart';
import 'package:cube_challenge_timer/model/timer_info.dart';
import 'package:cube_challenge_timer/timer/scramble_widget.dart';
import 'package:cube_challenge_timer/timer/time_widget.dart';
import 'package:cube_challenge_timer/timer/penalty_widget.dart';
import 'package:flutter/material.dart';

class UserTimer extends StatefulWidget {
  UserTimer({@required this.status, this.info, this.callback})
      : super(key: status.key);
  final PlayerStatus status;
  final TimerInfo info;
  final Function callback;

  UserTimerState createState() => UserTimerState(status, info, callback);
}

class UserTimerState extends State<UserTimer> with WidgetsBindingObserver {
  final PlayerStatus _status;
  TimerInfo _info;
  final Function _timerStateCallback;

  int _start;
  int _end;
  int _runningTime;

  bool _parent;
  bool _appVisible;

  UserTimerState(this._status, this._info, this._timerStateCallback)
      : _runningTime = 0,
        _parent = true,
        _appVisible = true {
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
      if (_status.isTiming && _info.showTime) {
        _updateTimeWhenTiming();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: _status.id == 0 ? 0 : 2,
        child: Listener(
          behavior: HitTestBehavior.opaque,
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
                ScrambleWidget(
                  scramble: _info.scramble,
                  timing: _status.isTiming,
                  scrambleSize: _info.scrambleSize,
                ),
                TimeWidget(
                  time: _status.isTiming ? _runningTime : _status.time,
                  timing: _status.isTiming,
                  penalty: _status.penalty,
                  timeSize: _info.timeSize,
                  showTime: _info.showTime,
                ),
                Listener(
                  onPointerDown: _status.notTimingCanStart
                      ? (details) => _parent = false
                      : null,
                  onPointerUp: (details) => _parent = true,
                  child: PenaltyWidget(
                    enabled: _status.notTimingCanStart,
                    penalty: _status.penalty,
                    callback: _penaltyCallback,
                  ),
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
      _timerStateCallback(TimerState.Updated);
    });
  }

  _handleTapUp() {
    if (_status.canStart) {
      setState(() {
        _start = DateTime.now().millisecondsSinceEpoch;
        _status.startTiming();
        _timerStateCallback(TimerState.Timing);
        if (_info.showTime) _updateTimeWhenTiming();
        _status.penalty = Penalty.OK;
      });
    } else if (_status.isReady) {
      setState(() {
        _status.setNotReady();
      });
    }
  }

  _handleTapDown() {
    if (_parent) {
      if (_info.scramble != null) {
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
  }

  //TODO make this to update time only when app in in foreground
  _updateTimeWhenTiming() {
    Timer.periodic(Duration(milliseconds: 30), (Timer timer) {
      if (_status.isTiming && _appVisible) {
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
