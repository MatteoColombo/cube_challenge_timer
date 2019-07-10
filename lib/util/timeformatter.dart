//1000= 1s
//60000=1m
//3600000=1h
String formatTime(int time) {
  int centiseconds = (time % 1000) ~/ 10;
  int seconds = (time ~/ 1000) % 60;
  int minutes = (time ~/ 60000) % 60;
  int hours = time ~/ 3600000;
  if (hours > 0)
    return "$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}.${_twoDigits(centiseconds)}";
  else if (minutes > 0)
    return "$minutes:${_twoDigits(seconds)}.${_twoDigits(centiseconds)}";
  return "$seconds.${_twoDigits(centiseconds)}";
}

String _twoDigits(int d) {
  if (d < 10) return "0$d";
  return "$d";
}
