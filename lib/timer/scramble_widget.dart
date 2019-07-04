import 'package:flutter/material.dart';

class ScrambleWidget extends StatelessWidget {
  ScrambleWidget(this._scramble, this._timing);

  final String _scramble;
  final bool _timing;

  @override
  Widget build(BuildContext context) {
    return Text(_scramble == null ? "Generating scramble" : _scramble,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: _timing ? Colors.white30 : Colors.white,
        ));
  }
}
