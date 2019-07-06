//1000= 1s
//60000=1m
//3600000=1h
String formatTime(int time) {
  if(time < 0) return "DNF";
  int t = time;
  int centis = (t % 1000) ~/ 10;
  t = t ~/ 1000;
  int seconds = t % 60;
  t = t ~/ 60;
  int mins = t % 60;
  t = t ~/ 60;
  int hours = t;
  if (hours > 0) {
    return "$hours:${_twoDigits(mins)}:${_twoDigits(seconds)}.${_twoDigits(centis)}";
  } else if (mins > 0) {
    return "$mins:${_twoDigits(seconds)}.${_twoDigits(centis)}";
  } else {
    return "$seconds.${_twoDigits(centis)}";
  }
}

String _twoDigits(int d) {
  if (d < 10) return "0$d";
  return "$d";
}
