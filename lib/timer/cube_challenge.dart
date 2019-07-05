import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/enum/popup_menu.dart';
import 'package:cube_challenge_timer/enum/timer_state.dart';
import 'package:cube_challenge_timer/model/player_status.dart';
import 'package:cube_challenge_timer/model/util_class.dart';
import 'package:cube_challenge_timer/scrambler/scrambler.dart';
import 'package:cube_challenge_timer/timer/puzzle_selector.dart';
import 'package:cube_challenge_timer/timer/result_widget.dart';
import 'package:cube_challenge_timer/timer/user_timer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CubeChallengeTimer extends StatefulWidget {
  @override
  CubeChallengeState createState() => CubeChallengeState();
}

class CubeChallengeState extends State<CubeChallengeTimer> {
  CubeChallengeState() {
    _scrambler = Scrambler();
    _utils = UtilClass();
    _getNewScramble();
    _loadSP();
    _p0 = PlayerStatus(0);
    _p1 = PlayerStatus(1);
  }

  UtilClass _utils;

  Scrambler _scrambler;
  String _puzzleId;
  int _winner;

  PlayerStatus _p0;
  PlayerStatus _p1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            UserTimer(_p1, _utils, _playerTimerCallback, _updateTime),
            Divider(
              height: 1,
            ),
            ResultWidget(_p0.points, _p1.points, _settingsCallback, _utils),
            Divider(
              height: 1,
            ),
            UserTimer(_p0, _utils, _playerTimerCallback, _updateTime),
          ],
        ),
      ),
    );
  }

  _loadSP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _puzzleId = prefs.getString("puzzleId") ?? "333";
      _utils.showTime = prefs.getBool("showTimerUpdate") ?? true;
      _utils.scrambleSize = prefs.getDouble("scrambleSize") ?? 24;
      _utils.timeSize = prefs.getDouble("timeSize") ?? 48;
      _p0.points = prefs.getInt("p0") ?? 0;
      _p1.points = prefs.getInt("p1") ?? 0;
    });
  }

  _settingsCallback(PopUpOptions choice) async {
    if (choice == PopUpOptions.Reset) {
      _resetAll();
    } else if (choice == PopUpOptions.SelectPuzzle) {
      var res = await showDialog(
          context: context, builder: (context) => PuzzleSelector(_puzzleId));
      if (res != null && res != _puzzleId) {
        _puzzleId = res;
        await _scrambler.changePuzzle(_puzzleId);
        _resetAll();
      }
    } else if (choice == PopUpOptions.ShowTime) {
      _utils.invertShowTime();
    }
  }

  _resetAll() {
    _getNewScramble();
    setState(() {
      _utils.scramble = null;
      _p0.reset();
      _p1.reset();
    });
  }

  _playerTimerCallback(TimerState state) {
    if (state == TimerState.Ready)
      _playerReady();
    else if (state == TimerState.Timing)
      _playerTiming();
    else if (state == TimerState.Finished) _playerFinished();
  }

  _playerReady() {
    if (_p0.readyToStart && _p1.readyToStart) {
      _p0.allowToStart();
      _p1.allowToStart();
    }
  }

  _playerTiming() {
    if (_p0.isTiming && _p1.isTiming) {
      _p0.setNotReady();
      _p1.setNotReady();
    }
  }

  _playerFinished() {
    if (_p0.hasFinished && _p1.hasFinished) {
      _p0.canNotStart();
      _p1.canNotStart();
      _utils.scramble = null;
      _getNewScramble();
      _computeWinner();
    }
  }

  _computeWinner() {
    final p0 = _p0.penalty;
    final p1 = _p1.penalty;
    final t0 = (p0 == Penalty.OK
        ? _p0.time ~/ 10
        : (p0 == Penalty.PLUSTWO ? (_p0.time + 2000) ~/ 10 : -1));

    final t1 = (p1 == Penalty.OK
        ? _p1.time ~/ 10
        : (p1 == Penalty.PLUSTWO ? (_p1.time + 2000) ~/ 10 : -1));

    setState(() {
      if ((t0 < t1 && p0 != Penalty.DNF) || (p1 == Penalty.DNF && t0 > 0)) {
        _winner = 0;
        _p0.points = 1;
      } else if ((t1 < t0 && p1 != Penalty.DNF) ||
          (p0 == Penalty.DNF && t1 > 0)) {
        _winner = 1;
        _p1.points = 1;
      } else if (t1 == t0) {
        _winner = -1;
        _p0.points = 1;
        _p1.points = 1;
      }
    });
  }

  _updateTime() {
    if (_winner == 0)
      _p0.points = -1;
    else if (_winner == 1)
      _p1.points = -1;
    else if (_winner == -1) {
      _p0.points = -1;
      _p1.points = -1;
    }
    _computeWinner();
  }

  _getNewScramble() async {
    String scramble = await _scrambler.getScramble();
    setState(() {
      _utils.scramble = scramble;
    });
  }
}
