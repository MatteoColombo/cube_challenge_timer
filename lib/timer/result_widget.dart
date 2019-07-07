import 'package:cube_challenge_timer/enum/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ResultWidget extends StatelessWidget {
  ResultWidget(
      {@required this.p0,
      @required this.p1,
      @required this.showTime,
      @required this.deleteLast,
      @required this.winner,
      @required this.amoledBlack,
      this.callback});
  final int p0;
  final int p1;
  final bool showTime;
  final bool deleteLast;
  final int winner;
  final Function callback;
  final bool amoledBlack;

  final TextStyle _style =
      const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
  final TextStyle _winning = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green);
  final TextStyle _losing = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red);

  final Map<String, PopUpOptions> optionsMap = const {
    "Change puzzle": PopUpOptions.SelectPuzzle,
    "Delete last solve": PopUpOptions.DeleteLast,
    "Show time when solving": PopUpOptions.ShowTime,
    "Hide time when solving": PopUpOptions.HideTime,
    "Reset session": PopUpOptions.Reset,
    "Amoled black theme": PopUpOptions.AmoledBlack,
    "Default black theme": PopUpOptions.DefaultTheme,
  };

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
          RotatedBox(
            quarterTurns: 2,
            child: Icon(
              MdiIcons.trophy,
              color: winner == 1 || winner == -1
                  ? Colors.yellow
                  : Colors.transparent,
            ),
          ),
          PopupMenuButton<PopUpOptions>(
              onSelected: (PopUpOptions choice) => callback(choice),
              itemBuilder: (context) {
                List<PopupMenuEntry<PopUpOptions>> options = [];
                for (final k in optionsMap.keys) {
                  PopUpOptions opt = optionsMap[k];
                  if (opt == PopUpOptions.ShowTime && showTime)
                    continue;
                  else if (opt == PopUpOptions.HideTime && !showTime) continue;
                  if (opt == PopUpOptions.DeleteLast && !deleteLast) continue;
                  if (opt == PopUpOptions.AmoledBlack && amoledBlack) continue;
                  if (opt == PopUpOptions.DefaultTheme && !amoledBlack)
                    continue;
                  PopupMenuItem<PopUpOptions> entry = PopupMenuItem(
                    value: opt,
                    child: Text(k),
                  );
                  options.add(entry);
                }
                return options;
              }),
          RotatedBox(
            quarterTurns: 0,
            child: Icon(
              MdiIcons.trophy,
              color: winner == 0 || winner == -1
                  ? Colors.yellow
                  : Colors.transparent,
            ),
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
