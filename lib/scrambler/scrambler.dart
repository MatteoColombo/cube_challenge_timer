import 'package:flutter/services.dart';

class Scrambler {
  static const platform =
      const MethodChannel('it.speedcubing.cube_challenge_timer/scramble');
  List<String> _scrambleQueue = [];

  Scrambler() {
    _populateQueue();
  }

  Future<String> getScramble() async {
    if (_scrambleQueue.length == 0) {
      await _populateQueue();
    }
    String scramble = _scrambleQueue.removeAt(0);
    _populateQueue();
    return scramble;
  }

  _populateQueue() async {
    while (_scrambleQueue.length < 3) {
      try {
        String scramble = await platform.invokeMethod('scramble');
        _scrambleQueue.add(scramble);
      } on PlatformException catch (e) {
        print("Scramble generation errror $e");
      }
    }
  }
}
