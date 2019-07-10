import 'package:cube_challenge_timer/enum/puzzle.dart';
import 'package:flutter/material.dart';
import 'package:cube_challenge_timer/generated/i18n.dart';

class PuzzleSelector extends StatelessWidget {
  PuzzleSelector({@required this.puzzle});

  final String puzzle;

//This sucks but I don't have a better option, for now
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(S.of(context).selectPuzzle),
      children: <Widget>[
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_222,
          title: Text(S.of(context).type_222),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_333,
          title: Text(S.of(context).type_333),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_444,
          title: Text(S.of(context).type_444),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_555,
          title: Text(S.of(context).type_555),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_666,
          title: Text(S.of(context).type_666),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_777,
          title: Text(S.of(context).type_777),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_CLOCK,
          title: Text(S.of(context).type_clock),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_MINX,
          title: Text(S.of(context).type_minx),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_PYRAM,
          title: Text(S.of(context).type_pyram),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_SKWB,
          title: Text(S.of(context).type_skwb),
        ),
        RadioListTile(
          onChanged: (val) => Navigator.of(context).pop(val),
          groupValue: puzzle,
          value: Puzzle.TYPE_SQ1,
          title: Text(S.of(context).type_sq1),
        ),
      ],
    );
  }
}