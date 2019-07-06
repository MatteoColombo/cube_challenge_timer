import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:flutter/material.dart';

class PenaltyWidget extends StatelessWidget {
  PenaltyWidget(
      {this.callback, @required this.enabled, @required this.penalty});

  final Function callback;
  final bool enabled;
  final Penalty penalty;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
            child: Text("OK"),
            onPressed: (enabled && penalty != Penalty.OK)
                ? () => callback(Penalty.OK)
                : null,
          ),
        FlatButton(
          child: Text("+2"),
          onPressed: (enabled && penalty != Penalty.PLUSTWO)
              ? () => callback(Penalty.PLUSTWO)
              : null,
        ),
        FlatButton(
          child: Text("DNF"),
          onPressed: (enabled && penalty != Penalty.DNF)
              ? () => callback(Penalty.DNF)
              : null,
        ),
      ],
    );
  }
}
