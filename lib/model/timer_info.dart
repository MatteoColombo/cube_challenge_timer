import 'package:shared_preferences/shared_preferences.dart';

class TimerInfo {
  TimerInfo(
      {this.scramble,
      this.puzzleId,
      this.scrambleSize,
      this.timeSize,
      this.showTime});

  String scramble;
  String puzzleId = "333";
  bool showTime = true;
  double scrambleSize = 24;
  double timeSize = 48;

  set setShowTime(bool value) {
    showTime = value;
    _savePreference();
  }

  _savePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("showTimerUpdate", showTime);
  }
}
