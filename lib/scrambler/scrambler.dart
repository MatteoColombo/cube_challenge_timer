import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Scrambler {
  static const platform =
      const MethodChannel('it.speedcubing.cube_challenge_timer/scramble');

  Future<String> getScramble() async {
    try {
      return await platform.invokeMethod('scramble');
    } on PlatformException catch (e) {
      print("Scramble generation error $e");
    }
    return "Error";
  }

  Future<void> changePuzzle(String puzzleId) async {
    _savePuzzle(puzzleId);
    try {
      await platform.invokeMethod('changePuzzle', {"puzzleId": puzzleId});
      return;
    } on PlatformException catch (e) {
      print("Scramble generation error $e");
    }
    return;
  }

  _savePuzzle(String puzzleId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('puzzleId', puzzleId);
  }
}
