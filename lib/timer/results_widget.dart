import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ResultsWidget extends StatelessWidget {
  ResultsWidget(
      {@required this.player,
      @required this.opponent,
      @required this.winner,
      this.rotated});

  final int player;
  final int opponent;
  final bool winner;
  final bool rotated;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: rotated ? 2 : 0,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(
                MdiIcons.trophy,
                color: winner ? Colors.yellow : Colors.transparent,
              ),
            ),
            Expanded(
              flex: 3,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 28, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "$player",
                        style: TextStyle(
                            color: player > opponent
                                ? Colors.green
                                : opponent > player
                                    ? Colors.red
                                    : Colors.white),
                      ),
                      TextSpan(text: " - $opponent"),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
