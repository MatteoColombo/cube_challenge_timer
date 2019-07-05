import 'package:cube_challenge_timer/model/util_class.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ScrambleWidget extends StatelessWidget {
  ScrambleWidget(this._utils, this._timing);

  final UtilClass _utils;
  final bool _timing;

  @override
  Widget build(BuildContext context) {
    if (_utils.scramble == null) {
      return FadingText(
        "Generating scrambles...",
      );
    }
    return Text(_utils.scramble,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: _utils.scramble.length > 140
              ? (_utils.scrambleSize / 100 * 70)
              : _utils.scrambleSize,
          color: _timing ? Colors.white30 : Colors.white,
        ));
  }
}
