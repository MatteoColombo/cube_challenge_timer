import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ScrambleWidget extends StatelessWidget {
  ScrambleWidget(
      {@required this.timing, @required this.scramble, this.scrambleSize});

  final bool timing;
  final String scramble;
  final double scrambleSize;

  @override
  Widget build(BuildContext context) {
    if (scramble == null) {
      return FadingText(
        "Generating scrambles...",
      );
    }
    List<String> splitScramble = scramble.split(" ");
    return Text(scramble,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: splitScramble.length > 59
              ? (scrambleSize / 100 * 71) ?? 17
              : scrambleSize ?? 24,
          color: timing ? Colors.white30 : Colors.white,
        ));
  }
}
