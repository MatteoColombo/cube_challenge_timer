import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:cube_challenge_timer/model/player_status.dart';
import 'package:flutter/material.dart';

class PenaltyWidget extends StatelessWidget {
  PenaltyWidget(this._callback, this._playerStatus);

  final Function _callback;
  final PlayerStatus _playerStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: (_playerStatus.notReadyTimingCanStart &&
                  (_playerStatus.penalty != Penalty.OK))
              ? () => _callback(Penalty.OK)
              : null,
        ),
        FlatButton(
          child: Text("+2"),
          onPressed: (_playerStatus.notReadyTimingCanStart &&
                  (_playerStatus.penalty != Penalty.PLUSTWO))
              ? () => _callback(Penalty.PLUSTWO)
              : null,
        ),
        FlatButton(
          child: Text("DNF"),
          onPressed: (_playerStatus.notReadyTimingCanStart &&
                  (_playerStatus.penalty != Penalty.DNF))
              ? () => _callback(Penalty.DNF)
              : null,
        ),
      ],
    );
  }
}
