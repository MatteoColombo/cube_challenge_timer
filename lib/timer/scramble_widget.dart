import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:cube_challenge_timer/generated/i18n.dart';

class ScrambleWidget extends StatelessWidget {
  ScrambleWidget(
      {@required this.timing, @required this.scramble, this.scrambleSize});

  final bool timing;
  final String scramble;
  //At the moment this is unused
  final double scrambleSize;

  @override
  Widget build(BuildContext context) {
    if (scramble == null) {
      return FadingText(
        S.of(context).generating
      );
    }
    double fs = _getFontSize(MediaQuery.of(context).size.width);
    int scLen = scramble.split(" ").length;
    return Text(scramble,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: scLen < 60 ? fs : fs * 80 / 100,
          color: timing ? Colors.white30 : Colors.white,
        ));
  }

  _getFontSize(double dp) {
    if (dp >= 700) return 32.0;
    if (dp >= 600) return 28.0;
    if (dp > 450) return 24.0;
    if (dp > 400) return 22.0;
    if(dp >345) return 18.0;
    return 16.0;
  }
}
