import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/enum/popup_menu.dart';
import 'package:cube_challenge_timer/enum/timer_state.dart';
import 'package:cube_challenge_timer/model/player_status.dart';
import 'package:cube_challenge_timer/model/timer_info.dart';
import 'package:cube_challenge_timer/scrambler/scrambler.dart';
import 'package:cube_challenge_timer/dialog/puzzle_selector.dart';
import 'package:cube_challenge_timer/bar/middle_bar_widget.dart';
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
    _info = TimerInfo();
    _getNewScramble();
    _loadSP();
    _p0 = PlayerStatus(0);
    _p1 = PlayerStatus(1);
    _winner = -2;
  }

  TimerInfo _info;

  Scrambler _scrambler;
  String _puzzleId;
  int _winner;

  PlayerStatus _p0;
  PlayerStatus _p1;

  bool _amoledBlack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _amoledBlack ?? false ? Colors.black : null,
        body: Column(
          children: <Widget>[
            UserTimer(
                status: _p1, info: _info, callback: _playerTimerCallback),
            Divider(
              height: 1,
            ),
            MiddleBarWidget(
              p0: _p0.points,
              p1: _p1.points,
              deleteLast: _p0.time != 0 && _p1.time != 0,
              showTime: _info.showTime,
              winner: _winner,
              amoledBlack: _amoledBlack,
              callback: _settingsCallback,
            ),
            Divider(
              height: 1,
            ),
            UserTimer(
                status: _p0, info: _info, callback: _playerTimerCallback),
          ],
        ),
      ),
    );
  }

  _loadSP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _puzzleId = prefs.getString("puzzleId") ?? "333";
      _info.showTime = prefs.getBool("showTimerUpdate") ?? true;
      _info.scrambleSize = prefs.getDouble("scrambleSize") ?? 24;
      _info.timeSize = prefs.getDouble("timeSize") ?? 48;
      _amoledBlack = prefs.getBool("amoledBlack") ?? false;
      _p0.points = prefs.getInt("p0") ?? 0;
      _p1.points = prefs.getInt("p1") ?? 0;
    });
  }

  _settingsCallback(PopUpOptions choice) async {
    switch (choice) {
      case PopUpOptions.Reset:
        _resetAll();
        break;
      case PopUpOptions.SelectPuzzle:
        _changePuzzle();
        break;
      case PopUpOptions.HideTime:
        setState(() {
          _info.setShowTime = false;
        });
        break;
      case PopUpOptions.ShowTime:
        setState(() {
          _info.setShowTime = true;
        });
        break;
      case PopUpOptions.DeleteLast:
        _deleteLast();
        break;
      case PopUpOptions.AmoledBlack:
        _saveTheme(true);
        break;
      case PopUpOptions.DefaultTheme:
        _saveTheme(false);
        break;
    }
  }

  _saveTheme(bool val) async {
    setState(() {
      _amoledBlack = val;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("amoledBlack", _amoledBlack);
  }

  _deleteLast() {
    setState(() {
      _removeLastWinner();
      _p0.deleteLast();
      _p1.deleteLast();
    });
  }

  _changePuzzle() async {
    var res = await showDialog(
        context: context,
        builder: (context) => PuzzleSelector(
              puzzle: _puzzleId,
            ));
    if (res != null && res != _puzzleId) {
      _puzzleId = res;
      await _scrambler.changePuzzle(_puzzleId);
      _resetAll();
    }
  }

  _resetAll() {
    _getNewScramble();
    setState(() {
      _info.scramble = null;
      _winner = -2;
      _p0.reset();
      _p1.reset();
    });
  }

  _playerTimerCallback(TimerState state) {
    switch (state) {
      case TimerState.Ready:
        _playerReady();
        break;
      case TimerState.Timing:
        _playerTiming();
        break;
      case TimerState.Finished:
        _playerFinished();
        break;
      case TimerState.Updated:
        _updateTime();
        break;
      default:
    }
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
      _info.scramble = null;
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
    _removeLastWinner();
    _computeWinner();
  }

  _removeLastWinner() {
    if (_winner == 0)
      _p0.points = -1;
    else if (_winner == 1)
      _p1.points = -1;
    else if (_winner == -1) {
      _p0.points = -1;
      _p1.points = -1;
    }
    _winner = -2;
  }

  _getNewScramble() async {
    String scramble = await _scrambler.getScramble();
    setState(() {
      _info.scramble = scramble;
    });
  }
}