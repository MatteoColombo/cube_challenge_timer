import 'package:cube_challenge_timer/enum/penalty.dart';
import 'package:flutter/material.dart';

class PenaltyWidget extends StatelessWidget {
  PenaltyWidget(this._callback, this._enabled, this._penalty);

  final Function _callback;
  final bool _enabled;
  final Penalty _penalty;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: (_enabled && (_penalty != Penalty.OK))
              ? () => _callback(Penalty.OK)
              : null,
        ),
        FlatButton(
          child: Text("+2"),
          onPressed: (_enabled && (_penalty != Penalty.PLUSTWO))
              ? () => _callback(Penalty.PLUSTWO)
              : null,
        ),
        FlatButton(
          child: Text("DNF"),
          onPressed: (_enabled && (_penalty != Penalty.DNF))
              ? () => _callback(Penalty.DNF)
              : null,
        ),
      ],
    );
  }
}
