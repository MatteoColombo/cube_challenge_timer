import 'package:cube_challenge_timer/enum/popup_menu.dart';
import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  ResultWidget(this._p0, this._p1, this._callback);
  final int _p0;
  final int _p1;
  //final bool showTime;
  final Function _callback;

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
                    Text("$_p1",
                        style: (_p1 > _p0
                            ? _winning
                            : (_p0 > _p1 ? _losing : _style))),
                    Text(" - $_p0", style: _style)
                  ],
                )),
          ),
          PopupMenuButton(
            onSelected: (PopUpOptions choice) => _callback(choice),
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Reset"),
                    value: PopUpOptions.Reset,
                  ),
     /*             PopupMenuItem(
                    child: Text("Show time"),
                    value: PopUpOptions.ShowTime,
                  ),
                  PopupMenuItem(
                    child: Text("Hide time"),
                    value: PopUpOptions.HideTime,
                  ),*/
                ],
          ),
          Expanded(
            child: RotatedBox(
                quarterTurns: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("$_p0",
                        style: (_p1 > _p0
                            ? _losing
                            : (_p0 > _p1 ? _winning : _style))),
                    Text(" - $_p1", style: _style)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
