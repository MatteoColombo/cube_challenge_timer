import 'package:cube_challenge_timer/enum/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:cube_challenge_timer/generated/i18n.dart';

class SettingsDialog extends StatelessWidget {
  SettingsDialog({this.canDelete, this.showTime, this.amoled});

  final bool canDelete;
  final bool showTime;
  final bool amoled;

//This sucks but for now I don't have a better option
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: SimpleDialog(
        title: Text(S.of(context).options),
        children: <Widget>[
          ListTile(
            onTap: () => Navigator.pop(context, PopUpOptions.SelectPuzzle),
            title: Text(S.of(context).selectPuzzle),
          ),
          if (canDelete)
            ListTile(
              onTap: () => Navigator.pop(context, PopUpOptions.DeleteLast),
              title: Text(S.of(context).deleteLast),
            ),
          if (!showTime)
            ListTile(
              onTap: () => Navigator.pop(context, PopUpOptions.ShowTime),
              title: Text(S.of(context).showTime),
            ),
          if (showTime)
            ListTile(
              onTap: () => Navigator.pop(context, PopUpOptions.HideTime),
              title: Text(S.of(context).hideTime),
            ),
          ListTile(
            onTap: () => Navigator.pop(context, PopUpOptions.Reset),
            title: Text(S.of(context).reset),
          ),
          if (!amoled)
            ListTile(
              onTap: () => Navigator.pop(context, PopUpOptions.AmoledBlack),
              title: Text(S.of(context).amoledTheme),
            ),
          if (amoled)
            ListTile(
              onTap: () => Navigator.pop(context, PopUpOptions.DefaultTheme),
              title: Text(S.of(context).defaultTheme),
            )
        ],
      ),
    );
  }
}
