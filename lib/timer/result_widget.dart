import 'package:cube_challenge_timer/enum/popup_menu.dart';
import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  ResultWidget(
      {@required this.p0,
      @required this.p1,
      @required this.showTime,
      this.callback});
  final int p0;
  final int p1;
  final bool showTime;
  final Function callback;

  final TextStyle _style =
      const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
  final TextStyle _winning = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green);
  final TextStyle _losing = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: RotatedBox(
                quarterTurns: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("$p1",
                        style: (p1 > p0
                            ? _winning
                            : (p0 > p1 ? _losing : _style))),
                    Text(" - $p0", style: _style)
                  ],
                )),
          ),
          PopupMenuButton(
            onSelected: (PopUpOptions choice) => callback(choice),
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Reset"),
                    value: PopUpOptions.Reset,
                  ),
                  PopupMenuItem(
                    child: Text("Select Puzzle"),
                    value: PopUpOptions.SelectPuzzle,
                  ),
                  PopupMenuItem(
                    child: Text(showTime ? "Hide time" : "Show Time"),
                    value: PopUpOptions.ShowTime,
                  ),
                ],
          ),
          Expanded(
            child: RotatedBox(
                quarterTurns: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("$p0",
                        style: (p1 > p0
                            ? _losing
                            : (p0 > p1 ? _winning : _style))),
                    Text(" - $p1", style: _style)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
