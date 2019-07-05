import 'package:flutter/services.dart';

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

  Future<void> changePuzzle(String puzzleId) async{
    try {
      await platform.invokeMethod('changePuzzle', {"puzzleId":puzzleId});
      return;
    } on PlatformException catch (e) { 
      print("Scramble generation error $e");
    }
    return;
  }
}
