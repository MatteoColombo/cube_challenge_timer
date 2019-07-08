import 'package:cube_challenge_timer/enum/popup_menu.dart';
import 'package:cube_challenge_timer/timer/results_widget.dart';
import 'package:flutter/material.dart';

class MiddleBarWidget extends StatelessWidget {
  MiddleBarWidget(
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
    return Row(
      children: <Widget>[
        ResultsWidget(
          player: p1,
          opponent: p0,
          winner: winner == 1 || winner == -1,
          rotated: true,
        ),
        _buildPopUpMenu(),
        ResultsWidget(
          player: p0,
          opponent: p1,
          winner: winner == 0 || winner == -1,
          rotated: false,
        ),
      ],
    );
  }

  PopupMenuButton<PopUpOptions> _buildPopUpMenu() {
    return PopupMenuButton<PopUpOptions>(
        onSelected: (PopUpOptions choice) => callback(choice),
        icon: Icon(Icons.settings),
        itemBuilder: (context) {
          List<PopupMenuEntry<PopUpOptions>> options = [];
          for (final k in optionsMap.keys) {
            PopUpOptions opt = optionsMap[k];
            if (opt == PopUpOptions.ShowTime && showTime)
              continue;
            else if (opt == PopUpOptions.HideTime && !showTime) continue;
            if (opt == PopUpOptions.DeleteLast && !deleteLast) continue;
            if (opt == PopUpOptions.AmoledBlack && amoledBlack) continue;
            if (opt == PopUpOptions.DefaultTheme && !amoledBlack) continue;
            PopupMenuItem<PopUpOptions> entry = PopupMenuItem(
              value: opt,
              child: Text(k),
            );
            options.add(entry);
          }
          return options;
        });
  }
}
