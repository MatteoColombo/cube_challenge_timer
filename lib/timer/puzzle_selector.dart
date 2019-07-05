import 'package:flutter/material.dart';

class PuzzleSelector extends StatelessWidget {
  PuzzleSelector(this._selected);

  final String _selected;

  final Map<String, String> puzzles = {
    "222": "2x2x2 Cube",
    "333": "3x3x3 Cube",
    "444": "4x4x4 Cube",
    "555": "5x5x5 Cube",
    "666": "6x6x6 Cube",
    "777": "7x7x7 Cube",
    "minx": "Megaminx",
    "pyram": "Pyraminx",
    "skwb": "Skewb",
    "clock": "Clock",
    "sq1": "Square-1"
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView.separated(
        itemCount: puzzles.length,
        separatorBuilder: (context, i) => Divider(),
        itemBuilder: (context, i) {
          return RadioListTile(
            onChanged: (val) => Navigator.pop(context, val),
            groupValue: _selected,
            title: Text(puzzles.values.elementAt(i)),
            value: puzzles.keys.elementAt(i),
          );
        },
      ),
    );
  }
}
