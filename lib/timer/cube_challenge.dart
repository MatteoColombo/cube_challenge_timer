import 'package:cube_challenge_timer/enum/popup_menu.dart';
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
  CubeChallengeState()
      : p0Ready = false,
        p1Ready = false,
        p0Timing = false,
        p1Timing = false,
        p0Finished = true,
        p1Finished = true,
        canStart = false,
        p0Points = 0,
        p1Points = 0,
        p0Time = 21345,
        p1Time = 18376 {
    _scrambler = Scrambler();
    _getNewScramble();
    p0TimerKey = GlobalKey();
    p1TimerKey = GlobalKey();
    _loadSP();
  }

  String _scramble;
  Scrambler _scrambler;
  String _puzzleId;

  int p0Points;
  int p1Points;
  int p0Time;
  int p1Time;
  int winner;

  bool p0Ready;
  bool p1Ready;
  bool p0Timing;
  bool p1Timing;
  bool p0Finished;
  bool p1Finished;
  bool canStart;

  GlobalKey<UserTimerState> p0TimerKey;
  GlobalKey<UserTimerState> p1TimerKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            UserTimer(p1TimerKey, 1, _scramble, _playerReady, _playerNotReady,
                _playerTiming, _playerFinished, _updateTime),
            Divider(
              height: 1,
            ),
            ResultWidget(p0Points, p1Points, _settingsCallback),
            Divider(
              height: 1,
            ),
            UserTimer(p0TimerKey, 0, _scramble, _playerReady, _playerNotReady,
                _playerTiming, _playerFinished, _updateTime),
          ],
        ),
      ),
    );
  }

  _loadSP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _puzzleId = prefs.getString("puzzleId") ?? "333";
      p0Points = prefs.getInt("p0") ?? 0;
      p1Points = prefs.getInt("p1") ?? 0;
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
        _savePuzzle();
        await _scrambler.changePuzzle(_puzzleId);
        _resetAll();
      }
    }
  }

  _savePuzzle() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('puzzleId', _puzzleId);
  }

  _resetAll() {
    setState(() {
      _scramble=null;
      _getNewScramble();
      p0Points = 0;
      p1Points = 0;
      p0Time = 0;
      p1Time = 0;
      p0TimerKey.currentState.reset();
      p1TimerKey.currentState.reset();
      _savePoints();
    });
  }

  _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('p0', p0Points);
    prefs.setInt('p1', p1Points);
  }

  _playerReady(int uid) {
    if (uid == 0) p0Ready = true;
    if (uid == 1) p1Ready = true;

    if (p0Ready && p1Ready && !canStart) {
      canStart = true;
      _allowStart();
      p0Finished = false;
      p1Finished = false;
    }
  }

  _playerNotReady(int uid) {
    if (uid == 0) p0Ready = false;
    if (uid == 1) p1Ready = false;
  }

  _playerTiming(int uid) {
    if (uid == 0) p0Timing = true;
    if (uid == 1) p1Timing = true;
    if (p0Timing && p1Timing) {
      p0Ready = false;
      p1Ready = false;
    }
  }

  _playerFinished(int time, int uid) {
    if (uid == 0) {
      p0Finished = true;
      p0Timing = false;
      p0Time = time;
    }
    if (uid == 1) {
      p1Finished = true;
      p1Timing = false;
      p1Time = time;
    }
    if (p0Finished && p1Finished) {
      canStart = false;
      _getNewScramble();
      _computeWinner();
    }
  }

  _computeWinner() {
    final t0 = p0Time >= 0 ? p0Time ~/ 10 : -1;
    final t1 = p1Time >= 0 ? p1Time ~/ 10 : -1;
    setState(() {
      if ((t0 < t1 && t0 > 0) || (t1 == -1 && t0 > 0)) {
        winner = 0;
        p0Points++;
        _savePoints();
      } else if ((t1 < t0 && t1 > 0) || (t0 == -1 && t1 > 0)) {
        winner = 1;
        p1Points++;
        _savePoints();
      } else if (t1 == t0) {
        winner = -1;
        p0Points++;
        p1Points++;
        _savePoints();
      }
    });
  }

  _updateTime(int time, int uid) {
    if (uid == 0) p0Time = time;
    if (uid == 1) p1Time = time;
    if (winner == 0)
      p0Points--;
    else if (winner == 1)
      p1Points--;
    else if (winner == -1) {
      p0Points--;
      p1Points--;
    }
    _computeWinner();
  }

  _getNewScramble() async {
    String scramble = await _scrambler.getScramble();
    setState(() {
      _scramble = scramble;
    });
  }

  _allowStart() {
    p0TimerKey.currentState.allowStart();
    p1TimerKey.currentState.allowStart();
  }
}
